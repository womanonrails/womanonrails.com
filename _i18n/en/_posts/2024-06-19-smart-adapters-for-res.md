---
excerpt: >
  It's a good practice to remain independent of external tools,
  gems, or libraries.
  Of course, in many cases,
  we do rely on external code, and that's normal.
  Otherwise, we'd end up doing things
  like HTTP requests or user authentication ourselves,
  and that would distract us from the real needs of our customers.
  So the balance between using external tools
  and creating custom solutions is crucial.
  The real question is
  how can we use external tools
  and still have enough flexibility in our code?
  That's what we'll focus on today,
  using our integration with RailsEventStore as an example.
layout: post
photo: /images/rails-event-store/rails-event-store-adapters-header
title: Smart adapters for RailsEventStore
description: Managing layer of events abstraction
headline: Premature optimization is the root of all evil.
categories: [programming, rails-event-store]
tags: [Ruby, Ruby on Rails, RailsEventStore]
imagefeature: rails-event-store/og_image_adapters.png
lang: en
one_lang: true
---

It's a good practice to remain independent of external tools, gems, or libraries. Of course, in many cases, we do rely on external code, and that's normal. Otherwise, we'd end up doing things like HTTP requests or user authentication ourselves, and that would distract us from the real needs of our customers. So the balance between using external tools and creating custom solutions is crucial. The real question is how can we use external tools and still have enough flexibility in our code? That's what we'll focus on today, using our integration with RailsEventStore as an example.

In my last article, I described how we moved the [first event to the RailsEventStore]({{ site.baseurl }}/first-event-in-res "First Event in RailsEventStore"). This would not have been so easy without the separation between the `wisper` gem and our application, without a layer of abstraction - the adapters we wrote. Today, I will focus on showing you these adapters. We will discuss:
- the `emit` method we use to publish events
- the basic handler class for event subscription
- YAML configuration for matching publishers and subscribers
- event data type check
- and grouping events by using streams.

{% include toc.html %}

## Directory structure and convention

I often see application logic organized by domains, where each domain contains all the related logic, whether it's an event, a handler, or something else. I think this is a good approach because it allows you to focus on a single directory to understand the domain-specific logic. In our case, we use a different approach, not necessarily better, just different.

We keep all events in one directory, separated by domains. We use the same convention we use for event handlers. You could say that the first approach is more domain oriented, while our approach is more pattern oriented.

```bash
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

The next part of our convention involves the suffixes added to the event and handler names. Event files will have names like  `something_happened_event.rb` while handler/subscriber files will have names like `incoming_domain__something_happened_handler.rb`. The handler file is included in the subscriber domain.

For example, the `housekeeping` domain has a subscriber file named `inventory__unit_became_dirty_handler.rb`, that responds to the `unit_become_dirty` event from the `inventory` domain.

## Emit method

In the previous post, I put the event emission code directly in webhooks to event translation logic.

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

As you can see, instead of using a single `emit` method, we have an `if` condition in place. This approach is fine for a proof of concept but not suitable for a long-term solution. Instead of this condition, we want to keep the code simple, like this:

```ruby
# app/lib/webhooks/snt/emit_events_for_webhook_payload.rb

def call
  emit("snt__#{payload.event}", payload.event_attributes)
end
```

### Prepare one emit method for both ways RailsEventStore and Wisper

We move the responsibility for the event emission logic out of the webhooks translator and put it into the `emit` method. Since we use the `emit` method consistently throughout the application, we don't need to change the application code, we just change the `emit` method itself. Here’s what the emit method looks like  during the transition:

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

The `if` condition is now within the `emit` method, but it's _smarter_. We check the class we inherit from. If it's a RailsEventStore event, we use its method to call the event. Otherwise, we use `wisper` gem flow. For readability, we split part of the logic into smaller classes. These classes are:
- `EventClassFactory` - searches for the right event class based on the event name and domain.
- `EventEmission` - emits the right event with the correct payload. Currently, the `EventEmission` class covers the wisper solution.

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

  EventEmission.new(
    abstract_event_class, event_class, event_name, explicit_payload, self
  ).call
end
```

Here the `EventEmission` class covers the RailsEventStore way of emitting events.

## Handler class

In the case of handlers, we just change the class that handler inherits from.

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

