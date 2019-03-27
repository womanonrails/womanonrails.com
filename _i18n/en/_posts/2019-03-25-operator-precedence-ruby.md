---
layout: post
title: Operator precedence in Ruby
description: What you need to know about mathematical operations and not only them?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
comments: true
---

Order of math operations is very important in programming language. If you don't know them well then you can get completly different results then you expect. And you code can be just wrong. You need to know if rules are similar like in math or equastion is interpreted from left to right. Do you know how this looks like in Ruby? Let's check it.

```ruby
2 + 2 * 2
 => 6
```

This is not 8. It is 6. You can see here that multiplication is _stronger_ then addition. In this case we will say that multiplication has **higher operator precedence** then addition. This is exactly the same situation like we learned on Math in school. To show you this more precaisly we have:

```ruby
2 + (2 * 2)
 => 6

(2 + 2) * 2
 => 8
```

OK, but how I will know that? There is lot of different opperators. Well, you need to remember this table of operators order, from [Ruby docs](https://ruby-doc.org/core-2.2.0/doc/syntax/precedence_rdoc.html):

```ruby
!, ~, unary +
**
unary -
*, /, %
+, -
<<, >>
&
|, ^
>, >=, <, <=
<=>, ==, ===, !=, =~, !~
&&
||
.., ...
?, :
modifier-rescue
=, +=, -=, etc.
defined?
not
or, and
modifier-if, modifier-unless, modifier-while, modifier-until
{ } blocks
```

As you can see here `*` is higher then `+` so it has higher precedence.

## Examples

### Boolean operators

Let's start form something simple. Precedence hrirarhy for boolean operators.

```ruby
1 || 2 && nil
 => 1

1 or 2 and nil
 => nil
```

At the first look logic is the same but we get different results. But when you take a look closly you will see the difference. Order of calculations. In first example order looks like `(1 || (2 && nil))`. We get `nil` from `2 && nil`. And then we have `1 || nil` so this is `1`. I lied a litte bit here. Our interpreter is smarter then you see it in this conclustion. Because we have this `||` operator. It is trueth always when left hand side is truth, so it only check first part of our equation. Check here:

```ruby
a = 0
 => 0

a = 1 || a = 2
 => 1

a
 => 1
```

On the beginning I assign `0` to `a`. Then I check condition together with assigments. If we check also right hand side, we should get `2` assigned to `a` varialbe. But we get `1`. We will get `2` only when left had side will be falsye. For example:

```ruby
a = false || a = 2
 => 2
a
 => 2
```

In the second example order is completly opposite: `((1 or 2) and nil)`. At first we check `1 or 2`. We get `1` and then we check `1 and nil` so finnal result is `nil`.

To better understand differences between this to notations let's check all possibilities here:

<table class='table refactoring-step-by-step'>
  <thead>
    <tr>
      <th>`a`</th>
      <th>`b`</th>
      <th>`c`</th>
      <th>`a || b && c`</th>
      <th>`a or b and c`</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>`false`</td>
      <td>`false`</td>
      <td>`false`</td>
      <td>`false`</td>
      <td>`false`</td>
    </tr>
    <tr>
      <td>`false`</td>
      <td>`false`</td>
      <td>`true`</td>
      <td>`false`</td>
      <td>`false`</td>
    </tr>
    <tr>
      <td>`false`</td>
      <td>`true`</td>
      <td>`false`</td>
      <td>`false`</td>
      <td>`false`</td>
    </tr>
    <tr>
      <td>`true`</td>
      <td>`false`</td>
      <td>`false`</td>
      <td class='red'>`true`</td>
      <td class='red'>`false`</td>
    </tr>
    <tr>
      <td>`true`</td>
      <td>`true`</td>
      <td>`false`</td>
      <td class='red'>`true`</td>
      <td class='red'>`false`</td>
    </tr>
    <tr>
      <td>`true`</td>
      <td>`false`</td>
      <td>`true`</td>
      <td>`true`</td>
      <td>`true`</td>
    </tr>
    <tr>
      <td>`false`</td>
      <td>`true`</td>
      <td>`true`</td>
      <td>`true`</td>
      <td>`true`</td>
    </tr>
    <tr>
      <td>`true`</td>
      <td>`true`</td>
      <td>`true`</td>
      <td>`true`</td>
      <td>`true`</td>
    </tr>
  </tbody>
</table>

As you see in this table there are 2 cases where we see difference between otherators `||` and `&&` and operators `or` and `and`.


### Assigments

This example is related with boolean operators, but also with assignment:

```ruby
foo = 1 && 2
 => 2

foo
 => 2

foo = 1 and 2
 => 2

foo
 => 1
```

Both of this logic operations geve us `2` as truthy result. But there is one difference here. In first case `foo` equal to `2` and in secound example `foo` is `1`. This is related of course with precedence. Becasue `&&` has heiger precedence then `=` in first example we have:

```ruby
foo = (1 && 2)
```

In second example order of this operations is different. `=` has higher precedence then `and` so we have:

```ruby
(foo = 1) and 2
```

Similar behavior we will see for `||` and `or`. This will be visible only when first part of this condition will be `false` or _falsey_. For truthy value of first part, we will see no difference. They will behave the same:

```ruby
# first part of condition is falsey
foo = false || 2
 => 2
foo
 => 2

foo = false or 2
 => 2
foo
 => false

# first part of condition id truthy
foo = 1 || 2
 => 1
foo
 => 1

foo = 1 or 2
 => 1
foo
 => 1
```

I would like to exaplin why this happend. For `foo = 1 || 2` we should set bracket like this `foo = (1 || 2)`. From this `||` logical condition we get `1` and we assign it to `foo`. In second example `foo = 1 or 2` first we do assignment and then we check this conticion. Result is the same but order of this operation is different. This is worth to remember!

In this end of this section I would like to show you one more example. I thisk it is very interestion one. It is more complex becase it use `=`, `&&`, `and` and `<<`.

```ruby
s = '2'

s = '1' && s << '3'
 => "23"

s = '2'

s = '1' and s << '3'
 => "13"
```

Let's go step by step to undersand what is going on here. In first example we have `&&`. We know that it has quite high precedence, but predecence for `<<` is higer then `&&`. So the order of calculations here looks like: `s = ('1' && (s << '3'))`. First we concat `'3'` to string. We get `s = ('1' && '23')`. Now we do `&&`, so the result is `'23'`.

In the second example we have `(s = '1') and (s << '3')`. We start form assigments. So `s` is now `'1'` not `'2'`. Then because this is `and` we calculate right hand side part and we get `'1' and '13'` so the finall result is `'13'`.

### Methods & boolean operators

We still are in area of boolean operators. This example will show you how they behave with method calls without sepyfy bracket. As you know in Ruby you can omit braketes in some cases. But when you work with boolean at the same time, you need to be carefull.

We declare our method and first example of usage:

```ruby
# declare method
def method(char)
  puts "My char id #{char}"
end

# example 1
method 'a' || 'b'
My char id a
 => nil
```

In this example first `||` will be called we will get `a` from that. This is why we see `"My char id a"` text. but becase function is dispaying only this test and don't return anything we see `nil` value ant the end. This is important that our method always retyrn `nil` we will see why in next examples. Order of operations were: `method('a' || 'b')`.


```ruby
# example 2
method 'a' && 'b'
My char id b
 => nil
```

In secound example order is the same `method('a' && 'b')`. First we do `&&` operation and we get `'b'` from it. Then we call our method. So this is why `b` is in our text.


```ruby
# example 3
method 'a' or 'b'
My char id a
 => "b"
```

In example 3 you can notice different behavior. As we already know order will be `method('a') or 'b'`. This is why we see `a` in text but then we need to finish this logical operation. Becasue our method return `nil` and this is _falsey_ value we have `nil or 'b'` and in the end we see `b` is returned not from method but from all equastion.


```ruby
# example 4
method 'a' and 'b'
My char id a
 => nil

For example numer 4 order of operation is the same like for example 3. We have `method('a') and 'b'`. Text is `"My char id a"` because of `a` artument in method. Then function return `nil` so we have `nil and 'b'`. This is why we see one more time `nil` in the end.

OK, and now we will still stay in method calls context but with different example. We declare two methods one with no aruments and one with argument.

```ruby
def method1
  puts 'Method 1 call'
end

def method2(text)
  puts "Method 2 call with #{text}"
end
```

Now we will check what will happend with `or` and `||` condition.

```ruby
method1 or method2 'foo'
Method 1 call
Method 2 call with foo
 => nil
```

First example looks OK. We call `method1` which display `"Method 1 call"` text and return `nil` (as we know from example above). Then we call `method2` with one artument `'foo'`. We display text and return `nil`. Order of operations: `method1() or method2('foo')`. Everything is fine. OK, let's look to second example.

```ruby
method1 || method2 'foo'
Traceback (most recent call last):
        1: from /home/agnieszka/.rvm/rubies/ruby-2.5.3/bin/irb:11:in `<main>'
SyntaxError ((irb):32: syntax error, unexpected tSTRING_BEG, expecting keyword_do or '{' or '(')
method1 || method2 'foo'
                   ^
```

Somethng went wrong. We got error. This is because of precedence. Order in this case is: `(method1 || method2) 'foo'`. We can show it in more descriptive way `(method1() || method2()) 'foo'`. Our interpreter don't now what to do becasue of two reasons. One `method2` should have one argument and don't get any. And second, more important which we see in error message that interpreter see some free text `'foo'` without any operator in one line with calling methods. To fix that we need to say explitice what we want: `method1 || method2('foo')`

The same problem you will get when instead of `method2` you will use `raise` or `return` or any other method. This are very specific cases which you can use. If you like, just play a little bit with them.


### Blocks

Time for bloks. We need to be aware that blocks with `{}` have higer precedence then blocks `do ... end`. This is not exaclty specyfy in our order table, but in documentation you can find small note about it. So let's check this out. We will prepare two methods with blocks. In one we will call block with `{}` and in second with `do ... end`

```ruby
def foo(options = {}, &block)
  puts "Foo has block: #{block_given?}"
end

def bar(options = {}, &block)
  puts "Bar has block: #{block_given?}"
end

foo a: bar { 1 }
Bar has block: true
Foo has block: false
 => nil

foo a: bar do 1 end
Bar has block: false
Foo has block: true
 => nil
```

In example one order is like here: `foo(a: (bar { 1 }))`. First we will call `bar` method with block. It will return `nil` and then we will call method `foo` with only hash parameter. It will looks like this: `foo(a: nil)`. So this is why we don't get a block in method `foo`.

In second example order is different: `foo(a: bar) do 1 end`. It will be even better to split it to separate lines. We could even omit this hash parameter in the call of this two methods and it will be woring the same. At least for displaying text on a screen. You can try do thet you own `foo bar { 1 }` and `foo bar do 1 end`.

```ruby
foo(a: bar) do
  1
end
```

At first we call method `bar` but without any argument and without block. This is what we see in text: `"Bar has block: false". Then we call method `foo` with hash `{ a: nil }` as `options` and with block.

### Others examples

```ruby
array = []
a = 1
b = 2
array << a + b
 => [3]
```

This example bahaves like we expect. Frist we sum `a` and `b` and then we put value to array. If you check in our table `+` has higher precedence then `<<`.

In next example also everything will be all right. `+=` and `*=` has lower precedence then `+` and `*`. So you can ommit brackets.

```ruby
a = 1
b = 2
sum = 0
multi = 1

sum += a + b
 => 3
sum
 => 3

multi *= a * b
 => 2
multi
 => 2
```

Now presedences related with reanges. Because `+` and `-` has heiger precedence then range you can omit bracket here and everything will be fine:

```ruby
n = 9
 => 9

1..n - 1
 => 1..8

(1..n - 1).to_a
 => [1, 2, 3, 4, 5, 6, 7, 8]
```

This is like doing `1..(n - 1)`.

## Summary

- Be aware of operator precedence in Ruby.
- If you are not sure about precedence put the right bracket or even better check in documentation. Do tests also ;]
- Sometimes even I know precedences in Ruby I like to live brackets, it is more readable for my. Like here: `method('a' && 'b')`. I know that this notation `method 'a' && 'b'` is correct and do exactly what I want but I like to be more specitic here . So, this is more "Tell don't ask" approch.

That's it. If you have any other precednece examples which were not metion here, feel free to share them in the comments. Thank you for reading and see you next time!

