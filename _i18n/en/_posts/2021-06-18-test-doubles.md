---
layout: post
photo: /images/test-doubles/test-doubles
title: Test doubles - the difference between stubs and mocks
description: How to use different types of test doubles?
headline: Premature optimization is the root of all evil.
categories: [testing]
tags: [tdd, tests, mocks, stubs]
imagefeature: test-doubles/og_image-test-doubles.png
lang: en
---

In the testing world, we have **stubs**, **mocks**, **dummy objects**, and so on. It can be confusing what to use and when to use it. I would like to organize all of those terms in a more accessible way. There is one problem.  In many different sources, we have discrepancies regards to those terms. I will show you my understanding of this topic. Of course, based on chosen sources.

First of all, what is **test double**? The test double is any object used for testing purposes, which replaces the real object. So, this test double pretends to be some real object in a test. Here are different types of test doubles: <a href="#dummy-object">dummy</a>, <a href="#fake-object">fake</a>, <a href="#stub-object">stub</a>, <a href="#spy-object">spy</a>, or <a href="#mock-object">mock</a>. Now we can go through all of those specific terms.

## Dummy object

**Dummy object** is a bogus object **passed to the code to satisfy the API**. We usually put it to the parameter/argument/attribute list, but we don't need to use it. Dummy objects don't have an implementation. We can say it's empty like an eggshell. I can use it, for example, when I'm testing the method of a class that requires mandatory attribute(s) in an initializer (constructor), which has no impact on my method. I may use a dummy object in that case for the creation of a class instance.

#### Example

I notice that I don't use dummy objects too often. In most cases, I use other test doubles instead of a dummy object. So, the example will be more showcase than the real code example. I will use the **RSpec** tool for that.

```ruby
class EmailRecipient
  def initialize(recipient)
    @recipient = recipient
  end

  def message_already_received?
    false
  end

  ...
end

RSpec.describe EmailRecipient do
  describe '#message_already_received?' do
    it 'returns false' do
      recipient = double(Recipient)

      email_recipient = EmailRecipient.new(recipient)

      expect(recipient.message_already_received?).to eq false
    end
  end

  ...
end
```

The `EmailRecipient` has one argument in the initializer that isn't used in the `message_already_received?`. In this case, I don't care too much about the `recipient` instance variable. Instead of `double`, I could even use the `nil` value here. As you can see, it's like a shell, nothing inside.

## Fake object

**Fake** in an object with working implementation, but in most cases, it's simpler than on production. So, you won't use it there. **The purpose of a fake object is to simplify the way we test code**. It removes unnecessary or heavyweight dependencies and allows us to focus only on our code, not interactions with some external infrastructure, for example. The most common cases where we use fake are:
- in-memory or one-file database, like SQLite - It's good for testing, more lightweight than the _real_ database, but you wouldn't use it on production.
- save data to files on disk or in-memory file system instead of using external service for that (e.g. Amazon S3) - In your case, the _save to disk_ implementation is a fake. On production, you'd use real external storage.  In your unit test, you don't need it. It's a good practice to does not interact with external infrastructure in unit tests.

#### Example

The example will be Rails **Active Storage** functionality. It facilitates uploading files to cloud storage services and then attaches those files to Active Record objects. In production environment setups, we will do something like:

```ruby
# config/environments/production.rb
config.active_storage.service = :amazon
```

but in the case of tests, we will set:

```ruby
# config/environments/test.rb

# Store uploaded files on the local file system in a temporary directory.
config.active_storage.service = :test
```

Storage setups can look like this:

```yml
# config/storage.yml

test:
  service: Disk
  root: <%= Rails.root.join('tmp/storage') %>

amazon:
  service: S3
  access_key_id: <%= ENV.fetch('AWS_DOCUMENT_ACCESS_KEY_ID') %>
  secret_access_key: <%= ENV.fetch('AWS_DOCUMENT_SECRET_ACCESS_KEY') %>
  bucket: <%= ENV.fetch('AWS_DOCUMENT_BUCKET') %>
  region: <%= ENV.fetch('AWS_IMAGE_REGION') %>
```

Thanks to those settings, we can test upload functionality using a local file system instead of cloud storage. We simplify logic related to file upload for tests. It's transparent for us.

```ruby
module Admin
  module Book
    class AttachmentsController < ApplicationController
      ...

      def update
        book_form.files.attach(params[:book][:files])
        book_form.save

        flash[:notice] = 'Document has been uploaded for this book'
        redirect_to admin_book_path(book)
      end

      ...
    end
  end
end

module Admin
  module Book
    RSpec.describe AttachmentsController, type: :controller do
      describe '#update' do
        it 'adds file to book' do
          admin = create(:user, :confirmed, :admin)
          login_user(admin)
          book = create(:book)
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/support/fixtures/test.png'), 'image/png'
          )

          expect {
            put :update, params: { book_id: book.id, book: { files: [file] } }
          }.to change { book.reload.files.attached? }.from(false).to(true)
        end
      end

      ...
    end
  end
end
```

