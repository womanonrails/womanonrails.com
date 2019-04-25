---
layout: post
title: Co to jest git?
description: Git - podstawy
headline: My code is getting worse, please send more chocolate
categories: [narzędzia]
tags: [środowisko programistyczne, git, system kontroli wersji]
lang: pl
---

Chciałabym z Wami zacząć dzisiaj krótką serię 2-3 artykułów na temat **Gita**. To będzie naprawdę podstawa. W Internecie jest wiele różnego rodzaju kursów na temat Gita. A ja nie chciałabym robić kolejnego. Jeżeli chciałybyście dowiedzieć się czegoś więcej na ten temat, osobiście mogę polecić 2 kursy na temat Gita z CodeSchool. Możecie zacząć [tutaj](https://www.codeschool.com/courses/try-git).

Nie będę tutaj podawać definicji tego czym jest Git, bo możecie ją znaleźć na [wiki](https://en.wikipedia.org/wiki/Git_(software)) czy w [dokumentacji Gita](https://git-scm.com/documentation). Powiem tylko, że git to **system kontroli wersji**. Teraz zajmiemy się zrozumieniem do czego można wykorzystać Gita i dlaczego jest to naprawdę świetne narzędzie.

Czy zdarzają się Wam sytuacje, w których pracujecie wspólnie z innymi nad tymi samymi plikami? Sytuacje takie jak: projekt zespołowy w szkole, na uczelni? Może jakaś duża aplikacja internetowa? Prezentacja lub raport dla szefa? Lub inne zadanie, gdzie każdy w zespole ma dostęp do tych samych plików? Ja spotykam się z taką sytuacją każdego dnia w swojej pracy. Pracuję w zespole składającym się z około 8 osób. A może pracujecie tylko dla siebie, ale nie możecie sobie pozwolić na utratę Waszych danych? Może jesteście pisarzami i przykładowo piszecie książkę?

## Praca tylko dla siebie

Załóżmy, że pracujemy sami. Piszemy książkę. Pracujemy nad nią od dwóch lat. Nagle komputer się zepsuł, przypadkowo usunęliśmy plik z danymi lub po prostu chcemy wrócić do poprzedniej wersji, bo była znacznie lepsza, niż ta po ostatnich poprawkach. Co teraz? Wiem dzisiaj istnieje już wiele sposobów, dzięki którym możemy zapobiec tego typu sytuacją. Mamy Dropbox, dyski zewnętrzne czy pocztę internetową (na którą wysyłamy koleją wersję naszych danych). Nawet programy, takie jak LibreOffice potrafią zapamiętywać ostatnie dokonane zmiany. Git też to potrafi. Pamięta on historię wszystkich zapisanych zmian. Można dzięki temu wrócić do dowolnej starszej wersji plików.

Jeżeli przykład ten nie przekonał Cię, że Git może być użytecznym narzędziem, to zapraszam do kolejnego przykładu.

## Praca zespołowa

Każdy w naszym zespole ma dostęp do projektu na swoim własnym komputerze. Przykładowo mamy jeden plik. Kochamy język Ruby, więc plik będzie pisany właśnie w tym języku. A wygląda on tak:

```ruby
# hello_world.rb
def hello
  "hello"
end
```

Każdym ma ten plik lokalnie na swoim komputerze. Teraz ja dostaję zadanie, by zmienić napisaną w nim metodę, tak by zwracała nie `hello` tylko `hello world`. Po zmianie plik wygląda następująco:

```ruby
# hello_world.rb
def hello
  "hello world"
end
```

Teraz w jakiś sposób muszę podzielić się tą zmianą z innymi osobami w zespole. Ale jak? Przez e-mail? Dropbox? Pendrive? Każde z tych rozwiązań jest dość bolesne w tym przypadku. Nasz pierwszy problem to: **1. Aktualizacja projektu (jak mieć dostęp do bieżącej wersji projektu)**

Ten problem jest możliwy do rozwiązania. Czasem rozwiązanie może być pracochłonne i nużące, ale jesteśmy w stanie sobie z nim poradzić. Natomiast, co zrobimy w przypadku, gdy dwie osoby zmieniają dokładnie ten sam fragment kodu? Przykładowo druga osoba zmienia nazwę metody, nad którą ja w tym czasie pracuje. Kod tej osoby wygląda następująco:

```ruby
# hello_world.rb
def say_hi
  "hello"
end
```

Teraz ja wysyłam moje zmiany do wszystkich, druga osoba robi to samo. Które zmiany powinny zostać? Które zmiany są ważniejsze? A może zależy nam na czymś takim:

```ruby
# hello_world.rb
def say_hi
  "hello world"
end
```

Połączone zmiany. W jaki sposób możemy ten problem rozwiązać? Moglibyśmy mieć taką osobę w zespole, która by to dla nas przygotowywała. Rozmawialibyśmy z tą osobą o zmianach, jakie wprowadziliśmy i ona starałaby się rozwiązywać takie konflikty za nas. Czy myślicie tak jak ja że to bardzo zły pomysł? Jeżeli tak do dobrze, bo to katastrofalny pomysł. No i kto chciałby być taką osobą w zespole? Pojawia się nam drugi chyba jeszcze ważniejszy problem: **2. W jaki sposób łatwo łączyć zmiany wprowadzone przez różne osoby?**

Git jest takim narzędziem, które w wielu przypadkach automatycznie łączy zmiany pochodzące od różnych osób. Jest to bardzo przydatne narzędzie zwłaszcza przy zespołowych projektach. Ale! (zawsze musi być jakieś ale). O ile w bardzo przystępny sposób za pomocą Gita można poruszać się po plikach tekstowych (programy, książki, artykuły) i ich zmianach. To znacznie ciężej jest poruszać się po plikach graficznych. Obrazki to pliki binarne (w większości przypadków, za wyjątkiem np. svg). Kiedy zmienimy coś w takim pliku ciężko jest nam obserwować zmiany.

Przykładowo, nasz obrazek może dla komputera wyglądać następująco:

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

Nasz komputer w łatwy sposób jest wstanie zinterpretować ciągi tych liczb i literek w postaci kształtów i kolorów. My niestety nie. Więc gdy zmienimy coś na naszym obrazku, nie potrafimy po jakimś czasie stwierdzić co to była za zmiana. Chyba, że otworzymy ten obrazek w odpowiednim programie. Rozumiecie co mam na myśli? Nie chodzi o to, że nigdy nie dodajemy plików graficznych do Gita. Chodzi o to, że bez dodatkowych narzędzi ciężko nam śledzić na takich plikach zmiany.

Mam nadzieję, że ten artykuł był dla Was pomocny, w zrozumieniu tego po co przydaje się takie narzędzie jak Git. W następnym artykule chciałabym opisać podstawowe użycie tego narzędzia. Jeżeli macie jakieś pytania lub sugestie, dajcie znać w komentarzach. Do zobaczenia następnym razem. Pa!
