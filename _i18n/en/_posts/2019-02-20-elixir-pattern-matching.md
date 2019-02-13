---
layout: post
title: Elixir basics - pattern matching
description: What I leanred about Elixir so far?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Elixir]
comments: true
---

Elixir is functional language, created by José Valim in 2012, runs on the Erlang virtual machine. If you want to know more about Elixir, go to it [offictial website](https://elixir-lang.org/). I would like to mention one more thing. It is Rails and Ruby reference here. José is one of the members Rails Core Team.

First time I heard about Elixir was on Euruko 2016 in Sofia, when José before his presentation talk a little bit about Elixir. Then I saw that Ruby comminity started to be more interesten in Elixir. Even in Silesia peapole started doing projects in Elixir and Phenix. And on the end of 2018, I had a posibility to be a participant on first Elixir Girls in Poland. This wokrshops had a place in Poznan. It was fantastic experience. I can say mind opening. But I would like to not talk about the workshops themself. The structure is very similar to Rails Girls but you use Elixir and Phonix instead of Ruby and Rails. I would like to show you what I really like about Eilixir - pattern matching. It provides to reducing numbers of if statments in code and simplyfy code stratcure.

### Basic match operator

Let's start from the beginning. **What is pattern matching?**. Pattern matching is checking if code is matching to the pattern. Yes, it sounds strange. I said the same in different words. Let's imagine that we have some rules - patters and you just check if your code/text waht ever match to this parterns or no. Like in childhood putting sqare to square hole. Sounds similar? Did you ever use regular expresions? I wrote one of my articles about them [Regular expresions what can gos wrong?](). Regular expresions are one of example of pattern matchng. Ok, when we know more less what patteren matching is let's strat from simle example.

```elixir
iex> x = 4
4
```

Wait a moment it is just assignment. Well, not exactly. Not in Elixir. In Elixir `=` is the match operator. So we check if left hand side can match to right hand side. This is why we can do:

```elixir
iex> 4 = x
4
```

This is valid expression. It is matched from both sides to 4. We cannot do something like that in Ruby.

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

On the other hand when we go back to Elixir and we check `5 = x` we will see:

```elixir
iex> 5 = x
** (MatchError) no match of right hand side value: 4
```

Right now comparision between left and right hand side faild. We get information about `no match`. Similar situation will be when we will try with unknown yet variable like `y`.

```elixir
iex> 5 = y
** (CompileError) iex:6: undefined function y/0
```

Elixir doesn't know variable `y` so it's trying to find function with zero aruments. This expresion also faild. To fulfill this expression we can do:

```elixir
iex> y = x + 1
5
iex> 5 = y
5
iex> 5 = x + 1
5
```

It is woth to mention one more thing here. Each time you will do comparision like `x = 3` you will _overrides_ `x` value. If you want to match against the current value of a variable use the `^` operator:

```elixir
iex> ^x = 4
4
iex> ^x = 5
** (MatchError) no match of right hand side value: 5
```

If you want to just chcek if `x` has specific value use `==` like in Ruby.

```elixir
iex> x == 5
false
iex> x == 4
true
```

### Tuples

Let's do next step on more complex elements:

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

We can have on left hand side not only variables but also values. So in this case when on left side we don't have 2, we get error. We didn't match to pattern. The same situation is for size of tuple. If side is different between sides, we also get error.

### Lists

Now time for list. We can do similar things like for tuple.

```elixir
iex> [a, b] = [4, 5]
[4, 5]
iex> a
4
iex> b
5
```

We can do even more. We can take out first element in list and decrease output list by 1 element.

```elixir
iex> [head | tail] = [4, 5, 6]
[4, 5, 6]
iex)> head
4
iex> tail
[5, 6]
```

As you see, `head` is first element of our list, but `tail` is still list minus one element. You can play with this:

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

Similar like for tuple, if we have not enough element in list we will get error:

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

Using this approuch we can add element on top/beginning of a list:

```elixir
iex> list = [4, 5, 6]
[4, 5, 6]
iex> [3 | list]
[3, 4, 5, 6]
```

Next thing was for me very interstion. Because `'hello'` is char list so we can do similar things to this _text_. Just remember we will get integer representation of each char.

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

We use patter matching in Elixir also in `case`:

```elixir
iex> case {4, 5, 6} do
...> {4, 5} -> "One"
...> {4, 5, x} -> "Two #{x}"
...> _ -> "Three"
...> end
"Two 6"
```

We match to first exuastion from a top. This is `{4, 5, x}` and we get assingment for free. If we don't have second pattern we will match to last one. Any input data will match to `_`. We can also add extra condition as guards:

```elixir
iex> case {4, 5, 6} do
...> {4, 5, x} when x > 6 -> "One"
...> {4, 5, x} when x <= 6 -> "Two #{x}"
...> _ -> "Three"
...> end
"Two 6"
```

Remember not all errors in guards will be discover. Some of them will not show error but will just fail the guards.

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

Finnaly we came to functions, where all the beauty of patter matching will show. Starting from anonymous functions:

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

We can handle many different cases in a clear way. I know this example is not a life example and we don't cover all edge cases like `sum.(0, 1)`. When we look closly we can probably simplyfy it even more. But this is not topic of this atricle. Take a look on next example with named function:

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

We can declare function with different arity. We can also use different types. We see all case explicite. I can try to do this in Ruby using default values and checking conditions, but it will not be so readable like declaryng each version of function completly separate. On the end I would like to stop for a moment on recursion:

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

Of course we can do the same with `reduce` in Elixir, but look on this example only from recursion perspective. We just declare twice the same function: one with _braking contition_ and one with _iteration_. Clearly we see what is going on here. For this simle example loop will be still readable, but think about this from the potential perspective. I like this apporuch very much.

That's it for today. I hope you had fun with Elixir the same as I had. I hope to see you soon, in my next article. Thank you for ready. Bye!
