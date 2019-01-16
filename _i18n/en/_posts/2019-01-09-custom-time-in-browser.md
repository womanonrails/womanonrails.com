---
layout: post
title: How to use custom time in browser to manual tests for app?
description: Custom time in browser without changing your default setups.
headline: Premature optimization is the root of all evil.
categories: [tools]
tags: [TIL, browser, Linux]
comments: true
---

I don't like changing my setups when they work fine. This time, I wanted to test some functionality in the project in different time zones. I found a way to do that independently to my existing setups.

I work in a project where we use some external API to get weather data and display them to the user. There was a problem with missing values in a specific range of time. For example, when you asked about data for October you would get one day less. So you do not get 31th of October. If you asked about September, everything was fine. The problem was related to the change from CEST to CET time. In 2018 it happened on 28th of October. Missing hour in this day effected last day of this month. After fixing this problem, I wanted to be pretty sure that everything is working in Europe, but also for other countries in the world. I planned to do a manual testing for that. It is possible to change time zone for your entire system or for browser, but I had bad experience with this approach in the past. This trick completely desynchronized my calendar and notifications about meetings in it. So I didn't want to get the same problems twice.

While searching for answers in Google, I found a clever idea to change time in the Chrome browser, but without changing your default settings. You need to create a separate folder for the new profile (name depends completely on you, I used `chrome-profile`):

```bash
mkdir $HOME/chrome-profile
```

then you need to specify time zone by `TZ` parameter:

```bash
TZ='US/Pacific' google-chrome "--user-data-dir=$HOME/chrome-profile"
```

and after all this testing you can remove this profile:

```bash
rm -rf $HOME/chrome-profile
```

That's it! You can use your browser with different time zones right now. There is one quick note here. You need to know **the right name of time zone**. This is important for people like me, who do lots of misspellings. In case you will use wrong name you **will not get error** and your browser will **open in default time zone**.

Thanks for reading and see you next time! Bye!
