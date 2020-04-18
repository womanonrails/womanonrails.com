---
layout: post
title: Pattern matching w Elixirze - podstawy
description: Czego nauczyłam się o Elixirze do tej pory?
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Elixir]
lang: pl
---

Elixir to język funkcyjny, stworzony przez José Valim w 2012 roku. Uruchamia się on na maszynie wirtualne Erlanga. Jeżeli chciałabyś dowiedzieć się więcej o samym Elixirze, to odsyłam do oficjalnej strony
{% include links/external-link.html name='Elixira' url='https://elixir-lang.org/' %}.
Warto na wstępie wspomnieć jeszcze jedną rzecz. W historii języka Elixir pojawia się pewne nawiązanie do Rubiego i Railsów. Otóż José jest członkiem Rails Core Team, czyli zespołu, który zajmuje się rozwijaniem frameworka Ruby on Rails.

Ja osobiście z językiem Elixir spotkałam się po raz pierwszy na konferencji Euruko 2016 w Sofii. Przed swoją prezentacją José Valim pokazał nam odrobinę tego, co ma do zaoferowania Elixir. Po tym wydarzeniu zaczęłam zauważać, że społeczność Ruby mocno się interesuje Elixirem. Nawet na Śląsku zaczęły powstawać projekty napisane w Elixirze i frameworku Phoenix. Ale taką prawdziwą styczność z tym językiem miałam dopiero pod koniec 2018 roku. Uczestniczyłam wtedy w pierwszych warsztatach **Elixir Girls** w Polsce, które odbyły się w Poznaniu. To było naprawdę ciekawe doświadczenie. Mogę powiedzieć, że otwierające oczy. Struktura samych warsztatów podobna jest do warsztatów <a href="{{ site.baseurl }}/tags/#Rails%20Girls" title="Moje porzednie artykuły na temat Rails Girls">Rails Girls</a>, więc nie chciałabym się tutaj na nich skupiać. Największa różnica to język, którego się używa. Zamiast Rubiego i Railsów podczas warsztatów używaliśmy Elixira i Phoenixa. Dziś jednak, chciałabym pokazać Ci, co mi się na prawdę spodobało w Elixirze. A dokładnie, chciałabym pokazać Ci **pattern matching** czyli po polsku dopasowanie do wzorca.

### Match operator

Zacznijmy od początku. **Co to jest pattern matching?** Pattern matching to sprawdzenie czy dany kod pasuje do z góry zadanego wzorca. Tak wiem, powiedziałam dokładnie to samo innymi słowami. Wyobraź sobie, że masz pewne zasady (wzorce) względem, których porządkujesz (sprawdzasz) kod lub tekst. Pasuje do wzorca lub nie. Podobnie jak w dzieciństwie miało się drewniane klocki. Kwadraty pasowały do kwadratowych dziur, koła do okrągłych dziur. Czy to Ci nie przypomina czegoś z czym miałaś styczność w innych językach programowania? Wyrażenia regularne? Dokładnie! Jakiś czas temu napisałam nawet artykuł na temat <a href="{{ site.baseurl }}/email-regular-expressions" title="Wyrażenia regularne - na co zwracać uwagę">wyrażeń regularnych</a> oraz co z nimi może pójść nie tak? Wyrażenia regularne to jest jeden z przykładów **pattern matchingu**. Skoro już wiemy odrobinę więcej, czym jest pattern matching, zacznijmy od prostego przykładu:

```elixir
iex> x = 4
4
```

Czy to nie przypadkiem zwykłe przypisanie? No cóż, nie do końca. Nie w przypadku języka Elixir. To co widzisz w pierwszym przykładzie to **operator match**. W Elixirze `=` pozwala nam sprawdzić czy lewa strona wyrażenia pasuje do prawej strony. Dlatego też możliwe jest wykonanie:

```elixir
iex> 4 = x
4
```

Jest poprawna operacja w Elixirze. Sprawdzamy, czy po obu stronach mamy 4. Nie możemy czegoś podobnego zrobić w języku Ruby.

```ruby
irb> x = 4
 => 4
irb> 4 = x
Traceback (most recent call last):
        1: from /home/agnieszka/.rvm/rubies/ruby-2.5.3/bin/irb:11:in `<main>'
SyntaxError ((irb):5: syntax error, unexpected '=', expecting end-of-input)
4 = x
  ^
