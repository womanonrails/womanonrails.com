---
excerpt: >
  There was a very simple code to implemented.
  It brings me a lot of fun when I started the research.
  I had an array of different objects and
  I wanted to join them into one string in a special way.
  An important question here was:
  **How objects will look like after casting into a string?**
  The answer was short - good ;)
  But this is not the clue of this article.
  The most important question is:
  **Why objects are cast into string in this way?**
  Here is what I discover during my research.
layout: post
photo: /images/casting-ruby-object-into-string/chain-to_s-vs-to_str
title: How Ruby casts object into a string?
description: Difference between to_s and to_str
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
lang: en
imagefeature: casting-ruby-object-into-string/og_image-to_s-vs-to_str.png
---

There was a very simple code to implemented. It brings me a lot of fun when I started the research. I had an array of different objects and I wanted to join them into one string in a special way. An important question here was: **How objects will look like after casting into a string?** The answer was short - good ;) But this is not the clue of this article. The most important question is: **Why objects are cast into string in this way?** Here is what I discover during my research.

## Casting objects into a string

Let's start with a very simple case. Array with string and symbol:

```ruby
[:symbol, 'string'].join(' ')
 => "symbol string"
```

Everything looks fine. This is exactly what I expected. OK, what about an array in the array?

```ruby
[[:symbol], 'string'].join(' ')
 => "symbol string"
```

Looks nice! I don't need to worry about array and I get exactly what I wanted to. I also noticed one more thing here. When I use the `puts` method, it behaves similarly to the `join` method. We see what is inside of the array, but we don't see brackets:

```ruby
puts [:one, :two, :three]
one
two
three
 => nil
```

This is the moment when the most important question pops up. Why `join` and `puts` behave like this, when the conversion of the array into a string looks different?

```ruby
[:symbol].to_s
 => "[:symbol]"
```

So, my logical part of the brain says: _After method `join` I should get `"[:symbol] string"` and this is not what I have. Hmm... why?_. I started my research. In the beginning, I focused on a difference between the `to_s` method and the `join` method.

## Join method under the hood

First, what I discovered was that the `join` method doesn't use `to_s` under the hood. At least this was my first understanding of this problem. It uses the `to_str` method. Let me show this in the example. I will declare a new object and I will check how it behaves in `join`.

```ruby
class RubyStringTest
  def to_s
    'calls to_s'
  end

  def to_str
    'calls to_str'
  end
end

string_test = RubyStringTest.new

string_test.to_s
 => "calls to_s"

[:it, string_test, :method].join(' ')
 => "it calls to_str method"
```

But why we have these two methods? On the string, they work the same, but we see that we can provide different implementations for them. Do I need them both?

```ruby
"String".to_s
 => "String"

"String".to_str
 => "String"
```

## Difference between to_s and to_str

We need to understand what is a difference between method `to_s` and `to_str`. Method `to_s` is defined in `Object` class. So, all object in Ruby has method `to_s`. In case of `to_str` method not all objects implement it. When we try to call it on array we will get an exception:

```ruby
[:symbol].to_str
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):7
NoMethodError (undefined method `to_str' for [:symbol]:Array)
Did you mean?  to_set
               to_s
```

This is because of the meaning of `to_str` method. `to_s` method allows us to cast an object into a string and `to_str` allow us to behave like a string. If we go back to our `RubyStringTest` example we can see:

```ruby
string_test = RubyStringTest.new

"This test #{string_test}"
 => "This test calls to_s"

"This test " + string_test
 => "This test calls to_str"
```

Do you see the difference? In the first case, we cast an object into a string, so we call the `to_s` method. In the second example, we don't cast object into a string. We want to object behave like a string. We want to object allow to use the `:+` method the same as strings do. When we look at the array example we will see that `Array` is not behaving like a `String`:

```ruby
"This is an array #{[:symbol]}"
 => "This is an array [:symbol]"

'This is an array' + [:symbol]
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):8
        2: from (irb):8:in `rescue in irb_binding'
        1: from (irb):8:in `+'
TypeError (no implicit conversion of Array into String)
```

We can of course force array to behave like a string, but by default, it is not like that.

```ruby
class Array
  def to_str
    to_s
  end
end

'This is an array ' + [:symbol]
 => "This is an array [:symbol]"
```

OK, but this is not the answer to my main question. We see that in the previous example by default array don't behave like a string so it doesn't implement method `to_str`. As we saw, when we try to call that method on the array, we will get an exception.

```ruby
[:symbol].to_s
 => "[:symbol]"