## Stub object

**Stub** provides hard-coded answers to calls done during the test. It's an object, in most cases, responding only to what was programmed in for test purposes, nothing else. We can say that stub overrides methods and returns needed for test values. **The purpose of a stub is to prepare a specific state of your system under the test.**

For example, we want to test a class dependent on time consuming and complex calculations. Those calculations are tested separately. So in our case, we want to have some specific result from those calculations. We prepare the state of our system for the test. No matter how we get there. The most important is how the system will behave in that particular state. We use a shortcut - the stub.

#### Example 1

```ruby
class UserDuplicates
  ...

  def each
    duplicate_users.each do |user_duplicate|
      mismatched_attributes = mismatched_attributes(user_duplicate)
      match_level = TypeOfUserMatch.result_for(user, user_duplicate: user_duplicate)

      yield user_duplicate, match_level, mismatched_attributes
    end
  end

  ...
end
```

Let's assume that the `TypeOfUserMatch` class has complex calculations. They take 2-3 seconds to finish. We don't want to wait till the end of calculations. So, we will use the stub to provide a specific state of those calculations in our test case.

```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'yields fully duplicated objects' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)
      allow(TypeOfUserMatch).to receive(:result_for).and_return(:full)

      expect { |n| UserDuplicates.new(user).each(&n) }.to yield_successive_args([
        user_duplicate, :full, []
      ])
    end

    ...
  end
end
```

Alert! If for some reason, we will stop using `TypeOfUserMatch`, this test can still pass. For example, in case the logic will be fulfilled. The test won't tell us that we don't use `TypeOfUserMatch`. It's important. Keep it in mind. I will come back to this information in the <a href="#mock-object">mock section</a>.

I'd like to mention one more thing here. By doing some adjustments in the code, like dependency injection, we could use different RSpec mechanisms. A `class_double` to stub the class state. The `class_double` is similar to `instance_double`. Both are useful because they verify if we are compatible with the class/object interface. In case we change the name of a method or remove it, the test will fail. Below you can find a possible look for the test.


```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'yields fully duplicated objects' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)
      user_match_double = class_double(TypeOfUserMatch, result_for: :full)

      expect { |n| UserDuplicates.new(user, user_match_double).each(&n) }.
        to yield_successive_args([
          user_duplicate, :full, []
        ])
    end

    ...
  end
end
```

### Using stub with API

Another example is interaction with external REST API. Generally, it's good practice don't call the external API in test cases (at least in low-level tests, like unit tests). To don't depend on it. It's a good place to use stubs. You can try different API answers, like responses with a specific error. This way, you could write tests that check how the system reacts for specific API states.

#### Example 2

Let's see how could it looks like. We have API with quotes. Here is a code:

```ruby
class Client
  BASE_URI = 'http://quotes.rest'

  def get_qod(category)
    response = HTTParty.get(
      "#{BASE_URI}/qod.json",
      headers: headers,
      query: "category=#{category}"
    )
    parse_response(response)
    ...
  end

  ...
end
```

Now, the test. Of course, it won't give us 100% that code is working. It's just a stub. There are some other ways to check that, but let's focus on our test.

```ruby
RSpec.describe Client do
  describe '#get_qod' do
    it 'returns quote object' do
      body = {
        'success' => { 'total' => 1 },
        'contents' => {
          'quotes' => [
            {
              'quote' => 'A leader is the wave pushed ahead by the ship.',
              'length' => '46',
              'author' => 'Leo Nikolaevich Tolstoy',
              'tags' => ['leadership', 'management'],
              'category' => 'management',
              ...
            }
          ],
          ...
        }
      }
      stub_request(:get, 'http://quotes.rest/qod.json').
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          },
          query: { 'category' => 'management' }
        ).
        to_return(body: body.to_json)

      result = Client.new.get_qod('management')

      expect(result).to match(body)
    end
  end
end
```

Here is an example of how the code reacts to specific API states.

```ruby
RSpec.describe Client do
  describe '#get_qod' do
    ...

    it 'returns empty hash when there is a Net::ReadTimeout' do
      allow(HTTParty).to receive(:get).and_raise(Net::ReadTimeout)

      result = Client.new.get_qod('management')

      expect(result).to match({})
    end
  end
end
```

## Spy object

In my understanding of spy, **spy** is a specific type of stub that can also record some information based on how it was called.  Spy takes over some calls to the real objects and verifies those calls without replacing the entire original object. At some point, it can sound similar to a fake. For me, the fake object is more of a transparent layer. We use it to simplify the tests. The spy object allows us to verify some information. I'd say that **the purpose of a spy is to help us with verifying some information on an object normally hard to verify**.

