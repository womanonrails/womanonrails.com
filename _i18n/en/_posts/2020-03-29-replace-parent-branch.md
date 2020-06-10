---
layout: post
title: How change parent branch in git?
description: Setting git parent pointer to a different parent with git rebase --onto.
headline: Premature optimization is the root of all evil.
categories: [tools, git]
tags: [environment, git, version control system]
lang: en
imagefeature: git-rebase/git.png
---

A few days ago, I created new branch. I did some commits there, but after a while I noticed, that I created this new branch from the wrong parent branch. I created it from some feature branch not from the master. What I should do in this situation? I need to merge my current branch before I will merge this other feature branch and I don't want to add not needed commits to mater branch. How can I handle it? Well, here is the time for git.

The problem which I described above, can be resolved in at least two ways. First is easy to understand, but a little bit time consuming. We can create a new branch with parent master branch and use `git cherry-pick` command to move each commit from one branch to another. This solution is OK, when you don't have many commits, because for each commit you need to do `git cherry-pick`. There is one more inconvenience. In many companies, there is workflow how new functionality should go to master branch. Teams use pull/merge requests to the code review. In case when you need to create a new branch, you need to create also new pull/merge request. You need to ask someone in your team to check again your code and approve it. This solution causes additional work to do.

There is another solution. We can use `git rebase --onto` command. It can do exactly what we need. Replace the old parent branch with new parent branch. In our case with master branch. This is like our branches tree looks like:

```
A---B---C---D  master
            \
              E---F---G  feature-branch
                      \
                        H---I---J current-feature-branch (HEAD)
```

and this is what we would like to achieve:

```
A---B---C---D  master
            |\
            | E---F---G  feature-branch
            |
             \
              H'---I'---J' current-feature-branch (HEAD)
```

To replace parent branch with `master`, we need to be on `current-feature-branch` branch and do:

```bash
git rebase --onto master feature-branch
```

That's it. Right now we have our `current-feature-branch` branch based on master branch, not like before based on `feature-branch`.

In the end, I would like to say two more things here. First, if you want to move from one parent to another the command should look like this:

```bash
git rebase --onto new-parent old-parent
```

So right now you can adjust it to your situation.

Second, as you see one schema above, after using `git rebase --onto` we don't have exactly the same commit like before. Code is the same, but the SHA number (you know the commit identifier, for example `2d4698b`) for each commit is different. Everything will be fine, when you work alone on the branch where you want to do the trick. This was my situation. In case other people also work on this branch this command can provide problems. They will have different commits then you have and then are on the remote repository. This is always asking for troubles. Keep it in mind, before you will use `git rebase --onto` in this solution.
