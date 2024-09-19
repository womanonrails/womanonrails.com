---
excerpt: >
  Some time ago I wrote an article about
  [Pattern matching in Elixir](/elixir-pattern-matching).
  I really like this idea.
  Now from Ruby version 2.7 we have **pattern matching in Ruby**!!!
  It is not the same like in Elixir, but it is a nice feature to have.
  Keep in mind that this is still an experimental feature,
  so it can change in the future versions of Ruby.
  Let's check out what we can do with pattern matching in Ruby.
layout: post
title: Ruby pattern matching
description: Pattern matching - new feature of Ruby 2.7
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
lang: en
last_modified_at: 2022-01-19 10:00:00 +0200
---

Some time ago I wrote an article about [Pattern matching in Elixir]({{site.baseurl}}/elixir-pattern-matching "Elixir - How to fit to the pattern?"). I really like this idea. Now from Ruby version 2.7 we have **pattern matching in Ruby**!!! It is not the same like in Elixir, but it is a nice feature to have. Keep in mind that this is still an experimental feature, so it can change in the future versions of Ruby. Let's check out what we can do with pattern matching in Ruby.

Before we start, let's remind ourselves **what is pattern matching?** Pattern matching is a way to specify a pattern for our data and if data are matched to the pattern we can deconstruct them according to this pattern. In other words: Pattern matching is choosing specific elements from data, based on defined rules. We can also say that pattern matching is like _regular expressions_ with multiple assignments not only for strings.

In the beginning of _Pattern Matching in Elixir_ article, I started from **basic match operator** in Elixir. Because Ruby was created based on different concepts than Elixir, we will not have anything like **match operator** in Ruby. We have normal **assignment**. So when in Elixir we can do:

```elixir
iex> x = 4
4

iex> 4 = x
4
```

this is not possible in Ruby:

```ruby
irb> x = 4
 => 4
irb> 4 = x
Traceback (most recent call last):
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `<main>'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `load'
        1: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
SyntaxError ((irb):2: syntax error, unexpected '=', expecting end-of-input)
4 = x
  ^
```

I don't say that Ruby is worse then Elixir. I'm showing you this to explain how big of a challenge was to put pattern matching in Ruby. I want you to be forgiving if something is not working like you would like to. There is still work to do, questions to answer and decisions to take. Be patient and celebrate with me this first step of pattern matching in Ruby.

Since Ruby 3.0, there is a new way to do the above pattern matching:

```ruby
3.0.0 > 4 => x
 => nil
3.0.0 > x
 => 4
```

## Pattern matching in Ruby - basics

For pattern matching in Ruby, we have new syntax for `case`. It looks like this:

```ruby
case expression
in pattern [if|unless condition]
  ...
in pattern [if|unless condition]
  ...
else
  ...
end
```

The patterns are run in the order, like with normal `case` until we find the first match. In case there will be no pattern found, `else` clause will be executed. If there is no pattern and no `else` clause, we will get `NoMatchingPatternError`. Check out the examples below.

## Pattern matching with Array

One of the simplest examples of the array is:

```ruby
case [1, 2]
in [2, a]
  :no_match
in [1, a]
  :match
end
 => :match

irb> a
 => 2
```

First pattern didn't match to the array `[1, 2]`, so we went to second one where a match was found. We also get assignment `a = 2`.

If you don't know the size of your array or you just want to take a part of your array, you can always use **splat operator** to do that.

```ruby
case [1, 2, 3, 4]
in [1, *a]
end
 => nil

irb> a
 => [2, 3, 4]
```

Remember what is the difference between normal variable `a` and splat operator `*a`:

```ruby
# normal variable
case [1, 2, 3]
in [1, a, 3]
end
 => nil

irb> a
 => 2

# splat operator
case [1, 2, 3]
in [1, *a, 3]
end
 => nil

irb> a
 => [2]
```

Splat operator will always return to you an array. You can use `_` to skip some values in your pattern:

```ruby
case [1, 2, 3]
in [_, a, 3]
end
 => nil

irb> a
 => 2
