---
excerpt: >
  Sometimes I like new changes, new features,
  or improvements in Ruby and sometimes not.
  Today I would like to tell you more about the changes
  that I'm very excited about.
  I mean the **Pattern Matching**.
  I wrote a separate article about
  [Pattern Matching in Ruby](/ruby-pattern-matching "Pattern Matching in Ruby basics")
  some time ago.
  Now it's the time to go deeper into the Pattern Matching news.
  So let's get started!
layout: post
photo: /images/pattern-matching/pattern-matching
title: Second look at pattern matching in Ruby
description: News about Pattern matching in Ruby
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
imagefeature: pattern-matching/og_image-pattern-matching.png
lang: en
last_modified_at: 2022-01-19 16:00:00 +0200
---

Sometimes I like new changes, new features, or improvements in Ruby and sometimes not. Today I would like to tell you more about the changes that I'm very excited about. I mean the **Pattern Matching**. I wrote a separate article about [Pattern Matching in Ruby]({{site.baseurl}}/ruby-pattern-matching "Pattern Matching in Ruby basics") some time ago. Now it's the time to go deeper into the Pattern Matching news. So let's get started!

### 1. One-line Pattern Matching

It's the Pattern Matching feature I didn't notice before when I was testing it the first time. Anyway, now we can do pattern matching in one line.

In Ruby 3.0 we have two ways of doing one-line pattern matching: `in` and `=>`. The behavior is different in both cases. When we use `in` the result will be `true` or `false`. There will be no exception. This behavior allows us to use `in` one-line pattern matching inside of blocks like `any?` or `all?`. I will tell you more about it later. In the case of `=>`, we will get an assignment to the variable or an exception. Here are examples:

##### One-line Pattern Matching with Hash

When we have a match for `in`

```ruby
{ foo: 1, bar: 2 } in { foo: f }
 => true

3.0.0> f
 => 1
```

without match

```ruby
{ foo: 1, bar: 2 } in { baz: b }
 => false

3.0.0> b
 => nil
```

The same we can do without a variable declaration

```ruby
{ foo: 1, bar: 2 } in { foo: }
 => true

3.0.0> foo
 => 1
```

In the case of `=>` match we have

```ruby
{ foo: 1, bar: 2 } => { foo: f }
 => nil

3.0.0> f
 => 1
```

without a match, we will get an exception

```ruby
{ foo: 1, bar: 2 } => { baz: }

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        1: from (irb):7:in `<main>'
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

##### One-line Pattern Matching with Array

A similar thing we get for Array using `in`

```ruby
[1, 2, 3] in [a, 2, 3]
 => true

3.0.0> a
 => 1
```

and using `=>`

```ruby
[1, 2, 3] => [a, 2, 3]
 => nil

3.0.0> a
 => 1
```

##### One-line Pattern in Ruby 3.1

First of all, one-line pattern matching in Ruby 3.1 is no longer experimental. The second news is related to parentheses. They can be omitted for array or hash in one-line pattern matching.

Code with parentheses:

```ruby
3.0.0> [0, 1] => [_, x]
3.0.0> x
 => 1
```

In Ruby 3.0, we have a syntax error when we omit parentheses.

```ruby
3.0.0> [0, 1] => _, x
Traceback (most recent call last):
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        1: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
SyntaxError ((irb):6: syntax error, unexpected ',', expecting end-of-input)
[0, 1] => _, x
```

In Ruby 3.1, everything is working.

```ruby
3.1.0> [0, 1] => _, x
 => nil
3.1.0> x
 => 1
```

### 2. Pattern matching for specific beginning and end of Array

```ruby
[1, 2, 3, 4, 5, 6] in [first, *middle, last]

3.0.0> first
 => 1

3.0.0> middle
 => [2, 3, 4, 5]

3.0.0> last
 => 6
```

or when we don't care about the middle part of Array

```ruby
[1, 2, 3, 4, 5, 6] in [first, *, last]

3.0.0> first
 => 1

3.0.0> last
 => 6
```

### 3. Exact match for Hash

As I mentioned in my previous article, an exact match for hashes is different than for arrays. Here I will show you what's new in these two cases, but a first short reminder about an exact match.

When we have an array without an exact match, we get an error.

```ruby
case [1, 2]
in [1]
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        1: from (irb):12:in `<main>'
NoMatchingPatternError ([1, 2])
```

In the case of hash, even there is no exact match between the pattern and input data, we won't have an error.

```ruby
case { foo: 1, bar: 2 }
in foo:
  :match
end
 => :match

3.0.0> foo
 => 1
```

If we want to have an exact match for the hash, we can do that in this way:

```ruby
case { foo: 1, bar: 2 }
in foo:, **rest if rest.empty?
  :no_match
end

Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        2: from (irb):15:in `<main>'
        1: from (irb):16:in `rescue in <main>'
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

but also like that:

```ruby
case { foo: 1, bar: 2 }
in foo:, **nil
  :no_match
end

Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        2: from (irb):19:in `<main>'
        1: from (irb):20:in `rescue in <main>'
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

### 4. Exact match for Array

In Ruby 2.7, there was no way to match any array element (something similar like we can do for hash). We could match first or last

```ruby
case [1, 2, 3]
in [1, *]
  :match
end
 => :match

case [1, 2, 3]
in [*, 3]
  :match
end
 => :match
```

but now in 3.0, we can match something in the middle of an array

```ruby
case [1, 2, 3, 4]
in [*, 2, a, *]
  :match
end
 => :match

3.0.0> a
 => 3