And this is the code that adapts the RailsEventStore interface to our needs:

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

So, this class allows us to process events only when certain conditions in the domain are met, such as a property having integration with the housekeeping service. In addition, we can access event data more easily. Instead of `event.data[:room_id]` we can use `event_data.room_id`.

## Adapter class

The `EventHandlerBuilder` class allows us to translate the way RailsEventStore calls subscribers to the way we call them in our application. This class allows us to use the same interface for all handlers:

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

We will use this in the `rails_event_store.rb` initializer for only one event for now:

```ruby
# config/initializers/rails_event_store.rb

event_store.subscribe(
  EventHandlerBuilder.new(Inventory::SntRoomStatusHandler),
  to: [Snt::RoomStatusEvent]
)
```

Based on the code, you can see that we are prepared to handle events both synchronously and asynchronously. The `EventWorker` is our worker designed to handle events asynchronously.

```ruby
# workers/event_worker.rb

class EventWorker < SidekiqWorker
  sidekiq_options backtrace: 20, dead: true, retry: 100, queue: 'events'
  sidekiq_retry_in { |count| count > 100 ? 120 : 60 }

  def perform(class_name, event_id)
    class_name.constantize.new(
      Rails.configuration.event_store.read.event(event_id)
    ).call!
  end
end
```

## YAML configuration

As I mentioned before, we put the event subscriber into the `rails_event_store.rb` as a proof of concept:

```ruby
# config/initializers/rails_event_store.rb

Rails.configuration.to_prepare do
  # ...

  event_store.subscribe(
    EventHandlerBuilder.new(Inventory::SntRoomStatusHandler),
    to: [Snt::RoomStatusEvent]
  )
end
```

### Extract subscriptions from RailsEventStore configuration file

We wanted to avoid declaring all the new subscribers directly in the `rails_event_store.rb` file, as this would become a large and frequently modified file. To solve this problem, we extracted the event subscriptions into a separate YAML configuration file. The first version of this logic was hardcoded into the `rails_event_store.rb` file:

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
      handler_class =
        "#{domain_name.classify}::#{event_domain}#{name}Handler".constantize
      event_store.subscribe(
        EventHandlerBuilder.new(handler_class, subscription_type),
        to: [event_class]
      )
    end
  end
end
```

We load the `YAML` file and for each domain we create subscribers based on the names in the `YAML` file. Here is the an example of a `YAML` file:

```yaml
# config/subscriptions.yml

inventory:
  snt__room_status: async
```

We can translate this to: _The Inventory domain has a SntRoomStatusHandler subscriber that asynchronously handles the RoomStatusEvent from the Snt domain_.

### Handling streams for events

We also wanted to be able to handle events in multiple streams. To do this in a simple way, we created a single subscriber for all events that associates events with specific streams. More information about this can be found later in this article in the [Event streams section]({{ site.baseurl }}/smart-adapters-for-res#event-streams "Event streams"). Here, I'll show the necessary logic from a configuration perspective. This solution can also be used in other cases where we want to perform an action on all triggered events, such as additional logs or something similar.

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
        handler_class =
          "#{domain_name.classify}::#{event_domain}#{name}Handler".constantize
        event_store.subscribe(
          EventHandlerBuilder.new(handler_class, subscription_type),
          to: [event_class]
        )
      end
    end
  end
end
```

So now the logic takes care of two different cases: one that handles all events in the same way, and another that covers only specific events. Here is what the `subscriptions.yml` file will look like, with additional `all_events` type in specific _domain_.

```ruby
# config/subscriptions.yml

inventory:
  snt__room_status: async

streams:
  all_events: sync
```

### Final solution for subscription file

After migrating all the logic related to mapping events and subscribers to the separate class `SubscriptionsList`, the code in the `rails_event_store.rb` file looks like this:

```ruby
# config/initializers/rails_event_store.rb

Rails.configuration.to_prepare do
  Rails.configuration.event_store = event_store =
    RailsEventStore::Client.new(
      repository: RailsEventStoreActiveRecord::EventRepository.new(
        serializer: RubyEventStore::NULL
      )
    )

  SubscriptionsList.config_path = Rails.root.join('config/subscriptions.yml')
  SubscriptionsList.load!(event_store)
end
```

