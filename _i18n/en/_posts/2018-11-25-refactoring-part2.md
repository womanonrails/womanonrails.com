---
excerpt: >
  Last time in the article
  [Ruby Refactoring step by step - part 1](https://womanonrails.com/refactoring-step-by-step)
  we went through the very procedural code in one class to a more object oriented approach.
  This time we will continue our journey through refactoring.
  We will cover small object instead of one big class
  and we will use composition to plug behavior into an object.
  Let's start!
layout: post
title: Ruby Refactoring step by step - part 2
description: How to refactor your code? <br> From object related code to composition.
headline: Premature optimization is the root of all evil.
categories: [refactoring]
tags: [Ruby]
lang: en
---

Last time in the article [Ruby Refactoring step by step - part 1](https://womanonrails.com/refactoring-step-by-step) we went through the very procedural code in one class to a more object oriented approach. This time we will continue our journey through refactoring. We will cover small object instead of one big class and we will use composition to plug behavior into an object. Let's start!

# Step 8 - More descriptive output

This step I started from [here](https://github.com/womanonrails/poker/blob/46e12428d0d67cb90d17f417147dc936815a69e7/lib/poker/hand.rb "Code after 7th step of refactoring"). I mainly focus on meaning of this method:

```ruby
def check
  return 9 if straight_flush?
  return 8 if four_of_a_kind?
  return 7 if full_house?
  return 6 if flush?
  return 5 if straight?
  return 4 if three_of_a_kind?
  return 3 if two_pair?
  return 2 if one_pair?
  return 1 if high_card?
  return 0
end
```

I need to say, this step was very important. When you think about readability, it is better to have something like `:straight_flush` than `9`. In this case you don't need to go deep in code to understand the meaning of this number. On the other hand, I was thinking only about this one class (without impact on whole system). I changed the result of `check` method. In some cases, in big systems this change can be hard to do or even impossible (for the current state of the code). Even in my case, this force changes in all tests, so you need to be careful before this kind of changes. You need to know how big impact the change will provide to your system. Anyway, in this case I still think that it was worth to do.

Code after changes:

```ruby
def check
  return :straight_flush if straight_flush?
  return :four_of_a_kind if four_of_a_kind?
  return :full_house if full_house?
  return :flush if flush?
  return :straight if straight?
  return :three_of_a_kind if three_of_a_kind?
  return :two_pair if two_pair?
  return :one_pair if one_pair?
  return :high_card if high_card?
  return :none
end
```

You can find new version of code [here](https://github.com/womanonrails/poker/blob/4896498a348db52d5c884a522a132eae5b2c4f60/lib/poker/hand.rb "Code after 8th step of refactoring").

## Stats:
- **LOC**  - 80
- **LOT**  - 190
- **Flog** - 62.5
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Step 9 - Meta-programming

This step is completely optional. I did that because I didn't like so much of a redundancy in method `check`. In this case in my opinion, this method is still readable in short time. I mean, you don't need to debug this long time to understand what is going on. Remember that not always a code with meta-programming is simple to read. Sometimes it's even better to leave the code without meta-programming to improve readability. But as always you, as a programmer, are responsible for the solution you choose. In this case, I create array with right order by checking hand and then I connected it to `check` method.

Code before:

```ruby
def check
  return :straight_flush if straight_flush?
  return :four_of_a_kind if four_of_a_kind?
  return :full_house if full_house?
  return :flush if flush?
  return :straight if straight?
  return :three_of_a_kind if three_of_a_kind?
  return :two_pair if two_pair?
  return :one_pair if one_pair?
  return :high_card if high_card?
  return :none
end
```

Code after:

```ruby
def check
  @order_checking.each do |name|
    method_name = (name.to_s + '?').to_sym
    return name if send(method_name)
  end
end
```

where `@order_checking` is order of checking hand.

```
@order_checking = [
  :straight_flush, :four_of_a_kind, :full_house, :flush, :straight,
  :three_of_a_kind, :two_pair, :one_pair, :high_card, :none
]
```

All code you can find [here](https://github.com/womanonrails/poker/blob/4d649a25af020c7f862b3c6ed964f1b2e73a0f60/lib/poker/hand.rb "Code after 9th step of refactoring").

## Stats:
- **LOC**  - 82
- **LOT**  - 190
- **Flog** - 59.3
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Step 10 - Small object

This step is quite big and also very important. Maybe even the most important one. I started from **SOLID** principles. If you've never heard about them or you would like to refresh your memory to do this in short way you can check [wiki page](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design) "SOLID (object-oriented design)") or to deeply understand it check out the presentation of [Sandy Metz - SOLID Object-Oriented Design](https://www.youtube.com/watch?v=v-2yFMzxqwU "Sandy Metz - SOLID Object-Oriented Design"). I started from **S - Single responsibility principle**. When I look into this code I can say that `Hand` class know and do everything. As I already mentioned before this code is more procedural than object oriented. So I started extracting functionality one by one. These are the steps for each method by `four_of_a_kind` example:

- I moved `four_of_a_kind` logic to separate class. Yes, there are some duplications, but as Sandi says: *duplication is better than a wrong abstraction*.

```ruby
module Poker
  class FourOfAKind
    def initialize(array)
      @array = array.sort
      @figures, @colors = cards_figures_and_colors
      @frequency = cards_frequency.values
    end

    def check
      :four_of_a_kind if @frequency.include?(4)
    end

    private

    def cards_figures_and_colors
      @array.map { |item| [item / 4, item % 4] }.transpose
    end

    def cards_frequency
      @figures.each_with_object(Hash.new(0)) do |item, hash|
        hash[item] += 1
      end
    end
  end
end
```

- Create/modify ugly `if` statement to handle new class and also old methods names.

```ruby
def check
  @order_checking.each do |name|
    if name == :four_of_a_kind
      return name if FourOfAKind.new(@array).check == name
    else
      method_name = (name.to_s + '?').to_sym
      return name if send(method_name)
    end
  end
end
```

- Prepare tests for new class. Yes, I also duplicated tests but they need to stay like that for now.

```ruby
require 'spec_helper'

describe Poker::FourOfAKind do
  [
    [0, 1, 2, 3, 4],
    [4, 5, 6, 0, 7],
    [8, 9, 0, 10, 11],
    [12, 0, 13, 14, 15],
    [0, 16, 17, 18, 19],
    [20, 21, 22, 23, 0].shuffle,
    [24, 25, 26, 27, 0].shuffle,
    [28, 29, 30, 31, 0].shuffle,
    [32, 33, 34, 35, 0].shuffle,
    [36, 37, 38, 39, 0].shuffle
  ].each do |cards|
    it "detects four_of_a_kind for #{cards}" do
      hand = described_class.new(cards)
      expect(hand.check).to eq :four_of_a_kind
    end
  end
end
```

During that process I did one more thing. I inject order of hand checking to the initializer. `ORDER_CHECKING` you can treat that as configuration, which I can move in future to separate file (this is not needed right now). I did that just in case we would like to change quickly the order of hand in tests or even in future of application.

```ruby
def initialize(array, order_checking = ORDER_CHECKING)
  ...
end
```

The code for this step you can find [here](https://github.com/womanonrails/poker/tree/0c5d6850d40f899d98ff531e4a2b948d469c3d84/lib/poker "Code after 10th step of refactoring"). This step I repeated to all different hands. After each iteration all tests were passing. If you would like to check the pattern which I repeated you can [check this commit](https://github.com/womanonrails/poker/tree/08631288c747a2a9fda3d986f4046e9e363ea027/lib/poker "Pattern for 3 classes created based on the steps above"), there already exist 3 classes created based on the steps above.

## Stats:
- **LOC**  - 85
- **LOT**  - 200
- **Flog** - 65.5
- **Flay** - 0
- **Tests** - 116 examples, 0 failures

# Step 11 - Remove duplication

In this step, I noticed that all my new classes have a lot of duplications in code. I only changed two things in each class: class name and one line in method `check`. In this case we need to extract some behavior, maybe method or even class which will take care of sorting cards in hand and will have knowledge about the colors and figures on this card. I decided to create some normalization for the cards. I created class `CardsNormalization`, which is one of representation of `Normalization` class. You can ask me why did I create 2 classes when probably I need only one? Well, I had a feeling that I create simple *interface* which can have many representations. For now is only one, but who knows the future? So I created *interface* `Normalization` with one representation `CardsNormalization`. Another example of normalization can be normalization for dice. There are the same rules like in poker (one pair or four of a kind), but normalization will be different. Code for these two classes you can find [here](https://github.com/womanonrails/poker/tree/a668a538cb86dd17e946157c5d62373fe2266c0e/lib "Code after 11th step of refactoring"). I just moved code which was duplicated in many classes to this `Normalization`:

```ruby
class Normalization
  attr_reader :figures, :colors, :figures_frequency
  def initialize(array)
    @array = array.sort
    @figures = prepare_figures
    @colors = prepare_colors
    @figures_frequency = prepare_figures_frequency.values
  end
  private
  def prepare_colors
    @array
  end
  def prepare_figures
    @array
  end
  def prepare_figures_frequency
    @figures.each_with_object(Hash.new(0)) do |item, hash|
      hash[item] += 1
    end
  end
end
```

and `CardsNormalization`:

```ruby
class CardsNormalization < Normalization
  private
  def prepare_colors
    @array.map { |item| item % 4 }
  end
  def prepare_figures
    @array.map { |item| item / 4 }
  end
end
```

I did one more thing here. I inject this normalization as a argument of `Hand` initializer:

```ruby
def initialize(array, order_checking = ORDER_CHECKING, normalization = CardsNormalization)
```

and after that my class `OnePair` looks like this:

```ruby
module Poker
  class OnePair
    def initialize(array, normalization = Normalization)
      @normalize_array = normalization.new(array)
    end

    def check
      :one_pair if @normalize_array.figures_frequency.include?(2)
    end
  end
end
```

Only one method looks ugly. This is `check` method. We have more conditions there. But I know that I will take care of this method as soon as I will finish extracting all hands type to separate classes. For now this method looks like that:

```ruby
def check
  @order_checking.each do |name|
    if [:one_pair].include? name
      class_name  = 'Poker::' + name.to_s.split('_').collect(&:capitalize).join
      return name if Object.const_get(class_name).new(@array, @normalization).check == name
    end
    if [:four_of_a_kind, :three_of_a_kind, :one_pair].include? name
      class_name  = 'Poker::' + name.to_s.split('_').collect(&:capitalize).join
      return name if Object.const_get(class_name).new(@array).check == name
    else
      method_name = (name.to_s + '?').to_sym
      return name if send(method_name)
    end
  end
end
```

Next, I did the same for rest of existing clases. So I used `CardsNormalization` for class `FourOfAKind` and `ThreeOfAKind`.  You can find code for that [here](https://github.com/womanonrails/poker/tree/87891306fe875bd415554a6eb5ebc0b46f893c9d/lib/poker "Code after 11th step of refactoring").

## Stats:
- **LOC**  - 87
- **LOT**  - 200
- **Flog** - 82.5
- **Flog total** - 122.4
- **Flay** - 0
- **Tests** - 124 examples, 0 failures

# Step 12 - Remove more duplications

This time I noticed one more duplication in the code. For now all new classes, check similar condition: `@normalize_array.figures_frequency.include?(4)` only number is changing. For me this is some kind of a rule. We check if we have  2, 3 or 4 the same figures. I decided to create class `FrequencyRule` and this is the code for this class:

```ruby
module Rules
  class FrequencyRule
    def initialize(frequency_array, count)
      @frequency_array = frequency_array
      @count = count
    end

    def check?
      @frequency_array.include?(@count)
    end
  end
end
```

then I added `@rule = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 3)` to initializers and used `@rule.check?` instead of `@normalize_array.figures_frequency.include?(3)`. Example of class after this changes:

```ruby
class ThreeOfAKind
  def initialize(array, normalization = Normalization)
    @normalize_array = normalization.new(array)
    @rule = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 3)
  end

  def check
    :three_of_a_kind if @rule.check?
  end
end
```

Whole code is [here](https://github.com/womanonrails/poker/tree/d66590842ef194a9218dea70ccd083212b5d43b2/lib "Code after 12th step of refactoring"). After this changes and writing new tests all new and old tests have passed.

## Stats:
- **LOC**  - 87
- **LOT**  - 161
- **Flog** - 82.5
- **Flog total** - 134.9
- **Flay** - 0
- **Tests** - 95 examples, 0 failures


# Step 13 - Combining rules

Now this is the interesting part. Time for a full house. In this case we need to have 3 of the same figures and 2 of the same figures at the same time. Like 2&#9824; 2&#9827; <span class='red-text'>2&#9829; 3&#9829; 3&#9830;</span> So we need to check the same rules twice. This is a good time to prepare something what will combine different rules I called this class `RulesFactory` and code looks like that:

```ruby
class RulesFactory
  def initialize(*rules)
    @rules = rules
  end

  def check?
    @rules.each do |rule|
      return false unless rule.check?
    end
    true
  end
end
```

Now we can provide the code of `FullHouse` class:

```ruby
module Poker
  class FullHouse
    def initialize(array, normalization = Normalization)
      @normalize_array = normalization.new(array)
      rule1 = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 2)
      rule2 = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 3)
      @rules = RulesFactory.new(rule1, rule2)
    end

    def check
      :full_house if @rules.check?
    end
  end
end
```

Do you see the pattern? Of course I need to make some improvements in my `Hand` class, add more test and check if all of them pass. Full code on this stage available [here](https://github.com/womanonrails/poker/tree/d18cf1f273c9fdcb97e21067d3411938beefdf36/lib "Code after 13th step of refactoring").

# Step 14 - Repeat steps

So now time to repeat some steps. Create new rules like `StraightnessRule`, `FlushnessRule` or `RoyalnessRule`. Create new classes `Straight`, `Flush` or `RoyalFlush`. The code after those changes you will find [here](https://github.com/womanonrails/poker/tree/0985c071c87de56c8c49307d6d20963aced7ff79/lib "Code after 14th step of refactoring").

I would like to mention one magic thing here. When we do small classes with one responsibility defined in a general way, we can use our classes in unexpected ways. Here is an example:

```ruby
module Rules
  class FlushnessRule
    def initialize(color_array)
      @color_array = color_array
    end
    def check?
      @color_array.uniq.size == 1
    end
  end
end
```

This is what class should do:

```ruby
rule = FlushnessRule.new([1,1])
 => #<FlushnessRule:0x00000001eced60 @color_array=[1, 1]>
rule.check?
 => true
```

and this is what this class can do:

```ruby
rule = FlushnessRule.new(['#fff','#fff'])
 => #<FlushnessRule:0x00000001ebc020 @color_array=["#fff", "#fff"]>
rule.check?
 => true
```

When I created this class I never thought about using it on an array of strings. I know that this is partially thanks to `Ruby` as a language and [**duck typing**](https://en.wikipedia.org/wiki/Duck_typing "Duck typing in Ruby"), but also because of simplicity of the code.

## Stats:
- **LOC**  - 94
- **LOT**  - 171
- **Flog** - 69.7
- **Flog total** - 191.2
- **Flay** - 0
- **Tests** - 142 examples, 0 failures

# Step 15 - Rule for nothing

When you play poker you can have something in your hand like three of a kind or you can have nothing. And this "nothing" also you need to handle in your code. So I created class for "nothing" - `None` class. And I did some cleanups in `Hand` class.

```ruby
module Poker
  class None
    def initialize(array, normalization = Normalization)
      @normalize_array = normalization.new(array)
    end

    def check
      :none
    end
  end
end
```

All code you can check [here](https://github.com/womanonrails/poker/tree/03a356a42afed39fffd98ceff0b7b1311f7b05ec/lib "Code after 15th step of refactoring") and tests have passed after this changes.

## Stats:
- **LOC**  - 55
- **LOT**  - 171
- **Flog** - 56.0
- **Flog total** - 180.8
- **Flay** - 0
- **Tests** - 145 examples, 0 failures

# Step 16 - MultiFrequencyRule

This will be our final step of this refactoring and also a tricky one. You can believe or not, checking if in hand, we have two pairs is the hardest rule. We have rule which checks the frequency of figure `FrequencyRule` but we cannot use it here because we need to check if we have 2 pairs. So we need to create another frequency rule. We will call it `MultiFrequencyRule`:

```ruby
module Rules
  class MultiFrequencyRule
    def initialize(frequency_array, count, times = 1)
      @frequency_array = frequency_array
      @count = count
      @times = times
    end

    def check?
      selected_frequency = @frequency_array.reject { |number| number < @count }
      selected_frequency.count >= @times
    end
  end
end
```

This time we select only chosen frequency in `@frequency_array` and then we check how many times it is there. But wait! When we have this combination 2&#9824; 2&#9827; <span class='red-text'>2&#9829; 3&#9829; 3&#9830;</span> we have a full house but also two pairs. So rule which checks if in this hand are two pairs should return `true`. That's why we check `number < @count` and remove them from this array. The code for this class is [here](https://github.com/womanonrails/poker/blob/6a3af1c900c88477097ac00d405fef59866eb06b/lib/rules/multi_frequency_rule.rb "Code for MultiFrequencyRule class").


**Alert!** If you take a closer look to this code you will see one more problem. What if we have 2&#9824; 2&#9827; <span class='red-text'>2&#9829; 2&#9830; 3&#9829;</span>. We can say that these are also 2 pairs (of course, this is also four of a kind). So our `check?` method should look like this:

```ruby
def check?
  selected_frequency = @frequency_array.map { |number| number / @count }
  selected_frequency.sum >= @times
end
```

When we have this rule we can check `TwoPair`, we can finally clean up logic in `Hand` class and we can replace class `FrequencyRule` with `MultiFrequencyRule` which is much more general. After that all tests have passed. You can find the code [here](https://github.com/womanonrails/poker/tree/277d2893ffac1318c2a64fca2704e1c8258856e1/lib "Code after 16th step of refactoring"). Check out how `Hand` class looks like now:

```ruby
module Poker
  ORDER_CHECKING = [
    :royal_flush, :straight_flush, :four_of_a_kind, :full_house, :flush,
    :straight, :three_of_a_kind, :two_pair, :one_pair, :high_card, :none
  ].freeze

  # Poker hand
  class Hand
    def initialize(
      array,
      order_checking = ORDER_CHECKING,
      normalization = CardsNormalization
    )
      @array = array.sort
      @order_checking = order_checking
      @normalization = normalization
    end

    def check
      @order_checking.each do |name|
        return name if class_name(name).check == name
      end
    end

    private

    def class_name(name)
      class_name = 'Poker::' + name.to_s.split('_').collect(&:capitalize).join
      Object.const_get(class_name).new(@array, @normalization)
    end
  end
end
```

I'm pretty proud of this class. If you would like to compare this class with first implementation check this [commit](https://github.com/womanonrails/poker/blob/55c9ae0ab921f7aa95bb7e47676d87b970a32033/lib/poker/hand.rb "First version of Poker class").

## Stats:
- **LOC**  - 37
- **LOT**  - 173
- **Flog** - 28.0
- **Flog total** - 182.4
- **Flay** - 0
- **Tests** - 145 examples, 0 failures

# Summarize

Let's summarize what we've done:

- We used more descriptive names in our code.
- We simplified code using a little bit of meta-programming.
- We created small objects with small responsibility.
- We prepared a bunch of rules for checking poker logic.

# What's next?

Do you think that's all? We finished refactoring. I'm thinking about that quite differently. In my opinion refactoring never ends, there is always something to improve or change. When time is flying by we have more and more information about future of the code. We know more specifically what will happen. So based on this knowledge we can modify the code or prepare a better architecture.

When I am looking at this code now, I will change it for sure. I would start from duplications in hands classes. Probably you also notice that this classes are quite generic and all of them look the same. In the next step I would remove them and create one class which can take name and needed rules. Then I would do more cleanups in tests. Maybe I would move configuration from `Hand` class to some `.yml` file. Maybe configuration could prepare the code for some rules? So we could be able to generate our code base on what we have in configuration. Is it too much for so small functionality like poker hand? Maybe, but this is only an example.

# What did I learn during this refactoring?

- small, readable and easy to test classes
- quite big flexibility (I can use code in many different ways, not only for checking poker hand but also dicing)
- less dependencies, we can easily add or remove some rules
- we are open to extension - we don't need to modify the existing code to add more rules, we need to add new classes and prepare right configuration. We can also use convention and do this automatically, so if someone add new class, everything will be working with new functionality without configuration.
- It was simply a fun project!

# My rules for refactoring

- always after the next step of refactoring keep tests passing
- start slowly from small details and go up to big picture/overview
- do not change everything at once
- your code should be written in a way to not need comments (there are some situation when it is good to have comments, but in most cases code should be self explenatory)
- tools like Rubocop or Reek are to help, but they don't know everything
- try to avoid duplication in code, but sometime duplication is better than wrong abstraction (check out Sandi Mezt in the bibliography)
- public interface should be small
- think about your whole system, how big of an impact will the change have in your environment?
- always think about rules like **Single responsibility principle** try to implement them in your code
- remove duplications in a smart way
- think general and always keep in mind the big picture

# At the end

I would like to mention one more thing here. I put statistics (metrics results) for each step. I don't know if you notice this, but in the middle of refactoring they were worse then in the beginning. We should never reject good long term refactoring if you see that in the middle of it you get bad results, bad statistics. If you have good intuition, and I think you have, then trust that refactoring will bring good effect on the end.

That's it. These are some ideas for refactoring which you can use separately. You can choose steps which are helpful for you. Steps can be done in different order (maybe not all but some of them for sure) and you don't need to use them all. If you like this article share your thoughts with me in the comments below. And see you next time. Bye!

<hr>

### Bibliography

#### Books
- {% include books/en/refactoring-martin_fowler.html %}
- {% include books/en/clean_code-robert_martin.html %}
- {% include books/en/design_patterns_in_ruby-russ_olsen.html %}
- {% include books/en/test_driven_development-ken_beck.html %}
- {% include books/en/practical_object_oriented_design_in_ruby-sandi_metz.html %}
- {% include books/en/pragmatic_programmer-andrew_hund_david_thomas.html %}

#### Presentations
- [All the Little Things by Sandi Metz](https://www.youtube.com/watch?v=8bZh5LMaSmE "All the Little Things by Sandi Metz")
- [LA Ruby Conference 2013 Refactoring Fat Models with Patterns by Bryan Helmkamp](https://www.youtube.com/watch?v=5yX6ADjyqyE "Fat Models with Patterns by Bryan Helmkamp")
- [Nothing is something by Sandi Metz](https://www.youtube.com/watch?v=OMPfEXIlTVE "Nothing is something by Sandi Metz")
- [Best Ruby on Rails refactoring talks](https://infinum.co/the-capsized-eight/best-ruby-on-rails-refactoring-talks "8 best Ruby on Rails refactoring talks")
