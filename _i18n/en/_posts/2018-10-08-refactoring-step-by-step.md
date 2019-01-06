---
layout: post
title: Ruby Refactoring step by step - part 1
description: How refactor your code? <br> From procedural to more object related code.
headline: Premature optimization is the root of all evil.
categories: [refactoring]
tags: [Ruby]
comments: true
---

It was a long break from the last technical article. During that time I was trying many different things. You can look here: <a href="https://bemore.womanonrails.com/" title="Be more - Life style blog" target="_blank">Be More - my lifestyle blog in Polish</a>, <a href="https://www.youtube.com/channel/UCudKRFuddrf8saaxUEoo0xQ" title="Woman on Rails YouTube channel" target="_blank" rel="nofollow noopener noreferrer">Woman on Rails YouTube channel</a> and my <a href="https://vimeo.com/womanonrails" title="Woman on Rails - Vimeo channel" target="_blank" rel="nonofollow noopener noreferrer">travel Vimeo channel</a>. It was a great time to discover what I like to do and what not. But back to the topic. I prepared this article for a long time. I can say even too long. I started in 2015 and now you will see the results. Let's get started.

Refactoring is one of my favorite topics. I love to clean up things in real life and also in code. I've worked and I'm still working on web application projects. And I look for answers on how to write good code. What are the reasons that after some time our code is messy and not readable? So day by day I learn how to refactor code in a good way based on my experience and the experience of others. Today I would like to share an example of refactoring with you.

I got a code which was written by a person on internship long time ago in <a href="https://fractalsoft.org/" title="Fractal Soft - Ruby on Rails web applications" target="_blank">my company</a>. The plan was to improve this code. It was mostly one class which you can see  <a href="https://github.com/womanonrails/poker/blob/55c9ae0ab921f7aa95bb7e47676d87b970a32033/lib/poker/hand.rb" title="Code before refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>. In this one class you have all rules in poker to check a hand only for cards without jokers. That code is not bad. When you know business logic (in this case poker rules), you will be able to move around this code. This code has also tests. So, this is good news. It will be easier to change something if tests cover all logic. If they don't, we can break functionality, when we won't be careful. The code looks more procedural than object oriented and it has some duplications. Sometimes this will be enough. When this is written once and you will not need to change this code for long time **maybe** you don't need to clean it up. But if the requirements can/will change, probably your code does too. You need to decide if it is better to refactor it now or later. (I prefer refactoring now, when I still remember logic and code, then later when I need to understand it one more time.) I would like to show you how I do refactoring base on this example.

# Step 1 - Preparing environment to work

I updated gems which were in the project and I installed gems like Rubocop or Reek to help myself start refactoring. Those tools are helpful to see where problem in code can be. To do this, first do the overview. But those are only tools, sometimes they are right and sometimes are not. And it is easy to cheat them. But this is another topic.

## Stats (based on metrics):
- **LOC** (Line of code) - 194
- **LOT** (Line of tests) - 168
- **Flog** - 112.8
- **Flay** - 123
- **Tests** - 12 examples, 0 failures

# Step 2 - Start first clean ups

Base on tests without going deep into logic, I made some improvements in the code. I removed some condition and simplified this code.

Code before change:

```ruby
def straight_flush?(array)
  if straight?(array) and flush?(array)
    return true
  else
    return false
  end
end
```

Code after change:

```ruby
def straight_flush?(array)
  straight?(array) && flush?(array)
end
```

All the code you can find <a href="https://github.com/womanonrails/poker/blob/148429e4591638aef38b5b7abaab5e0198d805c0/lib/poker/hand.rb" title="Code after 2nd step of refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>. This change, in my opinion, improves readability a little bit.

After that all tests passed.

# Step 3 - Understand the logic and try to simplify it

Now when code is more readable, I can start changing the logic to simplify it. I have tests, so each of my changes relies on tests. I took the first method. I removed it (remove all content inside). And start from the beginning. This is what I got.

Code before change:

```ruby
def one_pair?(array)
  tmp = array.clone
  tmp.collect!{|x| x / 4 }

#  (0..8).each do |elem|
#    tmp.delete(elem)
#  end

  helper_array = [0] * 13

  tmp.each do |elem|
    helper_array[elem] += 1
  end

  helper_array.delete(0)

  helper_array.include?(2)
end
```

Code after:

```ruby
def one_pair?(array)
  hash = Hash.new(0)
  array.each { |item| hash[item / 4] += 1 }
  hash.values.include?(2)
end
```