```

Z drugiej strony, gdy wrócimy do Elixira możemy też sprawdzić wyrażenie `5 = x`.

```elixir
iex> 5 = x
** (MatchError) no match of right hand side value: 4
```

I tu widzimy komunikat, że porównanie się nie powiodło. Teraz jeszcze lepiej widać, że to nie jest takie zwykłe przypisanie. Podobnie sprawa będzie wyglądać sytuacji, gdy spróbujemy sprawdzić dopasowanie do wzorca ze zmienną, która nie została jeszcze zadeklarowana.

```elixir
iex> 5 = y
** (CompileError) iex:6: undefined function y/0
```

Elixir nie zna jeszcze zmiennej `y`, więc po tym jak jej nie znajduje, stara się jeszcze przeszukać zbór funkcji, którymi dysponuje. Dlatego też tym razem komunikat jest trochę inny. Dostajemy informację, że nie istnieje funkcja `y` z zerową liczbą argumentów. By to naprawić możemy zrobić:

```elixir
iex> y = x + 1
5
iex> 5 = y
5
iex> 5 = x + 1
5
```

Warto tu wspomnieć jeszcze o jednej sprawie. Za każdym razem, gdy w kodzie wpiszesz `x = 3`, _nadpisujesz_ bieżącą wartość zmiennej `x`. Jeżeli chcesz sprawdzić dopasowanie z bieżącym wyrażeniem `x` potrzebujesz użyć operatora `^`:

```elixir
iex> ^x = 4
4
iex> ^x = 5
** (MatchError) no match of right hand side value: 5
```

Jeżeli natomiast chcesz po prostu sprawdzić jaką wartość ma `x` użyj `==` podobnie jak w Ruby:

```elixir
iex> x == 5
false
iex> x == 4
true
```

### Tuples

Zajmijmy się teraz bardziej złożonymi elementami:

```elixir
iex> { a, b } = { 1, 2}
{1, 2}
iex> a
1
iex> b
2
iex> { a, b } = { "one", 2 }
{"one", 2}
iex> a
"one"
iex> b
2
```

Jak pewnie zauważyłaś, możesz użyć pattern matching na bardziej złożonych obiektach. Możemy zrobić też coś takiego:

```elixir
iex> { a, 2 } = { "one", 2 }
{"one", 2}
iex> { a, 3 } = { "one", 2 }
** (MatchError) no match of right hand side value: {"one", 2}
iex> { a, b, c } = { "one", 2 }
** (MatchError) no match of right hand side value: {"one", 2}
```

Po lewej stronie wyrażenia możemy mieć nie tylko zmienne, ale również wartości liczbowe lub jakiekolwiek inne wartości. W chwili gdy lewa strona nie ma liczby 2, dostajemy błąd. Nie pasujemy do wzorca również wtedy, gdy tuple ma inny rozmiar. Wtedy też dostajemy błąd.

### Listy

Teraz czas na listy. Możemy tu rozpatrywać podobne dopasowania jak w przypadku tuple.

```elixir
iex> [a, b] = [4, 5]
[4, 5]
iex> a
4
iex> b
5
```

Możemy zrobić nawet więcej. Wybrać z listy jeden element i zmniejszyć listę wynikową o jeden.

```elixir
iex> [head | tail] = [4, 5, 6]
[4, 5, 6]
iex)> head
4
iex> tail
[5, 6]
```

Jak widzisz, `head` zawiera pierwszy element z listy, natomiast `tail` jest dalej listą tylko bez pierwszego elementu. Można się tym trochę pobawić:

```elixir
iex> [head1 | [head2 | tail]] = [4, 5, 6]
[4, 5, 6]
iex> head1
4
iex> head2
5
iex> tail
[6]
```

Podobnie jak w przypadku tuple, dostajemy błąd, gdy nasza lista ma za mało elementów:

```elixir
iex> [head | tail] = [4]
[4]
iex> head
4
iex> tail
[]
iex> [head | tail] = []
** (MatchError) no match of right hand side value: []
```

Używając tego podejścia możemy też dodać element z przodu naszej listy:

```elixir
iex> list = [4, 5, 6]
[4, 5, 6]
iex> [3 | list]
[3, 4, 5, 6]
```

Kolejną rzeczą, jaka była dla mnie interesująca, to `'hello'` typu **char list**. A skoro jest to lista, to możemy zastosować wszystkie poznane do tej pory operacje na listach również dla napisu `'hello'`. Warto tu jednak pamiętać, że pojedyncze elementy tej listy (znaki) będą reprezentowane jako odpowiednia wartość liczbowa kodów ASCII.

```elixir
iex> [head1 | [head2 | tail]] = 'hello'
'hello'
iex> head1
104
iex> head2
101
iex> tail
'llo'
```

### Case

Pattern matching możemy też używać w `case`:

```elixir
iex> case {4, 5, 6} do
...> {4, 5} -> "One"
...> {4, 5, x} -> "Two #{x}"
...> _ -> "Three"
...> end
"Two 6"
```

Zawsze sprawdzamy dopasowanie zaczynając od góry. Pierwszym pasującym dopasowaniem w tym przypadku będzie `{4, 5, x}`. Dodatkowo dostajemy przypisanie całkowicie za darmo! Jeżeli usunęłybyśmy wyrażenie `{4, 5, x}`, to znalazłybyśmy dopasowanie do ostatniego przypadku. `_` pozwala nam złapać wszystkie przypadki, które nie znalazły dopasowania wcześniej. Możemy też w kodzie dodatkowo użyć warunku zwanego **guard** (strażnikiem):

```elixir
iex> case {4, 5, 6} do
...> {4, 5, x} when x > 6 -> "One"
...> {4, 5, x} when x <= 6 -> "Two #{x}"
...> _ -> "Three"
...> end
"Two 6"
```

Pamiętaj jednak, że nie wszystkie błędy mogą zostać wychwycone. Jeżeli dotyczą one guards.

```elixir
iex> hd([5, 6])
5
iex> hd(5)
** (ArgumentError) argument error
    :erlang.hd(5)
