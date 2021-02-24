---
layout: post
title: Custom Rails Validators
description: How can I create my own validator?
headline: My code is getting worse, please send more chocolate
categories: [programming]
tags: [Ruby, Ruby on Rails]
lang: en
---

For a few days I worked on custom validators in Rails. First what are validators? When you want to check some data which comes to your application, you use validators. For example:

- if email has specific format,
- if number is odd,
- or if you simply want to check if name is required

for all of this we use validators.

Rails has many different validators already in side. Check the
{% include links/external-link.html
   name='documentation'
   url='https://guides.rubyonrails.org/active_record_validations.html#validation-helpers' %}.
But sometimes you want to do more. In my case I need validator for black list of words for string field. I know I can use
{% include links/external-link.html
   name='build-in validator'
   url='https://guides.rubyonrails.org/active_record_validations.html#exclusion' %}.
But I need much more customization:

1. The list of excluded words was very long.
2. I didn’t want to have this words in my Ruby file.
3. I always want to add new wards without changing my application.

## So I decide to do my own validator.

I look to documentation and I find
{% include links/external-link.html
   name='this'
   url='https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations' %}.
I choosed `ActiveModel::EachValidator` where I have access to whole record, specific attribute to check and the value of this attribute. This was all I needed. To do my custom validator I must only write one method: `validate_each`. It look like this:

```ruby
# app/validators/blacklist_validator.rb

# Validate list of words that can not be use in specifig field
class BlacklistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :on_blacklist) if blacklist.include? value
  end

  private

  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist.txt')).map(&:strip)
  end
end
```

## How this works?

I add error `:on_blacklist` to record when value is located on black list. I put my black list – `blacklist.txt` – in Rails `config` directory. To use this validator we put something like this in our model:

```ruby
validates :name, blacklist: true
```

## Remember convention:

When your valdator class is named `BlacklistValidator` then in your model you use `blacklist: true` parameter.

This was perfect for me, but what about put some custom parameters to validator? Something like this:

```ruby
validates :age, numericality: { greater_than: 18 }
```

This is not a problem. In custom validators you have available something like `options`, where you have access to all custom parameters. When you call `options` for our example you see:

```ruby
 => { greater_than: 18 }
```

I use this for array validator, where I check size of array:

```ruby
# app/validators/array_lenght_validator.rb

# Validate if array is not too short
class ArrayLenghtValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless options.key?(:minimum)
    array_size = (value.try(:size) || 0)
    minimum = options[:minimum]
    return if array_size >= minimum
    record.errors.add(attribute, :too_short_array, count: minimum)
  end
end
```

## What happened here?

I check if `:minimum` parameter is set. I count number of elements in array. If `array_size` is lower then `minimum` size, I add error `:too_short_array` to record.

I can call this validator like this:

```ruby
validates :array, array_lenght: { minimum: 1 }
```

It is one more think to say. **How put translation to our validators in `locales`?**

We use Rails Convention. This is one but not only way to do this (all convention is explain in
{% include links/external-link.html
   name='https://guides.rubyonrails.org/i18n.html#error-message-scopes'
   url='https://guides.rubyonrails.org/i18n.html#error-message-scopes' %}):

```yaml
en:
  activerecord:
    errors:
      models:
        our_model_name:
          attributes:
            name:
              on_blacklist: is on words blacklist
            array:
              too_short_array:
                one: is too short (minimum is 1 item)
                other: is too short (minimum is %{count} items)
```

In `our_model_name:` key we put model name. For example when we have model `User`, we have key `user:`. Next we put names of our validated fields:

- `name:` field (form black list validation),
- `array:` field (from array length validation).

Then we put names of our errors: `on_blacklist:` and `too_short_array:`. For `on_blacklist:` this is it. But `too_short_array:` error had `count` parameter. Rails Internalization can recognized if it singular or plural version of `count`. And serve `one:` or `other:` translation. Last thing: In `other:` translation we put our count parameter thought `%{}`. Then Rails know where put `count` value.

This is it. I hope this was useful for you. Please live your comments,
questions or any suggestions below. To next time! Bye!