[:symbol].to_str
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):2
NoMethodError (undefined method `to_str' for [:symbol]:Array)
Did you mean?  to_set
               to_s
```

## How join method works on the array?

To understand how the `join` method works we need to go to the source. I mean, we need to go to the
{% include links/external-link.html
   name='Ruby source code'
   url='https://github.com/ruby/ruby/blob/ruby_2_7/array.c#L2384' %}.

```ruby
/*
 *  call-seq:
 *     ary.join(separator=$,)    -> str
 *
 *  Returns a string created by converting each element of the array to
 *  a string, separated by the given +separator+.
 *  If the +separator+ is +nil+, it uses current <code>$,</code>.
 *  If both the +separator+ and <code>$,</code> are +nil+,
 *  it uses an empty string.
 *
 *     [ "a", "b", "c" ].join        #=> "abc"
 *     [ "a", "b", "c" ].join("-")   #=> "a-b-c"
 *
 *  For nested arrays, join is applied recursively:
 *
 *     [ "a", [1, 2, [:x, :y]], "b" ].join("-")   #=> "a-1-2-x-y-b"
 */
```

This is a description of how the `join` method works. Two sentences give us the answer: _Returns a string created by **converting** each **element** of the array **to a string**, separated by the given separator. For nested arrays, join is applied recursively._ So, the `to_str` method isn't called on an array, but on each element of this array. This match to what we get from our examples:

```ruby
[[:symbol], 'string'].join(' ')
 => "symbol string"

:symbol.to_str
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):17
NoMethodError (undefined method `to_str' for :symbol:Symbol)
Did you mean?  to_s
               to_sym
```

What? This doesn't match. `Symbol` class doesn't implement the `to_str` method! Let's go back to our example with `RubyStringTest`, run a new console, and do that example one more time step by step.

```ruby
class RubyStringTest
end

string_test = RubyStringTest.new

string_test.to_s
 => "#<RubyStringTest:0x000055567edb0bd0>"

[:it, string_test, :method].join(' ')
 => "it #<RubyStringTest:0x000055567edb0bd0> method"
```

We see that in this case, the `join` method uses the `to_s` method under the hood. When we override the `to_s` method, we will see our implementation:

```ruby
class RubyStringTest
  def to_s
    'calls to_s'
  end
end

string_test = RubyStringTest.new

string_test.to_s
 => "calls to_s"

[:it, string_test, :method].join(' ')
 => "it calls to_s method"
```

When we override both methods `to_s` and `to_str` we will see, that join start using `to_str` method:

```ruby
class RubyStringTest
  def to_s
    'calls to_s'
  end

  def to_str
    'calls to_str'
  end
end

string_test = RubyStringTest.new

string_test.to_s
 => "calls to_s"

[:it, string_test, :method].join(' ')
 => "it calls to_str method"
```

So, based on this example we see that `join` try to use `to_str` method and when it is not there `join` use `to_s` method. This matches, what we see for `Symbol`:

```ruby
[[:symbol], 'string'].join(' ')
 => "symbol string"

:symbol.to_s
 => "symbol"
```

## How puts method works on the array?

Similar behavior has a `puts` method. When we call `puts` on an array we will see elements of the array. Each element in the new line. `puts` doesn't work on a whole array:

```ruby
[1, 2, 3].to_s
 => "[1, 2, 3]"

puts [1, 2, 3]
1
2
3
 => nil
```

So, both methods `join` and `puts` don't call `to_str` and `to_s` methods on whole array but an each element in the array. You can also see this directly in
{% include links/external-link.html
   name='Ruby code'
   url='https://github.com/ruby/ruby/blob/ruby_2_7/io.c#L7720' %}
for `puts` method:

```ruby
/*
 *  call-seq:
 *     ios.puts(obj, ...)    -> nil
 *
 *  Writes the given object(s) to <em>ios</em>.
 *  Writes a newline after any that do not already end
 *  with a newline sequence. Returns +nil+.
 *
 *  The stream must be opened for writing.
 *  If called with an array argument, writes each element on a new line.
 *  Each given object that isn't a string or array will be converted
 *  by calling its +to_s+ method.
 *  If called without arguments, outputs a single newline.
 *
 *     $stdout.puts("this", "is", ["a", "test"])
 *
 *  <em>produces:</em>
 *
 *     this
 *     is
 *     a
 *     test
 *
 *  Note that +puts+ always uses newlines and is not affected
 *  by the output record separator (<code>$\\</code>).
 */
```

## Summary

1. Two methods are allowing us to be like a string:
    - `to_s` method - allow casting object into a string. Every object has that method.
    - `to_str` method - allow the object to behave like a string. Not all object has this method. Not all objects behave like a string ;)
2. `join` method uses under the hood `to_str` method if it is implemented. If no, then the `join` method uses the `to_s` method.
3. `puts` method always uses under the hood `to_s` method.
4. `join` and `puts` methods calls `to_str` and `to_s` methods on each element of the array not on the array it's self.
5. `Symbol` and `Array` class don't implement the `to_str` method by default.
