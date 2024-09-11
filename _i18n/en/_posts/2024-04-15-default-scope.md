---
excerpt: >
  Do a quick online search for "Rails Default Scope"
  and you will get a ton of articles:
  why you should not use default scope at all,
  why default scope is the root of all evil,
  how to remove default scope from your project.
  These articles often have a strong negative opinion
  about default scope.
  But is default scope really that bad?
  The default scope discussion has been going on since at least 2015,
  almost a decade of Rails development,
  and people are still talking about it.
layout: post
photo: /images/default-scope/default-scope-header
title: Rails Default Scope Overview
description: What you don't know about Default Scope?
headline: Premature optimization is the root of all evil.
categories: [programming]
tags: [Ruby, Ruby on Rails]
imagefeature: default-scope/og_image.png
lang: en
---

Do a quick online search for "Rails Default Scope" and you will get a ton of articles: why you should not use default scope at all, why default scope is the root of all evil, how to remove default scope from your project. These articles often have a strong negative opinion about default scope. But is default scope really that bad? The default scope discussion has been going on since at least 2015, almost a decade of Rails development, and people are still talking about it.

Let's face it: in most cases, these articles make good points about why default scopes can be risky. But does that mean you should never use them? If default scopes are so problematic, why does Rails still have them after all these years? Could there be specific scenarios where default scopes are actually beneficial and safe to use? In this article, I'll break down default scopes, explain how they work, and explore whether they have any place in modern Rails projects. Let's dive in and find out together!

{% include toc.html %}

## What is the `default_scope`?

Based on [api.rubyonrails.org documentation](https://api.rubyonrails.org/v7.1.3.2/classes/ActiveRecord/Scoping/Default/ClassMethods.html#method-i-default_scope "Ruby on Rails documentation - default_scope") for Rails 7.1 `default_scope` is a macro in a model to set a default scope for all operations on the model. So, we can narrow down all operations on the model to a specific order or query.

## How to create a default scope?

```ruby
class Article < ActiveRecord::Base
  default_scope { where(published: true) }
end
```

There is a second way to declare `default_scope`:

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
end
```

The default scope defined this way will limit the `.all` query to published articles only.

```ruby
Article.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true
```

Since the default scope has the following definition:

```ruby
def default_scope(scope = nil, all_queries: nil, &block)
  scope = block if block_given?

  if scope.is_a?(Relation) || !scope.respond_to?(:call)

  # [...]
end
```

We can have a little fun with creating a default scope. First, we can create [`Proc` object]({{site.baseurl}}/functional-programming-ruby#proc-object "
Proc object in Ruby") and provide it as an argument to `default_scope` in two ways:

```ruby
class Article < ActiveRecord::Base
  published_articles = -> { where(published: true) }

  default_scope(all_queries: true, &published_articles)
  default_scope(published_articles, all_queries: true)
end
```

It's possible because when [block]({{site.baseurl}}/functional-programming-ruby#blocks-in-ruby "Blocks in Ruby") is provided it is assigned as scope inside `default_scope` definition. The second trick we can do is to prepare a class that has a `call` method. It's the only condition we need to fulfill to be able to create our `default_scope`.

```ruby
class PublishedScope
  def initialize(context)
    @context = context
  end

  def call
    context.where(published: true)
  end

  private

  attr_reader :context
end


class Article < ActiveRecord::Base
  default_scope(PublishedScope.new(self), all_queries: true)
end
```

This allows us to extract scope logic into a separate class/context.

One more note at the end of this section. If you are wondering if you can have, for example, date/time calculations in the scope, the answer is yes. Since we have `Proc` in a block that is calculated each time the default scope is run, we don't have to worry about the date/time freezing.

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where('created_at > ?', Time.current) }
end

Article.all
# SELECT "articles".* FROM "articles" WHERE (created_at > '2024-04-29 10:16:38.292367')

Article.all
# SELECT "articles".* FROM "articles" WHERE (created_at > '2024-04-29 10:18:49.980174')
```

## Default scope vs. creating/building of new object

When we use the default scope, we need to remember that the `default_scope` is also applied when we create/build a record. So if you have default scope:

```ruby
class Article < ActiveRecord::Base
  default_scope { where(published: true) }
end
```

The `published` attribute is set to `true` for all built and created records:

```ruby
Article.new
# => #<Article id: nil, title: nil, published: true, created_at: nil, updated_at: nil>
```

Depending on your needs, this may or may not be expected behavior. In the case of articles, where usual flow is first a draft and then a published article for all readers, it can be problematic. So while you want to make sure you don't accidentally list unpublished articles, you now create published articles by default.

So the important thing to remember is that **`default_scope` will always affect your model initialization and creation**. Of course, there is a way to override the default value during initialization, but this is one more thing to remember:

```ruby
Article.new(published: false)
# => #<Article id: nil, title: nil, published: false, created_at: nil, updated_at: nil>
```

## Default scope vs. object update

**By default, `default_scope` is not applied when a record is updated**.

```ruby
article = Article.last
# => #<Article id: 1, title: 'Default scope overview', published: false, created_at: ..., updated_at: ...>

article.update(title: 'Default scope - user manual')
# => #<Article id: 1, title: 'Default scope - user manual', published: false, created_at: ..., updated_at: ...>
```

If you want to apply a `default_scope` when updating or deleting a record, add `all_queries: true` to your `default_scope` declaration:

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }, all_queries: true
end
```

then you will get

```ruby
article = Article.last
# => #<Article id: 1, title: 'Default scope overview', published: false, created_at: ..., updated_at: ...>