iex> case 5 do
...> x when hd(5) -> "One"
...> x -> "Two"
...> end
"Two"
```

### Funkcje

Nareszcie dotarłyśmy do funkcji. W tym przypadku moim zdaniem pattern matching naprawdę błyszczy. Zacznijmy od funkcji anonimowych:

```elixir
sum = fn
  x, 0 -> x
  x, y when x < 0 -> -x + y
  x, y when x > 0 -> x + y
end

sum.(1, 2)
#=> 3
sum.(-1, 2)
#=> 3
sum.(1, 0)
#=> 1
sum.(-1, 0)
#=> -1
```

Możemy tu używać pattern matching tak, jak w przypadku `case`. Moim zdaniem jest to dość czytelny sposób. Wiem, że przykład podany tutaj nie jest zbyt życiowy i nie obsługuje wszystkich możliwości, jak `sum.(0, 1)`, ale liczę na Twoją wyobraźnię. Zobaczmy teraz przykład z nazwaną funkcją:

```elixir
defmodule Math do
  def minus?(), do: "No number"
  def minus?(x), do: x < 0
  def minus?(x, 2), do: "Suprice #{x}!"
  def minus?(x, y), do: x < 0 && y < 0
end

Math.minus?
#=> "No number"
Math.minus?(1)
#=> false
Math.minus?(1, 2)
#=> "Suprice 1!"
Math.minus?(1, 3)
#=> false
Math.minus?(1, -3)
#=> false
Math.minus?(-1, -3)
#=> true
```

Możemy zadeklarować tą samą nazwę funkcji i podawać różną liczbę argumentów, a także różne typy. W przejrzysty sposób widzimy wszystkie przypadki. W Ruby możemy próbować osiągnąć coś podobnego używając domyślnych wartości i sprawdzając różne warunki. Nie jestem jednak przekonana, że będzie to wyglądać bardziej przejrzyście. Na koniec chciałabym pokazać jeszcze jeden przykład tym razem z rekurencją:

```elixir
defmodule Math do
  def sum_list(list, accumulator \\ 0)

  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  def sum_list([], accumulator) do
    accumulator
  end
end

Math.sum_list([1, 2, 3])
#=> 6
Math.sum_list([1, 2, 3], 1)
#=> 7
```

Oczywiście możemy ten sam efekt osiągnąć używając `reduce` w Elixirze, ale chciałabym spojrzeć na ten przykład z perspektywy samej rekurencji. Deklarujemy domyślną wartość dla `accumulator` i dwa razy zapisujemy definicję funkcji. Raz by podać warunek zatrzymania, a raz by pokazać jeden krok _iteracji_. Od razu widać co się dzieje. Dla tego konkretnego przykładu pętla będzie dalej czytelna, trudno jednak będzie to samo stwierdzić dla bardziej skomplikowanego przypadku. Mi osobiście bardzo podoba się to podejście.

To tyle na dziś. Mam nadzieje, że też miałaś trochę frajdy z tego jak działa **pattern matching w Elixirze**. Do zobaczenia niedługo w następnym artykule. Dzięki, że tu ze mną jesteś. Trzymaj się! Pa!
