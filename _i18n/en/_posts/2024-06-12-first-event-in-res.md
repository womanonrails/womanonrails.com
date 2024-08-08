---
layout: post
photo: /images/rails-event-store/rails-event-store-header
title: First Event in RailsEventStore
description: Migration from Wisper to RailsEventStore
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, Ruby on Rails, RailsEventStore]
imagefeature: rails-event-store/og_image.png
lang: en
one_lang: true
---

The Programmer's Dilemma: As a dedicated developer, you care deeply about your project. You actively perform updates, refactor code, write tests, and more. At some point, however, you realize that a gem you rely on at the core of your system has become obsolete. Its last update was several years ago, and it no longer supports the latest version of Ruby. What do you do? Do you pressure the gem's maintainer to fix the problem? Do you take over maintenance of the gem yourself? Do you switch to an alternative solution, or even create your own? In this RailsEventStore series, I will show how we transitioned from the `wisper` gem to the `rails_event_store` gem in just three months.

{% include toc.html %}

## Introduction

**Disclaimer:** This article is not about introducing events to your existing application. It focuses on migrating from one event system to another.

We already have events in our system, but we don't use event sourcing. Our core logic emits and listens to events, so we can say that we have a Pub/Sub architecture. We exchange messages between publishers and subscribers, where one domain emits an event and another domain reacts to it.

For example:
- When a room is dirty, the housekeeping domain can notify the cleaner.
- When a credit card is provided, check-in instructions can be sent to the guest.
- When in the property timezone is 9 AM, daily reports can be sent to the team.

These examples illustrate how we integrate external services with our Property Management System (PMS). We manage multiple properties (hotels) and communicate with external systems to allow guests to book rooms, send messages to guests, add remote access to room locks, or handle online check-in flow (ID and credit card uploads). Multiple domains within our system interact with each other.

For example:
- Inventory - Handles everything related to room management.
- Housekeeping - Manages the cleaning of properties and rooms.
- Remote Locks - Handles remote lock management.
- Reservations - Manages all aspects of reservations.
- Alerts and Notifications - Manages system alerts and notifications.
- Messaging - Manages guest messaging (SMS, email).
- PMS - Manages properties through external systems (such as Cloudbeds, Stayntouch).
- And others

## Why do we decided to move to RailsEventStore?

We have been using the `wisper` and `wisper-sidekiq` gems to publish and subscribe to events in our system. The problems appeared towards the end of 2021, when we noticed issues updating Ruby to version 3. The last updates for these gems were in the last quarter of 2019. This was concerning, but we saw on GitHub that the issue was known. We decided on a temporary fix while we monitored the situation. By mid-2022, with no new gems developments, we decided to take action. Our options were:
- Implement a hotfix on our end (which we did temporarily)
- Contribute to the gem's maintenance
- Develop our own solution
- Migrate to another existing solution

We analyzed our current situation and the solutions available on the market and came to the following conclusion:
- We don't want to allocate our resources to build or maintain a Pub/Sub solution.
- We want to use a solution with long-term support.
- In the near future, we aim to handle more properties.
- We want the ability to analyze reservation history not only by developers in logs, but also by regular users in the application.
- We are not tightly coupled to the `wisper` gem, we use our own adapters between the application and the `wisper`.
- We cannot stop development while migrating to a new solution.
- We don't want a long-lived branch with features duplicated from the main branch, but implemented in the new way.

Based on these guidelines, we decided to choose <a href="https://railseventstore.org/docs/v2/install/" title="Rails Event Store - Installation" target='_blank' rel='nofollow'>RailsEventStore</a>. This solution is supported by <a href="https://blog.arkency.com/" title="Arkency blog" target='_blank' rel='nofollow'>Arkency</a>, a company that uses RailsEventStore in their projects. This gives us greater assurance for maintenance and potential support if needed. Other benefits of this decision include:
- Persistence of events in the database - In the wisper-based solution, events were only logged in the AWS CloudWatch. RailsEventStore keeps events in the database.
- Easier Re-running of Handlers/Subscribers - Previously, we only relied on the Sidekiq retry mechanism. Re-running a handler later required extracting JSON logs from CloudWatch, which took some effort. With RailsEventStore, all we need is a record from the database.
- Open way for Domain-Driven Design (DDD) and Event Sourcing - If we decide to adopt DDD or Event Sourcing in the future, RailsEventStore will help us with that.
- Group events into streams - RailsEventStore allows us to organize events into streams, so that we can group related data in one place. For instance, we want to create a reservation timeline that includes all events related to a reservation. It could be difficult to achieve with a `wisper` solution.

## Adapters

