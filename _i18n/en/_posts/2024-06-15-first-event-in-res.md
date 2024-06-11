---
layout: post
photo: ..
title: First Event in RailsEventStore
description: Migration from Wisper to RailsEventStore
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, Ruby on Rails, RailsEventStore]
imagefeature: ..
lang: en
---

Programmer's dilemma. You are a good developer. You care about your project. You do updates, refactorings, tests and so one and at some point gem you are using in the core of your system is obsolete. The last update was couple years ago. Gem doesn't support the new Ruby version. What you do? You force the gem owner to fix the issue? You start gem maintenance by your self? You move to other solution? Or even create your own solution? In this Rails Event Store series, I will show you how in three moths we moved from `wisper` gem to `rails_event_store` gem.

{% include toc.html %}

## Introduction

**Disclaimer:** This article is not about introduction of events to your existing application. This article is about migration from one event system to another.

We have events in the system, but without events sourcing. The core logic emits events and listen to events, so we can say that we have Pub/Sub architecture. We exchange messages between publishers and subscribers. One domain emit event and other domain react on that.

For example:
- Room is dirty, so now housekeeping domain can send info to the cleaner about it.
- When credit card is provided, we can send check in instructions to the guest.
- When in the property time is 9AM, we can send reports to the team.

As you can see after these examples, we are working with integration of external services to PMS - Property Management System. So we have multiple properties (hotels) and we communicate with external systems to allow guest to book rooms, to send messages to guests, to add remote access to room lock, to handle online check in guest flow (id credit card upload). We have multiple domains which are communicating each other.

For example:
- Inventory - everything related to rooms management
- Housekeeping - everything related to clean up the property/rooms and so on
- Remote locks - remote lock management
- Reservations - everything related to reservation
- Alerts and notifications - system alerts and notifications
- Messaging - management of messages send to the guest (SMS, emails)
- PMS - external systems to manage properties (like Cloudbeds, Stayntouch)
- and others

## Why do we decided to move to RailsEventStore?

We were using `wisper` and `wisper-sidekiq` gems to publishing and subscribing to events in our system. The problem appears around end of 2021 where we noticed issues with updating Ruby to version 3. The last updates for those gems were in last quarter of 2019 year. It was not promising, but we saw on GitHub pages that issue is known. We decided to do temporary fix and monitor the situation. In a mid of 2022, since nothing new appears for that issue, we decided to something about it. Our options were:
- do the hotfix on our end (which we did temporary)
- try to help in the gem maintenance
- prepare own on solution
- rewrite it to other existing solution

We analyzed our current situation and available solutions on a market and we get:
- We don't want to spend our resources to create or maintenance a Pub/Sub solution.
- We want to use solution where we have long support possibility available.
- In near future we want to handle more properties.
- We want to be able to analyze the history of the reservation not only by the developer in logs but also by the normal user in the application.
- We are not directly connected to the `wisper` gem, we have our own adapters between the application and the `wisper`.
- We cannot freeze the development during the migration to new solution.
- We don't want a long-live branch with duplication of features on the main branch but in the new way.