I repeat that approach over and over again for all methods.

1. Take method and remove content
2. Run the tests (some tests are failing), understand the logic
3. Write new code in a simpler way
4. Check the tests

After this step you can find the code <a href="https://github.com/womanonrails/poker/blob/a0bb2f6ab99bf8d977c1b68a53774b2eef7a46ac/lib/poker/hand.rb" title="Code after 3rd step of refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>. During that step I also removed commented code, Polish comments and I added some tests, which for me, were missing.

## Stats:
- **LOC**  - 73
- **LOT**  - 170
- **Flog** - 76.3
- **Flay** - 63
- **Tests** - 12 examples, 0 failures

# Step 4 - From procedural to more object oriented code

I don't know if you noticed this, but everywhere we put as argument `array`. And we have class, but we don't use initializer for this class. The second thing is that in many places we use something like `array.each {|item| hash [item / 4] += 1}` let's move this also for initializer and use class state instead of calculating this everywhere.

#### Quick explanation:
I think at this point I should explain a little bit how this code works. Each card has representation as a number from 0 to 51. So number 0-3 represents 2 with all colors, 4-7 represents 3 and so on. Like in this table:

<table class='table refactoring-step-by-step'>
  <tbody>
    <tr>
      <td>0 </td> <td>2&spades;</td>
      <td>4 </td> <td>3&spades;</td>
      <td>8 </td> <td>4&spades;</td>
      <td>12</td> <td>5&spades;</td>
      <td>16</td> <td>6&spades;</td>
      <td>20</td> <td>7&spades;</td>
      <td>24</td> <td>8&spades;</td>
    </tr>
    <tr>
      <td>1 </td> <td>2&clubs;</td>
      <td>5 </td> <td>3&clubs;</td>
      <td>9 </td> <td>4&clubs;</td>
      <td>13</td> <td>5&clubs;</td>
      <td>17</td> <td>6&clubs;</td>
      <td>21</td> <td>7&clubs;</td>
      <td>25</td> <td>8&clubs;</td>
    </tr>
    <tr class='red-text'>
      <td>2 </td> <td class='red'>2&hearts;</td>
      <td>6 </td> <td class='red'>3&hearts;</td>
      <td>10</td> <td class='red'>4&hearts;</td>
      <td>14</td> <td class='red'>5&hearts;</td>
      <td>18</td> <td class='red'>6&hearts;</td>
      <td>22</td> <td class='red'>7&hearts;</td>
      <td>26</td> <td class='red'>8&hearts;</td>
    </tr>
    <tr class='red-text'>
      <td>3 </td> <td class='red'>2&diams;</td>
      <td>7 </td> <td class='red'>3&diams;</td>
      <td>11</td> <td class='red'>4&diams;</td>
      <td>15</td> <td class='red'>5&diams;</td>
      <td>19</td> <td class='red'>6&diams;</td>
      <td>23</td> <td class='red'>7&diams;</td>
      <td>27</td> <td class='red'>8&diams;</td>
    </tr>
  </tbody>
</table>

<br>

<table class='table refactoring-step-by-step'>
  <tbody>
    <tr>
      <td>28</td> <td>9&spades;</td>
      <td>32</td> <td>10&spades;</td>
      <td>36</td> <td>J&spades;</td>
      <td>40</td> <td>D&spades;</td>
      <td>44</td> <td>K&spades;</td>
      <td>48</td> <td>A&spades;</td>
    </tr>
    <tr>
      <td>29</td> <td>9&clubs;</td>
      <td>33</td> <td>10&clubs;</td>
      <td>37</td> <td>J&clubs;</td>
      <td>41</td> <td>D&clubs;</td>
      <td>45</td> <td>K&clubs;</td>
      <td>49</td> <td>A&clubs;</td>
    </tr>
    <tr class='red-text'>
      <td>30</td> <td class='red'>9&hearts;</td>
      <td>34</td> <td class='red'>10&hearts;</td>
      <td>38</td> <td class='red'>J&hearts;</td>
      <td>42</td> <td class='red'>D&hearts;</td>
      <td>46</td> <td class='red'>K&hearts;</td>
      <td>50</td> <td class='red'>A&hearts;</td>
    </tr>
    <tr class='red-text'>
      <td>31</td> <td class='red'>9&diams;</td>
      <td>35</td> <td class='red'>10&diams;</td>
      <td>39</td> <td class='red'>J&diams;</td>
      <td>43</td> <td class='red'>D&diams;</td>
      <td>47</td> <td class='red'>K&diams;</td>
      <td>52</td> <td class='red'>A&diams;</td>
    </tr>
  </tbody>
