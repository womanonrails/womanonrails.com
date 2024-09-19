---
excerpt: >
  Ruby is an object oriented language.
  That doesn't mean we cannot do some functional programming in Ruby.
  When you take a look closer to the history of the Ruby language, you can find out,
  that Ruby was influenced by other languages like
  Perl, Smalltalk, Eiffel, Ada, Basic or Lisp.
  Because of this different inspirations
  we can find in Ruby not only object oriented concepts,
  but also a little bit of functional programming.
layout: post
title: Functional programming in Ruby
description: Short introduction to blocks, procs, lambdas and closures.
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, functional programming]
lang: en
---

Ruby is an object oriented language. That doesn't mean we cannot do some functional programming in Ruby. When you take a look closer to the history of the Ruby language, you can find out, that Ruby was influenced by other languages like Perl, Smalltalk, Eiffel, Ada, Basic or Lisp. Because of this different inspirations we can find in Ruby not only object oriented concepts, but also a little bit of functional programming.

Before we start going deep in functional programming in Ruby. Let's focus on **functional programming** its self. What is functional programming? You can find out, that functional programming is a **programming paradigm**. That means it is a way to classify programming languages based on their features. OK, so what are the features of functional programming language?

- Pure functions (no side-effects) - Function always returns the same result for the same arguments and function can never cause any observable side effects. This is how the function works in the mathematical world.
- Immutability - After the state/value is created, you cannot change it. Instead of changing state or value, you create a new one.
- Referential transparency - this is combining pure function and immutability.
- Memoization - It is a side effect of referential transparency. It can seed up computations by saving the results of previous calls.
- Idempotence - You will get the same results no matter how many times you will call a function. This is also a side effect of referential transparency.
- Higher-order functions - Functions which can get function as argument or return function as a result.
- Currying - Transforming a function that takes multiple arguments into a function that takes one argument and return function. We can say that this is a function generator in some sense.
- Recursion - It is invoking the function by themselves and letting an operation be repeated until it reaches the stop condition or base case.
- Lazy evaluation (non-strict evaluation) - It does not evaluate function arguments unless their values are needed for evaluation of the function itself.

Now we know a little bit about functional programming concepts. We can start going into Ruby functional programming.

## Blocks in Ruby

**Block it is nameless function in Ruby.** We can put it as last argument into function. There can be **only one block** put as an argument in Ruby method. In Ruby blocks are higher-order functions. A common block in Ruby is for example `each`:

```ruby
[1, 2, 3, 4].each do |item|
  p item
end

1
2
3
4
 => [1, 2, 3, 4]
```

Let's create our own block:

```ruby
def my_own_block
  p 'before'
  yield if block_given?
  p 'after'
end

irb> my_own_block
"before"
"after"
 => "after"
```

As you see, `my_own_block` behaves like a normal method because it is a normal method. The magic begins, when we will start using `yield` part. What is this `yield`? It is a call of our block, our nameless function which we can put as argument to `my_own_block` method. We can say that our `yield` will be replaced by everything what is in our argument for `my_own_block`. Let's check how we can call this method with block as an argument:

```ruby
irb> my_own_block { p 5 }
"before"
5
"after"
 => "after"
```

To call block as argument of the function we need to use curly brackets `{}` or `do end` clause. We cannot use normal brackets `()`. In this case we will get an error.

```ruby
irb> my_own_block(p 5)
5
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):13
        2: from (irb):13:in `rescue in irb_binding'
        1: from (irb):4:in `my_own_block'
ArgumentError (wrong number of arguments (given 1, expected 0))
```

First of all, we see `5` because in the beginning Ruby runs and calculates argument of the method. Then we get `wrong number of arguments (given 1, expected 0)`. That means that block argument is treated in a different way than normal method arguments. So, we cannot run block as a normal argument in this case. Later I will show you how to do that in the right way.

In this example I didn't tell you one more thing. What is it the `block_given?` condition? This helps us with handling a case when you do not put block as an argument. This method checks if block is given or not and prevent us before an exception. If we miss that condition in our method declaration and we will call the method without a block, we will see:

```ruby
def my_own_block
  p 'before'
  yield
  p 'after'
end

irb> my_own_block
"before"
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):19
        1: from (irb):16:in `my_own_block'
