---
layout: post
title: Small code smells
description: We think about big architecture concepts, but we have problems with small code smells.
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Visual Basic, code smells]
comments: true
---

I think every programmer, at least at some point, wanted to resolve big problems, focuse on big architecture and be the one who will fix antirer world. Did you ever feel that way? I did, more then once. It's funny because at that moment I feel that I can change appliaction completly, for better of course ;] I can do refacoring here and here. I can do that alone, without any help. I see the solution inside my head. It is almost done. But after this moment of exciment, I know that this is a dayly bases work. To have good architecture we need to take care of each small line of code. This will not happend by night. It is hard work and sometimes we forget about it. It is much more fun to think about integration with google erth engine then about naming of one small variable. Don't you think?

Here is what I would like to show you. I got Visual Basic code to rewrite it in Ruby. I cannot show you all of this code. It is still under NDA (non-disclosure agreement). But you can image this situation. I opened the file. One big file. 2000 lines of code. I started reading the code to understand the logic. It was hard. Very hard. It was painfull. Many variables almost form `a` to `z`, then form `aa` to `zz` without any  explanation what they mean. One big method. Lot of duplications and no intentations. And something what I've seen last time on my University during classes about microcontrollers programing. Lot of `goto` commands, almost everywhare. It took me some time to understand it. Logic was quite eazy, after spending hours of reading code. Yes, there were many math calculations, but after all this were linear equesions to solve in loops. If person who prepare this code, took care of it in the proper way, I would have much less work to do. I whould spent less time to understand it. And it would be a pleasue to work with this code. I think even for that person the code would be much eazier with a good design.

I will give you two small exmples of this code, to show you the problem:

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

Do you know what this code do. First look, first thought. No idea. You need to analied it, to understand it. OK, let's give you small help here:

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

It is more readable, because we know which code is inside the other. And we see that `m1 = 2` so we have only 2 steps for each loop. But this `goto` breaks all the flow of reading it. What if I tell you that this code is no more then this:

```basic
array = [
  [1, 0],
  [0, 1]
]
```

Much more eazy to understand. I can show you other solution just in case you want to stay with dinamic generation of this matrix based on size. In this Visual Basic code we use only size of 2, so for me it's no make sens to do that dinamicly but who knows.

```basic
For i = 1 To m1
  For j = 1 To m1
    If i <> j Then s3(i, j) = 0
    If i = j Then s3(i, j) = 1
  Next j
Next i
```

Second example is fast. Do you know the difference between `n12` and `n1n2` variables? Maybe this is just misspell? And after all what is this `n12`? What does it mean?

```basic
n12 = n1 ^ 2
n1n2 = n1 * n2
```

It is not hard to do some mistake here. Names are so similar, that you can eazly put second variable instead of first. We still don't know what is the real meaning of this varialbes, but at least we know the difference. When you have lot of this kind of variables in code it is almost inpossible to remember them.

If we want to have overall good architecture we should start small. We should put attention to each line of code. We should explicite show the meaning of our code. It is easy to do a mess, but good code need more work and engagement.

Thank you that you are here and want to imporve your progamming skills. Share your thoughts in the comments below. One more time thank you and see you next time!
