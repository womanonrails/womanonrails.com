---
layout: post
title: What is git?
description: Git - basic
headline: My code is getting worse, please send more chocolate
categories: [tools]
tags: [environment, git, version control system]
comments: true
---

Today I would start quick series about **Git**. This will be 2-3 article about **basic of Git**. Internet has many different articles and tutorials about Git so I don’t want to do another one. If you like get know more about Git I can recommend 2 courses on CodeSchool about it. Start [here](https://www.codeschool.com/courses/try-git).

I don’t give you definition of Git because you can find definition in [wiki](https://en.wikipedia.org/wiki/Git_(software)) or [Git documentation](https://git-scm.com/documentation). I only say that, this is **version control system** and I give you info for what cases or problems we can use Git and why is it great tool.

Do you have sometimes situations where you need to work on the same files with many people. Situations such as: group project in school, university or maybe big web application? Presentation or report for boss? Or other work to do when every one of team members need to share the same files. And everyone can change any files in this project. I have this situation all the time in my work. I work on web application where I cooperate with about 8 people. Or maybe you work just by your self but you don’t want to loose your changes. Maybe you are writer and you write book. So what can it goes wrong?

## Only my work

We work alone. For example we are writing book. We are working on this project through last 2 years. And something happened: computer breaks down, we removed file through mistake, or we change something and the previous version was better and we want get back this version. What then? I know we have many choices: Dropbox, hard drive (just in case), send emails to my self. Even programs do this easy for us. They remember history of last changes and so on. But Git can handle this too. Git remember all yours files changes history. You can get back to any of your files version.

If you don’t now why Git can be better solution for some problems, we have second example. ;]

## Team case

Every one in team has they own computer so they have locally on computer copy of our project. For example we have one file. We love Ruby so this file has Ruby code:

```ruby
# hello_world.rb
def hello
  "hello"
end
```

So every one have this file locally on this computer. Now I have task to change this method to return no `hello` but `hello world`. So I change this file:

```ruby
# hello_world.rb
def hello
  "hello world"
end
```

Now I need to send to all of team members this new code. How do this? E-mail? Dropbox? Pendrive? Each of this solutions can be painful. So we have problem one. **1. Actualization of our project (how have access to current version).**

This problem we can somehow resolved. But what happened in this situation. Someone in team change something in the same file as I. For example change method name but he/she don’t know that I working on this file in the same time. So his/her code looks like this:

```ruby
# hello_world.rb
def say_hi
  "hello"
end
```

Now I send my change to everyone (somehow) and the other person sends his/her changes also. Which changes are last changes? My or the other person? Or maybe we would like to have something like that:

```ruby
# hello_world.rb
def say_hi
  "hello world"
end
```

All changes together. How we can resolve this problem? We can have some one in team who will take care of this. We can talk with this person, tell what we changed and then this person need to go though all files check and figure out how fix conflicts. Do you also think that this is not good idea? Even worse. This is catastrophically bad idea and who wants to be this person? So second and I think the most important problem **2. how merge all changes together easily?**

Do you see that this is painful? Even more than the first example. Yes? I think that too.

So Git can resolved this problems for us in most cases automatically. So Git is tool to help with cooperative projects. But! (there is always some but) It is good for text files (programs, books, articles) but not good for images. Image is binary file no text file (in most cases excluded for example svg). When we change something in this file we can not read in easy way those changes.

Example:
Our image have this inside:

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

Our computer can interpret this in colors and shapes but we can’t. So when we change something on this image (one or more bits), we don’t even know what was this change. Do you know what I mean? I don’t say that we never put images to git. I say that we can not see what changed (in simple way).

I hope that this article help you to understand for what we use git and why it is helpful. In next article I describe how we can use it. If you have some question or suggestion please let me know in comments. See you next time. Bye!
