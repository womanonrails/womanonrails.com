---
excerpt: >
  Have you ever thought about the `to_a`
  and `to_ary` methods for the `Array` class?
  Are they the same?
  Why do we have two similar methods?
  What is the difference?
  What about implementations of these methods
  in classes other than `Array`?
  In this article I want to answer these questions.
  So let's get started!
layout: post
photo: /images/ruby-to-ary/ruby-to-ary
title: What's the difference between to_a and to_ary in Ruby?
description: Ruby to_a and to_ary method comparison
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
imagefeature: ruby-to-ary/og_image.png
lang: en
---

Have you ever thought about the `to_a` and `to_ary` methods for the `Array` class? Are they the same? Why do we have two similar methods? What is the difference? What about implementations of these methods in classes other than `Array`? In this article I want to answer these questions. So let's get started!

Let's start with the definition of the `to_a` and `to_ary` methods in the `Array` class. On the [Ruby Doc](https://ruby-doc.org/current/Array.html#method-i-to_a "Ruby documentation") website we can see that

>`to_a` - When `self` is an instance of `Array`, returns `self`. Otherwise, returns a new `Array` containing the elements of `self`.

>`to_ary` - Returns `self`.

The definitions are similar, but we see the difference. When we talk about the implementation of these methods in classes other than `Array`, we can say that `to_ary` is used for _implicit_ conversions, while `to_a` is used for _explicit_ conversions. This can be hard to understand. That's why I like to say that `to_ary` allows an object to be **treated as an array**, while `to_a` actually **tries to convert the object into an array**. This pattern is used all over the Ruby language, for example in method pairs like `to_s` and `to_str`, `to_i` and `to_int`.

OK, let's check this out with examples. Let's create a `Point` class that we can check when the `to_a` or `to_ary` method is called.

```ruby
class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_a
    puts 'to_a method called'
    [x, y]
  end

  def to_ary
    puts 'to_ary method called'
    [x, y]
  end

  def inspect
    "#<#{self.class.name} (#{x}, #{y})>"
  end

  private

  attr_reader :x, :y
end
```

Now we can check what happened when we used the splat operator (*) on the `Point` object.

```ruby
point = Point.new(1, 3)
#  => #<Point (1, 3)>

Point.new(*point)
# to_a method called
#  => #<Point (1, 3)>
```

As we can see, the `to_a` method has been called. On another side, when we assign a `Point` object into variables, method `to_ary` is called.

```ruby
x, y = point
# to_ary method called
#  => #<Point (1, 3)>
```

As a next step, we will check what happened when we use `each` on points collection.

```ruby
[point].each { |item| item }
#  => [#<Point (1, 3)>]

[point].each { |(x, y)| [x, y] }
# to_ary method called
#  => [#<Point (1, 3)>]
```

In the first example, nothing happened. We iterated through the collection in the normal way. In the second example we see that the method `to_ary` is called. This is because we're doing variable assignments. It's worth mentioning that in the implementation of the `Point` class, the point components are private, but thanks to the `to_ary` method used in `each` (or another iterator), we can get access to them.

Some time ago, in the article [How Ruby casts object into a string?]({{ site.baseurl }}/casting-ruby-object-into-string "Difference between to_s and to_str methods in Ruby"), I described how the `puts` method works on the array. Now let's see which method `to_a` or `to_ary` is used to print the array.

```ruby
puts point
# to_ary method called
# 1
# 3
#  => nil
```

If the `to_ary` method is implemented in the `Point` class, the `puts` method will try to call it to split the object into smaller pieces. Then `puts` is called on each element. So we can say that in this case `puts` is called recursively.

Now is a good time to mention that if your object doesn't have the `to_ary` method implemented, variable assignment will behave differently without exception. See below:

```ruby
class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_a
    puts 'to_a method called'
    [x, y]
  end

  def inspect
    "#<#{self.class.name} (#{x}, #{y})>"
  end

  private

  attr_reader :x, :y
end

point = Point.new(1, 3)
#  => #<Point (1, 3)>

x, y = point
#  => #<Point (1, 3)>

x
#  => #<Point (1, 3)>

y
#  => nil
```

So you see that the `Point` object has not been split into its coordinates. Now let's check the `puts` method for `Point` without the `to_ary` method.

```ruby
point = Point.new(1, 3)
#  => #<Point (1, 3)>

puts point
#  #<Point:0x00007f6e92b2a8b0>
#  => nil
```

`puts` does not iterate over point coordinates. A similar observation can be made for the `flatten` method. If the `Point` class does not implement the `to_ary` method, we will see:

```ruby
point_1 = Point.new(1, 3)
#  => #<Point (1, 3)>

point_2 = Point.new(1, 5)
#  => #<Point (1, 5)>

[point_1, point_2].flatten
#  => [#<Point (1, 3)>, #<Point (1, 5)>]
```

On the other hand, for the `Point` class with the `to_ary` method, the result will be different.

```ruby
point_1 = Point.new(1, 3)
#  => #<Point (1, 3)>

point_2 = Point.new(1, 5)
#  => #<Point (1, 5)>

[point_1, point_2].flatten
#  to_ary method called
#  to_ary method called
#  => [1, 3, 1, 5]
```

`flatten` will call `to_ary` (recursively) on each of the elements in the array. As an exercise, you can check the same behavior for the `join` method.

## Summary
1. Two methods allow us to be like an `Array`:
    - `to_a` method - allows to cast object into an `Array`.
    - `to_ary` method - allows the object to _behave_ like an `Array`.
2. Splat operator `*` uses `to_a` method.
3. Object assignment to variables tries to use `to_ary` if it's implemented. If no `to_ary` method is implemented, only the first variable will get the assignment. The rest of the variables will be `nil`.
4. The `puts` method tries to use the `to_ary` method if it is implemented.
5. The `flatten` and `join` methods behave similarly to `puts`. They try to use the `to_ary` method under the hood when it is implemented.

## Links
- [How Ruby casts an object into a string?]({{ site.baseurl }}/casting-ruby-object-into-string "Difference between to_s and to_str methods in Ruby")
- [Array Ruby Doc](https://ruby-doc.org/current/Array.html#method-i-to_a "Array Ruby documentation")
- [What's the difference between to_a and to_ary? - Stack Overflow](https://stackoverflow.com/questions/9467395/whats-the-difference-between-to-a-and-to-ary "Stack Overflow thread about to_a and to_ary methods")
