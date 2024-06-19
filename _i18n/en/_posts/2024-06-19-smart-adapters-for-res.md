---
layout: post
photo: ..
title: Smart adapters for RailsEventStore
description: Managing layer of events abstraction
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, Ruby on Rails, Rails Event Store]
imagefeature: ..
lang: en
one_lang: true
---

It's a good practice to be independent from external tools, gems or libraries. Of course, in many cases we relay on external code and it's normal. In other way, we need to do thinks by our selfs. We focus on handling http requests or user authentication instead of the true client needs. So, the balance between external tools and custom solutions is important. The real question is how to use external tools, but still have enough flexibility in our code? This is the topic, we focus on today on example of integration with RailsEventStore.

In my last article, I described how we moved the [first event to the RailsEventStore](/first-event-in-res). It wouldn't be so easy to do without separation between the `wisper` gem and our application, without layer of abstraction - the adapters we wrote. So today, I will focus on showing them to you. We will talk about:
- `emit` method, we use for publishing the event
- basic handler class for event subscription
- YAML configuration for matching publishers and subscribers
- event data type check
- and grouping events by using streams.

{% include toc.html %}

## Directory structure and convention

I often see that the logic in the application is splited by domains. So, you have domain and there all logic related to it no matter if this is event, handler or something else. I think this is good approach. You can focus on one directory where you have all you need to understand the domain specific logic. In our case we have different approach and I will not say it's better. It's different. We have all events in one directory split by domain, the same convention we have for event handlers. We can say the first approach is more domain focus. The second one more pattern focus.

```console
├── event_handlers
│   ├── housekeeping
│   │   ├── inventory__unit_became_dirty_handler.rb
│   ├── inventory
│   ├── remote_locks
│   ├── ...
├── events
│   ├── housekeeping
│   ├── inventory
│   │   ├── unit_became_dirty_event.rb
│   ├── remote_locks
│   ├── ...
├── config
│   ├── subscription.yml
│   ├── ...
├── ...
```

The next part - the convention - suffix added to the event and handler name. So event file will have name `something_happened_event.rb` and handler/subscriber file will have name `incoming_domain__something_happened_handler.rb`. And the handler file will be included in the subscriber domain. In the example above `housekeeping` domain have subscriber in file `inventory__unit_became_dirty_handler.rb`, which will react on `unit_become_dirty` event from `inventory` domain.

## Emit method

In previous post, I put the event emission code directly in webhooks to event translation logic.

```ruby
# app/lib/webhooks/snt/emit_events_for_webhook_payload.rb

def call
  if payload.is_a?(Payload::RoomStatus)
    Rails.configuration.event_store.publish(
      RoomStatusEvent.new(data: payload.event_attributes),
      stream_name: "snt__#{payload.event}"
    )
  else
    emit("snt__#{payload.event}", payload.event_attributes)
  end
end
```

As you can see, instead of using one method `emit`, we now have there `if` condition. It's good for proof of concept, but not for long term solution. Instead of this condition, we would like to keep the code here very simple, like this:

```ruby
# app/lib/webhooks/snt/emit_events_for_webhook_payload.rb

def call
  emit("snt__#{payload.event}", payload.event_attributes)
end
```

### Prepare one emit method for both ways RailsEventStore and Wisper

We move the responsibility for the event emission logic out of the webhooks translator and put it into `emit` method. Since everywhere in the application, we use exactly `emit` method, we don't need to change the code, we need to change the `emit` method. This is how the `emit` method looks like during the transition phase:

```ruby
def emit(event_name, explicit_payload = {})
  event_class = EventClassFactory.build(
    event_name,
    domain_name: self.class.name.deconstantize.demodulize,
    abstract_event_class: explicit_payload.delete(:abstract_event_class)
  )

  if event_class.ancestors.include?(RailsEventStore::EventWithType)
    res_event = event_class.new(data: explicit_payload)
    Rails.configuration.event_store.publish(res_event, stream_name: event_name)
  else
    EventEmission.new(event_class, explicit_payload, self).call
  end
end
```

The `if` condition is now here in the `emit` method, but it's _smart_. We check the class we inheritance from. If this is the RailsEventStore event, we use its method to call the event. In other case we use `wisper` gem flow. Part of the logic is splitted into smaller classes for readability. Those classes are:
- `EventClassFactory` - to search for the right event class based on event name and domain
- `EventEmission` - class emits the right event with the right payload. Now `EventEmission` class cover `wisper` solution.