With this setup, you can manage event subscriptions in a separate YAML file, keeping the `rails_event_store.rb` file clean and maintainable. I really like this solution.

## Event Data Type Check

We had in our own event system a check for event data types. We used `Dry::Struct` for that. To not lose this functionality, we prepared our own version of the RailsEventStore event class `EventWithType`.

```ruby
# lib/event_with_type.rb

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
# events/snt/room_status_event.rb

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

It allows us to easily check if the data is in the correct format. We don't have to worry about whether the type of `room_id` is a string, an integer, or something else. We see it in the declaration. This gives us live documentation and quick validation benefits. We know what to expect in the event, which is very useful. This information is always up to date because it's a part of the running code.

## Event streams

Thanks to RailsEventStore, we can group our events into streams. We decided to create two different types of streams. The default one, where we just need the data the event has, and custom streams, which require some calculations to link to the right stream.

### Handling default streams for events

We handle all default streams in the stream handler. You can get more information about the configuration of default streams in the [Handling streams for events]({{ site.baseurl }}/smart-adapters-for-res#handling-streams-for-events "Handling streams for events") section. Here you can see the `StreamsHandler` class.

```ruby
# app/event_handlers/streams_handler.rb

class StreamsHandler < RailsEventStore::DomainEventHandler
  def call
    event.stream_names.each do |stream_name|
      event_store.link(
        event.event_id,
        stream_name: stream_name,
        expected_version: :any
      )
    end
  end

  private

  def event_store
    Rails.configuration.event_store
  end
end
```

To add an event to the default stream, we have the `stream_names` method in the event class:

```ruby
# events/snt/room_status_event.rb

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

As you can see, we will be able to find the `RoomStatusEvent` in the `snt__timeline` stream and in the specific room stream, for example, `room_123`. In addition, by default we will add this event to the `snt__room_status` stream. This is the result of the `emit` method declaration.

### Handling custom streams for events

If we need a more customized solution to link events to specific streams, we can use custom streams. A good example is the reservation timeline. For each reservation, we wanted to aggregate all events related to that specific reservation:
- all changes related to the status, dates, and type of the room
- all changes in the guest data
- all changes in the room, but only during the reservation period
- all information about notifications and messages related to reservation
- and much more

This data gives us full knowledge of what is happening with a specific reservation. We get access to the complete reservation history. The timeline aggregates information from different domains related to the selected reservation and displays them in one place.

To get this data, we need to perform some calculations. For example, events related to room status changes don't know anything about reservations. To ensure that we connect the right room at the right time to the correct reservation, we need to apply some logic. To do this, we have created a separate domain, the `reservation_timeline` domain. This domain allows us to listen to all relevant events and link the right events to the right reservation. Some of the events we link to reservation timeline can be seen in the subscription configuration file below:

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

Example of custom logic for one of the events:

```ruby
# event_handlers/reservation_timeline/reservations_identity_document_added_handler.rb

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

As you can see here, when we receive information about a new guest ID added to the reservation, we need to map the external PMS (Property Management System) reservation ID to our internal reservation ID. This is relatively simple, but sometimes the logic is more complex, as in the case of `remote_locks__first_guest_entry`. This event has no information about the reservation, it just contains data about the guest and the room. Based on this data we find the right reservation at the right time. The output is worth the effort. To get the history of the reservation, we just need to do the following:

```ruby
Rails.configuration.event_store.read.stream(
  "reservation_timeline__#{booking.id}"
).to_a
```

All the calculations were done before displaying the events collection, so this code is fast. Just display the collection. And collection have less than 100, even 50 events.

## Final thoughts

I understand that adding so much code to integrate RailsEventStore may seem overwhelming, especially since it is easy to use on its own. However, in our case, the effort we put into implementing these solutions has been well worth it. Here's what we get:
- an easy way to switch event provider
- well-structurized, modular code
- easy access to the data we need, grouped into useful streams
- documentation of event structure embedded in the code
- an easy-to-read list of events and subscribers, allowing a clear overview of interactions in a single file
- a DSL tailored to our specific needs

The benefits of this solution became apparent later, as we were able to develop new functionality for our customers faster and with better quality. I hope that this approach inspires you to find your own solutions that will make your work more effective and enjoyable.
