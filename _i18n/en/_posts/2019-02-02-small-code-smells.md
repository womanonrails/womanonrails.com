---
layout: post
title: Small code smells
description: We think about big architecture concepts, but we have problems with small code smells.
headline: Premature optimization is the root of all evil.
categories: [refactoring]
tags: [Visual Basic, code smells]
comments: true
---

I think every programmer, at least at some point, wanted to resolve some big problems, focus on big architecture and be the one, who will fix the entire world. Did you ever feel that way? I did, more than once. It's funny because at that moment I feel that I can change application completely, for the better of course ;] I can do some refactoring here and there. I can do that alone, without any help. I see the solution inside my head. It is almost done. But after this moment of excitement, I know that this is a daily base work. To have good architecture, we need to take care of each small line of code. This will not happen by night. It is hard work and sometimes we forget about it. It is much more fun to think about integration with Google Earth Engine then about naming of one small variable. Don't you think?

Here is what I would like to show you. I got Visual Basic code to rewrite it in Ruby. I cannot show you all of this code. It is still under NDA (non-disclosure agreement). But you can image this situation. I opened the file. One big file. 2000 lines of code. I started reading the code to understand the logic. It was hard. Very hard. It was painful. Many variables almost from `a` to `z`, then form `aa` to `zz` without any explanation what they meant. One big method. Lot of duplications and no indentations. And something what I've seen last time on my University during classes about micro-controllers programing. Lot of `goto` commands, almost everywhere. It took me some time to understand it. Logic was quite easy, after spending hours of reading this code. Yes, there were many math calculations, but after all, those were linear equations to solve in loops. If the person who prepared this code, took care of it in the proper way, I would have much less work to do. I would spend less time to understand it. And it would be a pleasure to work with this code. I think even for that person the code would be much easier with a good design.

I will give you two small examples of this code, to show you the problem:

```basic
For i = 1 To m1
For j = 1 To m1
If i <> j Then
s3(i, j) = 0
GoTo 410
End If
s3(i, j) = 1
410 Next j
Next i
```

Do you know what this code does? First look, first thought. No idea. You need to analyze it to understand it. OK, let me give you a hand here:

```basic
m1 = 2
For i = 1 To m1
  For j = 1 To m1
    If i <> j Then
      s3(i, j) = 0
      GoTo 410
    End If
  s3(i, j) = 1
  410 Next j
Next i
```

It is more readable, because we know which code is inside the other. And we see that `m1 = 2` so we have only 2 steps for each loop. But this `goto` breaks the flow of reading it. What if I told you that this code is no more than this:

```basic
array = [
  [1, 0],
  [0, 1]
]
```

Much easier to understand. I can show you another solution just in case you want to stay with dynamic generation of this matrix based on size. In this Visual Basic code we use only the size of 2, so for me it does not make sense to do that dynamically, but who knows.

```basic
For i = 1 To m1
  For j = 1 To m1
    If i <> j Then s3(i, j) = 0
    If i = j Then s3(i, j) = 1
  Next j
Next i
```

The second example is quick. Do you know the difference between `n12` and `n1n2` variables? Maybe this is just a misspell? And after all what is this `n12`? What does it mean?

```basic
n12 = n1 ^ 2
n1n2 = n1 * n2
```

It is not hard to do a mistake here. Names are so similar, that you can easily put second variable instead of first. We still don't know what is the real meaning of these variables, but at least we know the difference. When you have lots of this kind of variables in code it is almost impossible to remember them.

If we want to have the overall good architecture, we should start small. We should put attention to each line of code. We should explicite show the meaning of our code. It is easy to make a mess, but good code needs more work and engagement.

Thank you that you are here and that you want to improve your programming skills. Share your thoughts in the comments below. Once again, thank you and see you next time!