article.update(title: 'Default scope - user manual')
# => #<Article id: 1, title: 'Default scope - user manual', published: true, created_at: ..., updated_at: ...>
```

If you use `all_queries: true`, remember that the default scope is applied to **all queries**. So this is what you get when you delete the object:

```ruby
Article.find(1).destroy
# DELETE FROM "articles" WHERE "articles"."id" = ? AND "articles"."published" = ?  [["id", 1], ["published", true]]
```

Only published records are deleted. This behavior may surprise you when you try to remove a record that is not published.

One more thing to add to this section. I told you that by default `default_scope` is not used for updates. This is only true for updating one object. **In case of `update_all` the default scope will be used**, even if you didn't set `all_queries: true`. If you want to do all articles published by:

```ruby
Article.all_update(published: true)
# UPDATE "articles" SET "published" = ? WHERE "articles"."published" = ? [["published", true], ["published", true]]
```

You will still have objects in the database with `published: false` because of the narrowing of the query during `update_all`. The same situation will happen for `destroy_all` - default scope will narrow the query.

## Multiple default scopes

You can use multiple default scopes in a model, they will combine

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
  default_scope -> { where(archived: true) }
end
```

and you will get:

```ruby
Article.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true AND "articles"."archived" = true
```

In this case, both attributes are set during object initialization.

```ruby
Article.new
# => #<Article id: nil, title: nil, published: true, archived: true, created_at: nil, updated_at: nil>
```

If you want to check all the default scopes on your model, you can use:

```ruby
Article.default_scope

# =>
# [#<ActiveRecord::Scoping::DefaultScope:0x00007fb1157117e0
#   @all_queries=nil,
#   @scope=#<Proc:0x00007fb115711880 .../app/models/article.rb:17>>,
#  #<ActiveRecord::Scoping::DefaultScope:0x00007fb1157115d8
#   @all_queries=nil,
#   @scope=#<Proc:0x00007fb115711600 .../app/models/article.rb:18>>]
```

You will see all the places in the code where you have default scope declarations for your `Article` model.

## Default scope vs. inheritance

In the case of inheritance and module includes, where the parent or module defines one `default_scope` and the child or including class defines a second, these default scopes will be linked together as they are when default scopes are in the same model.

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
end

class ArchivedArticle < Article
  default_scope -> { where(archived: true) }
end
```

So our `ArchivedArticle` will have two scopes, being `published` and `archived` at the same time:

```ruby
ArchivedArticle.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true AND "articles"."archived" = true
```

I want to mention one thing here. The idea of adding a default scope for the `Article` class as a general class for articles is not a good idea in most cases, because we don't expect this behavior in the `Article` class. For a subset of articles like `ArchivedArticle`, where the name of the class already tells us about a specific type of article, the default scope can be useful.

## Default scope vs. association

Let's say we have two models: `Article` which can be created by `Author`. Each article can be created by an author, and an author can have multiple articles.

```ruby
class Author < ActiveRecord::Base
  has_many :articles, dependent: :destroy
end

class Article < ActiveRecord::Base
  belongs_to :author
  default_scope -> { where(published: true) }
end
```

If we try to select all articles for a specific author, the default scope will apply to our query and we will get only published articles - **`default_scope` will apply to model associations**.

```ruby
author.articles
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = ? AND "articles"."author_id" = ? [["published", true], ["author_id", 1]]
```

Let's say we want to remove author and all of his articles. Without default scope we could just do `author.destroy`, but if the articles have default scope the expected behavior will be different than what actually happens. Calling `author.destroy` will delete all articles that are `published`, but it won't delete articles that are `unpublished`. Therefore, the database will throw a foreign key violation because it contains records that reference the author we want to remove. It's important to keep this in mind.

## Default scope vs. overriding default scope value

Let's say our default scope on `Article` is the order of the items:

```ruby
class Article < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
end
```

and now instead of ordering by `created_at` you want to order by `updated_at`. The `Article.order(updated_at: :desc)` will not do what you expect. In this case we will get similar behavior as in the case of inheritance - scopes will accumulate. So you will see:

```ruby
Arcicle.order(updated_at: :desc).limit(10)
# SELECT "articles".* FROM "articles" ORDER BY "articles"."created_at" DESC, "articles"."updated_at" DESC LIMIT 10
```

It sorts articles by both `created_at` and `updated_at`, the default scope is not overridden, you need to use `unscoped` to explicitly disable the default scope.

```ruby
Article.unscoped.order(updated_at: :desc).limit(10)
# SELECT "articles".* FROM "articles" ORDER BY "articles"."updated_at" DESC LIMIT 10
```

But be aware that `unscoped` can be tricky. See below.

**One note**. If you are interested in specific order of your records check the `implicit_order_column` method in Rails.

## Default scope vs. `unscoped`

Unscope allows us to remove unwanted scopes that are already defined on a chain of scopes. This means that if you only want to remove one scope, you can do that, but you can also remove all of them at once.

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
  default_scope -> { where(archived: true) }
end
```

