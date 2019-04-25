---
layout: post
title: Pattern matching in Elixir - basics
description: What I learned about Elixir so far?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Elixir]
lang: en
---

Elixir is a functional language, created by José Valim in 2012, runs on the Erlang virtual machine. If you want to know more about Elixir, go to its <a href="https://elixir-lang.org/" title="Elixir - official website" target="_blank" rel="nofollow noopener noreferrer">official website</a>. I would like to mention one more thing. It is Rails and Ruby reference here. José is one of the members of Rails Core Team.

The first time when I've heard about Elixir, I was on Euruko 2016 in Sofia. José, before his presentation, talked a little bit about Elixir. Then I saw that Ruby community started to be more interested in Elixir. Even in Silesia, people started doing projects in Elixir and Phoenix. And in the end of 2018, I had a possibility to be a participant on first Elixir Girls in Poland. This workshop took a place in Poznan. It was a fantastic experience. I can say - mind opening. But I wouldn't like to talk about the workshops them self. The structure is very similar to <a href="{{ site.baseurl }}/tags/#Rails%20Girls" title="My previous Rails Girls articles">Rails Girls</a>, but you use Elixir and Phoenix instead of Ruby and Rails. I would like to show you what I really like about Eilixir - **pattern matching**. It provides reducing numbers of "if" statements in the code and simplify the code structure.

### Basic match operator

Let's start from the beginning. **What is pattern matching?** Pattern matching is checking if the code is matching to the pattern. Yes, it sounds strange. I said the same thing but in different words. Let's imagine that we have some rules - patterns, and you just check if your code/text match to this pattern or not. Like, when you were a child and tried putting a cubic block to square hole. Sounds familiar? Did you ever use regular expressions? I wrote one of my articles about them <a href="{{ site.baseurl }}/email-regular-expressions" title="Regular expressions - what you need to think of using them?">Regular expressions what can go wrong?</a>. Regular expressions are one of an example of pattern matching. OK, when we know more about what pattern matching is, let's start from simple example.

```elixir
iex> x = 4
4
```

Wait a moment it is just assignment. Well, not exactly. Not in Elixir. In Elixir `=` is the **match operator**. So we check if the left hand side expression can match to right hand side expression. This is why we can do:

```elixir
iex> 4 = x
4
```

This is a valid operation. It is matched from both sides to 4. We cannot do something like that in Ruby.

```ruby
irb> x = 4
 => 4
irb> 4 = x
Traceback (most recent call last):
        1: from /home/agnieszka/.rvm/rubies/ruby-2.5.3/bin/irb:11:in `<main>'
SyntaxError ((irb):5: syntax error, unexpected '=', expecting end-of-input)
4 = x
  ^
