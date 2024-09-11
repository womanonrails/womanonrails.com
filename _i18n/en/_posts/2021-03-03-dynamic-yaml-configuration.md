---
excerpt: >
  From time to time using Ruby or even more often using Ruby on Rails,
  I need additional configuration with some secret API keys.
  I don't want to save those data in the
  [git repository]({{site.baseurl}}/what-is-git "Introduction to Git distributed version-control system"),
  but it is too early to put them in the database.
  In this case, environment variables can do the trick.
  You put sensitive data to the `.env` file,
  and you don't track this file in the git repository.
  We're done! Not exactly, in my case.
  I wanted to have the structured data in one file.
  So I used the environment variable together with YAML
  (recursive acronym from words _YAML Ain’t Markup Language_) file
  and ERB (Embedded Ruby).
  Let me show you how this looks like.
layout: post
photo: /images/dynamic-yaml-configuration/ruby-yaml
title: Dynamic configuration using YAML in Ruby
description: How to use environment variables in YAML configuration file?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [TIL, Ruby, Ruby on Rails]
imagefeature: dynamic-yaml-configuration/og_image.png
lang: en
---

From time to time using Ruby or even more often using Ruby on Rails, I need additional configuration with some secret API keys. I don't want to save those data in the [git repository]({{site.baseurl}}/what-is-git "Introduction to Git distributed version-control system"), but it is too early to put them in the database. In this case, environment variables can do the trick. You put sensitive data to the `.env` file, and you don't track this file in the git repository. We're done! Not exactly, in my case. I wanted to have the structured data in one file. So I used the environment variable together with YAML (recursive acronym from words _YAML Ain’t Markup Language_) file and ERB (Embedded Ruby). Let me show you how this looks like.

I put my configuration related to Stripe accounts in one YAML file.

```yml
new_york:
  name: 'New York Cafe'
  token: <%= ENV.fetch('NEW_YORK_TOKEN') %>
  secret_api_key: <%= ENV.fetch('NEW_YORK_API_KEY') %>

los_angeles:
  name: 'Los Angeles Cafe'
  token: <%= ENV.fetch('LOS_ANGELES_TOKEN') %>
  secret_api_key: <%= ENV.fetch('LOS_ANGELES_API_KEY') %>
```

As you can see, I used environment variables that will be injected by using `ERB`. Now I only need to get the configuration with all needed data. To do that, I created a method that loads the data for me. In my case, it was a class method.


```ruby
class StripeAccount
  def self.configuration
    YAML.safe_load(ERB.new(File.read('path_to_my_file.yml')).result)
  end

  ...
end
```

Whenever I need this configuration, I run code:

```ruby
StripeAccount.configuration['new_york']['name']
 => "New York Cafe"
```

Of course, if you will use that configuration often, it is better to not load them each time. Just store the configuration, for example, in some variables.
