---
layout: post
title: CoffeeScript Refactoring – part 1
description: Small refactoring in CoffeeScript
headline: My code is getting worse, please send more chocolate
categories: [CoffeeScript, refactoring]
tags: [CoffeeScript, refactoring]
comments: true
---

This will be the first article about refactoring. I love refactoring, so let’s start.

I think that the best way to do this is to put some code on the beginning and then change it. Today I would like to show you a piece of CoffeeScript code:

```coffee
if checked_items == all_items
  $('#myId').prop('checked', true)
else
  $('#myId').prop('checked', false)
```

This code is simple. I check if number of selected items is same as number of all items. And then I select (or not) a checkbox on a web page. As I said it’s simple but can be improved:

```coffee
$('#myId').prop('checked', checked_items == all_items)
```
The same functionality in one line. I like this refactoring very much. If You see how can I improve this code, simply let me know.

See you next time!

