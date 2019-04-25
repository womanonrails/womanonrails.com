---
layout: post
title: Jak ustawić niestandardowy czas w przeglądarce dla testów aplikacji?
description: Niestandardowy czas i strefa czasowa w przeglądarce bez zmiany ustawień użytkownika.
headline: Premature optimization is the root of all evil.
categories: [narzędzia]
tags: [TIL, przeglądarka, Linuks]
lang: pl
---

Nie przepadam za zmienianiem ustawień użytkownika, gdy wszystko działa dobrze. Tym razem potrzebowałam przetestować funkcjonalność, która wymagała zrobienia tego w różnych strefach czasowych. Znalazłam sposób by zrobić to bez zmiany moich standardowych ustawień.

Pracuję w projekcie, gdzie używamy zewnętrznego API dla danych pogodowych, które później wyświetlamy użytkownikowi. Był tam pewien błąd z brakującymi wartościami dla konkretnych przedziałów czasowych. Gdy użytkownik prosił o dane z października, brakowało mu zawsze ostatniego dnia (31.10). Natomiast prosząc o dane z września wszystko działało poprawnie. Okazało się, że problem wynikał z przesunięcia czasu związanego z przejściem z czasu letniego (CEST) na czas zimowy (CET). W 2018 roku odbyło się to 28-go października. Brakująca godzina zmieniała się na końcu miesiąca w brakujący dzień. Problem naprawiłam, ale chciałam być pewna na 100%, że nie wystąpi on też dla innych stref czasowych, również poza Europą. Zaplanowałam sobie sesję testów manualnych. Oczywiście, na naszych komputerach jest możliwość zmiany ustawień czasu zarówno w systemie jak i dla przeglądarki. Nie chciałam jednak tego robić. Podczas ostatniej takiej próby mój kalendarz pokazywał błędne godziny, a powiadomienia o spotkaniach przychodziły po ich zakończeniu. Nauczona na błędach szukałam innego rozwiązania.

Z pomocą, jak zawsze, przyszedł Google. Znalazłam tam bardzo fajne rozwiązanie mojego problemu dla przeglądarki Chrome. Wystarczy stworzyć katalog dla nowego profilu przeglądarki (nazwa jest całkowicie dowolna ja wybrałam `chrome-profile`):

```bash
mkdir $HOME/chrome-profile
```

następnie wybrać strefę czasową i wpisać ją do zmiennej środowiskowej `TZ` (skrót od time zone):

```bash
TZ='US/Pacific' google-chrome "--user-data-dir=$HOME/chrome-profile"
```

po pracy wystarczy skasować katalog tego profilu:

```bash
rm -rf $HOME/chrome-profile
```

To wszystko! Możesz uruchomić przeglądarkę w różnych strefach czasowych nie zmieniając swoich ustawień. Chciałabym zwrócić tutaj uwagę na jedną drobną rzecz. Musisz znać **dokładną nazwę strefy czasowej**. To jest szczególnie ważne dla osób takich jak ja, które robią dużo literówek. W przypadku złej nazwy strefy przeglądarka otworzy się **bez żadnych błędów**, ale będzie miała ustawioną Twoją **standardową strefę czasową**.

Dzięki za przeczytanie i do następnego razu! Trzymaj się!