</table>

So code like `array.map {|item| item / 4}` tells us which figure from 2 to ace is on card and code like this `array.map {|item| item % 4}` represents the color of a card (&spades;, &clubs;, &hearts;, &diams;).

For more explanation of poker rules, please check <a href="https://en.wikipedia.org/wiki/List_of_poker_hands" title="Poker hands" target="_blank" rel="nofollow noopener noreferrer">wiki page to list all of poker hands</a>.

We add an initializer:

```ruby
def initialize(array)
  @array = array.sort
  @cards = @array.map { |item| item / 4 }
end
```

Example of a method before change:

```ruby
def three_of_a_kind?(array)
  hash = Hash.new(0)
  array.each { |item| hash[item / 4] += 1 }
  hash.values.include?(3)
end
```

After:

```ruby
def three_of_a_kind?
  hash = Hash.new(0)
  @cards.each { |item| hash[item] += 1 }
  hash.values.include?(3)
end
```

We remove some of duplication and use state of the class instance to improve our code. After this step you can find the code <a href="https://github.com/womanonrails/poker/blob/83d230e969df4d27ffa5e5e34a2cf1aa43e76d90/lib/poker/hand.rb" title="Code after 4th step of refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>. Quick note - I also did small refactoring on tests. I just moved the test cases to the array to also remove duplication there.

## Stats:
- **LOC**  - 76
- **LOT**  - 190
- **Flog** - 70.9
- **Flay** - 57
- **Tests** - 104 examples, 0 failures

# Step 5 - Remove duplication

Base on Reek metric I noticed a lot of duplication in code. So I decided to move this code to one method and use the state of the class' instance one more time. You can find the whole step <a href="https://github.com/womanonrails/poker/blob/74c05d7480e7857d1e99d604169f6eed46279758/lib/poker/hand.rb" title="Code after 5th step of refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>. And this is a quick overview.

We change the initalizer:

```ruby
def initialize(array)
  @array = array.sort
  @cards = @array.map { |item| item / 4 }
  @frequency = cards_frequency
end
```

New method `cards_frequency`:

```ruby
def cards_frequency
  hash = Hash.new(0)
  @cards.each { |item| hash[item] += 1 }
  hash.values
end
```

Example of a method before change:

```ruby
def four_of_a_kind?
  hash = Hash.new(0)
  @cards.each { |item| hash[item] += 1 }
  hash.values.include?(4)
end
```

After:

```ruby
def four_of_a_kind?
  @frequency.include?(4)
end
```

## Stats:
- **LOC**  - 76
- **LOT**  - 190
- **Flog** - 61.0
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Step 6 - Small public interface

When you will look at the code from <a href="https://github.com/womanonrails/poker/blob/74c05d7480e7857d1e99d604169f6eed46279758/lib/poker/hand.rb" title="Code after 5th step of refactoring" target="_blank" rel="nofollow noopener noreferrer">step 5</a>, you will notice that all methods are public. **The big public interface is something hard to maintain.** If you will try to replace class `Hand` by other class you need to prepare class with the same big interface. If something is public you can use it everywhere, what also can provide new dependencies in the code. In this case, when you look closer, you will see that even tests are checking only the method `check`. I decided to declare all others method as private. This change is visible <a href="https://github.com/womanonrails/poker/blob/ef117a56e3cc0fbfae9de4821ac61e5489f704fc/lib/poker/hand.rb" title="Code after 6th step of refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>.

## Stats:
- **LOC**  - 77
- **LOT**  - 190
- **Flog** - 59.9
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Step 7 - More clean ups

This step is similar to step 5. I removed more duplication in code and decided to change names to be more specific. I created new method `cards_figures_and_colors` which prepare now two things: `figures` and `colors`. You can say now: _where is **Single responsibility principle** or that is **micro optimalization**_ because now I use only one loop instead 2. My intuition tells me that this is ok. But you can have a different opinion. That's fine for me. I respect that. This is how this method looks like:

```ruby
def cards_figures_and_colors
  @array.map { |item| [item / 4, item % 4] }.transpose
end
```

and I'm open to discuss if this was a good or bad step. This change affects also our `initialize` method:

