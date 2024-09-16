---
excerpt: >
  In one of my last articles,
  I was writing about [improving names in the project](/names-have-meaning "How to create names with meaning? 13 ideas how to improve names.").
  One of the tips was **tell what pattern you use**.
  Then I read a newsletter from Sandi Metz
  _"Don't Name Classes After Patterns. Mostly."_
  which have a different opinion about patterns in names.
  I think it is a good topic to write about it.
  There is no one silver bullet rule on how to do programming or create names.
  We have some tips, but those are the signpost.
  There are always some pros and cons,
  so it is good to have a wider perspective.
layout: post
photo: /images/pattern-name-in-class-name/pattern-name-in-class-name
title: Pattern name in class name. Good or bad practice?
description: Is it OK to use pattern name in class name?
headline: Premature optimization is the root of all evil.
categories: [refactoring]
tags: [refactoring]
imagefeature: pattern-name-in-class-name/og_image-pattern-name-in-class-name.jpg
lang: en
---

In one of my last articles, I was writing about [improving names in the project]({{site.baseurl}}/names-have-meaning "How to create names with meaning? 13 ideas how to improve names."). One of the tips was **tell what pattern you use**. Then I read a newsletter from Sandi Metz _"Don't Name Classes After Patterns. Mostly."_ which have a different opinion about patterns in names. I think it is a good topic to write about it. There is no one silver bullet rule on how to do programming or create names. We have some tips, but those are the signpost. There are always some pros and cons, so it is good to have a wider perspective.

Let's start briefly from my hint: _Tell what pattern you use_. I still think that telling the pattern name can help with understanding the architecture. When you have class `User`, and then you create a class `UserDecorator` you know exactly which pattern you use. You know, that this is a `User` with some additional or changed behavior. This name shows the architecture decision you take. When this is what you want to focus on, I think it is OK to give a name for a class like `UserDecorator`. Pattern names are here to help the programmer to communicate in a short and precise way. They are meaningful, so we add them to class names.

Now, on the other hand, we have _Don't Name Classes After Patterns_ approach. The arguments for that are:
  - Adding a pattern name to your class name pollutes the domain with programming words not related to the domain.
  - Pattern will tell you how something is created but will not tell you what this really does or what this really is.
  - It will feel like you did a great job with your class name without actually having done so. Not even try.
Well, if we look at using pattern names in the name of a class from that perspective, it can be a problem. I think those arguments speak for no patterns in the names approach. I see a red light in my head, and I want to try harder with my names. So, when we look at `UserDecorator` maybe a name like `AdminUser` will be more precise with what the class really does, not how it is built. It will allow us to change the internal implementation in the future without changing the name of the class.

It's not the end. Even, I feel the right of the no pattern name approach, still, there are some places where I will go with pattern in the name. So, I took a look closely at my names, and I saw that using my intuition in some places I use patterns, and in some places no. I started thinking when I do that. First, when I work in the Rails framework, I don't break the convention there. If I have `UserController`, I stick to this name. The same I will do with an external library, I use. Second, there will be some classes implementing patters where I will stick to the pattern name. The example could be a Factory. In this case, I feel that the purpose of a class is to be a factory for other objects. Well, it depends on the context, as usual. Next, we have those cases where I will not use patterns in the class name like the Adapter pattern. I will call that class base on what for is this adapter. When I know the domain well, I'm able to use the same names as the client does. Then I exactly know the purpose of the class, no need for patterns in the names.

I can say that pattern in the name of a class is a middle stage. It's better than a random name without sense, but it is not perfect. We can try harder. Sometimes I'm not exactly sure yet, what the class is, what is the purpose of this class. It's a case where probably I will reach for low handing fruit - pattern name, heaving in mind that the **name can or will change in the future**. Here is one thing worth mentioning. We often don't change the name even it doesn't fit anymore to the class responsibility. Why? It is an quick win. Our text editors and IDE's support this kind of change. The name is not permanent, we should change it when it doesn't serve us anymore.

To summarize, as I told you, in the beginning, there is no silver bullet for naming things. Rules exist to help us, to create some boundaries, to save time & money, to learn from other's mistakes, to prevent our own mistakes. They are something we need to consider, and in most cases, we should stick to them. But, they are not the only truth. In the end, we are programmers. We take risks, and we are responsible for the future consequences. Let me know what you think about this topic. Do you use pattern names in the name of the class, or maybe not? Why? When you do that and when you don't? Feel free to left a comment below.