Based on that guidelines we decided to choose [RailsEventStore](https://railseventstore.org/docs/v2/install/). The solution is supported by [Arkency](https://blog.arkency.com/) company and they use that solution in theirs projects. This gives us more certainty for maintenance and possible support if needed. Other advantages for this decision:
- Events will stay in the database - in the solution based on `wisper` events where only logged in the CloudWatch on AWS.
- Easier way to re-run handlers/subscribers - to that point we only had the sidekiq retry mechanism. To re-run handler one more time later, we needed to take json logs from CloudWatch what took some effort. With RailsEventStore we just need a record from database.
- In case we decided to go forward with DDD (or event sourcing), RailsEventStore will help us with that.
- RailsEventStore allows us to group events in streams - We can build our own streams to group needed data in one place. We know that we want to prepare reservation timeline with all events happened around the reservation. It could be hard to achieve with `wisper` solution.

## Adapters

Now, we can go in more details. I already mentioned it, but let's describe it here even more. In our application we were connected to `wisper` and `wisper-sidekiq` via our custom adapters. So our DSL for events in the system was completely independent from `wisper` gems. Thanks to that we could change the adapters without touching application logic. Here is a brief overview of DSL:
- to declare events we use `events` directory
- to emit event we use `emit` method
- to subscribe to event we use class inherit from handler class
- to match published events with handlers we use configuration YAML file

I will describe this in more details in next articles, so stay tuned.

## Migration plan

We know that we can rewrite the way we emit the events without touching the core logic of the system, but we don't want to do that in a wrong way. We need to be able to continue development on new features during we introduce this big change. We also don't want the long-live branch with a lot of changes. It would be a nightmare. We want to see the progress step by step working on production. Decision was simple, we will stich from Wisper to RailsEventStore event by event, domain by domain. We start from one event, as a proof of concept, and deployed to production. When the rest of the app was still working in the old way, we could monitor the first event on RailsEventStore. It's also helping us with one more thing. New features providing new events could be already connected to RailsEventStore. In the future we don't need to rewrite new functionality to new way for emitting events.

## How did we do that? - the code time

### Set up Rails Event Store

Add a gem to `Gemfile`:

```ruby
gem 'rails_event_store'
```

Run migration for PostgreSQL with `jsonb` data type:

```bash
$ rails generate rails_event_store_active_record:migration --data-type=jsonb
$ rails db:migrate
```

Add RailsEventStore configuration already with subscription for the first event (in the future subscriptions will be extracted to separate configuration file):

```ruby
# config/initializers/rails_event_store.rb

class CustomScheduler
  # method doing actual schedule
  def call(klass, serialized_record)
    ServiceWorker.perform_async(klass.name, serialized_record.to_h)
  end

  # method which is checking whether given subscriber is correct for this scheduler
  def verify(subscriber)
    subscriber.is_a?(Class) && subscriber.respond_to?(:call)
  end
end

Rails.configuration.to_prepare do
  Rails.configuration.event_store = event_store = RailsEventStore::Client.new(
    repository: RailsEventStoreActiveRecord::EventRepository.new(serializer: RubyEventStore::NULL),
    dispatcher:
      RubyEventStore::ComposedDispatcher.new(
        RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: CustomScheduler.new),
        RubyEventStore::Dispatcher.new
      )
  )

  event_store.subscribe(Inventory::SntRoomStatusHandler, to: [Snt::RoomStatusEvent])
end
```

### Emitting first event

Tread the code below more like a pseudo-code.

At the beginning, we decided to move `RoomStatusEvent` event from `Snt` domain (one of the PMS domains) to RailsEventStore. The name of this event doesn't sound like a done activity, but this is a external webhook translated to internal event, so we decided to leave the name as it is outside of our system.

```ruby
# app/events/snt/room_status_event.rb

module Snt
  class RoomStatusEvent < RailsEventStore::Event
  end
end
```

This event is often triggered, but rarely have impact on the system. So it's great candidate to proof of concept. In this case, we used just a simple `if` condition to move `RoomStatusEvent` to RailsEventStore. We already put the event in to stream. This stream has all events with the same event type.

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

### Subscribing to first event

Our system gets external webhook, which is translate to the event. The event is process by `Inventory` domain only when related property (property with specific unit) has housekeeping service integration enabled. We can also say: `Inventory` domain subscribe to the `RoomStatusEvent` event.

```ruby
# app/event_handlers/inventory/snt_room_status_handler.rb
module Inventory
  class SntRoomStatusHandler < RailsEventStore::DomainEventHandler
    def call
      Housekeeping::ProcessStatusChange.call(unit, event_name: "mark_as_#{event_data.status}")
    end

    private

    delegate :property, to: :unit

    def process_event?
      property.snt_housekeeping_integration_enabled?
    end

    def unit
      @unit ||= Unit.find_by!(pms_room_id: event_data.room_id)
    end
  end
end
```

### Browser tool to see events in the system

```ruby
# config/routes.rb

authenticate :user, ->(user) { user.admin? || user.superuser? } do
  mount RailsEventStore::Browser => '/res'
end
```

<figure>
  <a href="{{ site.baseurl_root }}/images/rails-event-store/rails-event-store-browser-tool.png"><img src="{{ site.baseurl_root }}/images/rails-event-store/rails-event-store-browser-tool.png"></a>
</figure>

The first event in RailsEventStore is working with the rest of the system still using `wisper` gem.

## Questions

### Who long the migration take?

We started the events migration at 2022-11-18, and we finished at 2023-02-21. Those 3 moths covers migration of all events from all domains, test adjustments, additional cleanups in the code, removing `wisper` and `wisper-sidekiq` gems from the application. It is worth to mention that we didn't stop normal development during the migration process.

### Is there any new about wisper gem?

Yes, at 2023-07-06 new version 3.0.0.rc1 of `wisper` appeared. At that point we weren't relay on `wipser` gem for about 4 month. The `wisper-sidekiq` gem didn't get any update so far.

### Was it worthy to move to RailsEventStore?

Yes, we were able to fast prepare new functionality for the client's team. This functionality would be hard to achieve in the old way. The most important feature was the reservation timeline, where you can find information like:
- time of room cleanup before reservation
- time of providing credit card and ID by guest
- time of check in
- time of enter the room
- and many more

Thanks to that, we were able to find the problems in the reservation flow, the places to introduce improvements or ways to simplify the flow.

### How many events we have per day in the system?

Of course, it depends. In the weekend there is a bigger traffic then in the normal week day. The holiday season also have bigger occupancy, but the average is about 21_000.

### How much space it take in the database?

We start from about 30MB (end of 2022) when we had only a part of events moved to RailsEventStore. Now we have about 5GB of events data (middle of 2024).

### How big is your application?

The main part of the logic without additional library, tests and gems has about 32_000 LOC.

## Final thought

I'm pretty satisfied with what we achieved after 3 moths of RailsEventStore migration. I think, it's reasonable time to do this big change in the code, without braking the working application or stopping the development process. I will say, that there were some problems and issues during migration, but since we did small changes and run them against the production, we were able to solved and fix them on the go.

There are some additional areas related to the RailsEventStore topic which I would love to expand in the future. Like:
- first domain in the RailsEventStore
- adapters layer between system and RailsEventStore
- our additional _helpers_ (configuration files, data type check)
- fast search in the events
- testing
- external webhooks as internal events
- where to start with RailsEventStore
- and even more

If you like this topic, stay tuned.

