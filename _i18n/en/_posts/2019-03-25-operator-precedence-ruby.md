---
layout: post
title: Operator precedence in Ruby
description: What do you need to know about order of mathematical operations and not only about them?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
comments: true
---

Order of math operations is very important in programming language. If you don't know it well, you can get completely different results, than you expect. And your code can be just wrong. You need to know the rules. Is the order similar like in math? Or maybe the algebraic expression is interpreted from left to right? Do you know how does this look like in Ruby? Let's check it.

```ruby
2 + 2 * 2
 => 6
```

This is not 8. It is 6. You can see here that multiplication is _stronger_ then addition. In this case we will say that multiplication has **higher operator precedence** then addition. This is exactly the same like we have learned at school on Math classes. To show you this more precisely, we have:

```ruby
2 + (2 * 2)
 => 6

(2 + 2) * 2
 => 8
```

OK, but how will I know that? There are many different operators. Well, you need to remember the table of operators order, from <a href="https://ruby-doc.org/core-2.2.0/doc/syntax/precedence_rdoc.html" title="Ruby documentation - operators precedence" target="_blank" rel="nofollow noopener noreferrer">Ruby docs</a>:

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

As you can see here `*` is higher than `+`, so it has **higher precedence**.

## Examples

### Boolean operators

Let's start with something simple. Precedence hierarchy for boolean operators.

```ruby
1 || 2 && nil
 => 1

1 or 2 and nil
 => nil
```

On the first look, logic is the same, but we get different results. But when you take a look closely, you will see the difference. Order of calculations. In the first example, the order looks like `(1 || (2 && nil))`. We get `nil` from `2 && nil`. And then we have `1 || nil` so this is `1`. Well, I lied a little bit here. Our interpreter is smarter, than you can think of. Because we have this `||` operator. It has been truthy always when left hand side is truthy, so it checks only the first part of our expression. Check here:

```ruby
a = 0
 => 0

a = 1 || a = 2
 => 1

a
 => 1
```

In the beginning, we assigned `0` to `a`. Then we check condition together with assignments. If we check also right hand side, we should get `2` assigned to `a` variable. But we get `1`. We get `2` only, when the left hand side is falsy. For example:

```ruby
a = false || a = 2
 => 2

a
 => 2
```

In the second example `1 or 2 and nil` order of operations is completely opposite: `((1 or 2) and nil)`. First,  we check `1 or 2`. We get `1` and then we check `1 and nil`, so the final result is `nil`.

To understand better the differences between these two notations, let's check all possibilities here in table:

<table class='table'>
  <thead>
    <tr>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>a || b && c</th>
      <th>a or b and c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><strong><code>true</code></strong></td>
      <td><strong><code>false</code></strong></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><strong><code>true</code></strong></td>
      <td><strong><code>false</code></strong></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
  </tbody>
</table>

There are 2 cases, where you see the difference between operators `||` and `&&` and operators `or` and `and`.

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

Both of this logic expressions give us `2` as truthy result. But there is one difference here. In first case `foo` equals to `2` and in second example `foo` is `1`. This is related, of course, with operator precedence. Because `&&` has higher precedence than `=` in the first example we have:

```ruby
foo = (1 && 2)
```

In second example,  order of those operations is different. `=` has higher precedence, then `and` so we have:

```ruby
(foo = 1) and 2
```

Similar behavior we will see for `||` and `or` operators. This will be visible only, when the first part of the expression will be `false` or _falsy_ value. For truthy value, we will see no difference. Both expressions will behave the same:

```ruby
# first part of condition is falsy
foo = false || 2
 => 2
foo
 => 2

foo = false or 2
 => 2
foo
 => false

# first part of condition is truthy
foo = 1 || 2
 => 1
foo
 => 1

foo = 1 or 2
 => 1
foo
 => 1
```

I would like to explain, why we don't see any difference. For `foo = 1 || 2` we should set brackets like this `foo = (1 || 2)`. From logical condition `||`, we get `1` and we assign it to go`. In a second example `foo = 1 or 2`, first, we do the assignment and then we check the condition. The result is the same, but order of those operations is different. This is worth to be remembered!

In the end of this section, I would like to show you one more example. I think, it is a very interesting one. It is more complex because it uses  `=`, `&&`, `and` and `<<`.

```ruby
s = '2'

s = '1' && s << '3'
 => "23"

s = '2'

s = '1' and s << '3'
 => "13"
```

Let's go step by step to understand, what is going on in here. In the first example we have `&&`. We know that, it has quite high precedence, but predecence for `<<` is higher, than `&&`. So the order of calculations here looks like: `s = ('1' && (s << '3'))`. First, we concat `'3'` to string. We get `s = ('1' && '23')`. Now we do `&&`, so the result is `'23'`.

In the second example we have order like `(s = '1') and (s << '3')`. We start from assignments. So `s` is now `'1'` not `'2'`. Then we calculate right hand side part and we get `'1' and '13'`, so the final result is `'13'`.

### Methods & boolean operators

We still are in an area of boolean operators. This example will show you, how they behave with method calls without specifying brackets. As you know, in Ruby, you can omit brackets in some cases. But when you work with boolean at the same time, you need to be careful.

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

