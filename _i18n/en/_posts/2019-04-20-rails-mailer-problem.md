---
layout: post
title: Why you should not use mailers inside Rails model?
description: Case study - what can go wrong when you work with mailers and workers in the same time in Rails?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby]
lang: en
namespace: rails-mailer-problem
---

Sending emails in web application to users is very often process. We send emails related to registration, new changes in application, advertising, last activities or friends' invitations. This is very common. Even we create that functionality in ours apps frequently, we still have bugs there. I would like to share with you one of the bugs examples.

As humans, we have, problems with doing things in parallel. We are not multitasking beasts. Always something or someone is suffering, when we switch to parallel process. Sometimes it is something trivial, that we don't know what was the last paragraph of read book. But sometimes it is more important. For example, driving a car and talking by phone. It is sad to say, but I see that often on the road. People changing lane, even didn't notice that. They cannot find a way or even don't see the car in front of them. This can provide to accidents. So, please do not drive and use your phone at the same time. But back to the topic. The same problem, which we have in our cars, we also have with a parallel work, do it by computer. It is hard to understand. It is possible, but hard to do. It is hard to imagine, what can go wrong, when our code is running parallel. It is much easier to understand sequential code. First this and then that. We see step by step, what will be run, what will be called. This is why we don't like callback in JavaScript ;] It is hard to predict in which state, our system will be, when callback will start running.

In example, which I would like to show you, is one of this _parallel_ examples. I found this bug some time ago. And it was there before I even started working in this project. In this application, there was possible to invite a friend. When the user wanted to invite his friend to the app, two things happened in parallel. One, the application created invitation object and saved it into the database. Second, application was sending email to the user's friend. When application was small and everything was in one place invitation process looks OK. Everything was fine. But then, the application started to grow. Infrastructure changed. Database, workers, core application and other services went to dockers containers. Many queues were created for workers. Service for handling emails had also its own queue. And something was not right.

## Problem

When a user sends invitation to his friend, we get information from Sidekiq (a tool for background processing in Ruby), that this invitation is not found in database. I checked that based on what we had in logs and everything looks fine. Invitation in database exist. After some time Sidekiq retry to run process for sending emails with success. At first I thought, _This happened only one time, maybe this is some kind of a  mistake?_ I decided not to investigate this problem and just monitor the application. Record in DB exists, mail was sent to the user. Nothing to worry. But the problem came back. This time I am known, that this was not a mistake and something is wrong. I started debugging this problem. At first, I looked to code and I get:

```ruby
class Invitation < ActiveRecord::Base
  after_save :send_invitation_email

  # (...)

  def send_invitation_email
    AppMailer.invitation_email(
      user_id: user.id, recipient_email: email, invitation_id: self.id
    ).deliver_later
  end
end
```

The code was ok. Not great, but nothing very complex. I had `after_save` callback and simple method using mailers. When I try to reproduce this problem locally, never happened. So for debugging this problem only staging environment was helpful.

## Finding the reason

After some time I understood, what was the problem. First, very important is the order of callback in Rails models:

```ruby
before_validation
after_validation
before_save
around_save
before_create
around_create
after_create
after_save
after_commit/after_rollback
```

As you see `after_save` isn't the last one. I already had id for our invitation, but this invitation is still not persist and in the database. Second, this problem with `Invitation not found` happened only when our Sidekiq had no work to do. So, when queue is empty. Our process related to sending email was so fast, that it was faster than saving a record in the database (finishing transaction related with save). So, looking below on this scheme actions (1) and (2), were faster, then (3).

<figure>
  <img src="{{ site.baseurl_root }}/images/rails-mailer-problem/mailer-in-rails-model.jpg" alt='Scheme model - database - worker'>
  <figcaption>Scheme of saving invitation in database and sending email</figcaption>
</figure>
<br>

Don't you think it isn't intuitive? It is logical, when you know that already, but it is not intuitive. At least, not for me.

## Posible solutions

We have three possible solutions:

- change `after_save` to `after_commit`  - We will be pretty sure that the record is in the database, but our model will still take care of sending emails.
- change `deliver_later` to `deliver_later(wait: 10.seconds)` - It is not ideal, because what if saving a record in the database will take longer?
- extract completely sending email from model - This is not responsibility of the model, to send any emails. I think we should create some kind of process (we can call it service or workflow) to do a sequence of steps when a user wants to invite a friend to our app.

I think the last solution is the best. We should remove all external actions, not related to data persistency out from the model.

Which solution you will choose and why? Or maybe you see another solution? Let me know in the comments below. If you like this article share with your friends and I will be so grateful for all your feedback.