```

We can even name our `*`

```ruby
case [1, 2, 3, 4]
in [*first, 2, a, *last]
  :match
end
 => :match

3.0.0> a
 => 3
3.0.0> first
 => [1]
3.0.0> last
 => [4]
```

This feature is more visible on data like this:

```ruby
json = {
  name: "Woman on Rails",
  friends: [{ name: "Alex", age: 24 }, { name: "Tom", age: 25 }]
}
json in { name: "Woman on Rails", friends: [*, { name: "Alex", age: age }, *] }

3.0.0> age
 => 24
```

### 5. Alternative pattern with variables

We know that we cannot use an alternative pattern with variables

```ruby
case [1, 2]
in [1, 3] | [1, c]
  :match
end

Traceback (most recent call last):
        1: from (irb)
SyntaxError ((irb):55: illegal variable in alternative pattern (c))
```

but there is one exception from that rule. We can use `_`:

```ruby
case [1, 2]
in [1, 3] | [1, _]
  :match
end
 => :match

3.0.0> _
 => :match
```

We can even name it:

```ruby
case [1, 2]
in [1, 3] | [1, _last]
  :match
end
 => :match

3.0.0> _last
 => 2
```

### 6. Assign the same variable in our pattern many times

Thanks for `^` we can check pattern matching by using the same variables multiple times.

```ruby
case { name: "Woman on Rails", people: [{ name: "Alex", age: 24 }, { name: "Woman on Rails", age: 25 }] }
in name:, people: [*, {age:, name: ^name}]
  :match
end

 => :match
3.0.0> name
 => "Woman on Rails"
3.0.0> age
 => 25
```

### 7. Infinite ranges in Pattern Matching

It's related to the new Ruby feature for infinite ranges.

```ruby
case { a: 1, b: 2 }
in a: 0.. => first
  :match
end

:match
3.0.0> first
 => 1

case { a: 1, b: 2 }
in b: ..3 => first
  :match
end

 => :match
3.0.0> first
 => 2
```

### 8. Pattern Matching with regular expressions

```ruby
website = 'womanonrails.com'

case website
  in /\w*\.com/ => favorite_website
end

3.0.0> favorite_website
 => "womanonrails.com"
```

### 9. Pattern Matching in blocks

We can use `in` one-line pattern matching in blocks like `any?`, `'all?`, `select` or `find`.

```ruby
users = [{ name: "Woman on Rails", age: 22 }, { name: "Alex", age: 23 }]

users.any? { |user| user in { name: /C/, age: 20.. } }
 => false

users.any? { |user| user in { name: /A/, age: 20.. } }
 => true
```

### 10. Pattern Matching pin operator (^) with expression

Since Ruby 3.1, expressions and non-local variables are allowed in pin operator `^`. In the previous Ruby version, only constants, literals, and pinned local variables were allowed.

So, for example, in Ruby 3.0, there was a possibility to use range with numbers:

```ruby
3.0.0> { version: 12 } in { version: 10..15 }
 => true
```

but not with more complex objects:

```ruby
3.0.0> { version: 12 } in { version: (BigDecimal('10')..BigDecimal('15')) }
Traceback (most recent call last):
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        1: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
SyntaxError ((irb):19: syntax error, unexpected .., expecting ')')
...n {version: (BigDecimal('10')..BigDecimal('15'))}
...                             ^~
(irb):19: syntax error, unexpected ')', expecting end-of-input
...ecimal('10')..BigDecimal('15'))}
...                              ^
```

Now in Ruby 3.1, we can do those calculations using pin operator `^`:

```ruby
3.1.0> require 'bigdecimal'
 => true
3.1.0> { version: 12 } in { version: ^(BigDecimal('10')..BigDecimal('15')) }
 => true
```

It's now valid for any complex expression. Remember that **parenthesis are mandatory**. You cannot do:

```ruby
3.1.0> Time.now.year in ^rand(2021..2023)
/home/agnieszka/.rvm/rubies/ruby-3.1.0/lib/ruby/3.1.0/irb/workspace.rb:119:in `eval': (irb):16: rand: no such local variable (SyntaxError)
(irb):16: syntax error, unexpected '(', expecting end-of-input
Time.now.year in ^rand(2021..2023)
                      ^
        from /home/agnieszka/.rvm/rubies/ruby-3.1.0/lib/ruby/gems/3.1.0/gems/irb-1.4.1/exe/irb:11:in `<top (required)>'
        from /home/agnieszka/.rvm/rubies/ruby-3.1.0/bin/irb:25:in `load'
        from /home/agnieszka/.rvm/rubies/ruby-3.1.0/bin/irb:25:in `<main>'
```

instead, you need to do:

```ruby
3.1.0 :017 > Time.now.year in ^(rand(2021..2023))
 => false
```

That's all that I have today for you. Do you know more pattern matching tricks and tips? Share them in the comment below.

### Bibliography
- [Patter Matching in Ruby]({{site.baseurl}}/ruby-pattern-matching "Pattern Matching in Ruby basics")
- [Ruby lang docs - news for Ruby 2.7.0](https://docs.ruby-lang.org/en/2.7.0/NEWS.html#label-Pattern+matching "News for Ruby 2.7.0")
- [Ruby lang docs - news for Pattern Matching](https://docs.ruby-lang.org/en/master/doc/syntax/pattern_matching_rdoc.html "News in Pattern Matching")
- [Ruby introduces find pattern in pattern matching](https://blog.saeloun.com/2020/08/17/find-pattern-in-pattern-matching "Find pattern in pattern matching - Ruby")