In this example, first operator `||` will be called. We will get `'a'` from it. This is why we see `"My char id a"` text. But because the method is displaying only the test and it doesn't return anything, we see `nil` value in the end. This is important, that our method always return `nil`. You will see why in the next examples. Order of operations was: `method('a' || 'b')`.

Let's go to the next example:

```ruby
# example 2
method 'a' && 'b'
My char id b
 => nil
```

In the second example, the order is the same `method('a' && 'b')`. First, we do `&&` operation and we get `'b'` from it. Then we call our method. So this is why `'b'` is in our text.

```ruby
# example 3
method 'a' or 'b'
My char id a
 => "b"
```

In the example 3 you can notice a different behavior. As we already know, the order will be `method('a') or 'b'`. This is why we see `'a'` in text, but then we need to finish this logical expression. Because our method return `nil` and this is _falsy_ value, we have `nil or 'b'`. In the end, we see `'b'` is returned, not from the method, but from all expression.

```ruby
# example 4
method 'a' and 'b'
My char id a
 => nil
```

For example number 4, the order of operation is the same like for example 3. We have `method('a') and 'b'`. Text is `"My char id a"` because of a `'a'` argument in the method. Then function return `nil`, so we have `nil and 'b'`. This is why we see one more time `nil` in the end.

OK, and now we will still stay in method calls context, but with different example. We declare two methods, one with no arguments and one with an argument.

```ruby
def method1
  puts 'Call Method 1'
end

def method2(text)
  puts "Call Method 2 with #{text}"
end
```

Now we check, what will happen to `or` and `||` conditions.

```ruby
method1 or method2 'foo'
Call Method 1
Call Method 2 with foo
 => nil
```

First example looks OK. We call `method1`, which display `"Call Method 1"` text and return `nil` (as we know from example above). Then, we call `method2` with one argument `'foo'`. We display text and return `nil`. Order of operations: `method1() or method2('foo')`. Everything is fine. Let's look at the second example.

```ruby
method1 || method2 'foo'
Traceback (most recent call last):
        1: from /home/agnieszka/.rvm/rubies/ruby-2.5.3/bin/irb:11:in `<main>'
SyntaxError ((irb):32: syntax error, unexpected tSTRING_BEG, expecting keyword_do or '{' or '(')
method1 || method2 'foo'
                   ^
```

Something went wrong. We got an error. This is because of precedence. Order of operations in this case is: `(method1 || method2) 'foo'`. We can show it in a more descriptive way `(method1() || method2()) 'foo'`. Our interpreter doesn't know what to do because of two reasons. One, `method2` should have one argument and it didn't get any. And the second one, more important, which we see in the error message. Interpreter see some _free_ text `'foo'` without any operator in the same line with calling methods. To fix that, we need to say explicitly, what we want: `method1 || method2('foo')`

The same problem you will get when instead of `method2` you will use `raise` or `return` or any other method. If you like, just play a little bit with them.

### Blocks

Time for blocks. We need to be aware that **blocks with `{}` have higher precedence than blocks `do ... end`**. This is not exactly specified in our order table, but in the documentation, you can find a small note about it. So, let's check this out. We will prepare two methods with blocks. In one we will call the block with `{}` and in the second with `do ... end`.

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

In the example one, the order is like here: `foo(a: (bar { 1 }))`. First, we will call `bar` method with a block. It will return `nil` and then we will call method `foo` with only hash parameter. It will look like this: `foo(a: nil)`. So, this is why we don't get a block in method `foo`.

In second example the order is different: `foo(a: bar) do 1 end`. It will be even better, to split it into separate lines.

```ruby
foo(a: bar) do
  1
end
```

At first, we call method `bar`, but without any arguments and without a block. This is why we see this in the text: `"Bar has block: false"`. Then we call method `foo` with hash `{ a: nil }` as `options` and with block. We could even omit this hash parameter in the call of these two methods. It would be working the same. At least for displaying text on a screen. You can try to do that your own `foo bar { 1 }` and `foo bar do 1 end`.

### Other examples

```ruby
array = []
a = 1
b = 2
array << a + b
 => [3]
```

This example behaves like we expect. First, we sum `a` and `b` and then we put value in the array. If you check in our precedence table `+` has higher precedence than `<<`.

In next example also everything will be all right. `+=` and `*=` has lower precedence than `+` and `*`. So you can omit brackets:

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

Now precedence related to ranges. Because `+` and `-` has higher precedence than range, you can omit brackets here and everything will be fine:

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

- Be aware of operators precedence in Ruby.
- If you are not sure about precedence, put the right brackets or even better: check in the documentation.Also do the tests ;]
- Sometimes, even if I know precedences in Ruby, I like to leave brackets. It is more readable for me. Like here: `method('a' && 'b')`. I know that this notation `method 'a' && 'b'` is correct and do exactly, what I want, but I like to be more specific here. This is more **"Tell, don't ask"** approach.

That's it. If you have any other precedence examples, which were not mentioned here, feel free to share them in the comments. Thank you for reading and see you next time!
