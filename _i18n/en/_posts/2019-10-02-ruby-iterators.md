---
layout: post
title: Iterators in Ruby
description: What for in Ruby are iterators like each, map, collect, select, find or times?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
lang: en
---

Ruby as other programming languages has many ways to repeat instructions. We can use **loops** for that. Loops like `loop`, `while`, `until` or even `for`. This is very useful, but Ruby has also something like **iterators**. Iterators are even more awesome than loops. In Ruby you have many iterators with some specific destiny. You can use `each`, `map`, `collect`, `select`, `find`, `times` or even more. But wait! When should I choose `each` and when should I choose `map`? This is a good question! And I'm going to answer it.

## Basic terms

Before we start, let me explain you basic terms here.

#### Loop

First of all, **what is a loop?** Loop is a repetitive execution of a piece of code, which is specified once, but runs until some specific condition is met. It's very useful, when you want to automate some repeatable actions. You can think of the factory, where mugs are made. Repetitive action can be in this situation, putting mugs into boxes. This is the place where in programming world we use loops instead of robots. Here you have a simple example of the loop:

```ruby
x = 0

while x < 10
  if x.even?
    puts x
  end
  x += 1
end

# 0
# 2
# 4
# 6
# 8
#  => nil
```

We try to only display even numbers below 10. Ruby go automatically through all numbers below 10 and choose only even numbers. We don't need to do this manually.

#### Iterator

Now, let's go to **iterators**. The iterator is an object (sometimes we say method) allowing to iterate over the data set. So, we can go in _loop_ over each object in the collection and do some repeatable work. When you look at this definition you can say that functionality, I mean what iterators do, is the same like for loops. That's true, but they do that in different ways. When you use loops, you use external _object_ to do that. Like in our example, you use robot to put mugs in boxes. In iterators case, collection itself do this iterations. Or in other words collection itself has its own iterator. So, this is like a collection of mugs packing themselves to the boxes without an external robot. It will be great to have something like that in normal life. You buy plates and they wash themselves, when they are in the collection. Nice! In the Ruby world, we use iterators more often then loops, especially when we work with an array or hash. In most cases, we want to do something with element of collection and we don't care about its index.

```ruby
array = ['a', 'b', 'c']

for i in 0...array.size do
  puts array[i]
end

# a
# b
# c
#  => 0...3
```

In the example above, we use `for` where we iterate through indexes doing something on an element of `array` collection. You can say that, I don't need to iterate though indexes. I can iterate over a collection. That's true, but we still use external methods to do that. Like in example below with `for`:

```ruby
array = ['a', 'b', 'c']

for item in array do
  puts item
end

# a
# b
# c
#  => ["a", "b", "c"]
```

There is also a third way to do that. Using iterator. In this case, we use a method, which collection has already.

```ruby
array = ['a', 'b', 'c']

array.each do |item|
  puts item
end

# a
# b
# c
#  => ["a", "b", "c"]
```

## Type of iterators

Now you know the basics. We can start talking about:
- What are the differences between iterators?
- When can we use Ruby iterators?
- Where can we use Ruby iterators?
- What is the destiny of specific iterator in Ruby?
- How choose the best iterator for my purpose?

### Each

`each` iterator is the most popular iterator in Ruby. You saw it in one of last examples. By using `each` iterator, you can do some operations/calculations on elements of the collection.

```ruby
word = ''

['r', 'u', 'b', 'y'].each do |letter|
  word += letter
end

#  => ["r", "u", "b", "y"]

word
#  => "ruby"
```

As a result, after calculations `each` will always **return base collection**. In the example above at the beginning, we had `['r', 'u', 'b', 'y']` array and this is exactly, what was returned after `each`. That doesn't mean you cannot change initial object. It is not always expected, but it is good to know, when this happens. If you want to do that, the best solution is to use `map!` or `collect!`. This will explicite tell, that this is on purpose. We will explore more this iterators soon. In some cases overwriting basic collection is also possible when you use `each`, but it is hidden and sometimes you don't even expect it. Check next example:

```ruby
array = [{ static: "I don't want to be changed!" }, { static: 'Me too!' }]

array.each do |item|
  item[:dynamic] = 'I can change yours objects!'
end

#  => [{:static=>"I don't want to be changed!", :dynamic=>"I can change yours objects!"}, {:static=>"Me too!", :dynamic=>"I can change yours objects!"}]

array
#  => [{:static=>"I don't want to be changed!", :dynamic=>"I can change yours objects!"}, {:static=>"Me too!", :dynamic=>"I can change yours objects!"}]
```

You can see that in this case, as a result, we get from `each` different collection, then initial collection was. The second thing is that not only result changed, but we modify `array` object too! This happened always when `item` as an element of the collection is a _complex object_ and we try to change it for example by assignment. I said more about this problem in an article about <a href="{{ site.baseurl }}/ruby-hash-tips" title="Useful methods for Hash in Ruby">Ruby hash tips</a>. This will not happen when you work on simple array with numbers.

```ruby
array = [1, 2, 3]

array.each do |item|
  item = 5
end

#  => [1, 2, 3]

array
#  => [1, 2, 3]
```

