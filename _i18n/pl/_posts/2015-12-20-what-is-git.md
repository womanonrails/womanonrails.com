---
excerpt: >
  Jeżeli interesuje Cię programowanie, to prawdopodobnie słyszałaś już
  nazwę **Git** przynajmniej kilka razy.
  Może nawet więcej niż kilka razy.
  Git to narzędzie, którego używają programiści i programistki
  niezależnie od tego w jakim języku programowania pracują.
  To jedno z tych podstawowych narzędzi, które naprawdę warto znać.
  Między innymi dlatego napisałam cykl artykułów na temat narzędzia git.
  W Internecie możesz znaleźć wiele kursów czy artykułów mówiących o tym jak używać git-a.
  Ja chciałabym się skupić przede wszystkim na zrozumieniu dlaczego warto go stosować,
  jak on działa i co można za jego pomocą zrobić.
  Nie przedłużając, dziś zajmiemy się  zrozumieniem czym jest git
  i jak może nam pomóc w codziennej, programistycznej pracy.
  No to zaczynamy!
layout: post
title: Co to jest git?
description: Podstawy narzedzia Git. Dlaczego używamy git-a?
headline: Premature optimization is the root of all evil.
categories: [narzędzia, git]
tags: [środowisko programistyczne, git, system kontroli wersji]
lang: pl
mentoring: true
---

Jeżeli interesuje Cię programowanie, to prawdopodobnie słyszałaś już nazwę **Git** przynajmniej kilka razy. Może nawet więcej niż kilka razy. Git to narzędzie, którego używają programiści i programistki niezależnie od tego w jakim języku programowania pracują. To jedno z tych podstawowych narzędzi, które naprawdę warto znać. Między innymi dlatego napisałam cykl artykułów na temat narzędzia git. W Internecie możesz znaleźć wiele kursów czy artykułów mówiących o tym jak używać git-a. Ja chciałabym się skupić przede wszystkim na zrozumieniu dlaczego warto go stosować, jak on działa i co można za jego pomocą zrobić. Nie przedłużając, dziś zajmiemy się  zrozumieniem czym jest git i jak może nam pomóc w codziennej, programistycznej pracy. No to zaczynamy!

## Co to jest git?

Git to **rozproszony system kontroli wersji**, czyli narzędzie do zarządzania różnymi wersjami systemu lub aplikacji. Tak więc, możesz mieć różne wersje swojego systemu i dodatkowo mogą one być rozproszone pomiędzy różnymi komputerami. Jedna wersja może być na Twoim laptopie, a inna wersja może być na komputerze stacjonarnym w pracy.

Możesz myśleć o narzędziu git trochę jak o graniu w grę komputerową. Zaczynasz grać, aż w pewnym momencie gry chcesz zapisać jej stan, tak na wszelki wypadek zanim stoczysz ostateczną walkę z bossem. Nie chcesz przecież stracić informacji o tych wszystkich poziomach (levelach), które już udało Ci się przejść. To mogło by być dość frustrujące zaczynać od nowa. Tak samo jest właśnie z git-em. Zapisujesz stan swojej pracy, by jej nie stracić. Plus, prawdopodobnie będziesz chciała później porównać swoje zmiany ze zmianami innych osób w zespole.

## Gdzie używać git-a?

W skrócie - wszędzie. No dobrze, prawie wszędzie. Używaj git-a w projektach, w których zależy Ci przede wszystkim na współpracy z innymi oraz pewności, że nie stracisz swoich danych. Może pracujesz sama dla siebie. Przykładowo jesteś pisarką i piszesz książkę. Albo zdarzają Ci się sytuacje, w których pracujesz wspólnie z innymi nad tymi samymi plikami? Sytuacje takie jak: projekt zespołowy w szkole, na uczelni? Może jakaś duża aplikacja internetowa? Prezentacja lub raport dla szefa? Lub jakieś inne zadanie, gdzie każdy w zespole ma dostęp do tych samych plików? To właśnie są sytuacje, do których git jest stworzony. Ja spotykam się z takimi sytuacjami w swojej pracy na co dzień. Pracuję w zespole składającym się z około 8 osób.

### Praca tylko dla siebie

Pracujesz sama. Piszesz książkę. Jesteś pochłonięta tym projektem już od dwóch lat. Nagle Twój komputer się zepsuł, przypadkowo usunęłaś plik z danymi lub po prostu chcesz wrócić do poprzedniej wersji rozdziału. Co teraz? Wiem, dzisiaj istnieje wiele sposobów, które pozwalają zapobiec tego typu sytuacjom. Mamy Dropbox, Google Docs, dyski zewnętrzne czy pocztę internetową (na którą wysyłamy koleją wersję projektu). Nawet programy, takie jak LibreOffice potrafią zapamiętać ostatnio dokonane zmiany. Git też to potrafi. Pamięta on historię wszystkich zapisanych zmian. Można dzięki temu wrócić do dowolnej wersji wybranego pliku lub plików.

Jeżeli ten przykład nie przekonał Cię, że Git może być użytecznym narzędziem, to mam w zanadrzu jeszcze jeden. ;]

### Praca zespołowa

Pracujesz nad projektem zespołowym. Każdy w zespole ma dostęp do projektu na swoim własnym komputerze. Przykładowo w projekcie masz jeden plik. Kocham język Ruby, więc kod będzie napisany właśnie w tym języku. A wygląda on tak:

```ruby
# hello_world.rb
def hello
  "hello"
end
```

