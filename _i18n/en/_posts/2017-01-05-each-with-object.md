---
layout: post
title: Quick overview Ruby each_with_object method
description: Tips about each_with_object
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
lang: en
---

I worked in last a few days with `each_with_object` method. Every time when I would like to use some method in Ruby I try read documentation one more time and I look on some example of usage. This time I went through
{% include links/external-link.html
   name='APIdock'
   url='https://apidock.com/ruby/Enumerable/each_with_object' %}
and I noticed that in theirs documentation is missing one very nice example of usage `each_with_object` method. I tried to add this missing part there, but without success. In meantime when I'm waiting for message from APIdock support I decided to write short note here about this.


The most useful and I think the most popular usage of `each_with_object` is putting hash or array as an argument. You can do this like in example below:

```ruby
[:foo, :bar, :jazz].each_with_object({}) do |item, hash|
  hash[item] = item.to_s.upcase
end
 => {:foo=>"FOO", :bar=>"BAR", :jazz=>"JAZZ"}
```

or

```ruby
(1..10).each_with_object([]) do |item, array|
  array << item ** 2
end
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

I know this examples are trivial, but they show main rules. You don't need to declare array or hash before your loops for example like this:

```ruby
array = []
(1..10).each do |item|
  array << item ** 2
end
array
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

I know this example can be also replace with `map` use case. Like this:

```ruby
(1..10).map { |item| item ** 2 }
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

Other nice example of `each_with_object` usage is frequency hash:

```ruby
['one', 'two', 'one', 'one'].each_with_object(Hash.new(0)) do |item, hash|
  hash[item] += 1
end
 => {"one"=>3, "two"=>1}
```

In this case we use hash with default value set to `0` and now counting occurrence is easy and quick. You don't need to do `if` statement to be sure that you are nil safe like this:

```ruby
if hash[item]
  hash[item] += 1
else
  hash[item] = 0
end
```

**Important note**

You cannot use immutable objects like numbers. Example below does not return 55 but 0.

```ruby
(1..10).each_with_object(0) do |item, sum|
  sum += item
end
 => 0
```

Yes, we can do that in different way:

```ruby
(1..10).reduce(:+)
 => 55
```

or

```ruby
(1..10).inject(:+)
 => 55
```

or in Rails:

```ruby
(1..10).sum
 => 55
```

By the way, what is difference between `reduce` and `inject`? There is no difference. This two methods are
{% include links/external-link.html
   name='aliases'
   url='http://ruby-doc.org/core/Enumerable.html#method-i-inject' %}.

In this place we should add one more thing. `inject` method we can use similar to `each_with_object` but order of arguments in block is different and we need always remember to put in last line of block our accumulator value. Look here:

```ruby
(1..10).inject([]) do |array, item|
  array << item ** 2
end
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

or

```ruby
[:foo, :bar, :jazz].inject({}) do |hash, item|
  hash[item] = item.to_s.upcase
  hash
end
 => {:foo=>"FOO", :bar=>"BAR", :jazz=>"JAZZ"}
```

**Important note**

When we use `array << item ** 2` this command always returns all array, but for this second example `hash[item] = item.to_s.upcase` returns `item.to_s.upcase` not all `hash` so we need to remember about adding `hash` on the end.


And now the missing part for `each_with_object`. You can use this method also on hash not only on arrays or enumerators. This looks a little bit different than before. Let I show you:

```ruby
{ foo: 1, bar: 2, jazz: 3 }.each_with_object({}) do |(key, value), hash|
  hash[key] = value**2
end
 => {:foo=>1, :bar=>4, :jazz=>9}
```

or like this

```ruby
{ foo: 1, bar: 2, jazz: 3 }.each_with_object([]) do |(key, value), array|
  array << { id: value, name: key }
end
 => [{:id=>1, :name=>:foo}, {:id=>2, :name=>:bar}, {:id=>3, :name=>:jazz}]
```

This was quick overview for method `each_with_object`. I hope you like this examples like I do. If you have any question leave them below and see you next time!