LocalJumpError (no block given (yield))
```

## Proc object

**Proc** is a one of classes in Ruby. A Proc object is an encapsulated block of code, which can be stored in a local variable. It can be later passed to a method or another Proc as an argument and can be called. It is essential for Ruby functional programming features concept.

You already saw one way to declare method with a block. Below I put another way to do that:

```ruby
def my_block(&block)
  p 'before'
  p block.class
  block.call
  p 'after'
end
```

We can execute it the same way as before:

```ruby
irb> my_block { p 4 }
"before"
Proc
4
"after"
 => "after"
```

We see that object inside a `block` variable is an instance of `Proc` class. We can call it by using a method `call`. `block.call` behaves the same like `yield` in our first example. But `Proc` object is even cooler than simple block. We can put many of them as arguments to Ruby method:

```ruby
def run_proc(first, last)
  first.call
  last.call
end
proc1 = Proc.new { p 'first' }
proc2 = Proc.new { p 'last' }

irb> run_proc proc1, proc2
"first"
"last"
 => "last"
```

We can also call `Proc` object outside of a method in many different ways:

```ruby
my_proc = Proc.new do |item|
  p "Text: #{item}"
end

irb> my_proc.call 10
"Text: 10"
 => "Text: 10"

irb> my_proc.(20)
"Text: 20"
 => "Text: 20"

irb> my_proc[30]
"Text: 30"
 => "Text: 30"

irb> my_proc === 40
"Text: 40"
 => "Text: 40"
```

This allows us to do some fancy tricks. Like using `Proc` in `case`:

```ruby
proc1 = Proc.new { |number| number % 3 == 0 }
proc2 = Proc.new { |number| number % 3 == 1 }

case 3
when proc1 then p 'proc1'
when proc2 then p 'proc2'
else
  p 'not a proc'
end
"proc1"
 => "proc1"
```

Because `case` is using an equality operator `===` to check if the condition is fulfilled and `Proc` object is implementing this method, we can do that magic with `Proc` inside `case`. This is outlier but, because `Range` class also is implementing equality operator `===`, we can use it in `case` too.

```ruby
irb> (4..7) === 5
 => true

irb> (4..7) === 8
 => false
```

Right now I will show you one more way to declare `Proc` in your method:

```ruby
def run_proc
  p 'before'
  my_proc = Proc.new
  my_proc.call
  p 'after'
end

irb> run_proc { p 6 }
"before"
6
"after"
 => "after"
```

When you look at this implementation, it can be for you very strange. We do not declare argument, so how does the `Proc.new` know what to do? Normally when you will just do `Proc.new` without any block declaration, you will get exception `tried to create Proc object without a block`. In this case when `Proc.new` has no block code itself, it will seek a block declaration in the current scope. So when we run our `run_proc` method with block, everything is working like it should.

## Lambdas

A **lambda** is an anonymous function. It is a function definition that doesn't have a _name_. It is not bound to an identifier. You can assign it to variable, but it doesn't have a name by which you can call it. Anonymous functions are often used as arguments for higher-order functions. In Ruby they are very similar to `Proc` object, but there are some small differences. Let's go through them.

#### Arguments control

We will declare lambda and `Proc` object. By the way the shortcut for `Proc.new` is `proc` so you can see me switching those two forms in the code.

```ruby
my_proc = Proc.new { |item| p "==#{item}==" }
my_lambda = lambda { |item| p "==#{item}==" }
```

This 2 objects are the same class:

```ruby
irb> my_proc.class
 => Proc

irb> my_lambda.class
 => Proc
```

Both objects have the same arity:

```ruby
irb> my_proc.arity
 => 1

irb> my_lambda.arity
 => 1
```

But there is a difference when you call them without argument. `Proc` will be executed and lambda will raise an exception:

```ruby
irb> my_proc.call
"===="
 => "===="

irb> my_lambda.call
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):77
        1: from (irb):62:in `block in irb_binding'
ArgumentError (wrong number of arguments (given 0, expected 1))
```

We cannot distinguish them by class name, but it is possible to use method `lambda?` to do that.

```ruby
irb> my_proc.lambda?
 => false

irb> my_lambda.lambda?
 => true
```

I would like to add one more thing to this section. If you declare an array of arguments in lambda. You will get arity `-1`.

```ruby
irb> lambda { |*items| }.arity
 => -1
```

In the end of this section I will show you one more possible declaration of lambda, by using arrow operator `->`.

```ruby
my_lambda = -> (item) { p "==#{item}==" }

irb> my_lambda.lambda?
 => true
```

