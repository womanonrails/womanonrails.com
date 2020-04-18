---
layout: post
title: Regular expressions - what can go wrong?
description: Regular expression is just a tool. We, as programmers, need to use it responsible.
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, regular expressions]
lang: en
---

Someone said: _If you have a problem, use regular expressions. You will have two problems._ That's true. At least in some cases. As a programmer, we should be responsible for our code. We should think twice about all possible usage of our code. And also, do tests for it ;]. Today I would like to share an example with using regular expressions, but without enough preparation and testing. I would like to show what was wrong and how I fixed it. This is a case study. I will not introduce the concept of regular expressions, but I will show you, what you need to consider during using them.

I got a bug to fix. That's usually a start of a story. So, I got bug in one text area. In this text area user can put a list of emails, which should be imported as contacts to the application. The problem was that only some of those emails were imported and some of them not. My task was to discover the reason and resolve the problem. I like to think about myself as a detective in this case. I started my investigation.

This is how the Ruby code looks like for this feature:

```ruby
emails = params[:enter_emails].delete(' ')
if emails =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  emails = emails.split(/,/)
  # do something (for example add to contact list)
else
  # render error
end
```

The input for this code was just a string. We remove all space between parts of this string and then we check regular expression. If string fits to this expression, we split it by comma. And then do something with this data. For example, add to contact list. These are two main problems with this code:

  1. **Splitting by comma** - What if the user will use a semicolon or just one space or new line? This is a simple text area, he can do that. We are not able to check that.

  2. **Validation only the last part of string** - When we look closely we will see this problem. When we put as input: `"aaa@excom, bbb@ex.com"` it will be valid. And when we put `"bbb@ex.com, aaa@excom"` it won't.

What is going on? To see that kind of problems, it is good to check how our regular expression behaves for different edge cases in console or in some tool. I use and recommend
{% include links/external-link.html
   name='Rubular - Ruby regular expression editor'
   url='https://rubular.com/' %}.
At least for Ruby people. It is simple, but very useful website where you can check your regular expression.

<figure>
  <a href="{{ site.baseurl_root }}/images/email-regular-expressions/rubular.png"><img src="{{ site.baseurl_root }}/images/email-regular-expressions/rubular.png" title="Rubular - regular expressions" alt="Matching of regular expression"></a>
</figure>

As you can see we only check the last part of the string.The last email address. When the last email is valid whole string is valid no matter what you have in the beginning. That's not good. There are many possibilities to fix that problem. I decided to first split string and then check email's regular expression. For splitting I used `/\s+|\s*,\s*|\s*;\s*/`. So, I split the text by whitespace, commas and semicolons. There is one more thing to mention. When you split using this regular expression then you will get empty strings in array, like in the example below:

```ruby
emails = "aaa@excom,, , ,  bbb@ex.com aa".split(/\s+|\s*,\s*|\s*;\s*/)
 => ["aaa@excom", "", "", "", "bbb@ex.com", "aa"]
```

It can be enough for you or you'll need to take care of your empty strings in the array. After that you can, for example, check validation of each element of the array:

```ruby
emails.all? { |email| email =~ /\b[A-Z0-9._%a-z\-\+]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
 => false
```

or just choose valid elements:

```ruby
emails.select { |email| email =~ /\b[A-Z0-9._%a-z\-\+]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
 => ["bbb@ex.com"]
```

Do whatever fits the best for you.

You can ask now, why you share that? What was your purpose? The answer is simple. I see that everywhere. We, as programmers, sometimes do not pay too much attention to resolving problems or we just rush too much. In this situation we introduce new bugs to the application. And maybe sometimes it's ok, but ask yourself, do you want to go into surgery when doctor do not pay attention to your body? I know that some of our bugs are not so critical, but what if it is related to some formal documents or splitting dosage of medicine or maybe driving a car? In book "The Little Prince" the fox said: _"You become responsible, forever, for what you have tamed"_. In this situation I say: _"You become responsible, forever, for what you have coded"_.

If you want, share your thoughts in the comments below. Thanks for reading! See you next time. Bye!



