---
layout: post
title: Git Rebase
description: How can you do rebase?
headline: My code is getting worse, please send more chocolate
categories: [environment, git, tools]
tags: [git, tools]
comments: true
---

I wrote 2 articles about git: [What is git]({{ site.baseurl }}/what-is-git) and [Git usage]({{ site.baseurl }}/git-usage). There are basic information about git. Today I would like to do something more advanced. Last week I did quick presentation/lighting talk about `git rebase`. After that I realize that this is good topic to do short note. So, there you have.

When we use git, we have two ways to pull new changes from remote repository. **Merge** and **rebase**. When we use **merge** (this is default option) git will try resolve conflicts and put our changes between changes of others in our team (using timeline to this). But when we use **rebase**, git move our local changes to temporary area and pull all changes from remote repository. Then one by one will move each our local change to branch but on top of all downloaded changes. We say that rebase move your local changes on top of **HEAD**. We can say that HEAD is something like marker which version is current. When on remote repository are new changes and we don't have this changes locally we say that we are **behind the HEAD**. So when we pull all changes from remote repository we are **on HEAD**.

<figure>
  <a href="{{ site.baseurl_root }}/images/git-rebase/rebase-diagram.png"><img src="{{ site.baseurl_root }}/images/git-rebase/rebase-diagram.png"></a>
</figure>

Ok, let's move now to visual difference between those two method.

## Merge

<figure>
  <a href="{{ site.baseurl_root }}/images/git-rebase/merge.png"><img src="{{ site.baseurl_root }}/images/git-rebase/merge.png"></a>
</figure>

You can see that even someone do some connected commits, after merge all is one big mess. Even more, we see that there are also commits with title merge and we didn't create this commits.

## Rebase

<figure>
  <a href="{{ site.baseurl_root }}/images/git-rebase/rebase.png"><img src="{{ site.baseurl_root }}/images/git-rebase/rebase.png"></a>
</figure>

Here everything is in order. Connected commits are in one group. We also see history of our branches.

## How we can do this when our code is only locally?

1. Switch to develop branch

    ```bash
    git checkout develop
    ```

2. Download all changes lacally

    ```bash
    git pull
    ```

3. Switch to specific branch (branch on which you work)

    ```bash
    git checkout my-branch
    ```

4. Do rebase

    ```bash
    git rebase develop
    ```

5. Push changes to remote repository

    ```bash
    git push
    ```

Sometimes when you use rebase, then it can show some conflicts. You need to resolved them and add changes. Then you can continue rebase.

```bash
git rebase develop
# resolve conflicts
git add -u # add all changes
git rebase --continue
```

We need to talk about one more thing. Sometimes we have our code on remote repository and after rebase we cannot do `git push`. In this case we can use:

```bash
git push -f origin my-branch
```
But! You need to be very **careful**. This command will override all history of change on remote repository for your branch. You must be sure that you don't lose any change. If you work on branch alone, it is safe but when you work on branch with others you need to be sure what you doing.

If you like to abort rebase. You can do that in this way.

```bash
git rebase --abort
```

This is it. I showed you how you can use `git rebase`. I hope this is useful for you. If you have any question or suggestion please let me know in comments. See you next time! Bye!