#### Using with return

First, we declare method which will call a `Proc` object or a lambda.

```ruby
def run(proc)
  p 'before'
  proc.call
  p 'after'
end
```

Now we can run method `run` with lambda:

```ruby
irb> run lambda { p 'in'; return }
"before"
"in"
"after"
 => "after"
```

Everything is fine. Now, let's go to `Proc` object:

```ruby
irb> run proc { p 'in'; return }
"before"
"in"
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):91
        2: from (irb):87:in `run'
        1: from (irb):91:in `block in irb_binding'
LocalJumpError (unexpected return)
```

We see an error. We start with `"before"`, then we go to our `Proc` object and we print `"in"` and after that we get an exception. This is because `Proc` object doesn't return current context. **It wants to return context where it was defined.** This is the main context (irb console context). `Proc` cannot return from that context, so we see an exception. If we change the context, we will see the difference:

```ruby
def change_context
  run lambda { p 'in'; return }
  run proc { p 'in'; return }
end
```

Let's run our `change_context` method:

```ruby
irb> change_context
"before"
"in"
"after"
"before"
"in"
 => nil
```

First, we run part with lambda. It prints `"before"`, `"in"` and `"after"`. Then it calls a `Proc` object. We see `"before"`, `"in"` and then we finish our method `change_context`. Right now context of `Proc` object is context of `change_context` method. Because `Proc` return form context where it was created, it returns from method `change_context`. So, we cannot print second `"after"` string.

## Closures

Closure is a technique for creating a function based on another function with an environment which **have impact on this function during the declaration process**. This is one of the ways to generate new functions by using the function. It is related to higher-order functions concept. As it is hard to me to explain this in simple words, the example should help in understanding this concept.

```ruby
def multiple(m)
  lambda { |n| n * m }
end

double = multiple(2)
triple = multiple(3)

# Execute
irb> double[5]
 => 10
irb> triple[5]
 => 15
```

We declare function `multiple` with one argument. Inside this function we use lambda with also one argument, but we are using it with context of `multiple` method. We put `m` variable inside lambda declaration. Now we can generate functions based on `multiple` method. When we put as `m` variable `2` this value will go to lambda as sounding environment. Lambda in `double` method will be remembered as `lambda { |n| n * 2 }`. Right now when you call `double` method, you will put `5` as `n` variable. `5 * 2` is `10`.

There is one more thing to remember. In Ruby during closure we remember references to variable not the value of it. This is different then in other languages. And this is why you can change the context after it's declared, but you cannot create (declare) context after the declaration of closure. Let's check examples below. First, declare closure without context and try to add context later:

```ruby
my_proc = proc { p first_name }

irb> my_proc.call
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):107
        1: from (irb):105:in `block in irb_binding'
