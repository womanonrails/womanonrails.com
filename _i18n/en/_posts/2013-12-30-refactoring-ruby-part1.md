---
layout: post
title: Ruby Refactoring – part 1
description: Sum elements in array columns - Refactoring
headline: My code is getting worse, please send more chocolate
categories: [Ruby, refactoring]
tags: [Ruby, refactoring]
comments: true
---

This time I will change Ruby code. My little monster looks like this:

```ruby
def sum_by_column(data)
  sum_array =  data.group_by do |column|
    [column[0], column[2]]
  end.values.map { |item| item.transpose[1].inject(:+) }
  data.group_by do |column|
    [column[0], column[2]]
  end.keys.zip(sum_array).map { |first, last| [first[0], last, first[1]] }
end
```

If You know what this code does I say: Wow! I wrote this code but it’s terrible. I must do something with it. OK, lets start from the beginning. This method gets data as an array of integer arrays. Like this: `[[1, 2, 3], [4, 5, 6]]`. Then groups the data by first and last column and sums by middle column. When You have data like this:

```ruby
data = [
  [1, 3, 1],
  [1, 1, 1],
  [1, 1, 2],
  [1, 1, 2],
  [2, 2, 1]
]
```

then our method returns

```ruby
result = [
  [1, 4, 1],
  [1, 2, 2],
  [2, 2, 1]
]
```

I decided to change this method. On the end I need an array similar to result. So I declared an array. Then I grouped my array by first and last column. Finally I summed the middle column in loop and put all data into array. Now our method looks like this:

```ruby
def sum_by_column(data)
  array = []
  grouped_data = data.group_by { |column| [column[0], column[2]] }
  grouped_data.each do |key, value|
    sum = value.transpose[1].inject(:+)
    array << [key.first, sum, key.last]
  end
  array
end
```

After that I noticed that order in the data array doesn’t matter. My input and output changed to:

```ruby
data = [
  [1, 1, 3],
  [1, 1, 1],
  [1, 2, 1],
  [1, 2, 1],
  [2, 1, 2]
]

result = [
  [1, 1, 4],
  [1, 2, 2],
  [2, 1, 2]
]
```

The method changed only a little:

```ruby
def sum_by_column(data)
  array = []
  grouped_data = data.group_by { |column| column[0..1] }
  grouped_data.each do |key, value|
    array << (key << value.transpose[2].inject(:+))
  end
  array
end
```

OK, it looks better now but what else can I do to improve it? Let me see… Maybe I can replace each with map:

```ruby
def sum_by_column(data)
  grouped_data = data.group_by { |column| column[0..1] }
  grouped_data.map { |key, value| [*key, value.transpose[2].inject(:+)] }
end
```

Yeyyy… It looks fine now. Finally this method is acceptable for me. If you have any suggestions how can I change this method, please left your comment.