### Final emit method

After we finished migration, we cloud clean the `emit` method. See below:

```ruby
def emit(event_name, explicit_payload = {})
  abstract_event_class = explicit_payload.delete(:abstract_event_class)
  event_class = EventClassFactory.build(
    event_name,
    domain_name: self.class.name.deconstantize.demodulize,
    abstract_event_class:
  )

  EventEmission.new(abstract_event_class, event_class, event_name, explicit_payload, self).call
end
```

Here the `EventEmission` class changed and now covers RailsEventStore way of emitting events.

## Handler class

In case of handlers we just changed the class handler it inherit from.

Before:

```ruby
# app/event_handlers/inventory/snt_room_status_handler.rb
module Inventory
  class SntRoomStatusHandler < Wisper::DomainEventHandler
    # ...
  end
end
```

After:

```ruby
# app/event_handlers/inventory/snt_room_status_handler.rb
module Inventory
  class SntRoomStatusHandler < RailsEventStore::DomainEventHandler
    # ...
  end
end
```

And this is the code adjusting RailsEventStore interface to our needs:

```ruby
# app/lib/rails_event_store/domain_event_handler.rb

module RailsEventStore
  class DomainEventHandler
    def initialize(event)
      @event = event
    end

    def call
      raise NotImplementedError
    end

    def call!
      call if process_event?
    end

    private

    attr_reader :event

    def process_event?
      true
    end

    def event_data
      @event_data ||= OpenStruct.new(event.data)
    end
  end
end
```

So, this class allows us to process event only when some conditions in the domain are fullfil like property has integration with housekeeping service. Adjust the way of calling event data. Insead of `event.data[:room_id]` we can use `event_data.room_id`.

## Adapter class

`EventHandlerBuilder` class allows us to translate the way RailsEventStore need to call subscribers to our existing way we call them in the app. The class will allow us to use the same interface we have right now for all handlers.

```ruby
# app/builders/event_handler_builder.rb
class EventHandlerBuilder
  def initialize(class_name, subscription_type = :sync)
    @class_name = class_name
    @subscription_type = subscription_type.to_sym
  end

  def call(event)
    if async?
      EventWorker.perform_async(class_name.to_s, event.event_id)
    else
      class_name.new(event).call!
    end
  end

  protected

  attr_reader :class_name, :subscription_type

  def ==(other)
    class_name == other.class_name && subscription_type == other.subscription_type
  end

  private

  def async?
    subscription_type == :async
  end
end
```

We use that in `rails_event_store.rb` initializer for now only for one event:

```ruby
# config/initializers/rails_event_store.rb

event_store.subscribe(
  EventHandlerBuilder.new(Inventory::SntRoomStatusHandler), to: [Snt::RoomStatusEvent]
)
```

Base on the code, you can notice that we are prepared for handling events in a sync and async way. The `EventWorker` is our worker prepared to take care of handling the events in a async way.

```ruby
class EventWorker < SidekiqWorker
  sidekiq_options backtrace: 20, dead: true, retry: 100, queue: 'events'
  sidekiq_retry_in { |count| count > 100 ? 120 : 60 }

  def perform(class_name, event_id)
    class_name.constantize.new(Rails.configuration.event_store.read.event(event_id)).call!
  end
end
```

## YAML configuration

As I mention before, for the proof of concept we putted the event subscriber into the `rails_event_store.rb`:

```ruby
# config/initializers/rails_event_store.rb

Rails.configuration.to_prepare do
  # ...

  event_store.subscribe(
    EventHandlerBuilder.new(Inventory::SntRoomStatusHandler), to: [Snt::RoomStatusEvent]
  )
end
```

### Extract subscriptions from RailsEventStore configuration file

We didn't want to declare all the new subscribers in the `rails_event_store.rb` it would be a big file, which was one of the most common changed files. To avoid this situation we extracted the event subscription to separate config YAML file. The first version of logic related to this was hardcoded in the `rails_event_store.rb` file:

```ruby
# config/initializers/rails_event_store.rb

Rails.configuration.to_prepare do
  # ...

  subscriptions_path = Rails.root.join('config/subscriptions.yml')
  config = YAML.load_file(subscriptions_path)

  config.each do |domain_name, subscriptions|
    subscriptions.each do |event_name, subscription_type|
      event_domain, name = event_name.split('__').map(&:classify)
      event_class = "#{event_domain}::#{name}Event".constantize
      handler_class = "#{domain_name.classify}::#{event_domain}#{name}Handler".constantize
      event_store.subscribe(EventHandlerBuilder.new(handler_class, subscription_type), to: [event_class])
    end
  end
end
```

We load `YAML` file and for each domain we create subscribers based on the names in the `YAML` file. Here is the example of `YAML` file:

```yaml
# config/subscriptions.yml

inventory:
  snt__room_status: async
```

We can translate this into: _Inventory domain has subscriber SntRoomStatusHandler, which asyncrocously handle the RoomStatusEvent from Snt domain_.

### Handling streams for events

We wanted too to handle events in multiple streams. To allow that in a simple way, we created one subscriber for all events which link events to specific streams. More information about that you can find later in this article in the [Event stream section](#event-streams). Here I only show the logic needed from configuration perspective. This solution could be also used in other cases, when we want to do something for all triggered events like additional logs or something like that.

```ruby
# config/initializers/rails_event_store.rb

Rails.configuration.to_prepare do
  # ...

  config.each do |domain_name, subscriptions|
    subscriptions.each do |event_name, subscription_type|
      if event_name == 'all_events'
        handler_class = "#{domain_name.camelize}Handler".constantize
        event_store.subscribe_to_all_events(
          EventHandlerBuilder.new(handler_class, subscription_type)
        )
      else
        event_domain, name = event_name.split('__').map(&:classify)
        event_class = "#{event_domain}::#{name}Event".constantize
        handler_class = "#{domain_name.classify}::#{event_domain}#{name}Handler".constantize
        event_store.subscribe(
          EventHandlerBuilder.new(handler_class, subscription_type), to: [event_class]
        )
      end
    end
  end
end
```

So now logic take care of two different cases. One which will handle all events the same way and other which will cover only specific event. Here is how the `subscriptions.yml` file will looks like. We have additional `all_events` type in specific _domain_.

```ruby
# config/subscriptions.yml

inventory:
  snt__room_status: async

streams:
  all_events: sync
```

### Final solution for subscription file

After migration all logic related to mapping together events and subscribers to separate class `SubscriptionsList` the code in  `rails_event_store.rb` file looks:

```ruby
# config/initializers/rails_event_store.rb

Rails.configuration.to_prepare do
  Rails.configuration.event_store = event_store = RailsEventStore::Client.new(
    repository: RailsEventStoreActiveRecord::EventRepository.new(serializer: RubyEventStore::NULL)
  )

  SubscriptionsList.config_path = Rails.root.join('config/subscriptions.yml')
  SubscriptionsList.load!(event_store)
end
```

I like this clean solution.

## Event Data Type Check

We had in our own event system check for event data types. We used for that `Dry::Struct`.  To not loose this functionality, we prepared our own version of RailsEventStore event class `EventWithType`.

```ruby
class EventWithType < RailsEventStore::Event
  def initialize(event_id: SecureRandom.uuid, metadata: nil, data: {})
    super(
      event_id:,
      metadata:,
      data: self.class.instance_variable_get(:@schema_validator).new(
        data.deep_symbolize_keys
      ).attributes
    )
  end

  def stream_names
    []
  end

  def self.schema(&block)
    instance_variable_set(:@schema_validator, Class.new(Dry::Struct, &block))
  end
end
```

All our events are inherit from this class and have data type check:

```ruby
class RoomStatusEvent < RailsEventStore::EventWithType
  VALID_STATUSES = ['clean', 'inspected', 'dirty', 'pickup', 'do_not_disturb']

  schema do
    attribute :hotel_id, Types::Coercible::Integer
    attribute :room_id, Types::Coercible::Integer
    attribute :object, Types::Strict::String
    attribute :status, Types::String.constrained(included_in: VALID_STATUSES)
    attribute :status_was, Types::String.constrained(included_in: VALID_STATUSES)
    attribute :snt_event_id, Types::Strict::Integer
    attribute :snt_created_at, Types::Params::DateTime
  end

  def stream_names
    [
      "room__#{data[:room_id]}",
      'snt__timeline'
    ]
  end
end
```

It's allow us in a simply way check if the data are in the right format. We don't need to think if the type of `room_id` is a string, integer or something else. We see that in the declaration, so it's give us a live documentation and quick validation benefit. We know what we can expect in the even, which is very usefull. This information will be always uptodate becasue its a part of the running code.

## Event streams

Thanks to RailsEventStore, we can group our events into streams. We decided to create two different types of streams. The default one, where we need only data the event have, and custom streams which need some calculations to link to the right stream.

### Handling default streams for events

We handle all default streams in stream handler, you can get more info about configuration of default streams in the section about [Handling streams for events](...). Here you can see the `StreamsHandler` class.

```ruby
# app/event_handlers/streams_handler.rb

class StreamsHandler < RailsEventStore::DomainEventHandler
  def call
    event.stream_names.each do |stream_name|
      event_store.link(event.event_id, stream_name: stream_name, expected_version: :any)
    end
  end

  private

  def event_store
    Rails.configuration.event_store
  end
end
```

To add event to default stream we have `stream_names` method in the event class:

```ruby
module Snt
  class RoomStatusEvent < RailsEventStore::BaseEvent
    # ...

    def stream_names
      [
        "room__#{data[:room_id]}",
        'snt__timeline'
      ]
    end
  end
end
```

As you can see we will be able to find the `RoomStatusEvent` in the `snt__timeline` stream and in the stream to specyfic room for example `room_123`. Additional by default we will add this event also to `snt__room_status` stream. It result of `emit` method declaration.

### Handling custom streams for events

In case we need more custom solution to link event to specific stream, we can use custom streams. The good example will be reservation timeline. For each reservation, we wanted to map together all events related with specific reservation:
- all the changes realted to status, dates and type of the room for reservation
- all changes in the guest data
- all changes in the room but only in the time of the reservation
- all information about notifications and messages for the reservation
- and even more

Those data give us full knowlage about what is going on the specific reservation. So we get access to full reservation history. The timeline take all the information from different domains which can be related to selected reservation and display them in one place. To get the right data, we need to do some calculations. For example, events related to room status changes don't know about reservations, so to be sure that we connect the right room in the right time to right reservation we need to check some logic. To do that we decided to create separate domain, `reservation_timeline` domain. It's allow us to listen to all interesting for us events and link the right events with right reservation. Some of events we link to reservation timeline you can see in the subscription configuration file below:

```yaml
# config/subscriptions.yml

# ...

reservation_timeline:
  guest_portal__guest_credit_card_authorized: async
  messaging__check_in_instructions_sent: async
  remote_locks__first_guest_entry: async
  reservations__guest_checked_in: async
  reservations__identity_document_added: async
  reservations__unit_assigned: async
  snt__note_sent: async
  # ...
```

Example of custom logic for one of the event:

```ruby
module ReservationTimeline
  class ReservationsIdentityDocumentAddedHandler < TimelineHandler
    def call
      event_store.link(event.event_id, stream_name:, expected_version: :any)
    end

    private

    def booking
      Booking.find_by(pms_reservation_id: event_data.reservation_id)
    end

    def stream_name
      "reservation_timeline__#{booking.id}"
    end
  end
end
```

As you can see here, when we get information about new guest ID added to reservation, we need to map external PMS (Property Management System) reservation id with our internal reservation id. It's somethig easy to do, but sometimes the logic is more difficult, as in the `remote_locks__first_guest_entry` which has no information about reservation, it have information about guest and room. Based on that data, we are finding the right reservation at right time. The output is worth the effort. To get the history of the reservation we just need to do:

```ruby
Rails.configuration.event_store.read.stream("reservation_timeline__#{booking.id}").to_a
```

All the calculations were done before dispaling the events collection, so this code is fast. Just displays the collection. And collection have less the 100, even 50 events.

## Final thought

I know this can be a lot of additional code to take care of RailsEventStore, which is preatty simple in usege, but in our case effrort for introduction all of this solutions was profitable for us. Thanks to this we get:
- easy way to change the events provider
- well structurized, separated code
- easy access to needed data, grouped in usefull streams
- documentation about strucure of events in the code
- readable list of events and subscribers, where in one file you can check who is taking to who
- DSL adjusted to our need

The advantage of this solution was visible later, when we were able to prepare new functionality to our client faster and with better quality. I hope that this approach will inspire you to search for your own solutions that give you the power of effective and pleasent work.

TODO:
- zdjęcie adaptera do prądu
- poprawić linki w poprzednim artykule tak by były tooltipy!!! i no follow
