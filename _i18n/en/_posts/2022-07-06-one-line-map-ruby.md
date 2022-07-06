---
layout: post
photo: /images/ruby-and-map/ruby-map
title: Ruby map(&:method) syntax - meaning & usage
description: One-line map in Ruby
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, functional programming]
imagefeature: ruby-and-map/og_image.png
lang: en
---

A few days ago, I worked on a customer project, and I wanted to use one line `map` but with an argument for a method inside this `map`. I never had this need before. Normally in one line `map`, I do something like `.map(&:next)`. This time I needed something else. So, I did a short research on how can I do that. The results of this research were so interesting to me that I decided to create an article about this topic. So let's get started!

Normally, when we use `map` or another iterator we use it in a block version:

```ruby
[1, 2, 3, 4, 5].map do |item|
  item + 1
end
# => [2, 3, 4, 5, 6]
```

Sometimes calculations inside the block (like in the example above) are so simple that we can do it more shortly:

```ruby
[1, 2, 3, 4, 5].map { |item| item + 1 }
# => [2, 3, 4, 5, 6]
```

Or even shorter:

```ruby
[1, 2, 3, 4, 5].map(&:next)
# => [2, 3, 4, 5, 6]
```

The `map(&...)` looks nice and brings me to some questions. Is it a shortcut for already shown examples? Or maybe it's something different? Can we put an argument to method inside `map`? How can we use it creatively? And the most important question is what is going on there when we call `map(&...)`?

#### Disclaimers

1. First of all, everything I will cover today, you can use for other <a href="{{ site.baseurl }}/ruby-iterators" title="Ruby iterators overview">Ruby iterators</a> as well. Like: `each`, `inject`, `select`, and so on. Of course, not always do those tricks make sense, but they are possible.
2. The main focus here is on understanding `map(&...)`. Some of the solutions can be less readable than a normal `map` with a block. You, as a developer, decide what approach is the best for your code.
3. Since I will cover a lot of Ruby proc, lambdas and block topic, I recommend you to read also my article about <a href="{{ site.baseurl }}/functional-programming-ruby" title="Functional programming in Ruby">functional programming in Ruby</a>. It will help you to better understand what is going on.
4. I write this article for fun and to better understand the basic concepts of the Ruby language. I hope you will like it too.

## What does the `map(&...)` do?

When we see:

```ruby
[1, 2, 3, 4, 5].map(&:next)
# => [2, 3, 4, 5, 6]
```

at first, we can say that this is a shortcut for

```ruby
[1, 2, 3, 4, 5].map { |item| item.next }
# => [2, 3, 4, 5, 6]
```

but it's not true. It's shorthand for

```ruby
[1, 2, 3, 4, 5].map(&:next.to_proc)
# => [2, 3, 4, 5, 6]
```

The example above doesn't give us a full understanding of this code, so let's go step by step. When `[1, 2, 3, 4, 5].map(&:next)` is executed, the `&:next` is given to the `map`. Since the `&:next` is passed to the `map` as a block argument (I will explain it more in a moment) Ruby will try to make a `Proc` from it. It's why the `&:next.to_proc` is called. `:next` is a Symbol object so that we can call on it the `Symbol#to_proc` method. Then `map` sends `call` message to the `&:next.to_proc` with first parameter `1`. The `:next.to_proc.call(1)` is executed. From the implementation of the `to_proc` method, we know `to_proc` procedure for `Symbol` object sends a `send` method to a `1` object with argument `:next` (so, `1.send(:next)` is executed). The whole process is repeated on the rest of the elements in `[1, 2, 3, 4, 5]`.

## Block argument in map

Let's go back to the block argument in `map`. In Ruby, we can put "function" (block) as an argument to any method (not only a `map`). See the example below:

```ruby
def check_arguments_method(*args, &block)
  puts "args: #{args.inspect}"
  puts "block: #{block.inspect}"
end
```

When we call it with no block argument, we will see:

```ruby
check_arguments_method(:next)

# args: [:next]
# block: nil
```

There is no block in this case. But when we run it with `&`:

```ruby
check_arguments_method(&:next)

# args: []
# block: #<Proc:0x00005588aae7b4a8(&:next) (lambda)>
```

We see that Ruby converts `:next` by using the `to_proc` method into a `Proc` object, and we have a block. Why do I say that? Well, check the next example. When I try to provide `String` as a block, I will get:

```ruby
check_arguments_method(&'next')

# (irb):13:in `<main>': wrong argument type String (expected Proc) (TypeError)
```

We see that `Sting` is not a `Proc` and cannot be converted into a `Proc`. Or in other words, `String` doesn't respond to `#to_proc`. What happened when I put the real `Proc` object into this method?

```ruby
my_proc = Proc.new { |item| item.next }

# => #<Proc:0x00005588aa81c468 (irb):14>

check_arguments_method(&my_proc)

# args: []
# block: #<Proc:0x00005588aa81c468 (irb):14>
```

We see that the `my_proc` object is passed as a block argument into our `check_arguments_method`, and inside this method, we see the same object (based on its object id). Let's check one more thing. What happened when we omit the `&` before `my_proc`?

```ruby
check_arguments_method(my_proc)

# args: [#<Proc:0x00005588aa81c468 (irb):14>]
# block: nil
```

In this case, Ruby treats the `my_proc` argument as a no-block argument. So to be sure that the argument, we put into a method, is treated as a block, we need to add `&` as a prefix for it. That's why we put `&` in our `[1, 2, 3, 4, 5].map(&:next)` example.

## How to provide an argument into a block argument in the map?

As you saw in the previous example, we can do:

```ruby
[1, 2, 3, 4, 5].map(&:next)
# => [2, 3, 4, 5, 6]
```

But what if we want to add an argument to our block method? Something like:

```ruby
[1, 2, 3, 4, 5].map(&:+(2))

# /home/agnieszka/.rvm/rubies/ruby-3.0.3/lib/ruby/3.0.0/irb/workspace.rb:116:in `eval': (irb):19: syntax error, unexpected '(', expecting ')' (SyntaxError)
```

We see that it's not possible in that way. But can we do that differently? The answer is - yes.

```ruby
[1, 2, 3, 4, 5].map(&2.method(:+))
# => [3, 4, 5, 6, 7]
```

WOW! What happened here? First `2.method(:+)` is called. We take object `2` and we create **Method Object** on it. The Method Object responds to `to_proc` method so `2.method(:+).to_proc` is run. Then for each element of the array method `call` is called on Proc object. For example: `2.method(:+).to_proc.call(1)`.

There is one more thing worth mentioning here. When we have a Method Object, we can call the `call` method directly. We don't need to convert it to `Proc`.

```ruby
2.method(:+).call(1)
# => 3
```

### Other examples with additional argument

#### Convert Array to Enumerable object

```ruby
[1, 2, 3, 4, 5].to_enum.with_object(2).map(&:+)
# => [3, 4, 5, 6, 7]
```

We convert Array to Enumerable object. Then inject the `2` object into it. In the end, we iterate through each element of the Array and do the addition.

#### Lambda in map method

```ruby
[1, 2, 3, 4, 5].map(&->(item) { item + 2 })
# => [3, 4, 5, 6, 7]
```

Where `->(item) { item + 2 }` is a lambda and it's similar to `Proc` version.

```ruby
[1, 2, 3, 4, 5].map(&(Proc.new { |item| item + 2 }))
# => [3, 4, 5, 6, 7]
```

#### Declare our own method

This example is similar to the first one with a `method`, but now we have full control over what is going on in the `double` method. We don't rely on the Ruby `2` object interface.

```ruby
def double(x)
  x + 2
end

