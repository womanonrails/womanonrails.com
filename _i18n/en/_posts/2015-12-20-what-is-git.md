---
layout: post
title: What is git?
description: Git basics - Why we use git?
headline: Premature optimization is the root of all evil.
categories: [tools]
tags: [environment, git, version control system]
lang: en
---

If you are interested in IT or you are already a programmer, you should hear the name **Git** at least a couple of times. Maybe even more. This tool is common to many teams no matter what programming language they use. This is the base and it is good to know git. Today, I would like to start a short series about **Git basics**. On the Internet, you can find many articles and tutorials about how to use git. I would focus more on what is the purpose of using git and how it works. In this article, I will explain to you what git is and why it is important to have that tool in your toolbox. Let's get started!

## What is git?

Git is a **distributed version-control system**. It's a tool for managing different versions of your system/application. So you can have a different version of your system and they don't need to be in one central place. The version of your system can be distributed/spread to many computers. One version can be on your laptop and another one can be on your colleague computer.

You can think about git as it is a game playing. You start playing a game and at some point in the game, you would like to save the stage, just in case you lose your life when you will fight with the boss. You don't want to lose the levels you already achieved. This can be boring and irritating to do the same work twice. The same with git. You save a stage of your current work, to not lose it. And also probably to compare with other team members.

## When we should use git?

In short - everywhere. Just kidding, almost everywhere ;] Use git in projects where very important is the teamwork and the confidence that you don't lose your data. Maybe you work just by yourself. You are a writer and you write a book. Or maybe you have situations where you need to work on the same files with many people? Situations such as group projects in school, university, or maybe big web application? Presentation or report for a boss? Or other work where everyone in a team needs to share the same files and change them? Those are situations where git is very useful. I have those situations all the time in my work. I work on web applications where I cooperate with about 8 people.

### Work alone

You work alone. For example, you're writing a book. You're working on this project over the last 2 years. And something happened: computer breaks down, you removed the file by accident or you change something and the previous version was better, so you want to get back this old version. What then? I know we have many choices: Dropbox, Google docs, hard drive (just in case), or sending emails to yourself. These programs do our life easier. They remember the history of the last changes and so on. But git can handle this too. Git remembers the history of all your changes. You can get back any version of your files, you want.

If you don’t know why git can be a better solution for some problems, I have the second example - team working. ;]

### Work with a team

Everyone in a team has a computer. They have a copy of the project locally. For example, you have one file. I love Ruby, so this file is written in Ruby:

```ruby
# hello_world.rb
def hello
  "hello"
end
```

Everyone has this file locally on their computers. Now you have a task to change this method to return no `hello` but `hello world`. So you change this file:

```ruby
# hello_world.rb
def hello
  "hello world"
end
```

Now you need to send this new code to all of your team members. How to do that? E-mail? Dropbox? Pen drive (USB flash drive)? Each of these solutions can be painful. So we have the first problem. **Project synchronization. How to have access to the last version of the project?**

This problem we can solve somehow, even if the solution can be time-consuming. But what happened in the next situation. Someone in your team changed the same file as you changed. For example, your colleague changed the method name but he doesn’t know, that you were working on this file at the same time. So his code looks like this:

```ruby
# hello_world.rb
def say_hi
  "hello"
end
```

Now you send your changes to everyone and your colleague does the same. Which changes are the last ones? Yours or the other person? Or maybe you would like to have something like that:

```ruby
# hello_world.rb
def say_hi
  "hello world"
end
```

All changes together. How we can resolve this problem? We can have someone on the team, who will take care of this problem. We can talk with this person, tell her what we changed. Then this person needs to go through all files check them and figure out how to fix these conflicts. Do you think that this is a bad idea? Me too. This is even worse, then you expect. This is a catastrophic idea and who wants to be this person? Do you see how painful this can be? Even more than in the first example. So second and I think the most important problem is: **How to merge all changes easily?** So git can resolve these problems for us in most cases automatically. So **Git is a tool to help with cooperative projects**.

### Binary files in git

Is git created to work with all file types? Not exactly. There is an exception. Git is good for text files (source code, the text of books, or articles) but it isn't good for images, videos, or any other binary files. This is related to the git way of handling changes. Git remembers changes in lines, so this is why it is good for text files. Each text is composed of many lines. When you change one line you just see how the line was looking before and after the change. In the case of binary files, files that are composed of bits, it's more difficult. For example, when we open our image directly, inside it can look like this:

```
00000000  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
00000010  00 00 04 c9 00 00 01 7e  08 06 00 00 01 ef a0 7d  |.......~.......}|
00000020  68 00 00 00 09 70 48 59  73 00 00 2e 23 00 00 2e  |h....pHYs...#...|
00000030  23 01 78 a5 3f 76 00 00  00 19 74 45 58 74 53 6f  |#.x.?v....tEXtSo|
00000040  66 74 77 61 72 65 00 41  64 6f 62 65 20 49 6d 61  |ftware.Adobe Ima|
00000050  67 65 52 65 61 64 79 71  c9 65 3c 00 00 36 8c 49  |geReadyq.e<..6.I|
00000060  44 41 54 78 da ec 9c 61  6e 83 30 0c 46 47 c4 85  |DATx...an.0.FG..|
00000070  a6 75 47 da a9 76 a4 75  da 91 98 f8 41 95 a6 31  |.uG..v.u....A..1|
...
```

Our computer can interpret this in colors and shapes but we can’t. So when we change something in this image (one or more bits), we don’t even know what the change was. Although we have a specific program, that will interpret these bits for us, like image explorer. I don’t say that we never put images to git. I say that we can not see what changed easily.

### Next articles in this series:
- <a href="{{ site.baseurl }}/git-usage" title="How to start using git?">Basic commands in git</a>
- <a href="{{ site.baseurl }}/git-rebase" title="What is a difference between git merge and git rebase?">How can I use git rebase?</a>
- <a href="{{ site.baseurl }}/replace-parent-branch" title="Setting git parent pointer to a different parent.">How to replace parent branch in git?</a>
- <a href="{{ site.baseurl }}/git-rebase-onto" title="Git rebase --onto an overview.">How to use git rebase --onto?</a>