Każdy w zespole ma ten plik lokalnie na swoim komputerze. Dostajesz zadanie, by zmienić napisaną w nim metodę, tak by zwracała nie `hello` a `hello world`. Po zmianie plik wygląda następująco:

```ruby
# hello_world.rb
def hello
  "hello world"
end
```

Teraz w jakiś sposób musisz podzielić się tą zmianą z innymi osobami w zespole. Ale jak? Przez e-mail? Dropbox? Pendrive? Każde z tych rozwiązań jest dość czasochłonne. Pojawia się pierwszy problem. **Aktualizacja projektu (jak mieć dostęp do najnowszej wersji projektu).**

Ten problem da się jeszcze jakoś rozwiązać. Może być to pracochłonne i nużące, ale jesteś w stanie sobie z nim poradzić. Natomiast, co zrobisz w przypadku, gdy dwie osoby zmieniają dokładnie ten sam fragment kodu? Przykładowo druga osoba w zespole zmienia nazwę metody, nad którą Ty właśnie pracujesz. Kod tej drugiej osoby wygląda następująco:

```ruby
# hello_world.rb
def say_hi
  "hello"
end
```

Nadchodzi czas synchronizacji wersji projektu. Ty wysyłasz swoje zmiany do wszystkich, to samo robi ta druga osoba. Które zmiany powinny zostać? Które zmiany są ważniejsze? A może zależy nam na czymś takim:

```ruby
# hello_world.rb
def say_hi
  "hello world"
end
```

Połączone zmiany. W jaki sposób możesz ten problem rozwiązać? No cóż, w zespole mogłaby być taka osoba, która zajmowała by się rozwiązywaniem tego typu problemów. Inne osoby w zespole rozmawiałyby z tym śmiałkiem o zmianach, jakie wprowadziły. A nasz śmiałek starałaby się rozwiązać konflikty w kodzie za nas. Czy też uważasz, że to nie jest dobry pomysł? To katastrofalny pomysł. No i kto chciałby być taką osobą w zespole? Pojawia się nam drugi, ważniejszy problem: **Jak w łatwy sposób łączyć zmiany wprowadzane przez różne osoby w zespole?** Tu z pomocą przychodzi nam Git. Jest to narzędzie, które w wielu przypadkach automatycznie łączy zmiany pochodzące od różnych osób. **Git jest narzędziem przydatnym przy pracy w projektach zespołowych**. Ale czy zawsze jest tak różowo?

### Pliki binarne w git-cie

Zawsze musi być jakieś ale. O ile w bardzo przystępny sposób za pomocą git-a można zarządzać zmianami w plikach tekstowych (kod źródłowy programów, tekst książki czy artykułu). To znacznie ciężej jest poruszać się po plikach graficznych, plikach wideo i innych plikach binarnych. Problem polega na tym w jaki sposób git zapamiętuje zmiany w naszych plikach. Git pamięta zmiany, jakie zostały wprowadzone w kolejnych liniach. I właśnie dlatego tak dobrze sprawdza się w przypadku plików tekstowych, bo one są złożone z linii tekstu/kodu. Gdy zmienimy coś w jakiejś linijce, to od razu możemy zobaczyć jak ta linijka wyglądała przed i po zmianie. W przypadku plików binarnych, czyli plików zawierających sekwencję bitów, nie jest to takie łatwe. Gdybyśmy taki plik otworzyły bezpośrednio, to mógłby on wyglądać następująco:

```
00000000  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
00000010  00 00 04 c9 00 00 01 7e  08 06 00 00 01 ef a0 7d  |.......~.......}|
00000020  68 00 00 00 09 70 48 59  73 00 00 2e 23 00 00 2e  |h....pHYs...#...|
00000030  23 01 78 a5 3f 76 00 00  00 19 74 45 58 74 53 6f  |#.x.?v....tEXtSo|
00000040  66 74 77 61 72 65 00 41  64 6f 62 65 20 49 6d 61  |ftware.Adobe Ima|
00000050  67 65 52 65 61 64 79 71  c9 65 3c 00 00 36 8c 49  |geReadyq.e<..6.I|
00000060  44 41 54 78 da ec 9c 61  6e 83 30 0c 46 47 c4 85  |DATx...an.0.FG..|
00000070  a6 75 47 da a9 76 a4 75  da 91 98 f8 41 95 a6 31  |.uG..v.u....A..1|
...
```

Jest to fragment pliku graficznego PNG, który jest plikiem binarnym. Nasz komputer w łatwy sposób jest w stanie zinterpretować ciągi tych liczb i literek w postaci kształtów i kolorów. My niestety nie. Gdy wiec zmienimy coś w naszym obrazku (kilka bitów), nie jesteśmy w stanie w łatwy sposób stwierdzić, co to była za zmiana. Chyba, że otworzymy ten obrazek w odpowiednim programie. Nie chodzi o to, że nigdy nie dodajemy plików graficznych do git-a. Chodzi o to, że bez dodatkowych narzędzi ciężko nam śledzić zmiany w takich plikach.

### Następne artykuły w cyklu:

- [Podstawowe komendy narzędzia Git]({{ site.baseurl }}/git-usage "Jak zacząć używać git-a?")
- [Jak używać git rebase?]({{ site.baseurl }}/git-rebase "Jaka jest różnica między git merge a git rebase?")
- [Jak zmienić gałąź rodzicielską w git?]({{ site.baseurl }}/replace-parent-branch "Ustawienie innej gałęźi rodzicielckiej za pomoca git-a.")
- [Jak użyć komendy git rebase --onto?]({{ site.baseurl }}/git-rebase-onto "Zrozumienie komendy  git rebase --onto.")
