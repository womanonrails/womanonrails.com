---
layout: post
photo: /images/screenshot-in-the-browser/screenshot-in-the-browser
title: Screenshot directly in the browser
description: How to do a precise screenshot using only the browser?
headline: Premature optimization is the root of all evil.
categories: [tools]
tags: [TIL, browser, Linux]
imagefeature: screenshot-in-the-browser/og_image-screenshot-in-the-browser.png
lang: en
---

When you are web developer, sometimes you need to do a screenshot of your work. In most cases, you just use the `Print Screen` key for that. Then, of course when you use Linux operating system, you open a graphic editor like GIMP to cut an important part. Or maybe you need to do a screenshot of the entire website? Then you use a couple of times `Print Screen`, or you use some extension in the browser. But there is an easier way to do that. You can use a screenshot built in your browser. Let's check out how to do that.

First of all, this will work in your **Google Chrome** and **Chromium** browsers. You can do that in three steps:
  1. Press `Ctrl + Shift + I` or `Ctrl + Shift + C` - this will open Element Inspector (Webkit dev tools) in your browser.
  2. Press `Ctrl + Shift + P` - this will open Command-Line to search through the developer's tools.
  3. Type _screenshot_ - this will show you four possible ways to do a screenshot, you just need to choose one which fits you well.

<img src="{{ site.baseurl_root }}/images/screenshot-in-the-browser/screenshot.png"
     alt='Command-Line for screenshot in the browser'>

Since we know how to do this screenshot in the browser, let's check what we can do here. What options are available?
  - **Capture area screenshot** - This is my favorite one. When you choose this option, you can select the area in your browser, which will be visible on the screenshot. No more cutting full screen after using the `Print Screen` key. Your image will be downloaded directly to the Download directory with the name of the website.
  - **Capture full-size screenshot** - This will do a screenshot of the entire website. You don't need to worry about scrolling down or using some extension to do that.
  - **Capture node screenshot** - This will allow you to do a screenshot of some specific node (HTML tag) you choose. So first, select the node in the Element Inspector and then do the screenshot. I don't use this option at all. I think the **Capture area screenshot** is more flexible and can do similar things like this one. Try it yourself, if it fits you well.
  - **Capture screenshot** - This will behave like a normal `Print Screen` key. It saves an image of what you currently see on your screen.

That's it! The short tip about using a native screenshot in the browser. Is it useful for you? Let me know in the comments below.
