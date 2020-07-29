---
layout: post
photo: /images/names-have-meaning/names-have-meaning
title: 'Names have meaning: 13&nbsp;ideas on how to improve names in the project'
description: How good name can positively impact your project?
headline: Premature optimization is the root of all evil.
categories: [refactoring]
tags: []
imagefeature: names-have-meaning/names-have-meaning.png
lang: en
---

As developers, we are often talking about high-level architecture. I mean DDD, hexagonal architecture, and so on. We want to introduce those concepts to our project. We want to do that now! The new concept, new architecture, new language, new framework. We fall into a trap. Technical news is for us like drugs. We want more and more. And we don't think about the consequences. The goal is noble. We want to have a good quality project which can easily adjust to new requirements. Unfortunately, the way we do that is not always the best. We need evolution, not revolution. We need small, conscious steps. Today I would like to discuss one of those kinds of steps. Very important and also very hard. I would like to talk with you about **naming thing**.

## Why naming is so important?

Naming thing?! It's boring! You can think like that, but the truth is different. It's one of the most important parts of programming. How you name things can change your perspective. Can add or remove some information from your context. The information is a powerful weapon in the programmer's hand. If you call one of your classes `User`, what information this name gives you? Well, you can expect that this is a representation of a human, and he is using something. That's all. But if you use a class name like `Guest`, `Gamer` or `Programmer`, you have more information. You know exactly, what that person does, what that person uses. The main question is: Do you need this information? As usual - it depends. You need to know the purpose of this name, what you want to achieve. Sometimes it is enough to have a `User`, but sometimes you need to be more precise.

## New name, new perspective

Changing the name can give you a different perception, even a different context. It can allow you to look at the problem you are facing with from different angles. It's like using six thinking hats by Dr. Edward de Bono. Each hat gives you a different perspective. Each hat focus on a specific area of the problem. The similar effect you can achieve with names. Take a look at the example below.

We want to get information about files from the S3 bucket. Of course, we have AWS SDK for that, but we want to be more specific. Adjust and wrap what AWS SDK gives us. So, we create a **wrapper** for that.

```ruby
module S3
 class Wrapper
   def image_url
   end

   def get_file
   end
   ...
 end
end
```

But wait, we just do file operations. We look for a file path, and we want to read/download the file from S3. Maybe we have something more than `Wrapper`. Maybe this is something like a `File`? A remote S3 file? Maybe we should think about that code not as a wrapper but as a remote S3 file:

```ruby
module S3
  class File
    def public_url
    end

    def read
    end
    ...
  end
end
```

Don't you think that this changed our perspective? I think so. Is the first name wrong? It depends. Our goal is important. We often say: **Context is the king**. The intention has meaning. The thing, we want to achieve. Good names are crucial for understanding the code. Sometimes we need many iterations for the name to be as descriptive as we want to. To show the right perspective on the problem. To be understood in the same way or at least in a very similar way through all the team. And even more, to have the same understanding with a client too. It's the perfect situation when we use the same names/words during the development process not only in a development team but also with a client. We should create our common language - as Domain Driven Design calls it **Ubiquitous Language**. It will allow us not only better understand our domain, our problem, and each other but also to see the right things and the connection between them.

## Create project context by names

We are naming things that have meaning for us. Our words and our language shapes our world (problem or domain). Example from real life. Do you need one word for expressing a person very sensitive to the cold? People in Spain do. This word in Spanish is friolero. Or one word for telling about tiptoeing on hot sand? People in Nairobi have that word - hanyauku. It expresses their culture and the world around them. OK, but back to programming examples.

We have two names in the code:

```ruby
n1n2
n12
```

You can look at these two variables for a long time, and it will be hard to understand their meaning. You can even think that this is a misspelling. Maybe someone just missed one letter `n` in the second variable? You need to go deeper into the code, spent some time reading it to understand what is going on. You will see that both variables are used. They have their declarations, so this is not a mistake. Then you can focus on the meaning. Plants have a scale of growth, which calls BBCH. They can be grouped in different stages of growing, blooming, or giving fruits. So, numbers 1 and 2 are this king of stages groups. Letter `n` is from how much nitrogen is in the soil during that stage. So `n1n2` is a multiplication of `n1` with `n2`. Variable `n12`, on the other hand, is a power of `n1` (multiplication `n1` with `n1`). Is it something you can easily get after reading these names? NO! Those names completely forget about context. They don't explain their meanings, don't create the language of the problem. In this situation, we should create specific language-related to the domain.

