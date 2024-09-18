---
excerpt: >
  Jakiś czas temu uczestniczyłam w Instagramowym wyzwaniu #30devstories.
  Podczas tego wyzwania ja i inni twórcy przygotowaliśmy mnóstwo przydatnych materiałów.
  Dzieliliśmy się swoją wiedzą na przeróżne tematy.
  Bardziej lub mniej programistyczne.
  Ponieważ treści te były tworzone w takim dość ulotnym formacie jakim jest Instagram Story,
  postanowiłam, że podzielę się nimi z Tobą w bardziej trwałej wersji.
  Rozpoczniemy od **TDD**, czyli **Test Driven Development**.
  Szczegółowo o tym jak wygląda praca z TDD pisałam w artykule
  <a href='/pl/tdd-basic' title='Jak wygląda proces TDD na przykładzie?'>TDD - Wprowadzenie</a>.
  Dziś jednak chciałabym się podzielić krótką notatką o podstawach TDD.
layout: post
photo: /images/tdd-30devstories/tdd-30devstories
title: TDD w pigułce
description: TDD - Oprogramowanie sterowane testami
headline: Premature optimization is the root of all evil.
categories: [testowanie, 30devstories]
tags: [tdd, testy]
lang: pl
imagefeature: tdd-30devstories/og_image-tdd-30devstories.jpg
---

Jakiś czas temu uczestniczyłam w Instagramowym wyzwaniu #30devstories. Podczas tego wyzwania ja i inni twórcy przygotowaliśmy mnóstwo przydatnych materiałów. Dzieliliśmy się swoją wiedzą na przeróżne tematy. Bardziej lub mniej programistyczne. Ponieważ treści te były tworzone w takim dość ulotnym formacie jakim jest Instagram Story, postanowiłam, że podzielę się nimi z Tobą w bardziej trwałej wersji. Rozpoczniemy od **TDD**, czyli **Test Driven Development**. Szczegółowo o tym jak wygląda praca z TDD pisałam w artykule <a href="{{ site.baseurl }}/tdd-basic" title="Jak wygląda proces TDD na przykładzie?">TDD - Wprowadzenie</a>. Dziś jednak chciałabym się podzielić krótką notatką o podstawach TDD.

## Co to jest TDD?

TDD - Test Driven Development, czyli tworzenie oprogramowania sterowanego testami. Jest to nie tyle sposób pisania testów lub testowania, co sposób wytwarzania oprogramowania przy pomocy testów.

## Jak wygląda proces TDD?

Proces ten składa się z trzech kroków, powtarzanych cyklicznie:

1. **Test** - Każdy cykl TDD zaczynamy od testu. Po jego napisaniu, test uruchamiamy. Gdyby okazało się, że test jest spełniony bez konieczności dopisania jakiegokolwiek kodu oznaczyłoby to, że test jest bezużyteczny. Nie wnosi nic nowego do projektu.

2. **Kod** - Test nie przechodzi, a my możemy skupić się na napisaniu kodu. Trzeba tu pamiętać o napisaniu tylko i wyłącznie minimalnej ilość kodu potrzebnej do spełnienia testu. Nic więcej. Teraz test powinien _przechodzić_.

3. **Refactor** - Gdy mamy test i kod, to czas na refaktoryzację. Czy można coś poprawić, polepszyć, uprościć? Zmienić nazwę na bardziej czytelną? Uwaga tylko na jedną ważną rzecz. Trzeci krok w cyklu TDD nie jest po to by dopisywać nową funkcjonalność, lecz by poprawiać istniejącą.

Po zakończeniu całego cyklu możemy wrócić do kroku pierwszego i zacząć kolejny cykl. Cały proces powtarzamy aż uzyskamy satysfakcjonujące rozwiązanie - potrzebną logikę.

{% include video/instastory.html url='https://womanonrails.github.io/video/pl/30devstories/day01-tdd.webm' %}