Now, let's go into more details. As mentioned earlier, our application was connected to `wisper` and `wisper-sidekiq` via custom adapters. This design made our DSL for events completely independent of the `wisper` gems. As a result, we could replace the adapters without touching the application logic.
Here is a brief overview of the DSL:
- to declare events, we use the `events` directory
- to emit event we use `emit` method
- to subscribe to event we use class inherit from handler class
- to match published events with handlers we use configuration YAML file

I will provide more detailed explanations in the next articles, so stay tuned.

## Migration plan

We know the we could rewrite the way we emit the events without touching the core logic of the system, but we wanted to make sure we did it right. It was crucial to continue developing new features while introducing this significant change. We also wanted to avoid a long-lived branch with extensive changes, which would be a nightmare to manage. Instead, we wanted to see incremental progress, with each step working in production.

The decision was simple: we would switch from Wisper to RailsEventStore event by event, domain by domain. We started with one event as a proof of concept and deployed it to production. While the rest of the application continued to work in the old way, we could monitor the first event on RailsEventStore. This approach also had another benefit: new features that introduced new events could already be connected to the RailsEventStore. This meant that in the future, we wouldn't have to rewrite new functionality to use the new flow for emitting events.

## How did we do that? - the code time

### Set up Rails Event Store

Add a gem to `Gemfile`:

```ruby
gem 'rails_event_store'
```

Run migration for PostgreSQL with `jsonb` data type:

```console
$ rails generate rails_event_store_active_record:migration --data-type=jsonb
$ rails db:migrate
```

Add the RailsEventStore configuration already with the subscription for the first event (in the future, subscriptions will be extracted to a separate configuration file):

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

Treat the following code more like pseudocode.

First, we decided to migrate the `RoomStatusEvent` event from the `Snt` domain (one of the PMS domains) to the RailsEventStore. Although the name of this event doesn't suggest an activity, it represents an external webhook translated into an internal event. Therefore, we decided to keep the name as it is outside of our system.

```ruby
# app/events/snt/room_status_event.rb

module Snt
  class RoomStatusEvent < RailsEventStore::Event
  end
end
```

This event is often triggered but has little impact on the system, making it an ideal candidate for a proof of concept. For now, we used a simple `if` condition to move the `RoomStatusEvent` to RailsEventStore. We also added the event to a stream, which contains all events of the same type.

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

Our system receives an external webhook, which is translated into an event. This event is processed by the `Inventory` domain only when the related property (a property with a specific unit) has housekeeping service integration enabled. In other words, the `Inventory` domain subscribes to the `RoomStatusEvent` event.

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

The first event in the RailsEventStore works with the rest of the system still using the `wisper` gem.

## Questions

### How long did the migration take?

We started the event migration on 2022-11-18, and completed it by 2023-02-21. These 3 moths covered migration of all events from all domains, test adjustments, additional code cleanups, and the removal of the `wisper` and `wisper-sidekiq` gems from the application. It is worth to mentioning that we continued normal development during the migration process.

### Is there any news about wisper gem?

Yes, on 2023-07-06, a new version 3.0.0.rc1 of `wisper` gem was released. At that time, we had not relied on the `wipser` gem for about 4 months. The `wisper-sidekiq` gem has not received any update so far.

### Was it worth moving to RailsEventStore?

Yes, we were able to quickly prepare new functionality for the client's team that would have been difficult to achieve with the old system. The most important feature was the reservation timeline, which provides information such as:
- time of room cleanup before reservation
- time of providing credit card and ID by the guest
- time of check-in
- time of room entry
- and many more

Thanks to this, we were able to identify problems in the reservation flow, find areas for improvement, and discover ways to simplify the process.

### How many events do we have per day in the system?

It varies, of course. Traffic is higher on weekends compared to weekdays, and the holiday season also sees increased occupancy. On average, we handle about 21,000 events per day.

### How much space does it take in the database?

We started with about 30MB of event data at the end of 2022, when only a portion of the events had been migrated to RailsEventStore. By mid-2024, we have about 5GB of event data in the database.

### How big is your application?

The core logic of our application, excluding additional libraries, tests, and gems, consists of approximately 32,000 lines of code (LOC).

## Final thought

I'm quite satisfied with what we have achieved after 3 months of migration to RailsEventStore. I believe this was a reasonable timeframe to implement such a significant change in the codebase without breaking the working application or stopping the development process. Of course, there were some issues and problems during the migration, but by making small changes and deploying them to incrementally production, we were able to solve and fix them as we went.

There are several additional areas related to the RailsEventStore that I would love to explore in the future, such as:
- first domain in the RailsEventStore
- adapters layer between the system and the RailsEventStore
- our additional _helpers_ (configuration files, data type checks)
- fast search in the events
- testing
- handling external webhooks as internal events
- and much more

If you are interested in this topic, stay tuned.
