---
layout: post
title: Wzorzec projektowy – MVC
description: Kilka słów na temat MVC
headline: My code is getting worse, please send more chocolate
categories: [wzorce projektowe]
tags: [Ruby on Rails]
lang: pl
---

Jednym z tematów, o którym chciałabym tutaj pisać jest framework Ruby on Rails. Dzisiaj nadeszła pora by zacząć. Ten artykuł będzie na temat jednego z wzorców projektowych zastosowanych w Ruby on Rails. Ten wzorzec to **MVC – Model View Controller**.

Zacznijmy od początku. Co to jest wzorzec projektowy? Hmm… jest on jak dobry przepis na ciasto czekoladowe. Wielu ludzi robi ciasto czekoladowe jedni lepiej, jedni gorzej. Jednak gdy dany przepis jest naprawdę dobry ludzie zaczynają sobie go nawzajem polecać i używać. Tak samo jest z wzorcami projektowymi. Są to pewnego rodzaju dobre praktyki lub rozwiązania jak poradzić sobie z pewnymi często występującymi problemami dotyczącymi projektowania oprogramowania.

A więc MVC jest jak dobry przepis na ciasto czekoladowe. Oczywiście używamy go tylko na specjalne okazje czyli w naszym przypadku przy tworzeniu aplikacji internetowych.

**MODEL** – Rozmawia z bazą danych i kontrolerem. Baza danych jest jak zbiór składników: czekolada, mleko, mąka itd. Model posiada pewne metody do przetwarzania składników jak mieszanie, miksowanie czy pieczenie.

**VIEW (widok)** – Jest przetwarzany przez kontroler. W przypadku aplikacji internetowych jest to strona, którą widzimy w przeglądarce. Taką stronę tworzymy za pomocą HTML, Java Script i CSS. Możemy więc powiedzieć, że jest to dla nas gotowe ciasto.

**CONTROLLER (kontroler)** – Jest jak szef kuchni. Bierze składniki, przetwarza je za pomocą metod modelu i wysyła na widok. To kontroler podaje nam gotowe ciasto.

Życzę Wam powodzenia przy tworzeniu własnych aplikacji na bazie wzorca projektowego MVC. W następnych artykułach chciałbym opisać jak tworzyć aplikację internetową korzystającą z MVC przy pomocy Ruby on Rails, więc zapraszam do śledzenia pojawiających się tu nowości.
