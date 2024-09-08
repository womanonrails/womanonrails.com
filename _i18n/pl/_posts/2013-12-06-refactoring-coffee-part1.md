---
excerpt: >
  To będzie mój pierwszy wpis o refaktoringu.
  Uwielbiam refaktoring, więc bierzmy się do pracy.
  Myślę, że najlepszym sposobem by to zrobić będzie zapisanie
  na początku fragmentu kodu a później wprowadzenie zmian.
  Dzisiaj chciałabym zaprezentować Wam kilka linijek kodu w CoffeeScript...
layout: post
title: Refaktoryzacja CoffeeScript
description: Mały refaktoring w CoffeeScript
headline: My code is getting worse, please send more chocolate
categories: [refaktoring]
tags: [CoffeeScript, JavaScript]
lang: pl
---

To będzie mój pierwszy wpis o refaktoringu. Uwielbiam refaktoring, więc bierzmy się do pracy.

Myślę, że najlepszym sposobem by to zrobić będzie zapisanie na początku fragmentu kodu a później wprowadzenie zmian. Dzisiaj chciałabym zaprezentować Wam kilka linijek kodu w CoffeeScript:

```coffeescript
if checked_items == all_items
  $('#myId').prop('checked', true)
else
  $('#myId').prop('checked', false)
```

Ten kod jest naprawdę prosty. Sprawdzam czy ilość zaznaczonych elementów jest równa ilości wszystkich elementów. I w zależności od odpowiedzi zaznaczam (lub nie) checkbox na stronie internetowej. Tak jak powiedziałam jest to prosty kod, ale może być ładniejszy:

```coffeescript
$('#myId').prop('checked', checked_items == all_items)
```

Ta sama funkcjonalność w jednej linijce. Bardzo mi się podoba ten refaktoring. Jeśli widzicie jak można by jeszcze ulepszyć ten fragment kodu dajcie znać.

Do zobaczenia następnym razem!

