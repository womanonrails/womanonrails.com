---
layout: post
title: Why I do not use instance variables in my Ruby classes anymore?
description: Short tip how fast eliminate misspell in your code.
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
comments: true
lang: en
---

You can create a new class in many ways. From one point of view, this is awesome. You can be creative and adjust your code to your needs. On the other hand, it is hard to choose the best option. It can be even overwhelming, especially when you just started learning programming. That's why I would like to show you some quick tips, how to improve your classes on a very basic level.

The title of this article can be a little bit tricky. If you want to use class which have its own state, you need to use instance variables. You cannot eliminate them completely from your Ruby code and this is not goal of this article. I would like to show you a quick tip, how to decrease the number of instance variable occurrences and why. And also some other small improvements.

When I create a class in Ruby, I always keep in mind to show as less as possible to the outside world. This is always good practice, to keep your secrets in a vault. No one can use them against you in this situation. I go here, even deeper. Also inside the class, I try to give minimal information.

Let's start with a simple example:

```ruby
class Wheel
  attr_accessor :radius

  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @radius
  end
end
```

We have a simple class, which take care of wheel perimeter, but besides that, we also allow external world to ask and **change** internal radius value. This is asking for a trouble. After some time we can see code like this somewhere in the app:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bdda946a0 @radius=5>

wheel.perimeter
 => 31.41592653589793

wheel.radius = 2
wheel.perimeter
 => 12.566370614359172
```

This is like giving access to our wallet to strangers. We allow to take out our money even without asking for permission. It's not good. Let's change that.

```ruby
class Wheel
  attr_reader :radius

  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @radius
  end
end
```

It's better, but still we give access to information, how much we have in our wallet. We don't allow to take money out, but we give an **information** about them. This can finish like this:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bdda72ff0 @radius=5>
diagonal = wheel.radius * 2
 => 10
```

You probably see nothing wrong with that. Maybe in some cases it is not so bad. I would like to focus on one thing. The logic related to our wheel is now spread between different places in the code. Sometimes we don't need to give access to `radius` information. We can do some logic inside the class and show only result of calculations. The best solution is always to give minimal access to our privacy. **Do not prepare method just in case!** Let's change that in our class.

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @radius
  end

  def diagonal
    2 * @radius
  end
end
```

Right now we can use our `Wheel` class to get information about the diagonal, but we cannot calculate it outside of our class.

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bddb31f68 @radius=5>
diagonal = wheel.diagonal
 => 10
diagonal = wheel.radius * 2
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):15
NoMethodError (undefined method `radius' for #<Wheel:0x000055a962b0c780 @radius=5>)
```

OK, now it's the time to take care of the main question in this article. _Why I do not use instance variables in my classes?_ As you probably know from previous articles, I do lots of mistakes. I exchange letters all the time. Misspells that's my specialty. ;] Often, when I create some class, even I have tests, I get an error message, that no makes sense in that particular context. Maybe you have the same. Take a look at the class below:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @raidus
  end

  def diagonal
    2 * @radius
  end
end
```

Do you see the problem? If so, congratulation! For me this is something hard to find. Of course, I know myself, so I used to this kind of mistakes. I know how handle them fast, but still they are annoying. The error message in this situation can look like this:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x000055a962b79628 @radius=5>

wheel.perimeter
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):69
        2: from (irb):61:in `perimeter'
        1: from (irb):61:in `*'
TypeError (nil can't be coerced into Float)
```

The most important information is `nil can't be coerced into Float`, but based on this information it is hard to know, where is this `nil` comes from. Maybe not in this example, where we have only one instance variable `@raidus`. You can imagine situation, you have here more complex calculation. Then you need to check all your instance variables in specific line and find the `nil` one. The situation can be even worst to track. You can even don't have error message at all. For example Ruby can cast the `nil` value into a string. You will not get any error, but code will not work in the correct way. The tests are very handy in this situation. Check this:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  # ...

  def to_s
    "Wheel information: radius = #{@raidus}"
  end
end
```

When we run our class, there will be no error, but wrong text:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bdd850fb0 @radius=5>

wheel.to_s
 => "Wheel information: radius = "
```

This is the main reason why **I use a private method instead of instance variables.**

Check example here:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * raidus
  end

  def diagonal
    2 * radius
  end

  def to_s
    "Wheel information: radius = #{raidus}"
  end

  private

  attr_reader :radius
end
```

I only added private getter for our `@radius` instance variable. This is how the error will look like now:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bddafea50 @radius=5>

wheel.perimeter
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):89
        1: from (irb):76:in `perimeter'
NameError (undefined local variable or method `raidus' for #<Wheel:0x0000559bddafea50 @radius=5>)
Did you mean?  radius
               @radius
```

This is also working the same way for strings:

```ruby
wheel.to_s
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):137
        1: from (irb):129:in `to_s'
NameError (undefined local variable or method `raidus' for #<Wheel:0x0000559bddaf30b0 @radius=5>)
Did you mean?  radius
               @radius
```

The error message which we see now is much more clear. Ruby is even helping us and shows, that we can use `radius` method or `@radius` instance variable instead of our misspell `raidus`.

I see here one more advantage. When I create private getter and only getter it is for me easier to stick with immutable attribute in the class. If I have `@radius` it is much easier to do something like `@radius = 2` in code.

I know that this solution is not ideal, because when you will have a local variable with the same name, like method name, we will not have this nice error message like above. But I think it is still worth to try.

## Summarize

When I create my classes I try to stick to those rules (and not only them):

- **Show minimal information** about class logic of the external world - give access to results, but not for logic
- Use **private method** instead of **instance variables** - give clearer error messages
- Use functional programming paradigm (if possible) - to not mutate state of your class
- Use **open/closed principle** - Class (not only class) should be **open for extension, but closed for modification**
- Use **single responsibility principle** - I didn't mention about those 2 rules here (open/close and single responsibility), but they are very useful. I talked a lot more about them during my article about <a href="{{ site.baseurl }}refactoring-part2" title="Ruby refactoring - step by step">refactoring in Ruby</a>. They are shown by example.

If you what to know more about a **good patterns in Ruby** (and not only) check out those books:

- {% include books/en/design_patterns_in_ruby-russ_olsen.html %}
- {% include books/en/test_driven_development-ken_beck.html %}
- {% include books/en/practical_object_oriented_design_in_ruby-sandi_metz.html %}
- {% include books/en/pragmatic_programmer-andrew_hund_david_thomas.html %}
