---
layout: post
photo: /images/screenshot-in-the-browser/screenshot-in-the-browser
title: Zrzut ekranu w przeglądarce
description: Jak zrobić zrzut ekranu korzystając z przeglądarki?
headline: Premature optimization is the root of all evil.
categories: [narzędzia]
tags: [TIL, przeglądarka, Linuks]
imagefeature: screenshot-in-the-browser/og_image-screenshot-in-the-browser.png
lang: pl
---

Kiedy tworzysz aplikację internetową od czasu do czasu potrzebujesz zapisać aktualny wygląd strony, nad którą właśnie pracujesz. W większości przypadków pewnie korzystasz z klawisza `Print Screen` na klawiaturze. Później, oczywiście jeżeli korzystasz z systemu operacyjnego Linux, wystarczy tylko otworzyć zapisany zrzut ekranu w edytorze graficznym takim jak GIMP i wyciąć interesujący Cię fragment. Możesz też spotkać się z trochę inna sytuacją. Chciałabyś zapisać aktualny stan całej strony, a nie tylko wybranego fragmentu. Wtedy albo robisz kilka zrzutów z ekranu i próbujesz je połączyć w programie graficznym albo korzystasz z dodatku, który zapisze Ci wygląd całej strony. Na szczęście jest też prostsze rozwiązanie. Można skorzystać z wbudowanej w przeglądarkę funkcji robienia zrzutów ekranu. Sprawdźmy jak to działa.

Po pierwsze należy tu zaznaczyć, że opcja ta jest dostępna w przeglądarkach **Google Chrome** i **Chromium**. Zrzut ekranu można zrobić w trzech prostych krokach:
  1. Użyj skrótu klawiszowego `Ctrl + Shift + I` lub `Ctrl + Shift + C` - dzięki temu otworzysz Inspektor Elementów (Narzędzia deweloperskie) w Twojej przeglądarce
  2. Użyj `Ctrl + Shift + P` - ten skrót otworzy Ci linie poleceń, w której będziesz mogła wyszukać interesującej Cię funkcjonalności w liście narzędzi deweloperskich.
  3. Wpisz tam _screenshot_ - to pozwoli Ci zobaczyć cztery możliwe sposoby wykonania zrzutu ekranu. Wystarczy teraz, że wybierzesz ten, który jest Ci w danym momencie potrzebny.

<img src="{{ site.baseurl_root }}/images/screenshot-in-the-browser/screenshot.png"
     alt='Wiersz poleceń w przeglądarce do wybrania zrzutu ekranu'>

Skoro wiemy już jak wykonać zrzut ekranu w przeglądarce, to teraz czas zrobić szybki przegląd możliwości jakie mamy do dyspozycji:
  - **Capture area screenshot** - To mój ulubiony typ. Kiedy wybierzesz tą opcję, możesz zrobić zrzut tylko zaznaczonego fragmentu strony. Dzięki temu nie trzeba już docinać obrazka w programie graficznym. Zostanie on bezpośrednio pobrany na komputer.
  - **Capture full size screenshot** - Ta opcja pozwala na zrobienie zrzutu całej strony internetowej. Nie trzeba instalować dodatków do przeglądarki czy samodzielnie wykonywać kilka zrzutów.
  - **Capture node screenshot** - Dzięki tej opcji mamy możliwość zrobienia zrzutu konkretnego fragmenty strony. Wybiera się go za pomocą znaczników HTML. Na początku musisz wybrać w Inspektorze Elementów jaki tag HTML Cię interesuje, a dopiero później wykonać zrzut z ekranu. Ja osobiście nie używam tej opcji. Bardziej do gustu przypadło mi zaznaczanie elementów za pomocą kursora, czyli **Capture area screenshot**. Można dzięki temu uzyskać podobny efekt, ale bez konieczności poszukiwania odpowiedniego węzła (ang. node) w HTML.
  - **Capture screenshot** - czyli zachowanie podobne do tego dostępnego pod klawiszem `Print Screen`. Na obrazku zostanie uchwycone dokładnie to, co widzimy na ekranie, poza obramowaniem przeglądarki ;)

To była krótka notatka o tym, jak używać wbudowanej w przeglądarkę funkcjonalności zrzutu ekranu. Uważasz tą informację za użyteczną? Daj znać w komentarzu poniżej.