You will use `each` iterator each time when the calculations are the most important part of your code. You are not interested in what `each` will return and in most cases you don't want to change an initial object.

At the end of this section I will add one more thing. There are different types of `each`. For example: `each_char`, `each_line`, `each_with_index` or <a href="{{ site.baseurl }}/each-with-object" title="How to use each_with_object method?">`each_with_object`</a>. You can use them in a different context for specific purposes. If you are interested in more details, please check <a href='https://ruby-doc.org/' title='Documentation for the Ruby programming language' target='_blank' rel='nofollow noopener'>Ruby documentation</a>.

### Map / collect

`map` and `collect`, this is exactly the same iterator, we just have two names for it. The behavior of this iterator is different then for `each`. In this case we will return a new object, based on calculations inside `map`. Take a look on example below:

```ruby
array = [1, 2, 3, 4, 5]

array.map do |item|
  item ** 2
end

#  => [1, 4, 9, 16, 25]

array
#  => [1, 2, 3, 4, 5]
```

As you see the initial array was `[1, 2, 3, 4, 5]` and it didn't change after `map`, but what we get as a result of the `map` is different. We get `[1, 4, 9, 16, 25]`. This is a result of calculation `item ** 2`, where `item` is each number in the array.

We can use this iterator always when we want to generate a new array based on existing array, but we don't want to change the initial object.

### Map! / collect!

The situation looks slightly different when we add `!` on the end of iterator name. This small char will change iterator behavior and allow us to overwrite values of the initial object. In our example, this will be an array object.

```ruby
array = [1, 2, 3, 4, 5]

array.map! do |item|
  item ** 2
end

#  => [1, 4, 9, 16, 25]

array
#  => [1, 4, 9, 16, 25]
```

As you see in the example above, we overwrite the initial value of `array` from `[1, 2, 3, 4, 5]` to `[1, 4, 9, 16, 25]`. As in `map` we also return a new collection after calculations. This can be useful when you still want to use the same name of variable but with different value.

The behavior of `map!` is the same like doing `map` with the assignment.

```ruby
array = [1, 2, 3, 4, 5]

array = array.map do |item|
  item ** 2
end

#  => [1, 4, 9, 16, 25]

array
#  => [1, 4, 9, 16, 25]
```

One more thing, be careful when you use the `map!`. This iterator will modify your current state. And this always introduces more complexity in your code. Especially when you want to understand, what is going on with your variables and state.

### Select

Now let's take a look on something completely different. This iterator will not do calculations on collection, but it will allow us to select specific elements from the base collection based on logical conditions. If an element of the collection will fulfill the condition, then it will stay in the collection. If no, element will be removed from the collection. Check the example:

```ruby
(1..10).select do |item|
  item.even?
end

#  => [2, 4, 6, 8, 10]
```

The only way to get the same collection is to fulfill the condition by all elements in the collection.

```ruby
(1..10).select do |item|
  item.is_a?(Numeric)
end

#  => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

This iterator is very useful, when you want to choose only a specific group of elements. You are not interested in all collection, but with a small part of it.

In the same way will behave iterators `filter` and `find_all`.

### Find

Iterator `find` is similar to `select`, but with one difference. When `select` return collection of all elements fulfilling condition, then `find` will return only **first element** doing that. So the result of this iterator will not be a collection, but just a single element.

```ruby
(1..10).find do |item|
  item.even?
end

#  => 2
```

`find` iterator is useful when you search for one specific element in the collection. In most cases when you know that only one element fulfill condition or you need to choose first from collection doing that.

### All? / Any?

Now we will talk a little bit about two iterators, which still check fulfilling of the condition, but in different ways. They will return `Boolean` value after checking the condition. In case of `all?` iterator will return `true` when **all elements** fulfill the condition.

```ruby
(1..10).all? do |item|
  item.even?
end

#  => false
```

Because only half of the numbers from 1 to 10 are even, we will get `false`. The situation looks different for `any?` iterator. In this case **at least one element** need to fulfill the condition.

```ruby
(1..10).any? do |item|
  item.even?
end

#  => true
```

So because in this collection for example `2` is even number, we get `true`.

We can use these iterators when we want to check if elements in our collection has some feature (characteristic) and we are not interested in which element has that.

### Times

Last but not least is `times` iterator. This Ruby iterator is for doing something many times, repeatedly. You are not using this iterator on the collection, but on numbers. As in `each` iterator, it will return base object. So, in this case it will be a number. Check in the example below:

```ruby
5.times do
  puts 'Ruby `times` method repeat this line.'
end

# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
#  => 5
```

Of course we can parameterize `times` iterator a little bit using number of current iteration.

```ruby
5.times do |iterator|
  puts "#{iterator}. I repeat this text."
end

# 0. I repeat this text.
# 1. I repeat this text.
# 2. I repeat this text.
# 3. I repeat this text.
# 4. I repeat this text.
#  => 5
```

## Summary

We started from the difference between loop and iterator. Then I showed you some of the iterators:
- [each](#each)
- [map/collect](#map--collect)
- [map!/collect!](#map--collect-1)
- [select](#select)
- [find](#find)
- [all?/any?](#all--any)
- [times](#times)

I hope this article will allow you to better understand the differences between Ruby iterators and the way how use them.