[1, 2, 3, 4, 5].map(&method(:double))
# => [3, 4, 5, 6, 7]
```

#### Use curry method

```ruby
[1, 2, 3, 4, 5].map(&:+.to_proc.curry(2).call(2))
# => [3, 4, 5, 6, 7]
```

We will stop for a moment here to understand, what is going on in this code. First, we put the `:+` method into a `map` and convert it to Proc `&:+.to_proc`. Then `&:+.to_proc.curry(2)` tells Ruby that this Proc can be called only when has 2 arguments. I will talk a bit more about the `curry` method in the next section. Next we provide first argument `2` to this Proc `:+.to_proc.curry(2).call(2)`. Now is the part we know already. We call `to_proc` on our Proc and call the `call` method with each element of the array.

## Curring - quick overview

Last but not least **curring**. **Curring** is a mathematical term used in programming too. It's the technique a function with multiple arguments is converted into a sequence of functions that each have only one argument. Let's see that in our example. In normal life, method `:+` needs 2 arguments. We will convert it into two methods (functions) with only one argument.

```ruby
adding_method = :+.to_proc.curry(2)
# => #<Proc:0x000056401dc42fa8 (lambda)>

first_function = adding_method.call(2)
# => #<Proc:0x000056401e27ad08 (lambda)>

first_function.call(1)
# => 3
```

First we create our function (Proc) `:+.to_proc.curry(2)`. Then we call it with the first argument and assign it to the variable `first_function = adding_method.call(2)`. It will return a new function (Proc) with only one argument. After calling the new method `first_function.call(1)` we will get result of adding to numbers `2 + 1`. Without the `curry` method, we need to provide all arguments at the same time to the `:+` method.

```ruby
:+.to_proc.call(2, 1)
# => 3
```

In case we will try to postpone putting the second argument to the method, we will get an error.

```ruby
:+.to_proc.call(2)
# (irb):51:in `+': wrong number of arguments (given 0, expected 1) (ArgumentError)
```

We can say that curring allows us to postpone the final call of the method with multiple arguments in time. But it's worth mentioning that we don't need to postpone it.

```ruby
adding_method.call(2, 1)
# => 3
```

To summarize what we saw. When we use the `curry` method on Proc, the curried Proc-based method is returned. When the `call` with a number of arguments that is lower than the method's arity is called on returned Proc, then another curried Proc is returned. Only when enough arguments have been supplied to satisfy the method signature, the actual method will be called. This behavior is useful, for example, in a block like `map`.

The `map` method in Ruby is definitely an interesting one, similar to other block methods. Hopefully, I was able to explain the details of `map` with a block in a simple way. If you enjoyed it, make sure to give a 👏 so I know that it helped!

## Links

- <a href="{{ site.baseurl }}/ruby-iterators" title="Ruby iterators overview">Ruby iterators</a>
- <a href="{{ site.baseurl }}/functional-programming-ruby" title="Functional programming in Ruby">Block, proc and lambda in Ruby</a>
- <a href="https://stackoverflow.com/questions/23695653/can-you-supply-arguments-to-the-mapmethod-syntax-in-ruby" title="Stack Overflow question about map(&:method) arguments" target='_blank' rel='nofollow'>Can you supply arguments to the map(&:method) syntax in Ruby?</a>
- <a href="https://stackoverflow.com/questions/1217088/what-does-mapname-mean-in-ruby" title="Stack Overflow question about map(&:method) meaning" target='_blank' rel='nofollow'>What does map(&:name) mean in Ruby?</a>
- <a href="https://medium.com/@cesargralmeida/currying-a-ruby-approach-b459e32d355c" title="Medium article about curring basics" target='_blank' rel='nofollow'>Currying: A Ruby approach</a>
- <a href="https://stackoverflow.com/questions/53620881/understanding-the-arity-parameter-of-the-method-proc-curry-in-ruby" title="Stack Overview question about Proc.curry method" target='_blank' rel='nofollow'>Understanding the arity parameter of the method Proc.curry in Ruby</a>
