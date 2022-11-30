---
layout: post
photo: /images/ruby-tricks/ruby-tricks
title: Things you didn't know about Ruby
description: Ruby tips and tricks
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
imagefeature: ruby-tricks/og_image.png
lang: en
---

From time to time, when I create a code, people ask me: _Is this working?_ , or they tell me: _I didn't know that._ Being in those situations allows me to understand that something normal for me can be new for someone else. So, today I would like to share with you some Ruby tips and tricks. I hope you will like them.

## 1. `dig` default value & nested hashes/arrays

By default, when you use the `dig` method and the requested key is not in the hash, you will get `nil`. But we can change this behavior and return whatever we want.

Default behavior:

```ruby
hash = { foo: { bar: [:a, :b, :c] } }
hash.dig(:hello)

# => nil
```

Our new behavior:

```ruby
hash = { foo: { bar: [:a, :b, :c] } }
hash.default_proc = -> (hash, _key) { hash }
hash.dig(:hello, :world)

# => {:foo=>{:bar=>[:a, :b, :c]}}

hash.dig(:hello, :world, :foo, :bar, 2)

# => :c
```

You can see one more interesting thing here. When you use the `dig` method in the hash, it doesn't matter if this is a simple hash only with keys and values like `{ foo: 1, bar: 2}` or a more complex one with nested hashes and arrays like in the example above, you still can get selected value.

```ruby
hash = { foo: { bar: [:a, :b, :c] } }
hash.dig(:foo, :bar, 2)

# => :c
```

## 2. Quick debugging with `tap`

The most common usage of the `tap` method for me is to use it as a quick debugger.

```ruby
class Object
  def debug
    tap { |object| p object }
  end
end

"foo".upcase.debug.reverse

# "FOO"
# => "OOF"
```

Thanks to this `Object` class extension, we can see what an object looks like in the middle of the methods chain.

## 3. Difference between `concat` and `+=` for Array class

In most cases, we can use the `concat` and the `+=` methods interchangeably, but there is one important difference between them. Let's check the example below.

The result we get from both methods is the same.

```ruby
array = [1, 2, 3]
array.concat([4, 5, 6])

# => [1, 2, 3, 4, 5, 6]


array = [1, 2, 3]
array += [4, 5, 6]

# => [1, 2, 3, 4, 5, 6]
```

Now, let's check what will happen when we use the `tap` method with `concat` and `+=`.

```ruby
array = [1, 2, 3]
array.tap { |a| a.concat([4, 5, 6]) }

# => [1, 2, 3, 4, 5, 6]
```

`concat` behaves as we expected. We cannot say the same for `+=`.

```ruby
array = [1, 2, 3]
array.tap { |a| a += [4, 5, 6] }

# => [1, 2, 3]
```

What happened here? First, we need to understand the method `tap`. Base on the definition from  <a href="https://ruby-doc.org/core-2.6.1/Object.html#method-i-tap" title="Ruby documentation Object#tap" target='_blank' rel='nofollow'>documentation</a> we have:

> `tap` - Yields `self` to the `block`, and then returns `self`. The primary purpose of this method is to “tap into” a method chain, in order to perform operations on intermediate results within the chain.

The main hint in this definition is _and then returns `self`_. Let's check the `array` object.

```ruby
array = []
array.object_id

# => 260

array += [4, 5, 6]
array.object_id

# => 280
```

In the case of `+=`, we get a new object, but `tap` is returning the object which was created at the beginning. Let's compare that with the `concat` method.

```ruby
array = []
array.object_id

# => 300

array.concat([4, 5, 6])
array.object_id

# => 300
```

As you can see here, `concat` returns the same object which was in the beginning. So, to summarize `concat` **append** the new elements to the existing array, while `+=` creates a **new array** with elements from both the original and additional array.

The last thing for the `+=` method. To get the same result for `+=` as we get for `concat`, we can use the `then` method instead of `tap`. Definition for `then` based on the <a href="https://ruby-doc.org/core-2.6.1/Object.html#method-i-then" title="Ruby documentation Object#then" target='_blank' rel='nofollow'>documentation</a> is:

> `then` - Yields `self` to the `block` and returns the result of the `block`.

```ruby
array = [1, 2, 3]
array.then { |a| a += [4, 5, 6] }

# => [1, 2, 3, 4, 5, 6]
```

## 4. `split` with two arguments

We often use the `split` method for strings like this:

```ruby
"ruby:python:java".split(':')

# => ["ruby", "python", "java"]
```

but there is also a possibility to tell `split` how many pieces you want to get:

```ruby
"ruby:python:java".split(':', 1)

# => ["ruby:python:java"]

"ruby:python:java".split(':', 2)

# => ["ruby", "python:java"]

"ruby:python:java".split(':', 3)

# => ["ruby", "python", "java"]
```

## 5. String concatenation

There are a lot of possibilities to join strings. Some of them you can find below:

```ruby
first_name = 'Agnieszka'
last_name = 'Małaszkiewicz'

name = first_name + ' ' + last_name
name

# => "Agnieszka Małaszkiewicz"

name = first_name << ' ' << last_name
name

# => "Agnieszka Małaszkiewicz"

name = "#{first_name} #{last_name}"
name

# => "Agnieszka Małaszkiewicz"

name = [first_name, last_name].join(' ')
name

# => "Agnieszka Małaszkiewicz"
```

We have one more way to join strings. We can use space between strings like this:

```ruby
name = "Agnieszka" " " "Małaszkiewicz"
name

# => "Agnieszka Małaszkiewicz"
```

or simpler to see the pattern:

```ruby
name = "Agnieszka " "Małaszkiewicz"
name

# => "Agnieszka Małaszkiewicz"
```

At first look, it can be strange that something like this can work in Ruby, but how many times did you split the line with a string? I use that for example in the test description. For example:

```ruby
it 'calls DeliverCheckInInstructionsForProperty service for properties ' \
    'with check-in instructions delivery enabled' do
  # ...
end
```

Now the question: **Why is it working?** Based on what I found, it is related to <a href="https://github.com/ruby/ruby/blob/eab191040e9356a8ed4aaa418a7904d6f94064b9/parse.y#L3889-L3891" title="Ruby source code: tCHAR" target='_blank' rel='nofollow'>Ruby source code</a> in `parse.y`. Based on the answer from <a href="https://stackoverflow.com/a/23811744" title="Stack Overflow - Why do two strings separated by space concatenate in Ruby?" target='_blank' rel='nofollow'>Stack Overflow</a> we have:

> A Ruby string is either a `tCHAR` (e.g. `?q`), a `string1` (e.g. `"q"`, `'q'`, or `%q{q}`), or a recursive definition of the concatenation of `string1` and `string` itself, which results in string expressions like `"foo" "bar"`, `'foo' "bar"` or `?f "oo" 'bar'` being concatenated.

## 6. Create a hash with a default value

I write about this topic in <a href="{{ site.baseurl }}/ruby-hash-tips" title="Ruby tips for hash object">Ruby Hash article</a> in more detail, right now I want to mention two common uses of this feature.

First, you can declare the same default value for all keys in a hash. It's pretty useful when we want to count something.

```ruby
hash = Hash.new(0)
hash[:foo]

# => 0
```

Now we can count something by using `+=`.

```ruby
hash[:bar] += 1
hash[:bar]

# => 1
```

The second example is declaring a dynamic default value for each key in the hash. For example:

```ruby
hash = Hash.new { |hash, i| i }
hash[1]

# => 1

hash[35]

# => 35
```

## 7. Use `proc` in `case`

`proc` is one of the classes in Ruby, which helps us with <a href="{{ site.baseurl }}/functional-programming-ruby" title="Functional programming in Ruby">functional programming</a>. One interesting usage of `proc`, which is not often known, is using `proc` in `case`. We can create a `proc` and put it directly to the `when` condition of the `case`. See the example below:

```ruby
payload_1 = {
  event_type: 'ConversationAdded',
  body: 'Test'
}
payload_2 = {
  event_type: 'MessageAdded',
  body: 'Test'
}
payload_3 = {
  body: 'Test'
}

def payload_object(payload)
  message_type_event = proc { |event_type| event_type.include?('Message') }

  case payload[:event_type]
  when nil then 'Message'
  when message_type_event then 'ConversationMessage'
  else
    'None'
  end
end

payload_object(payload_1)

# => "None"

payload_object(payload_2)

# => "ConversationMessage"

payload_object(payload_3)

# => "Message"
```

## 8. Call method in different ways

Ruby is an awesome programming language. We can call a method in many different ways. If you are interested in how many ways we can find for calling method, I recommend you to read Gregory Witek's article <a href="https://www.notonlycode.org/12-ways-to-call-a-method-in-ruby/" title="12 ways to call a method in Ruby" target='_blank' rel='nofollow'>12 ways to call a method in Ruby</a>. I know two more ways to call a method, and I would like to share them with you. To be consistent with Gregory's article, I will use the same example:

```ruby
class User
  def initialize(name)
    @name = name
  end

  def hello
    puts "Hello, #{@name}!"
  end

  def method_missing(_)
    hello
  end
end
```

The first way, I discover in Nick Schwaderer's presentation from RailsConf 2022 <a href="https://www.youtube.com/watch?v=VPXHclib7X4" title="RailsConf 2022 - Ruby Archaeology by Nick Schwaderer" target='_blank' rel='nofollow'>Ruby Archaeology</a>:

```ruby
user = User.new('Agnieszka')
user::hello

# Hello, Agnieszka!
# => nil
```

The second way is related to functional programming. We can turn the method name into `proc` and call on this `proc` method `===`:

```ruby
user = User.new('Agnieszka')
:hello.to_proc === user

# Hello, Agnieszka!
# => nil
```

If you want to know more about calling `proc` by `===`, I recommend you to check my article about <a href="{{ site.baseurl }}/functional-programming-ruby" title="Functional programming in Ruby">functional programming</a>.