```

There is also a possibility to omit brackets too:

```ruby
case [1, 2, 3]
in 1, a, 3
end
 => nil

irb> a
 => 2
```

Pattern matching can be useful for the complex structure of the Array object.

```ruby
case [1, [2, 3, 4]]
in [a, [b, *c]]
end
 => nil

irb> a
 => 1
irb> b
 => 2
irb> c
 => [3, 4]
```

## Pattern matching in Hash

When we talk about pattern matching in Hash, you need to know that right now it will work only for **Hashes where keys are symbols**. It will not work for strings. You can find more about the reasons and problems related with string syntax for hashes in
[Kazuki Tsujimoto presenation](https://speakerdeck.com/k_tsj/pattern-matching-new-feature-in-ruby-2-dot-7)
about _Pattern matching in Ruby_.

Let's start with something simple:

```ruby
case { foo: 1, bar: 2 }
in { foo: 1, baz: 3 }
  :no_match
in { foo: 1, bar: b }
  :match
end
 => :match

irb> b
 => 2
```

As in Array you can use splat operator, in Hash you can use **double splat operator**. It will behave similar to splat operator in Arrays.

```ruby
case { foo: 1, bar: 2, baz: 3 }
in { foo: 1, **rest }
end
 => nil

irb> rest
 => {:bar=>2, :baz=>3}
```

The same like for arrays, you can omit brackets:

```ruby
case { foo: 1, bar: 2 }
in foo: foo, bar: bar
end
 => nil

irb> foo
 => 1
irb> bar
 => 2
```

Thanks for syntactic sugar, you can omit also variable and stay only with the symbol:

```ruby
case { foo: 1, bar: 2 }
in foo:, bar:
end
 => nil

irb> foo
 => 1
irb> bar
 => 2
```

I would like to mention one more thing here. **Exact matching** for arrays will behave different then in hashes. In case of array we will get `NoMatchingPatternError` exception in the example below:

```ruby
case [1, 2]
in [1]
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):33
NoMatchingPatternError ([1, 2])
```

This is complete opposite, then Hash behavior:

```ruby
case { foo: 1, bar: 2 }
in foo:
  :match
end
 => :match

irb> foo
 => 1
```

It can be confusing at the beginning, but I see that during my tests of Ruby pattern matching I used that quite often in my code. In case that this will change in the future, I can get used to this syntax too:

```ruby
case { foo: 1, bar: 2 }
in foo:, **_
end
```

To achieve the same behavior in Hash like for Arrays, you need to do something like that:

```ruby
case { foo: 1, bar: 2 }
in foo:, **rest if rest.empty?
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):37
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

It's important to know about this behavior, because it can surprise us in some cases:

```ruby
case { foo: 1, bar: 2 }
in { foo: 1 }
  :it_will_match_here
in { foo: 1, bar: b }
  :no_match
end
 => :it_will_match_here
```

We could expect to match to second pattern, but in this example we match to first one.

## Guards in pattern matching

I have already shown that to you in one of the previous examples. You can use **guard condition** in pattern matching too.

```ruby
case [1, 2, 3]
in [a, *c] if a != 1
  :no_match
in [a, *c] if a == 1
  :match
end
 => :match

irb> a
 => 1
irb> c
 => [2, 3]
```

## What can we use in pattern matching?

#### Literals

In Ruby pattern matching you can use literals: Booleans, `nil`, Numbers, Strings, Symbols, Arrays, Hashes, Ranges, Regular Expressions, Procs.

```ruby
case 2
in (1..3)
  :match
in Integer
  :too_late_for_match
end
 => :match
```

#### Variables

We can also use variables which we already saw in the previous examples. The only thing which I would like to add is that we always do assignment in this case:

```ruby
irb> array = [1, 2, 3]
 => [1, 2, 3]

case [1, 2, 4]
in array
  :match
end

irb> array
 => [1, 2, 4]
```

In case we want to compare what we have in our variable with an expression, we need to use `^`:

```ruby
irb> array
 => [1, 2, 4]

case [1, 2, 3]
in ^array
  :no_match
else
  :match
end

irb> array
 => [1, 2, 4]
```