```

On the other hand when we go back to Elixir and we check `5 = x`. We will see:

```elixir
iex> 5 = x
** (MatchError) no match of right hand side value: 4
```

Right now, comparison between left and right hand side failed. We get information about `no match`. The similar situation will be when we will try with unknown yet variable like `y`.

```elixir
iex> 5 = y
** (CompileError) iex:6: undefined function y/0
```

Elixir doesn't know variable `y` so it's trying to find a function with zero arguments. This expression also failed. To fulfill this expression we can do:

```elixir
iex> y = x + 1
5
iex> 5 = y
5
iex> 5 = x + 1
5
```

It is worth to mention one more thing here. Each time you will do comparison like `x = 3` you will _overrides_ `x` value. If you want to match against the current value of a variable use the `^` operator:

```elixir
iex> ^x = 4
4
iex> ^x = 5
** (MatchError) no match of right hand side value: 5
```

If you want to just check if `x` has specific value use `==` like in Ruby.

```elixir
iex> x == 5
false
iex> x == 4
true
```

### Tuples

Let's do the next step on more complex elements:

```elixir
iex> { a, b } = { 1, 2}
{1, 2}
iex> a
1
iex> b
2
iex> { a, b } = { "one", 2 }
{"one", 2}
iex> a
"one"
iex> b
2
```

As you see, we can use in pattern matching more complex objects. We can also check something like that:

```elixir
iex> { a, 2 } = { "one", 2 }
{"one", 2}
iex> { a, 3 } = { "one", 2 }
** (MatchError) no match of right hand side value: {"one", 2}
iex> { a, b, c } = { "one", 2 }
** (MatchError) no match of right hand side value: {"one", 2}
```

We can have on the left hand side not only variables but also values. So in this case when on the left side, we don't have 2, we get an error. We didn't match to the pattern. The same situation is for a size of the tuple. If the side is different between sides, we also get an error.

### Lists

Now time to list. We can do similar things like for tuples.

```elixir
iex> [a, b] = [4, 5]
[4, 5]
iex> a
4
iex> b
5
```

We can do even more. We can take out the first element in the list and decrease output list by 1 element.

```elixir
iex> [head | tail] = [4, 5, 6]
[4, 5, 6]
iex)> head
4
iex> tail
[5, 6]
```

As you see, `head` is the first element of our list, but `tail` is still list minus one element. You can play with this:

```elixir
iex> [head1 | [head2 | tail]] = [4, 5, 6]
[4, 5, 6]
iex> head1
4
iex> head2
5
iex> tail
[6]
```

Similar like for tuples, if we have not enough elements in the list we will get an error:

```elixir
iex> [head | tail] = [4]
[4]
iex> head
4
iex> tail
[]
iex> [head | tail] = []
** (MatchError) no match of right hand side value: []
```

Using this approach we can add an element on top of a list:

```elixir
iex> list = [4, 5, 6]
[4, 5, 6]
iex> [3 | list]
[3, 4, 5, 6]
```

The next thing was very interesting for me. Because `'hello'` is **char list** so we can do similar things like before to this _text_. Just remember we will get integer representation of each char.

```elixir
iex> [head1 | [head2 | tail]] = 'hello'
'hello'
iex> head1
104
iex> head2
101
iex> tail
'llo'
```

### Case

We use pattern matching in Elixir also in `case`:

```elixir
iex> case {4, 5, 6} do
...> {4, 5} -> "One"
...> {4, 5, x} -> "Two #{x}"
...> _ -> "Three"
...> end
"Two 6"
```

We check matching from a top. First fit is `{4, 5, x}`. We even get assignment for free. If we remove the second pattern we will match to the last one. Any input data will match to `_`. We can also add extra condition as **guards**:

```elixir
iex> case {4, 5, 6} do
...> {4, 5, x} when x > 6 -> "One"
...> {4, 5, x} when x <= 6 -> "Two #{x}"
...> _ -> "Three"
...> end
"Two 6"
```

Remember not all errors in guards will be discovered. Some of them will not show error, but will just fail the guards.

```elixir
iex> hd([5, 6])
5
iex> hd(5)
** (ArgumentError) argument error
    :erlang.hd(5)
iex> case 5 do
...> x when hd(5) -> "One"
...> x -> "Two"
...> end
"Two"
```

### Functions

Finally we came to functions, where all the beauty of pattern matching will show. Starting from anonymous functions:

```elixir
sum = fn
  x, 0 -> x
  x, y when x < 0 -> -x + y
  x, y when x > 0 -> x + y
end

sum.(1, 2)
#=> 3
sum.(-1, 2)
#=> 3
sum.(1, 0)
#=> 1
sum.(-1, 0)
#=> -1
```

We can handle many different cases in a clear way. I know this example is not a live example and we don't cover all edge cases like `sum.(0, 1)`. When we look closely we can probably simplify it even more. But this is not the topic of this article. Take a look for the next example with named function:

```elixir
defmodule Math do
  def minus?(), do: "No number"
  def minus?(x), do: x < 0
  def minus?(x, 2), do: "Suprice #{x}!"
  def minus?(x, y), do: x < 0 && y < 0
end

Math.minus?
#=> "No number"
Math.minus?(1)
#=> false
Math.minus?(1, 2)
#=> "Suprice 1!"
Math.minus?(1, 3)
#=> false
Math.minus?(1, -3)
#=> false
Math.minus?(-1, -3)
#=> true
```

We can declare a function with different arity. We can also use different types. We see all cases explicite. I can try to do this in Ruby using default values and checking conditions, but it will not be so readable, like declaring each version of function completely separately. In the end, I would like to stop for a moment on recursion:

```elixir
defmodule Math do
  def sum_list(list, accumulator \\ 0)

  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  def sum_list([], accumulator) do
    accumulator
  end
end

Math.sum_list([1, 2, 3])
#=> 6
Math.sum_list([1, 2, 3], 1)
#=> 7
```

Of course we can do the same with `reduce` in Elixir, but look at this example only from recursion perspective. We set default value for `accumulator` and just declare twice the same function: one with _braking condition_ (last declaration) and one with _iteration_. We clearly see what is going on here. For this simple example, loop will be still readable but think about this from the potential perspective. I like this approach very much.

That's it for today. I hope you had fun with Elixir the same way I had. I hope to see you soon, in my next article. Thank you for reading. Bye!
