---
layout: post
photo: /images/pattern-matching/pattern-matching
title: Second look at pattern matching in Ruby
description: News about Pattern matching in Ruby
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
imagefeature: pattern-matching/og_image-pattern-matching.png
lang: en
---

Sometimes I like new changes, new features, or improvements in Ruby and sometimes not. Today I would like to tell you more about the changes that I'm very excited about. I mean the **Pattern Matching**. I wrote a separate article about <a href="{{ site.baseurl }}/ruby-pattern-matching" title="Pattern Matching in Ruby basics">Pattern Matching in Ruby</a> some time ago. Now it's the time to go deeper into the Pattern Matching news. So let's get started!

### 1. One-line Pattern Matching

It's the Pattern Matching feature I didn't notice before when I was testing it the first time. Anyway, now we can do pattern matching in one line. Here are examples:

##### One-line Pattern Matching with Hash

```ruby
{ foo: 1, bar: 2 } in { foo: f }
 => nil

2.7.1> f
 => 1
```

or without a variable declaration

```ruby
{ foo: 1, bar: 2 } in { foo: }
 => nil

2.7.1> foo
 => 1
```

##### One-line Pattern Matching with Array

```ruby
[1, 2, 3] in [a, 2, 3]
 => nil

2.7.1> a
 => 1
```

**Notice:** In Ruby 3.0, instead of using `in` in one-line pattern matching as an experimental feature, we will be using hash rocket `=>`. So our code will look like this:

```ruby
{ a: '2', b: 5 } => { a: }
```

Unfortunately, in Ruby 3.0 preview 1, this approach is not working yet. So we need to wait a bit.

### 2. Pattern matching for specific beginning and end of Array

```ruby
[1, 2, 3, 4, 5, 6] in [first, *middle, last]

2.7.1> first
 => 1

2.7.1> middle
 => [2, 3, 4, 5]

2.7.1> last
 => 6
```

or when we don't care about the middle part of Array

```ruby
[1, 2, 3, 4, 5, 6] in [first, *, last]

2.7.1> first
 => 1

2.7.1> last
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
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):33
NoMatchingPatternError ([1, 2])
```

In the case of hash, even there is no exact match between the pattern and input data, we won't have an error.

```ruby
case { foo: 1, bar: 2 }
in foo:
  :match
end
 => :match

2.7.1> foo
 => 1
```

If we want to have an exact match for the hash, we can do that in this way:

```ruby
case { foo: 1, bar: 2 }
in foo:, **rest if rest.empty?
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):37
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

but also like that:

```ruby
case { foo: 1, bar: 2 }
in foo:, **nil
  :no_match
end

Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.1/lib/ruby/gems/2.7.0/gems/irb-1.2.3/exe/irb:11:in `<top (required)>'
        2: from (irb):49
        1: from (irb):50:in `rescue in irb_binding'
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

3.0.0-preview1> a
 => 3
```

It's more visible on data like this:

```ruby
json = {
  name: "Woman on Rails",
  friends: [{ name: "Alex", age: 24 }, { name: "Tom", age: 25 }]
}
json in { name: "Woman on Rails", friends: [*, { name: "Alex", age: age }, *] }

3.0.0-preview1> age
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

2.7.1> _
 => :match
```

### 6. Assign the same variable in our pattern many times

Thanks for `^` we can check pattern matching by using the same variables multiple times.

```ruby
case { name: "Woman on Rails", people: [{ name: "Alex", age: 24 }, { name: "Woman on Rails", age: 25 }] }
in name:, people: [*, {age:, name: ^name}]
  :match
end

 => :match
2.7.1> name
 => "Woman on Rails"
2.7.1> age
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
2.7.1> first
 => 1

case { a: 1, b: 2 }
in b: ..3 => first
  :match
end

 => :match
2.7.1> first
 => 2
```

### 8. Pattern Matching with regular expressions

```ruby
website = 'womanonrails.com'

case website
  in /\w*\.com/ => favorite_website
end

2.7.1> favorite_website
 => "womanonrails.com"
```

That's all that I have today for you. Do you know more pattern matching tricks and tips? Share them in the comment below.

### Bibliography
- <a href="{{ site.baseurl }}/ruby-pattern-matching" title="Pattern Matching in Ruby basics">Patter Matching in Ruby</a>
- <a href="https://docs.ruby-lang.org/en/2.7.0/NEWS.html#label-Pattern+matching" title="News for Ruby 2.7.0" target='_blank' rel='nofollow'>Ruby lang docs - news for Ruby 2.7.0</a>
- <a href="https://docs.ruby-lang.org/en/master/doc/syntax/pattern_matching_rdoc.html" title="News in Pattern Matching" target='_blank' rel='nofollow'>Ruby lang docs - news for Pattern Matching</a>
- <a href="https://blog.saeloun.com/2020/08/17/find-pattern-in-pattern-matching" title="Find pattern in pattern matching - Ruby" target='_blank' rel='nofollow'>Ruby introduces find pattern in pattern matching</a>