So if you use `unscoped` you will remove all scopes.

```ruby
Articles.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true AND "articles"."archived" = true

Articles.unscoped.all
# SELECT "articles".* FROM "articles"
```

But there is a way to remove only part of our default scope. In this case, you need to pass a specific argument to the `unscope` method.

```ruby
Article.unscope(where: :archived).all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true

Article.unscope(where: :published).all
# SELECT "articles".* FROM "articles" WHERE "articles"."archived" = true
```

We also need to remember that the order of scopes and unscopes is important. If you unscope first and then add a new scope, you will clean up the scope and provide a new one:

```ruby
Article.uncoped.where(title: 'Default scope overview')
# SELECT "articles".* FROM "articles" WHERE "articles"."title" = 'Default scope overview'
```

but if you change the order of these methods, you will remove all scopes, including this new `where`:

```ruby
Article.where(title: 'Default scope overview').uncoped
# SELECT "articles".* FROM "articles"
```

Interesting case we can get with unscope while using asociations.

```ruby
class Author < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :author
  default_scope -> { where(published: true) }
end
```

As we discussed earlier, when we use articles for specific authors, those articles are limited to the default scope:

```ruby
Author.first.articles
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = ? AND "articles"."author_id" = ? [["published", true], ["author_id", 1]]
```

but when we try to unscope articles, we no longer have the author condition.

```ruby
Autor.first.articles.unscoped
# SELECT "articles".* FROM articles
```

So it's important to remember that **`unscoped` removes ALL scopes that might normally apply to your select, including (but not limited to) associations**.

To do this unscope in a correct way we need to unscope only the `published` scope:

```ruby
Author.first.articles.unscope(where: :published)
# SELECT "articles".* FROM "articles" WHERE "articles"."author_id" = ? [["author_id", 1]]
```

## Several ways to override the default scope

Let's define our class again, as shown below:

```ruby
  class Article < ActiveRecord::Base
    default_scope -> { where(status: :published) }
    scope :archvied, -> { where(status: :archived)}
  end
```

We have several options to get what we want. Get only archived articles, whether they are published or not.

We can use `unscoped` and then the `archived` scope:

```ruby
Article.unscoped.archvied
# SELECT "articles".* FROM articles WHERE "articles"."status" = 'archived'
```

We can use `unscope` specific scope:

```ruby
Article.unscope(where: :state).archvied
# SELECT "articles".* FROM articles WHERE "articles"."status" = 'archived'
```

We can use `rewhere`:

```ruby
Article.rewhere(state: :archived)
# SELECT "articles".* FROM articles WHERE "articles"."status" = 'archived'
```

If your scope uses order, you can use the `reorder` method.

## Summary

- If you don't understand how default scope works, it can bring you a lot of trouble: long debugging time, unexpected behavior, strange problems, lack of readability, and more.
- Default scope can get really complicated, especially when used with associations or inheritance.
- The `default_scope` behaves similarly to the [ActsAsParanoid gem](https://github.com/ActsAsParanoid/acts_as_paranoid "Gem ActsAsParanoid"), so in case of this gem I also suggest caution. Think twice before using it.
- We can also think of `defaul_scope` as being similar to global state or singleton. We have to be sure what we are doing. These are useful tools, but used without enough caution can be dangerous ;)
- The `default_scope` is in my opinion a tool that should be used in very specific and rare cases, but I can't agree that it is the root of all evil ;)
- In my opinion, the biggest problem with `default_scope` is using it implicitly - hidden in code. When we do that, all the problems with understanding the logic, debugging, and strange behavior start. So I think it is more of a communication problem. Use `default_scope` explicitly.

## Sources

- [Why is using the rails default_scope often recommend against?](https://stackoverflow.com/questions/25087336/why-is-using-the-rails-default-scope-often-recommend-against "Stack Overflow thread about default_scope")
- [Using Default Scope and Unscoped in Rails](https://blog.jasonmeridth.com/posts/using-default-scope-and-unscoped-in-rails/ "Jason Meridth article about default_scope and unscoped")
- [How to Carefully Remove a Default Scope in Rails](https://singlebrook.com/2015/12/18/how-to-carefully-remove-a-default-scope-in-rails/ "Jared Beck article about removing default_scope")
- [Beware of using default scope](https://coderwall.com/p/khht6a/beware-of-using-default-scope "Interesting facts about default_scope")
- [`default_scope` - Ruby on Rails documentation](https://api.rubyonrails.org/classes/ActiveRecord/Scoping/Default/ClassMethods.html#method-i-default_scope "Ruby on Rails documentation - default_scope")