Alert! In RSpec we can find **spy** method. In my opinion, from its behavior point of view, it's more like <a href="#mock-object">mock object</a>.

For example, when you want to verify sending an email, depends on the spy type, you can get information about: sending a message, the number of sent messages, or even what is in the email body.

#### Example

Something like that we can find in Rails to verify emails. In the test configuration, we have:

```ruby
# config/environments/test.rb

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
```

Then we can test sending emails:

```ruby
RSpec.describe SendDailyNewsletter do
  describe '.call' do
    it 'delivers daily newsletter for subscriber' do
      ...

      expect {
        SendDailyNewsletter.call
      }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end
```

## Mock object

**Mock** is a part of your test that you have to set up with expectations. It's an object pre-programmed with expectations about calls it's expected to receive. **The purpose of a mock is to make assertions about how the system will interact with the dependency.** In other words, mock verify the interactions between objects. So, you don't expect that mock return some value (like in the case of stub object), but to check that specific method was called.

For example, after calling the `save` method on the new `User` object, mock expect that the `SendConfirmationEmail` service should be called.

#### Example 1

Let's go back to the `UserDuplicates` example. When I would like to check if the `result_for` method is called, it could look like this:


```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'calls result_for method for each user duplicate' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)
      allow(TypeOfUserMatch).to receive(:result_for).and_return(:full)

      UserDuplicates.new(user).each {}

      expect(TypeOfGuestMatch).to have_received(:result_for).
        with(user, user_duplicate: user_duplicate)
    end

    ...
  end
end
```

In the example above, first, I declare that I watch the `result_for` method using `allow`. Then I run code `UserDuplicates.new(user).each {}`. In the end, I verify if the `result_for` method was called by using `expect`.

#### Example 2

Now I will declare my expectation using `expect`. Then I will run a code `UserDuplicates.new(user).each {}`. In this case, verification will be done automatically.

```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'calls result_for method for each user duplicate' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)

      expect(TypeOfUserMatch).to receive(:result_for).
        with(user, user_duplicate: user_duplicate).
        and_return(:full)

      UserDuplicates.new(user).each {}
    end

    ...
  end
end
```

I like more the first example. It is easier for me to read and understand, but you can have your preferences.

## What is the difference between Stub and Mock?

In my opinion, a stub is an object that returns a hard-coded answer. So it represents a specific state of the real object. Mock, on the other hand, verify if a specific method was called. It's testing the behavior. I like the idea that stub returns answers to the question and mock verifies if the question was asked.

## What are the advantages and disadvantages of test doubles?

#### Advantage
- eliminates complex fixtures - when you work with real objects in your tests, especially with big systems, your fixture can be quite complex to cover all the cases. It's something that can resolve test doubles.
- support independent tests - when we use the real objects, a small change in the object can break a lot of tests. It's the next thing where tests doubles can help.
- faster tests - Since you don't need to create full-real objects (for example, create objects and save them in the database) or do time-consuming calculations, it can speed.

#### Disadvantage
- can give false positives - your test doubles can be incorrect. Your unit tests are green, but under the hoot, your code is not working. It's why I suggest using both approaches: real objects and test doubles.
- coupled to the implementation - In the case of mocks, your tests are coupled to the method or class implementation. When implementation changed, it's more likely your tests will break.
- problem with refactoring - since tests with mocks can be coupled to your code implementation, it can impact the refactoring in your system.

## Bibliography
- <a href="https://martinfowler.com/articles/mocksArentStubs.html" title="Martin Fowler - Mocks Aren't Stubs" target='_blank' rel='nofollow'>Mocks Aren't Stubs - Martin Fowler</a>
- <a href="https://blog.cleancoder.com/uncle-bob/2014/05/14/TheLittleMocker.html" title="Robert C. Martin - The Little Mocker" target='_blank' rel='nofollow'>The Little Mocker - Robert C. Martin</a>
- <a href="https://stackoverflow.com/questions/3459287/whats-the-difference-between-a-mock-stub" title="What's the difference between a mock & stub?" target='_blank' rel='nofollow'>What's the difference between a mock & stub?</a>
- <a href="https://stackoverflow.com/questions/346372/whats-the-difference-between-faking-mocking-and-stubbing" title="What's the difference between faking, mocking, and stubbing?" target='_blank' rel='nofollow'>What's the difference between faking, mocking, and stubbing?</a>
- <a href="https://relishapp.com/rspec/rspec-mocks/docs" title="RSpec Mocks" target='_blank' rel='nofollow'>RSpec Mocks</a>
- <a href="https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles" title="RSpec verifying doubles" target='_blank' rel='nofollow'>RSpec verifying doubles</a>