I hope those examples convinced you that names have a huge meaning. They can change your perspective, show code from different angles. Help you with understanding the problem, with the creation of the project language. Names can even help you with a better understanding of the project and show you the intention, bigger picture.

## 13 tips on how to improve names in the project

Now, this is a time for some tips to improve your names in the projects:

1. **Name logical steps in your code**

   When you have long calculations in your code, try to split them into smaller steps and descriptively name them. It will allow you and your team to understand the logic faster.

   ```ruby
   def remaining_amount
     total_amount = room_price * days * guest_amount
     paid_amount = room_price * guest_amount
     total_amount - paid_amount
   end
   ```

2. **Names of methods should inform about what they really do**

   For example, if a method changes the state of an object, it should inform you about this change. In Ruby, to do that, we use an exclamation mark `!`. Of course, this is only the names convention, so you can find methods that change the state but don't have an exclamation mark `!`. No matter what, I think this is a good practice to use. The most important is to find a way to inform about what method really does.

3. **Use names for magic, static values in your code**

   Give them meaning. Do not use 24. Instead of 24 use names like `day` and put it in the constant. In Ruby, we write a constant in an upper case like `DAY`. You have 7 in your code. Tell other team members that you mean `WEEK`. It will help you with communication via code.

4. **Use descriptive names**

   No more single-letter names. Use descriptive names for variables, methods, classes, or modules. Create context for your code by using good and descriptive names. Allow other people in your team to quickly understand the code meaning based on names. If the name isn't as precise as it should be, change it. Sometimes you need to do many iterations with the name to get the effect you want. It's normal.

5. **Choose the name to a specific level of abstraction**

   It's a hard one. Sometimes the name can be descriptive, but tells us too much or not enough on a specific level of abstraction. For example:

   ```ruby
   def create_tmp_file(image_path)
     ...
   end
   ```

   I think `image_path` quite good tells what it is. It's a path for an image file. But wait! Is that method only for image files or can be used in a wider context? Maybe the same code can be called for all kinds of files? When we have a name like `image_path` we narrow the usability of this function. It's the name that isn't good at this level of abstraction. Instead of `image_path` use `file_path`. It will show that you can put as an argument any file path.

6. **Use your programming language standards and conventions**

   In Ruby, when you have to return a Boolean value, you should end it with a question mark `?` like `blank?`. When you want to convert an object to a string, you should use `to_s`. There is a lot of this kind conventions. Try to use your language conventions.

7. **Tell what pattern you use**

   I think it can help you with understanding the architecture. Try to use design patterns names in your code. For example, you have a `User` class, and you want to decorate it. You can create a `UserDecorator` class. Maybe even `AdminUserDecorator` if this is what it will decorate. More you are precise in your names, then better.

8. **Use your project standards and conventions**

   When you have a complex domain, your project will need more conventions then only language level conventions. It's why it is a good idea to create your project **Ubiquitous Language** and use it everywhere in the project.

9. **Unequivocal names**

   Try to create names that tell exactly what they really do. Name like `create_record` can be too general for your code. Maybe in your context name `create_blank_record` will be better. Don't afraid long names too much. If you use the name once or twice, it's OK to have a longer, more precise name.

10. **The longer scope, the longer name too**

    If you have a short local scope, like a small loop, it is OK to use a variable like `i` to iterate by some range. But if you have a longer scope, like class scope, it will be much better to use more descriptive names. The longer scope you have, the longer, more descriptive names you should use. It will allow you to know exactly what is inside the variable. Remember also to don't go with long names too much. At some point, long names also can be not clear and bring more complexity then readability.

11. **Do not use prefixes or suffixes with type or sub-domains**

    It's related to Hungarian notation too. Do not create a name like `i_age` because this is an `Integer` type of age value or `CRMInvoice`. It will be better to do `CRM::Invoice`. It will help you to put files into the right directories. If your whole system is a `CRM` it will be even better to get rid of this `CRM` prefix. If your system is more then just the `CRM` module, it can help you separate thinks. Everything depends on your context.

12. **Names should describe side effects**

    If your method searches for a specific object, but also when the object doesn't exist, it creates a new object. You should put that information in your method name. You should have a method name like `find_or_create` instead of just `find`.

13. **Do not use mental shortcuts**

    For you, `id_url` will be an URL for Identity Document, but someone in your team can think about a primary key, the `id` in your database. If you are not sure about the name, ask your team members, they should understand your name in the same way.

That's all tips I have for the creation of the names. Today, I showed you why names are so important and how you can improve your names in the project. I hope it's useful for you. Do you have any other tips for better naming? Share them in the comment section.
