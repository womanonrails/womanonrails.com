---
layout: post
title: Ruby Hash Tips
description: What I know about Hash?
headline: My code is getting worse, please send more chocolate
categories: [programming]
tags: [Ruby]
comments: true
---

Today I will show you some Hash tips, which I like. But before that what really is this hash?

Hash is a very specific Array where as a key we can use anything we want and order to this key some value or values. For example: If we have books and theirs authors. We can connect author to his books. When we call author then we see his/her books.

```ruby
hash = {
  'Carlos Ruiz Zafon' => ['La Sombra del Viento', 'El Juego del Angel'],
  'Antoine de Saint-Exupery' => 'Le Petit Prince'
}

hash['Carlos Ruiz Zafon']        # => ['La Sombra del Viento', 'El Juego del Angel']
hash['Antoine de Saint-Exupery'] # => 'Le Petit Prince'
```

If we want to add new author to hash, we do this like in normal array.

```ruby
hash['author name'] = ['his famous book']
```

And that it. So, let’s started with some tips:

## 1. Create hash with default value:

If you create Hash like this:

```ruby
hash = {} lub hash = Hash.new
hash[:key] # => nil
```

Your default value will be `nil`.

What if you need to count something and put it to hash?
You can do this like that:

```ruby
hash = {}
hash[:key] = 0 unless hash.has_key?(:key)
hash[:key] += 1

hash # => {:key=>1}
```

or like this

```ruby
hash = Hash.new(0)
hash[:key] += 1

hash # => {:key=>1}
```

In second way you declare your default value to 0. Code look better and cleaner.

But what happened if we declare default value as an array? Let’s try it.

```ruby
hash = Hash.new([])
hash[:ala] << 1
hash        # => {}
hash[:ala]  # => [1]

hash[:bela] << 2
hash        # => {}
hash[:ala]  # => [1, 2]
hash[:bela] # => [1, 2]
```

Oops! It is something wrong! Our hash seems to be empty but when we look for specific key we have the same array for two different keys. We can say that if we put string or number as a hash key it is something light to carry on. But if we put array as a key to hash it is much more heavy. So hash as a very lazy object remember only address of array (where array leave). He has only one address so when we add value to this key he say: Value go to this address. So all values are on the same address. When we want to do this correctly we must set different address to different keys. We do this in this way:

```ruby
hash = Hash.new { |hash, key| hash[key] = [] }
hash[:a]
hash # => {:a=>[]}
hash[:b] << 3
# => {:a=>[], :b=>[3]}
```

## 2. Put together two hashes:

We can do this in couple ways. I show you three. The easiest way to do this, is as I show earlier:

```ruby
hash = {a: 3, b: 4}
hash[:c] = 6
hash # => {a: 3, b: 4, c: 6}
```

Second way, but only to add one key to hash:

```ruby
hash = {a: 3, b: 4}
hash.store(:c, 6)
hash # => {a: 3, b: 4, c: 6}
```

When we want to sum two different hashes. We can do this

```ruby
first_hash = {a: 3, b: 4}
second_hash = {c: 7, d: 9}
first_hash.merge(second_hash) # => {a: 3, b: 4, c: 7, d: 9}
```

This code don’t modify hashes. `first_hash` and `second_hash` stay the same. When you want to overwrite first hash you should use `merge!` method.

```ruby
first_hash = {a: 3, b: 4}
second_hash = {c: 7, d: 9}
first_hash.merge!(second_hash) # => {a: 3, b: 4, c: 7, d: 9}
first_hash                     # => {a: 3, b: 4, c: 7, d: 9}
second_hash                    # => {c: 7, d: 9}
```

#### Alert:
In this case, when you use merge method. You must be carefully because hash can have only ones specific key. When two hashes have the same key survive only the last key. Let me show you:

```ruby
first_hash = {a: 3, b: 4}
second_hash = {b: 5, d: 9}
first_hash.merge(second_hash) # => {a: 3, b: 5, d: 9}
```

## 3. We know how add hash to hash but what when we want to remove element or bigger part of hash?

First let I show you how remove one element from hash:

```ruby
hash = {a: 3, b: 4}
hash.delete(:b) # => 4
hash            # => {a: 3}
```

As we see when we remove one key from hash, method return value which was connect to this key. After then hash has no more this key inside.

When we want to remove more elements we can do this like:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.delete_if { |key, value| value % 2 == 0 } # => {a: 3}
hash                                           # => {a: 3}
```

This time called `delete_if` method return not a removed elements but elements which stay in hash.

Or we can remove element using method `reject`:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.reject { |key, value| value % 2 == 0 } # => {a: 3}
hash                                        # => {a: 3, b: 4, c: 2}
```

This method don’t change hash object. If we want do this, we can use `reject!` method. It behave like `delete_if`.

We can also do this in different way. We can say what we want to keep not what we want to remove. For example:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.keep_if { |key, value| value == 3 } # => {a: 3}
hash                                     # => {a: 3}
```

or with method `select`:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.select { |key, value| value == 3 } # => {a: 3}
hash                                    # => {a: 3, b: 4, c: 2}
```

**Alert:** `select!` behave like `keep_if` method:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.select! { |key, value| value == 3 } # => {a: 3}
hash                                     # => {a: 3}
```

## For now I show you:

- how we can create hash with default value,
- how we can add some keys with values to existing hash,
- and how we can remove keys form hash.

I think form the start it is enough. Thank you for reading and see you soon!
