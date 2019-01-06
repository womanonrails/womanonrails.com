---
layout: post
title: Ruby Array Tips
description: 10 Ruby tips for Array
headline: My code is getting worse, please send more chocolate
categories: [programming]
tags: [Ruby]
comments: true
---

Ruby have great documentation for Array method for example like this. To day I want to focus not on methods in documentation but some tips I know in Ruby with Array. Let’s start:

- Create Array with strings:

```ruby
%w{ 1 2 3 4 }
 => ["1", "2", "3", "4"]
```

- Create Array with the same number:

```ruby
[2]*5
 => [2, 2, 2, 2, 2]
```

- Create Array with ordered numbers:

```ruby
(1..4).to_a
 => [1, 2, 3, 4]
```

- Create Array with even numbers:

```ruby
(2..10).step(2).to_a
 => [2, 4, 6, 8, 10]
```

- Show last element in Array:

```ruby
array = [1, 2, 3, 4]
array[-1]
 => 4
```

- Show part of Array:

```ruby
array = [1, 2, 3, 4]
array[1..2]
 => [2, 3]
array[1...3]
 => [2, 3]
array[1, 2]
  => [2, 3]
```

- Array decomposition:

```ruby
a, b, c = [1, 2, 3, 4]
a => 1
b => 2
c => 3
```

or

```ruby
a, b, *c = [1, 2, 3, 4]
a => 1
b => 2
c => [3, 4]
```

- Sum all elements in Array:

```ruby
array = [1, 2, 3, 4]
array.inject(&:+)
 => 10
```

or

```ruby
array.reduce(&:+) (for parallel calculations)
 => 10
```

- Removed specific elements from Array:

```ruby
array = [1, 2, 3, 4]
array.slice!(1..2)
array => [1, 4]
```

- Array operations:

```ruby
# Sum
[1, 2, 3] | [1, 4] => [1, 2, 3, 4]
# Concatenation
[1, 2, 3] + [1, 4] => [1, 2, 3, 1, 4]
# Product
[1, 2, 3] & [1, 4] => [1]
# Difference
[1, 2, 3] - [1, 4] => [2, 3]
```
