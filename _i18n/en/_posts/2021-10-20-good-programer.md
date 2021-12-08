---
layout: post
photo: /images/programmers-skills/programmers-skills
title: Good programmer skills
description: What programmer should know? My subjective opinion.
headline: Premature optimization is the root of all evil.
categories: [work]
tags: [career, self-awareness]
imagefeature: programmers-skills/og_image-programmer-skills.png
lang: en
---

People often ask me what they should do to be a programmer. In most cases, they expect advice like: read this book, learn this technology or do this course. They want the silver bullet answer, but it's not so simple. Of course, you can graduate and feel more confident in programming. Even then, you can be a bad programmer. Programming is one of these fields, where you always evolving, improving your skills, your mindset, and learning new things. Today, I would like to show you some skills, which are, in my opinion, important for a programmer.

## Precision

In most cases, we always have a lot to do. Everything is important, a high priority. We do too much stuff at the same time. It's hard to focus. This behavior is bad for our precision. Features aren't fully done or done with only a happy path. When you start a task, you should <a href="{{ site.baseurl }}/how-to-focus" title="How to focus?">focus only on this one thing</a>. Do the best you can. Think about the whole flow. Ask the right questions. Try to predict customers' behavior. Understand what your code does. There is a lot to consider during the task. To be more precise, I suggest doing a checklist of what should be done before accepting the task. The definition of done (the overview - the same for all tasks) and the specifications for the current task. You can also ask yourself:
- Is this functionality doing exactly what it should do?
- Is it checked? (Code review)
- Is it tested? (Automated tests, QA)
- Does it match our code standards? Linters, formatters, metrics?
- Does it take care of all possible cases?
- Does it take care of wrong data format, missing parameters, possible errors?
- Do I take care of authentication and authorization in my app?
- Are the names meaningful? Names of files, variables, commit messages, and so on?

Those questions can be even more detailed. You can create your list. The most important is to do your best when you do the code. It's not the same as being perfect. Do what you can to prepare good code, architecture, and so on.

## Engagement

When you get a task, you are fully responsible for this task. Of course, you can look for help, do pair programming, and so on, but you are in charge. You do the research, take care of edge cases, ask questions to understand the task, take care of quality, readability, architecture. Your team is to support you, but you take care of the task from the beginning to the end. Till release on production. I know there are different teams, different approaches for the development process, but the goal is one. Take the responsibility for the task and do everything you can to deliver it the best way you can. Cooperate with others to provide the right information and support. The worst thing you can do is to move your responsibility to someone else. Saying something like: _This is not part of my responsibility. They should do that._ I know that sometimes it will require going out of your comfort zone, but this is the place where you learn the most.

## Independence

When there is a problem, we need to learn to search for solutions. Sometimes it's easy. Just read the documentation. But in other cases, it can be more complex to find the right solution. It will require deeper investigation on Internet forums, articles, or StackOverflow. In most cases, the information you need is somewhere. The skill to resolve problems independently is very useful. Of course, there are some problems where other people's help is needed, but more problems you can solve by yourself, less time you take from other team members.

## Communication

Communication is a big topic, especially in remote teams. The goal is to communicate proactively. In other words: _Tell, don't ask._ Try to accumulate all needed information in one message. Instead of doing a lot of short messages. It can be annoying and distracting. Of course, you don't need to talk about all the small details. Just give the overview. What is working, what not, where are the problems or uncertainties, on what you stuck. Communication is not only meetings or messages on the communicator. It's also how code is written, <a href="{{ site.baseurl }}/names-have-meaning" title="How to improve your names in the code?">naming convention</a>, comments, commit messages, PR/MR (pull requests/merge requests), tasks, or issue description. The idea is to know what was done, even after a few months or years later. You read all information you have, and you don't need to ask what is going on. You know that based on existing documentation.

## Curiosity

Something is working or not, but you don't know why? It's a good time to stop for a moment and check. Maybe there is a bug, and it'll be great to fix it. Or maybe, the functionality is working correctly, but you will learn something about the system. The more you ask those questions, the more you know about the system, and the system is better. It's not always easy, but you can learn a lot from existing code.

## Logical/Analytical thinking

Nothing in the programming world is working magically. It's why logical thinking is so important. To understand what is already done and how to create new functionality in logical steps.

#### Additional useful skills

In the end, I would like to share with you some additional tips, which can help to increase your programming skills:
- <a href="{{ site.baseurl }}/what-is-git" title="What is Git?">learn Git</a> - Git is a powerful tool, which allows you to store the whole history of your project changes. When you know how to use it, it can speed up your work with code. If you want to know more about Git, you can check my series of <a href="{{ site.baseurl }}/category/git" title="Articles about git">articles about git</a>
- <a href="{{ site.baseurl }}/tdd-basic" title="Test-Driven Development for beginners">learn how to test</a> - I know that in some teams, there are testers, who test the functionality, but even this is your team, you should write automated tests, at least for your code. It gives you faster information that something is not working right. It speeds up the development process, and you can be more sure that the code is working as it should. Good test cases are precious.
- learn about project/architecture patterns - It will help you improve your project architecture and structure. And it will help you with team communication. When you have a common language in your team, you can communicate on a specific level of abstraction. You don't need to explain everything. You just say _"Let's use <a href="{{ site.baseurl }}/mvc-design-pattern" title="Introduction to Model-View-Controller design pattern">MVC</a> here."_ and people will know what you're talking about.
- use **Linters** - When you start working in a new programming language or project, the formatting rules can be difficult to remember. Using Linters can help you to adjust to the new convention. You don't need to actively think about that. Linter will show you how the code structure should look.
- use shortcuts - to speed up your work, you can use keyboard shortcuts for your <a href="{{ site.baseurl }}/visual-studio-code" title="Visual Studio Code - shortcuts">text editor</a>, <a href="{{ site.baseurl }}/guake-terminal" title="Guake terminal - shortcuts">terminal</a>, or even browser. In this case, you don't need to switch between mouse and keyboard all the time. You just use one tool every effectively.
- improve your environment - to seep up your work, you can prepare your script, shortcuts, aliases and so on to automated manual repeatable work. It will allow you to focus on more important things and will improve your efficiency
- improve your English skills - this is very important, to be able to communicate in English. In most cases, the knowledge is available only in English. It's also good practice to document the project in English. It will be easier to add a new team member. English is the standard language for IT communication.

## Usefull books
- {% include books/en/pragmatic_programmer-andrew_hund_david_thomas.html %}
- {% include books/en/refactoring-martin_fowler.html %}
- {% include books/en/clean_code-robert_martin.html %}
- {% include books/en/design_patterns_in_ruby-russ_olsen.html %}
- {% include books/en/test_driven_development-ken_beck.html %}
- {% include books/en/practical_object_oriented_design_in_ruby-sandi_metz.html %}
