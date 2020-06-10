---
layout: post
title: Coderetreat 2015 Cracow
photo: /images/coderetreat/code-retreat
description: Coderetreat - programming workshop
headline: My code is getting worse, please send more chocolate
categories: [workshops]
tags: [coderetreat]
place: Cracow
lang: en
show_date: true
---

In last Saturday I was on
{% include links/external-link.html name='Global Day of Coderetreat' url='https://www.coderetreat.org/' %}
in Krakow. **Coderetreat** is one day in year when programmers focus not on delivery new functionality but focus on **good code quality**. I think this is very important to stop for a moment and think how to be better programmer. And Coderetreat is that moment.

## How looks this Coderetreat day?

All day is divide for 6-7 sessions of coding. In our case it was 6 sessions. In each session we try resolved
{% include links/external-link.html
   name='Game of life'
   url='https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life' %}
problem. This is very simple problem but in Coderetreat main goal is not solving this problem but focus on process and code quality. One session take 45 minutes and then we have 15 minutes to discuss and sum what we did and how we did. Through all sessions we do **ping pong pair programing** with some constrains. Pair programming because we work in pairs, ping pong because we change keyboard between people. One person writes test, second writes code and first one does refactoring. Now it is time to say something about constrains. They can be very different. Some of them are easy, some are very hard. Below are all constrains form Coderetreat day in this year.

1. **No primitives** – Wrap all primitives and strings

    In this session you don’t sent any primitive type between objects. So everything must be some kind of more complex object. On beginning is easy to put primitive types to our code. In future this behavior can cost us much more then we expect (not only our time). Now I will be thinking twice before I use primitives in my code. This first session was for me very productive, especially sharing my thought and conceptions about this problem with other woman.

2. **Functional programming**

    All code is not mutable. Every method get some argument and return results – like function in math. In this case methods cannot modifies object state. For me this session was session out of my comfort zone. First time in my life I wrote code in
    {% include links/external-link.html name='LiveScript' url='https://livescript.net/' %}.
    This language is very similar to
    {% include links/external-link.html name='CoffeeScript' url='https://coffeescript.org/' %},
    so it was nice to try other alternative. After this session I realized how easy was testing code like that. You call methods and only check if result equal to something.

3. **Tell don’t ask** – No getter, no setter, no properties

    This time methods don’t ask for data from other object but tell this object do something. Each method in your code is void type (don’t return anything). This code is very hard to test. You have black box and you don’t know what is inside your object. Code is as much as possible encapsulate. Objects do only things, which are in they responsibility. There was one more think very interesting about this session. I wrote Ruby code with Java developer. It was experience which opened my mind. When we work in one technology (language) we think through this technology. Our mind focus on what we can do in this technology. And we don’t know that it is other solution, other way. So learning new thing, **go out of your comfort zone** helps us thinking out of the box. This is true, not only in coding but also in our lives. Big respect for my pair programming partner for trying new things.

4. **3 minutes circles**

    We had only 3 minutes for finish one TDD circle. Test, code, refactoring. If we don’t finish at time we must remove all code for this one circle. This session helps me to understand that in work we sometime think about one big problem. We have lot of useless code, which don’t work because “it is not finished yet”. I can say that in this session we worked in small
    {% include links/external-link.html
       name='MVP'
       url='https://en.wikipedia.org/wiki/Minimum_viable_product' %}
    (Minimum Viable Product) session. After each 3 minutes we have working functionality. It was small functionality but it’s working.

5. **No loops, no conditions**

    In this session I wrote code in JavaScript ES6 (out of my comfort zone). We don’t suppose to use any loops and any conditions. This session was the hardest session for me. We use loops and condition many time per day. We even don’t realize how often we use this two tools. You can use recursion instead of loops but how stop recursion without conditions? This wasn’t easy task. I really liked this challenge. This was out of the box thinking session.

6. **Silent session**

    This was last session. This time we could not speak to each other. Even more. We could not write and show anything. Only tests and code can talk to us. And really, we do this everyday in work. You don’t have person which write code all the time available to ask about something. You need to figure out through code and tests of course, how this part of application work. In this session I worked with my best friend. I thought that we know each other so good, so we can read in our minds. But when we can not talk, we can not also choose one way to resolve problem. Each of us was thinking about this problem in different way. Only good, descriptive test and good, descriptive code can help us in this situation. All names, comments, tests are very important. This is must have!

<figure>
  <a href="{{ site.baseurl_root }}/images/coderetreat/first-session.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/first-session.jpg"></a>
</figure>
<figure class="third">
  <a href="{{ site.baseurl_root }}/images/coderetreat/summary.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/summary.jpg"></a>
  <a href="{{ site.baseurl_root }}/images/coderetreat/summary2.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/summary2.jpg"></a>
  <a href="{{ site.baseurl_root }}/images/coderetreat/summary3.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/summary3.jpg"></a>
</figure>
<figure>
  <a href="{{ site.baseurl_root }}/images/coderetreat/session5.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/session5.jpg"></a>
  <figcaption>Memories of Cracow Coderetreat</figcaption>
</figure>

Ok, this is it. This was very productive day for me. I learn new things. Coderetreat one more time open my eyes how important is good quality code. I wish every programmer to be part of this event. See you soon. All best! Bye.