```ruby
def initialize(array)
  @array = array.sort
  @figures, @colors = cards_figures_and_colors
  @frequency = cards_frequency.values
end
```

In this step I also did change in method `cards_frequency`. I used there `each_with_object` (you can find more about this method in my article <a href="https://womanonrails.com/each-with-object" title="Quick overview Ruby of each_with_object method">Quick overview - each\_with\_object method</a>) instead of `each` like this:

```ruby
def cards_frequency
  @figures.each_with_object(Hash.new(0)) do |item, hash|
    hash[item] += 1
  end
end
```

Thanks to `@colors` instance variable I can change `flush?` method from:

```ruby
def flush?
  color = @array.map { |item| item % 4 }
  color.uniq.size == 1
end
```

to:

```ruby
def flush?
  @colors.uniq.size == 1
end
```

You can see all the changes <a href="https://github.com/womanonrails/poker/blob/46e12428d0d67cb90d17f417147dc936815a69e7/lib/poker/hand.rb" title="Code after 7th step of refactoring" target="_blank" rel="nofollow noopener noreferrer">here</a>

## Stats:
- **LOC**  - 80
- **LOT**  - 190
- **Flog** - 64.5
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Summarize

Let's summarize what we've done till this point:

- We used metrics to do first cleanup in the code - to start
- We simplified the code using tests and our understanding of logic
- We changed procedural code and used for that more object oriented approach
- We removed duplications
- and we created a small public interface

In my next article I would like to go deeper with this refactoring and focus on:

- Code which is more descriptive
- Metaprograming as method to write more elastic code
- Preparing small independent classes, then one big class
- Building classes as elements which are replaceable and possible to combine
- Explanation why I used metrics on each step and what they tell us

Stay tuned! My next article will come soon! If you like this article share your thoughts with me in the comments below. Thank you so much for being here. And see you next time. Bye!

<hr>

### Bibliography

#### Books
- <a href="https://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672" title="Refactoring: Improving the Design of Existing Code" target="_blank" rel="nofollow noopener noreferrer">Refactoring: Improving the Design of Existing Code - Martin Fowler</a>
- <a href="https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882" title="Clean Code: A Handbook of Agile Software Craftsmanship" target="_blank" rel="nofollow noopener noreferrer">Clean Code: A Handbook of Agile Software Craftsmanship - Robert C. Martin</a>
- <a href="http://www.amazon.com/Design-Patterns-Ruby-Russ-Olsen/dp/0321490452" title="Design Patterns in Ruby" target="_blank" rel="nofollow noopener noreferrer">Design Patterns in Ruby - Russ Olsen</a>
- <a href="https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530" title="Test Driven Development: By Example" target="_blank" rel="nofollow noopener noreferrer">Test Driven Development: By Example - Ken Beck</a>
- <a href="https://www.amazon.com/Practical-Object-Oriented-Design-Ruby-Addison-Wesley/dp/0321721330" title="Practical Object-Oriented Design in Ruby: An Agile Primer" target="_blank" rel="nofollow noopener noreferrer">Practical Object-Oriented Design in Ruby: An Agile Primer - Sandi Metz</a>
- <a href="https://www.amazon.com/Pragmatic-Programmer-Journeyman-Master/dp/020161622X" title="The Pragmatic Programmer: From Journeyman to Master" target="_blank" rel="nofollow noopener noreferrer">The Pragmatic Programmer: From Journeyman to Master - Andrew Hund, David Thomas</a>

#### Presentations
- <a href="https://www.youtube.com/watch?v=8bZh5LMaSmE" title="All the Little Things by Sandi Metz" target="_blank" rel="nofollow noopener noreferrer">All the Little Things by Sandi Metz</a>
- <a href="https://www.youtube.com/watch?v=5yX6ADjyqyE" title="Fat Models with Patterns by Bryan Helmkamp" target="_blank" rel="nofollow noopener noreferrer">LA Ruby Conference 2013 Refactoring Fat Models with Patterns by Bryan Helmkamp</a>
- <a href="https://www.youtube.com/watch?v=OMPfEXIlTVE" title="Nothing is something by Sandi Metz" target="_blank" rel="nofollow noopener noreferrer">Nothing is something by Sandi Metz</a>
- <a href="https://infinum.co/the-capsized-eight/best-ruby-on-rails-refactoring-talks" title="8 best Ruby on Rails refactoring talks" target="_blank" rel="nofollow noopener noreferrer">Best Ruby on Rails refactoring talks</a>
