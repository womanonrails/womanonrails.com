---
layout: post
photo: /images/rails-event-store/rails-event-store-testing
title: Testing with Rails Event Store - Practical Tips and Custom Solutions
description: Explore a personalized approach to testing event-driven applications using Rails Event Store
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, Ruby on Rails, RailsEventStore, tests]
imagefeature: rails-event-store/og_image_testing.png
lang: en
one_lang: true
---

Testing is critical in any system, especially asynchronous applications. It's important to test each component in isolation, while carefully managing the communication between them. It is essential to ensure that everything works together seamlessly. For this reason, I would like to share with you the approach we take to testing in our Event-Driven system.

This article is part three of the [Rails Event Store](https://womanonrails.com/tags/#RailsEventStore) series. If you want to learn more, feel free to check out the previous articles. They also explain the [application convetions](https://womanonrails.com/smart-adapters-for-res#directory-structure-and-convention) we use, which may help you better understand our setup and what we want to test. Keep in mind that this is not a testing tutorial, but rather a case study of our experience.

{% include toc.html %}

## What do we use directly from the Rails Event Store?

The Rails Event Store provides its own [matchers for RSpec](https://railseventstore.org/docs/v2/rspec/), some of which we use in our project. The most commonly used ones are:
- `have_published`
- `have_subscribed_to_events` - we build our own matchers on top of these
- `publish`

Below is an example of how to use the `publish` method:

```ruby
require 'rails_helper'

RSpec.describe Booking do
  describe 'lifecycle events' do
    context 'when reservation group code changed' do
      context 'and group code is not empty' do
        it 'emits reservations__group_code_identified' do
          booking = create(:booking, group_code: 'GROUP')

          expect {
            booking.update(group_code: 'NEW_GROUP')
          }.to publish(
            an_event(Reservations::GroupCodeIdentifiedEvent).with_data(
              booking_id: booking.id,
              group_code: 'NEW_GROUP'
            )
          ).in(event_store).in_stream('reservations__group_code_identified')
        end
      end

      context 'and group code is empty' do
        it 'does not emit reservations__group_code_identified' do
          booking = create(:booking, group_code: 'GROUP')

          expect {
            booking.update(group_code: '')
          }.not_to publish(
            an_event(Reservations::GroupCodeIdentifiedEvent)
          ).in(event_store)
        end
      end
    end
  end
end
```

As you can see, we also use additional methods like:
- `an_event`
- `in_stream`
- `with_data`
- `in`

For more details on these methods, I recommend reading the [Rails Event Store documentation](https://railseventstore.org/docs/v2/rspec/).

## Our custom matchers

To make our tests more powerful, we like to create our own custom matchers. Some of these custom matchers use Rails Event Store methods internally. Let's take a look at some of them.

### have_nothing_published

This is a very useful matcher. It helps us ensure that nothing has been published after executing certain logic, such as when invalid data is provided.

```ruby
RSpec::Matchers.define :have_nothing_published do
  match do |block|
    events_count_before = event_store.read.count
    block.call
    events_count_after = event_store.read.count

    (events_count_after - events_count_before).zero?
  end

  def supports_block_expectations?
    true
  end
end
```

In this matcher, we check the contents of `event_store` both before and after executing the test. If nothing has changed, we can confirm that no event has been emitted. As you might have guessed, `event_store` is our shorthand for `Rails.configuration.event_store`, which we've defined in the application.

```ruby
require 'rails_helper'

module Reservations
  RSpec.describe IdentifyReservationsWithOutstandingBalance do
    describe '#call' do
      context 'when some reservation have outstanding balance' do
        # ...
      end

      context 'when none of reservations have outstanding balance' do
        it 'does not emit anything' do
          property = create(
            :property,
            :outstanding_balance_notifications_enabled,
            pms_property_id: 'prop1'
          )
          create(
            :booking,
            property:,
            pms_reservation_id: '1567',
            price_total: 1000.25,
            paid_total: 1000.25
          )
          create(
            :booking,
            property:,
            pms_reservation_id: '2567',
            price_total: 1000.25,
            paid_total: 1000.25
          )

          expect do
            IdentifyReservationsWithOutstandingBalance.call(
              property, pms_booking_ids: %w[1567 2567]
            )
          end.to have_nothing_published
        end
      end
    end
  end
end
```

### subscribe_stream

In some cases, we want to make sure that a particular event has been added to a particular stream. That's why we created this matcher:

```ruby
RSpec::Matchers.define :subscribe_stream do |stream|
  match do |event|
    event.stream_names.include?(stream)
  end
end
RSpec::Matchers.alias_matcher :subscribe_streams, :subscribe_stream
```

This matcher simply checks if the stream name is included in the event's list of streams.

### subscribe_to

We also need to check if a given domain subscribes to certain events. To do this, we created a matcher based on the Rails Event Store's `have_subscribed_to_events`. In addition, we make sure that the subscription is of the correct type - whether it's a synchronous or asynchronous event. Here is the code for the matcher:

```ruby
RSpec::Matchers.define :subscribe_to do |event_name|
  match do |domain|
    handler_class = build_handler_class(event_name, domain)
    event_class = build_event_class(event_name)
    subscription_type = async? ? :async : :sync

    expect(
      EventHandlerBuilder.new(handler_class, subscription_type)
    ).to have_subscribed_to_events(event_class).in(event_store)
  end

  chain :asynchronously do
    @asynchronously = true
  end

  private

  def build_handler_class(event_name, domain)
    handler_name = event_name.to_s.sub('__', '/').camelize
    handler_name.remove!('::')
    "#{domain.name}::#{handler_name}Handler".constantize
  end

  def build_event_class(event_name)
    event_class_name = event_name.to_s.sub('__', '/').camelize
    "#{event_class_name}Event".constantize
  end

  def async?
    @asynchronously
  end
end
```

## Additional test configuration

There are times when we don't want to store events in the database during testing. In such cases, we can use the Rails Event Store repository with the in-memory option. Here's the configuration for that:

```ruby
RSpec.configure do |config|
  config.around(:each, :in_memory_res_client) do |example|
    current_event_store = Rails.configuration.event_store
    Rails.configuration.event_store = RubyEventStore::Client.new(
      repository: RubyEventStore::InMemoryRepository.new
    )
    example.run
    Rails.configuration.event_store = current_event_store
  end
end
```

All you have to do is use it in describe like this, for example:

```ruby
require 'rails_helper'

RSpec.describe Property, :in_memory_res_client do
  # ...
end
```

## Additional linter support

Although it's not directly related to testing, this step occurs before the tests are run. We have a linter that runs before the tests. If our codebase passes the linter checks, the tests continue. However, if the linter fails, we get an alert and the tests are not run until the problem is fixed. While this may seem extreme, we've found it to be quite useful.

The linter we created is called `SubscriptionsList`. It iterates through all the domains and the events that each domain should be listening for, and checks to see if the appropriate handler class exists. This ensures that there's no way to have a defined connection between a domain and an event without handling it. We always get an alert if something is missing. All the information about events and subscribers is set in the `subscriptions.yml` file, that I described in [previous article](https://womanonrails.com/smart-adapters-for-res#yaml-configuration).

We add this linter to `spec/rails_helper.rb` so that every time we run the `rspec spec/` command, the linter is also run.

```ruby
SubscriptionsList.lint!
```

## Event factories

Writing tests becomes much easier and faster if we have the necessary data prepared in advance. For this reason, when we need an event in a test, we use event factories to set it up. We use the Factory Bot gem to do this. Here's an example of an event factory:

```ruby
FactoryBot.define do
  factory :accounts__account_created_event,
          class: Accounts::AccountCreatedEvent do
    skip_create

    sequence(:account_id)

    initialize_with { new(data: attributes) }
  end

  factory :accounts__remote_lock_account_created_event,
          parent: :accounts__account_created_event,
          class: Accounts::RemoteLockAccountCreatedEvent do
    sequence(:external_account_id)
  end

  factory :accounts__remote_lock_account_deleted_event,
          parent: :accounts__remote_lock_account_created_event,
          class: Accounts::RemoteLockAccountDeletedEvent

  factory :accounts__google_account_created_event,
          parent: :accounts__remote_lock_account_created_event,
          class: Accounts::GoogleAccountCreatedEvent

  factory :accounts__account_scheduled_for_deletion_event,
          parent: :accounts__account_created_event,
          class: Accounts::AccountScheduledForDeletionEvent do
    by { 'john@bode.co' }
  end
end
```

In most cases, these events are fairly straightforward - we just need to populate the correct attributes with data. This is the trade-off for enforcing schema validation on events. We always need to prepare a fully valid event, even if some data isn't needed for the specific test. Since event objects aren't meant to be stored in the database, we use `skip_create` for them (they're not the same as records in the `event_store_events` table). We also follow the convention of changing only the data that is relevant to the test, which makes the tests more readable.

## Testing events

Events are simple objects that, in most cases, hold data without any logic. In our case, we don't test the event schema in our tests. For event schema validation, we use `Dry::Struct`, and you can learn more about how we do that [here](https://womanonrails.com/smart-adapters-for-res#event-data-type-check). We also don't test specific data types. Instead, we focus on testing any additional methods added to the event object, such as `primary_source_name`. This method returns information about the source of the event.

```ruby
require 'rails_helper'

module Accounts
  RSpec.describe RemoteLockAccountCreatedEvent do
    describe '#primary_source_name' do
      context 'when account exists' do
        it 'returns creator name' do
          account = create(:account, creator_email: 'john@bode.co')

          event = build(
            :accounts__remote_lock_account_created_event,
            account_id: account.id
          )

          expect(event.primary_source_name).to eq('john@bode.co')
        end
      end

      context 'when account does not exist' do
        it 'returns Remmoved User text' do
          event = build(
            :accounts__remote_lock_account_created_event,
            account_id: 3867
          )

          expect(event.primary_source_name).to eq('Removed User')
        end
      end
    end
  end
end
```

Remember that since we have events in the system, we remember everything that was communicated by events. So we can get the email address of this user, but this was not a point of this method.

Sometimes we also test if the event was added to a specific stream:

```ruby
require 'rails_helper'

module Messaging
  RSpec.describe CheckInInstructionsSentEvent do
    context 'when triggered for Twillio Conversation type' do
      it 'subscribes to twilio__timeline stream' do
        event = build(
          :messaging__check_in_instructions_sent_event,
          :twilio_conversation_type
        )

        expect(event).to subscribe_stream('twilio__timeline')
      end
    end

    context 'when triggered for SendGrid type' do
      it 'does not subscribe to twilio__timeline stream' do
        event = build(
          :messaging__check_in_instructions_sent_event,
          :send_grid_type
        )

        expect(event).not_to subscribe_stream('twilio__timeline')
      end
    end
  end
end
```

Our application contains many different streams, each with a specific purpose, such as a reservation timeline or logs for external services. These logs help us keep track of exactly what we get from webhooks. I'll cover this in more detail in a future article.

## Testing event emission

Now let's explore how we can verify that an event has been emitted. For example, model callbacks are often a good place to start using events. Another good place for events is within services that perform actions and need to notify other parts of the system.

### Model class - event instead of callback

```ruby
require 'rails_helper'

RSpec.describe Property do
  describe 'lifecycle events' do
    context 'when inactive flag is enabled' do
      it 'emits configuration__property_deactivated event' do
        with_current_user(create(:user, email: 'tony@stark.dev')) do
          property = create(:property)
          property.inactive = true

          property.save!

          expect(event_store).to have_published(
            an_event(
              Configuration::PropertyDeactivatedEvent
            ).with_data(
              property_id: property.id,
              by: 'tony@stark.dev'
            )
          ).in_stream('configuration__property_deactivated')
        end
      end
    end

    context 'when inactive flag is disabled' do
      it 'emits configuration__property_activated event' do
        with_current_user(create(:user, email: 'tony@stark.dev')) do
          property = create(:property, :inactive)
          property.inactive = false

          property.save!

          expect(event_store).to have_published(
            an_event(
              Configuration::PropertyActivatedEvent
            ).with_data(
              property_id: property.id,
              by: 'tony@stark.dev'
            )
          ).in_stream('configuration__property_activated')
        end
      end
    end
  end
end
```

### Service class

A good example of a service is the creation of a Facebook account for a user who is not a guest of the property or hotel, but a member of the property team - a crew member.

```ruby
require 'rails_helper'

module Accounts
  RSpec.describe CreateFacebookAccount do
    describe '.call' do
      it 'creates facebook account' do
        account = create(
          :account,
          first_name: 'Tom',
          last_name: 'Crouse',
          email: 'tom@example.com',
          job_title: 'Event manager'
        )
        allow(FacebookApi::Wrapper).to receive(:create_account).
          with({
            email: 'tom@example.com',
            name: 'Tom Crouse',
            title: 'Event manager'
          }).
          and_return('facebook-id')

        CreateFacebookAccount.call(account.id)

        expect(account.reload.facebook_account_id).to eq('facebook-id')
      end

      it 'emits accounts__facebook_account_created event' do
        account = create(
          :account,
          first_name: 'Tom',
          last_name: 'Crouse',
          job_title: 'staff',
          email: 'tom@example.com'
        )
        allow(FacebookApi::Wrapper).to receive(:create_account).
          with({
            email: 'tom@example.com',
            name: 'Tom Crouse',
            title: 'staff'
          }).
          and_return('facebook-id')

        CreateFacebookAccount.call(account.id)

        expect(event_store).to have_published(
          an_event(Accounts::FacebookAccountCreatedEvent).with_data(
            account_id: account.id.to_s,
            external_account_id: 'facebook-id'
          )
        ).in_stream('accounts__facebook_account_created')
      end
    end
  end
end
```

In the first test, we check if the communication with Facebook via the API was successful (i.e. the external results). The next test verifies that the event was emitted and correctly placed in the appropriate stream.

### Async worker

This scenario is similar to the one with the service.

```ruby
require 'rails_helper'

module Reservations
  RSpec.describe RemoveBookingWorker do
    describe '#perform' do
      it 'emits reservations__booking_deleted event' do
        property = create(:property, pms_property_id: 'property_pms_id_1')
        booking = create(
          :booking,
          property:,
          pms_reservation_id: 'reservation_id_1'
        )

        RemoveBookingWorker.new.perform(booking.id)

        expect(event_store).to have_published(
          an_event(Reservations::BookingDeletedEvent).with_data(
            uid: 'reservation_id_1',
            property_pms_id: 'property_pms_id_1'
          )
        ).in_stream('reservations__booking_deleted')
      end
    end
  end
end
```

## Testing event subscriptions

These types of tests are fairly general, but sometimes you want to make sure that all domains that should be subscribing to certain events are actually doing so. Here's an example of this type of test:

```ruby
require 'rails_helper'

RSpec.describe Accounts, tag: :accounts do
  it 'subscribes to selected events' do
    expect(Accounts).to subscribe_to(:accounts__account_created).asynchronously
    expect(Accounts).to subscribe_to(
      :accounts__account_scheduled_for_deletion
    ).asynchronously
  end
end
```

As you can see here, we use our own matcher for this.

## Event Handler tests

We have two different types of tests for handlers:
1. **Expecting an outcome** - We expect something to happen, such as a change in the database, sending an email, or sending a message. These are often called black-box tests.
2. **Call expectation** - We expect something to be called, such as checking to see if a handler has called another service. The complete logic of the service is tested separately. Again, it's a good practice to test the logic through an **integration test**. An event enters the system, and we expect a certain behavior to follow.

### Testing a method call in an event handler

First, let's look at a test that checks whether a method or service is called:

```ruby
require 'rails_helper'

module Accounts
  RSpec.describe AccountsAccountCreatedHandler do
    it 'schedules account creation for all specified integrations' do
      ops_integration = instance_double(OpsIntegration, create!: nil)
      remote_lock_integration = instance_double(RemoteLockIntegration, create!: nil)
      allow(OpsIntegration).to receive(:new).and_return(ops_integration)
      allow(RemoteLockIntegration).to receive(:new).
        and_return(remote_lock_integration)
      stub_const(
        'Accounts::Integrations::INTEGRATION_LIST',
        [OpsIntegration, RemoteLockIntegration]
      )
      account = create(
        :account,
        first_name: 'Tom',
        last_name: 'Crouse',
        email: 'tom@example.com',
        ops_role: 'staff',
        ops_permissions: ['charging_cc_on_file'],
        ops_property_ids: [1]
      )
      event = build(:accounts__account_created_event, account_id: account.id)

      AccountsAccountCreatedHandler.new(event).call!

      expect(OpsIntegration).to have_received(:new).with(account)
      expect(RemoteLockIntegration).to have_received(:new).with(account)
      expect(ops_integration).to have_received(:create!)
      expect(remote_lock_integration).to have_received(:create!)
    end
  end
end
```

Let's break down what's happening here. We get an event indicating that a new account has been created. In this test, we want to verify the creation of external accounts, such as Remote Lock, Facebook, Google, and so on. In this particular test, we expect only two integrations, which are defined in the `INTEGRATION_LIST` constant. To verify the behavior, we check to see if the two classes, `OpsIntegration` and `RemoteLockIntegration`, have been executed.

Yes, this test is tightly coupled to the implementation of the handler, but this approach is helpful to guide the development of the correct logic (following the TDD flow). Since the logic involves communication with external APIs, we don't actually call those APIs during the test. We just want to make sure that our code is set up to communicate with them correctly.

### Testing that something happened in the event handler

```ruby
require 'rails_helper'

module Accounts
  RSpec.describe AccountsAccountScheduledForDeletionHandler do
    it 'schedules deletion of account integrations for all specified integrations' do
      ops_integration = instance_double(OpsIntegration, remove!: nil)
      remote_lock_integration = instance_double(RemoteLockIntegration, remove!: nil)
      allow(OpsIntegration).to receive(:new).and_return(ops_integration)
      allow(RemoteLockIntegration).to receive(:new).
        and_return(remote_lock_integration)
      stub_const(
        'Accounts::Integrations::INTEGRATION_LIST',
        [OpsIntegration, RemoteLockIntegration]
      )
      account = create(
        :account,
        first_name: 'Tom',
        last_name: 'Crouse',
        email: 'tom@example.com',
        ops_role: 'staff',
        ops_permissions: ['charging_cc_on_file'],
        ops_property_ids: [1]
      )
      event = build(
        :accounts__account_scheduled_for_deletion_event,
        account_id: account.id,
        by: 'john@bode.co'
      )

      AccountsAccountScheduledForDeletionHandler.new(event).call!

      expect(OpsIntegration).to have_received(:new).with(account)
      expect(RemoteLockIntegration).to have_received(:new).with(account)
      expect(ops_integration).to have_received(:remove!)
      expect(remote_lock_integration).to have_received(:remove!)
    end

    it 'saves user email in the account record as remover_email' do
      ops_integration = instance_double(OpsIntegration, remove!: nil)
      remote_lock_integration = instance_double(RemoteLockIntegration, remove!: nil)
      allow(OpsIntegration).to receive(:new).and_return(ops_integration)
      allow(RemoteLockIntegration).to receive(:new).
        and_return(remote_lock_integration)
      stub_const(
        'Accounts::Integrations::INTEGRATION_LIST',
        [OpsIntegration, RemoteLockIntegration]
      )
      account = create(
        :account,
        first_name: 'Tom',
        last_name: 'Crouse',
        email: 'tom@example.com',
        ops_role: 'staff',
        ops_permissions: ['charging_cc_on_file'],
        ops_property_ids: [1]
      )
      event = build(
        :accounts__account_scheduled_for_deletion_event,
        account_id: account.id,
        by: 'john@bode.co'
      )

      AccountsAccountScheduledForDeletionHandler.new(event).call!

      expect(account.reload.remover_email).to eq('john@bode.co')
    end
  end
end
```

In this example, you can see both types of event handler tests. The first test demonstrates checking a specific method call, while the second test checks a specific behavior - storing information about the person who removed the account.

## Summary

That's all I wanted to share with you about testing event-driven logic. We've created some additional matchers and configurations to make testing easier for ourselves. We also have a special approach to testing event subscriptions and handlers. All of these tweaks are for our convenience, to make test creation more enjoyable, and to provide flexibility in the testing process. It's all about making our lives easier. I hope some of these examples inspire your own journey down the Rails Event Store highway.

Please check out my previous Rails Event Store articles:
- [First Event in Rails Event Store](https://womanonrails.com/first-event-in-res)
- [Smart adapters for the Rails Event Store](https://womanonrails.com/smart-adapters-for-res#event-data-type-check)