NameError (undefined local variable or method `first_name' for main:Object)
```

We get an error. Now we will try to add missing context:

```ruby
first_name = "Agnieszka"
 => "Agnieszka"

irb> my_proc.call
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):109
        1: from (irb):105:in `block in irb_binding'
NameError (undefined local variable or method `first_name' for main:Object)
```

It is not possible to add context after the declaration of closure. Next example will show you, that we can change context which was declared before:

```ruby
name = 'Agnieszka'
my_proc = proc { p name }

irb> my_proc.call
"Agnieszka"
 => "Agnieszka"

name = 'Ula'
irb> my_proc.call
"Ula"
 => "Ula"
```

#### Method as lambda

We can create a method and use it as lambda. This is how we do that:

```ruby
def my_method
  p 'Hello word'
end

my_proc = method(:my_method)

irb> my_proc.call
"Hello word"
 => "Hello word"
```

#### Types of closures in Ruby

We have a few types of closure in Ruby:
- block + `yield`
- block + `&b`
- `Proc.new`
- `proc`
- `lambda`
- `method`

#### Where do we use closures?

In pure Ruby:

```ruby
[1, 2, 3].each { |item| p item }

[1, 2, 3].each_cons(2).map { |x, y| x + y }

[1, 2, 3].map { |item| item.next }

[1, 2, 3].inject(0) { |sum, item| sum + item }
[1, 2, 3].inject(0, :+)
```

In Ruby on Rails:

```ruby
respond_to do |format|
  format.html # index.html.erb
  format.xml  { render :xml => @items }
end
```

## Bonus - Lisp in Ruby

To do Lisp lists in Ruby we will use lazy enumerators and recursion. But first, let's check how lists look like in Lisp.

```common-lisp
(write '(1 2 3 4))
 => (1 2 3 4)

(write (car '(1 2 3 4)))
 => 1

(write (cdr '(1 2 3 4)))
 => (2 3 4)
```

If you read my article about [Elixir basics]({{site.baseurl}}/elixir-pattern-matching "Elixir - How to fit into the pattern?") you can compare `car` and `cdr` methods to `head` and `tail` in Elixir. `car` will always return first element of the list and `cdr` will return list without first element. Let's prepare a Ruby array to behave like Lisp lists.

```ruby
car, cdr = [1,[2,[3]]]

irb> car
 => 1

irb> cdr
 => [2, [3]]
```

Now we will prepare normal enumerator for this kind of lists:

```ruby
class LispyEnumerable
  include Enumerable

  def initialize(tree)
    @tree = tree
  end

  def each
    while @tree
      car, cdr = @tree
      yield car
      @tree = cdr
    end
  end
end
```

This will allow us to do some operations on `car` a head of the list and it will overwrite `@tree` variable for the next step of our loop with `cdr` tail of list. We can call it like:

```ruby
list = [1,[2,[3]]]
irb> LispyEnumerable.new(list).each { |item| p item }
1
2
3
 => nil
```

For now our list is not lazy and our enumerator is also not lazy. To change that we will use lambdas.

```ruby
class LazyLispyEnumerable
  include Enumerable

  def initialize(tree)
    @tree = tree
  end

  def each
    while @tree
      car, cdr = @tree.call
      yield car
      @tree = cdr
    end
  end
end
```

We changed only one line. We calculate (execute) our next element of the list by calling `@tree.call`. To be able to use this enumerator, we need to also change a structure of our list itself.

```ruby
list = lambda { [1, lambda { [2, lambda { [3] } ] } ] }
irb> LazyLispyEnumerable.new(list).each { |item| p item }
1
2
3
 => nil
```

Right now we don't see any difference. To see that, let me change list declaration. If it will have strict evaluation, we will see all prints for numbers in the beginning and then the numbers. But if this is a lazy evaluation, then we will see it one by one.

```ruby
list = lambda do
  p '1 is called'
  [1, lambda do
    p '2 is called'
    [2, lambda { p '3 is called'; [3] }]
  end]
end

irb> LazyLispyEnumerable.new(list).each { |item| p item }
"1 is called"
1
"2 is called"
2
"3 is called"
3
 => nil
```

As you can see we have lazy enumerator. Now is the time for the Fibonacci sequence with lazy evaluation:

```ruby
def fibo(a, b)
  lambda { [a, fibo(b, a + b)] }
end

LazyLispyEnumerable.new(fibo(1, 1)).each do |item|
  puts item
  break if item > 100
end
1
1
2
3
5
8
13
21
34
55
89
144
 => nil
```

I put there break point, but without it Ruby can do these calculations into infinity (theoretically). In some way this is not the real recursion. We can say that this is an infinite loop. If we do that with the real recursion, the code will look like:

```ruby
def recursive_fibo(n)
  return 1 if n == 0
  return 1 if n == 1
  recursive_fibo(n -1) + recursive_fibo(n - 2)
end

irb> recursive_fibo(11)
 => 144
```

In this situation if we remove our gourds we will get an error `SystemStackError (stack level too deep)`. This will be also slower than lazy evaluation.

In the end I will only mention that since Ruby version 2.0 we can use lazy enumerators inside a Ruby language, like this:

```ruby
irb> (1..Float::INFINITY).lazy.select(&:even?).first(5)
 => [2, 4, 6, 8, 10]
```

If you want more information about them, check out
[Lazy enumerator documentation](https://ruby-doc.org/core/Enumerator/Lazy.html).

That's all for today. I hope you like it. If you have any questions put them in the comments below. I will try to answer them. See you next time!

## Bibliography

- {% include links/youtube-link.html
     name='An Introduction video about Procs, Lambdas and Closures in Ruby'
     video_id='VBC-G6hahWA' %}
- [Presentation about functional programming in Ruby](https://www.slideshare.net/tokland/functional-programming-with-ruby-9975242)
- [Article about closures in Ruby](https://innig.net/software/ruby/closures-in-ruby)
- [Ruby documentation](https://ruby-doc.org/)
