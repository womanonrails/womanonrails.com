---
layout: post
photo: /images/adding-yarn-package-from-github/adding-yarn-package-from-github
title: How to add the yarn package from GitHub?
description: Short tips for using yarn
headline: Premature optimization is the root of all evil.
categories: [tools]
tags: [yarn, TIL, JavaScript]
imagefeature: adding-yarn-package-from-github/og_image-adding-yarn-package-from-github.png
lang: en
excerpt: In my current project, I use yarn for managing JavaScript packages. A few days ago, I needed a very specific version of a package from the GitHub repository. To keep it in mind, how to add a package from GitHub repository using yarn, I prepared this short note. I hope you will find it useful. I plan to do more this kind of short tips in the future.
---

In my current project, I use **yarn** for managing **JavaScript** packages. A few days ago, I needed to add a very specific version of a package from the GitHub repository. To keep it in mind, how to add a package from GitHub repository using yarn, I prepared this short note. I hope you will find it useful.

To **add yarn package from GitHub**, you need to use this command:

```console
yarn add <GitHub user name>/<GitHub repository name>
```

If you are interested in a **specific branch or commit**, you need to run the command:

```console
yarn add <GitHub user name>/<GitHub repository name>#<branch/commit/tag>
```

And if you need very **specific version** of the package, you will use:

```console
yarn add <package name>@<package version> --exact
```