#### Alternative pattern

The next thing which we can use is **alternative pattern**

```ruby
case 5
in 6
  :no_match
in 2 | 3 | 5
  :match
end
 => :match
```

#### As pattern

We can also bind  the variable to a value using **as pattern**. It can be useful when we need more complex assignments.

```ruby
case [1, 2, [3, 4]]
in [1, 2, [3, b] => a]
end
=> nil

irb> a
 => [3, 4]
irb> b
 => 4
```

## Pattern matching for others objects

For now there is only few Ruby object which we can use pattern matching for. We saw that for Array and Hash. We can also do that for Struct.

```ruby
Point = Struct.new(:latitude, :longitude)
point = Point[50.29543618146685, 18.666200637817383]

case point
in latitude, longitude
end
 => nil

irb> latitude
 => 50.29543618146685
irb> longitude
 => 18.666200637817383
```

If you want to use pattern matching for another object, you need to add method `deconstruct` or `deconstruct_keys` to your class. Depends on what method you choose, your object will behave during pattern matching like `Array` or like `Hash`. In the example above, we see that `Struct` behave like `Array` when it comes to pattern matching. I have added a very simple use case for `Hash` type of pattern matching below:

```ruby
class Date
  def deconstruct_keys(keys)
    { year: year, month: month, day: day }
  end
end

date = Date.new(2019, 9, 21)

case date
in year:
end
 => nil

irb> year
 => 2019
```

## Handle JSON data

I think the best place to use it is in JSON data. You can skip conditions and just use pattern matching.

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [
          18.666200637817383,
          50.29543618146685
        ]
      }
    }
  ]
}
```

JSON with pattern matching:

```ruby
case JSON.parse(json, symbolize_names: true)
in { type: "FeatureCollection", features: [{type: "Feature", geometry: { type: "Point", coordinates: [longitude, latitude]}}]}
end

irb> longitude
 => 18.666200637817383
irb> latitude
 => 50.29543618146685
```

JSON with `if` statements:

```ruby
point = JSON.parse(json, symbolize_names: true)
if point[:type] == "FeatureCollection"
  features = point[:features]
  if features.size == 1 && features[0][:type] == "Feature"
    geometry = features[0][:geometry]
    if geometry[:type] == "Point" && geometry["coordinates"].size == 2
      longitude, latitude = geometry["coordinates"]
    end
  end
end

irb> longitude
 => 18.666200637817383
irb> latitude
 => 50.29543618146685
```

You can see the difference.

## Scope strange behavior

Right now you can see the value of the variable even match of pattern failed. This is something Ruby core knows about and they will change that in future.

```ruby
case[1, 2]
in x, y if y > 3
  :no_match
in x, z if z < 3
  :match
end
 => :match

irb> x
 => 1
irb> z
 => 2

# unexpected assignment for y when pattern matching failed
irb> y
 => 2
```

## What I would like to see more?

When I play around pattern matching in Ruby, I found some cases which are not a part of this new feature, but it will be nice to have:

- one line pattern matching - We have one line `each`, so it will be good to have one line pattern matching. Something like `case [1, 2, [3, 4]] { [1, 2, [3, b] => a] }` just for assignments.
- calculations in patterns - Sometimes we would like to do some quick calculations like `in (1..3).to_a` in pattern, but this is not possible. We can do some work around and assign this to variable `array = (1..3).to_a` then use `array` in pattern `in ^array`.
- allowed variables in alternative pattern - It will be great to be able to do `[1, 2] | [1, 2, c]`.

I know that some of my ideas could be not possible or hard to do, but this is my wish list. ;]

From Ruby 3.0, we have more pattern matching features available. If you want to know more check out my article: [Second look at pattern matching in Ruby]({{site.baseurl}}/ruby-pattern-matching-second-look "News about pattern matching in Ruby").

## Summary

I'm really happy with this new feature. I know that this is not production ready, but it was nice to play around it. I hope it will be stable soon and it will have even more nice patterns. I think this is a good way to do Ruby even more readable.

What do you think about Ruby pattern matching? Let me know in the comments below.
