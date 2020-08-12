---
layout: post
photo: /images/tdd-30devstories/tdd-30devstories
title: TDD in a nutshell
description: Software development driven by tests
headline: Premature optimization is the root of all evil.
categories: [testing, 30devstories]
tags: [tdd, tests]
lang: en
imagefeature: tdd-30devstories/og_image-tdd-30devstories.jpg
---

Some time ago, I was participating in an Instagram challenge called #30devstories. During that challenge, I create a lot of nice and short materials related to programming. I would like to share them with you using a more permanent way then InstaStory. I will start with **TDD - Test Driven Development**. In more details, I described this topic in the article <a href="{{ site.baseurl }}/tdd-basic" title="Process TDD by example">TDD - Basics</a>. Today I will focus only on a very short introduction to TDD.

## What is TDD?

TDD - Test Driven Development. Software development driven by tests. That's mean TDD is not a way of writing tests. TDD is more like a process of creating software using tests.

## How TDD looks like?

TDD is 3 steps process, which we do in a loop:

1. **Test** - Each iteration start from the test. After we write a test, we need to check if this test doesn't pass. In case when the test is passing without any change in the code, this test is useless. It has no impact on the code.

2. **Code** - When we are pretty sure that the test failed, we can start coding. Remember to write only a minimum amount of code that passes the test. Nothing more.

3. **Refactor** - Test is passing. Now it's time for some refactoring. Is it something you can write better, simpler, or more readable? Do that. Name can be more descriptive? Let's do it. It's a good time for those kinds of adjustments. There is only one rule. Do not provide new logic to existing code.

After one cycle, you can start another one. Continue your process till you implement all that you need - all the logic.
