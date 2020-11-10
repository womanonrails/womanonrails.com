---
layout: post
photo: /images/adding-yarn-package-from-github/adding-yarn-package-from-github
title: Jak dodać pakiet yarna z repozytorium GitHuba?
description: Szybkie wskazówki użytkowania yarn-a
headline: Premature optimization is the root of all evil.
categories: [narzędzia]
tags: [yarn, TIL, JavaScript]
imagefeature: adding-yarn-package-from-github/og_image-adding-yarn-package-from-github.png
lang: pl
excerpt: Do zarządzania pakietami JavaScript używam w projekcie yarn-a. Kilka dni temu potrzebowałam dodać bardzo konkretną wersję pakietu z repozytorium znajdującego się na GitHub-ie. Tą krótką notatkę tworzę przede wszystkim by nie zapomnieć jak dodać pakiet z GitHub-a przy pomocy yarn-a. Mam nadzieję, że dla Ciebie też okaże się użyteczna. W przyszłości planuje więcej takich krótkich wpisów z cylku "Today I learned".
---

Do zarządzania pakietami JavaScript używam w projekcie yarn-a. Kilka dni temu potrzebowałam dodać bardzo konkretną wersję pakietu z repozytorium znajdującego się na GitHub-ie. Tą krótką notatkę tworzę przede wszystkim by nie zapomnieć jak dodać pakiet z GitHub-a przy pomocy yarn-a. Mam nadzieję, że dla Ciebie też okaże się użyteczna.

Aby **dodać pakiet yarn-a z GitHub-a** użyj następującego polecenia:

```console
yarn add <GitHub user name>/<GitHub repository name>
```

Jeżeli **potrzebujesz pakietu z konkretnej gałęzi** lub konkretnej zmiany (ang. commit) skorzystaj z:

```console
yarn add <GitHub user name>/<GitHub repository name>#<branch/commit/tag>
```

W przypadku, gdy **potrzebujesz konkretnej wersji pakietu** użyjesz:

```console
yarn add <package name>@<package version> --exact
```
