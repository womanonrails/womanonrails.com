---
excerpt: >
  Ruby, podobnie jak inne języki programowania,
  ma wiele sposobów na wykonywanie kodu wielokrotnie.
  Możemy do tego celu użyć **pętli** takich jak
  `loop`, `while`, `until` czy `for`.
  Są one oczywiście bardzo przydatne,
  ale w języku Ruby występują również **iteratory**.
  Moim zadaniem są one jeszcze lepsze niż pętle.
  W języku Ruby mamy wiele różnych iteratorów,
  z których każdy ma inne zastosowanie.
  Najczęściej używane iteratory to
  `each`, `map`, `collect`, `select`, `find`, `times`.
  Ale moment!
  Kiedy powinnyśmy użyć iteratora `each`, a kiedy iteratora `map`?
  To bardzo dobre pytanie i właśnie dziś na nie odpowiemy.
layout: post
title: Iteratory w Ruby
description: Po co w języku Ruby są iteratory each, map, collect, select, find lub times?
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
lang: pl
---

Ruby podobnie jak inne języki programowania ma wiele sposobów na wykonywanie kodu wielokrotnie. Możemy do tego celu użyć **pętli** takich jak `loop`, `while`, `until` czy `for`. Są one oczywiście bardzo przydatne, ale w języku Ruby występują również **iteratory**. Moim zadaniem są one jeszcze lepsze niż pętle. W języku Ruby mamy wiele różnych iteratorów, z których każdy ma inne zastosowanie. Najczęściej używane iteratory to `each`, `map`, `collect`, `select`, `find`, `times`. Ale moment! Kiedy powinnyśmy użyć iteratora `each`, a kiedy iteratora `map`? To bardzo dobre pytanie i właśnie dziś na nie odpowiemy.

## Podstawowe pojęcia

Zanim przejdziemy do iteratorów i odpowiedzi na pytanie kiedy stosować iteratory, zacznijmy od wyjaśnienia podstawowych pojęć.

#### Pętla

**Co to jest pętla?** Pętla to wielokrotne wykonanie fragmentu kodu, który raz został zapisany w programie i jest uruchamiany aż do spełnienia z góry określonego warunku. Jest to bardzo użyteczna instrukcja w programowaniu pozwalająca na zautomatyzowanie pewnych powtarzalnych czynności/akcji. Możesz o pętli myśleć jak o fabryce produkującej kubki ceramiczne. Powtarzalną czynnością może być w tym przykładzie pakowanie kubków do pudełek. W takich przypadkach w fabryce stosujemy roboty, a w programowaniu pętle. A oto prosty przykład pętli:

```ruby
x = 0

while x < 10
  if x.even?
    puts x
  end
  x += 1
end

# 0
# 2
# 4
# 6
# 8
#  => nil
```

Chcemy wyświetlić na ekranie tylko liczby parzyste poniżej liczby 10. Ruby automatycznie przechodzi krok po kroku przez wszystkie liczby poniżej 10 i wyświetla te, które spełniają warunek parzystości. Nie musimy robić tego manualnie.

#### Iterator

Teraz przejdźmy do **iteratorów**. Iterator to obiekt (czasami mówimy też metoda) pozwalający iterować po elementach zbioru. Możemy więc przejść w _pętli_ przez każdy element kolekcji i wykonać na nim powtarzalne operacje. Patrząc na tę definicję możesz stwierdzić, że co do funkcji jaką pełni iterator, to jest ona dokładnie taka sama, jak w przypadku pętli. I będziesz mieć rację, ale sposób w jaki iterator tę funkcję wykonuje jest inny. Kiedy używasz pętli, używasz _zewnętrznego obiektu_ do wykonania powtarzalnych czynności. W naszym przykładzie z kubeczkami był to robot. W przypadku iteratora kolekcja sama wykonuje te iteracje. Innymi słowy kolekcja ma swój własny iterator. To tak jakby kolekcja kubeczków sama się pakowała w pudełka bez zewnętrznego robota. Byłoby cudownie mieć coś takiego w prawdziwym życiu. Kupujesz zestaw talerzy, a on sam myje się po użyciu. Nieźle prawda? W świecie języka Ruby o wiele częściej korzystamy z iteratorów niż ze zwykłych pętli. Zwłaszcza jeżeli operujemy na obiektach typu `Array` lub `Hash`. W wielu przypadkach po prostu potrzebujemy wykonać pewne operacje na każdym elemencie kolekcji i niezależny nam na indeksie tego elementu.

```ruby
array = ['a', 'b', 'c']

for i in 0...array.size do
  puts array[i]
end

# a
# b
# c
#  => 0...3
```

W przykładzie powyżej używamy pętli `for` oraz iterujemy po kolejnych indeksach elementów w tablicy `array`. Oczywiście możesz powiedzieć, że w przypadku pętli `for` nie musimy iterować po indeksach. To prawda, ale dalej będziesz używać zewnętrznego _narzędzia_ do wykonania instrukcji. Tak jak w następnym przykładzie:

```ruby
array = ['a', 'b', 'c']

for item in array do
  puts item
end

# a
# b
# c
#  => ["a", "b", "c"]
```

Istnieje też inne rozwiązanie. Możemy też użyć iteratora, który jest częścią naszej kolekcji.

```ruby
array = ['a', 'b', 'c']

array.each do |item|
  puts item
end

# a
# b
# c
#  => ["a", "b", "c"]
```

## Typy iteratorów

Znamy podstawowe pojęcia. Teraz nadszedł czas by odpowiedzieć sobie na następujące pytania:
- Jakie są różnice między iteratorami?
- Kiedy możemy użyć iteratorów?
- Gdzie możemy użyć iteratorów?
- Jakie jest przeznaczenie konkretnych iteratorów?
- Jak wybrać najlepszy iterator do swojego celu?

### Each

`each` to najpopularniejszy iterator w języku Ruby. Mogłaś go już poznać w przykładzie powyżej. Używając iteratora `each` możesz wykonać operacje lub kalkulacje na elementach kolekcji.

```ruby
word = ''

['r', 'u', 'b', 'y'].each do |letter|
  word += letter
end

#  => ["r", "u", "b", "y"]

word
#  => "ruby"
```

Jako wynik po kalkulacjach w przypadku iteratora `each` dostaniemy bazową kolekcję. W naszym przykładzie jest to `['r', 'u', 'b', 'y']`. To dokładnie ta sama kolekcja, na której został użyty iterator. Nie znaczy to, że nie jest możliwa zmiana początkowego obiektu. Nie zawsze jest to zachowanie, jakiego byśmy oczekiwały, ale warto pamiętać, że jest to możliwe. Jeżeli chciałabyś zrobić to celowo to prawdopodobnie lepszym rozwiązaniem będzie użycie iteratora `map!` lub `collect!`. To pozwoli bezpośrednio zaznaczyć, że chcesz zmienić początkową kolekcję. Więcej o tych dwóch iteratorach będziesz mogła się dowiedzieć w dalszej części artykułu. A teraz zobaczmy kiedy może dojść do zmiany, nadpisania kolekcji początkowej w przypadku iteratora `each`.

```ruby
array = [{ static: "I don't want to be changed!" }, { static: 'Me too!' }]

array.each do |item|
  item[:dynamic] = 'I can change yours objects!'
end

#  => [{:static=>"I don't want to be changed!", :dynamic=>"I can change yours objects!"}, {:static=>"Me too!", :dynamic=>"I can change yours objects!"}]

array
#  => [{:static=>"I don't want to be changed!", :dynamic=>"I can change yours objects!"}, {:static=>"Me too!", :dynamic=>"I can change yours objects!"}]
```

W tym przypadku kolekcja, jaka została zwrócona po użyciu iteratora jest inna niż kolekcja początkowa. Dodatkowo watro zauważyć, że zmieniła się również początkowa wartość zmiennej `array`! Tak dzieje się w przypadku gdy `item` jako element naszej kolekcji to _złożony obiekt_ i wewnątrz iteratora próbujemy go zmienić używając na przykład przypisania. Więcej na ten temat pisałam w artykule <a href="{{ site.baseurl }}/ruby-hash-tips" title="Użyteczne metody dla klasy Hash w języku Ruby">Triki dla obiektu Hash w Ruby</a>. Taka sytuacja nie zajdzie w przypadku tablicy zwykłych liczb.

```ruby
array = [1, 2, 3]

array.each do |item|
  item = 5
end

#  => [1, 2, 3]

array
#  => [1, 2, 3]
```

Iteratora `each` będziesz używać za każdym razem, gdy najważniejszą rzeczą w Twoim fragmencie logiki będą same kalkulacje. Nie będzie dla Ciebie istotne, co zostaje zwrócone z `each` i nie chcesz zmieniać początkowego obiektu na jakim iterator `each` został wywołany.

Na koniec tej sekcji chciałabym powiedzieć jeszcze jedną rzecz. W języku Ruby występuje wiele typów iteratora `each` dla różnych obiektów. Przykładowo: `each_char`, `each_line`, `each_with_index` czy <a href="{{ site.baseurl }}/each-with-object" title="Jak używać metody each_with_object?">`each_with_object`</a>. Możesz ich używać w różnych kontekstach. Jeżeli jesteś zainteresowana większą ilością informacji na ich temat, to zachęcam do skorzystania z
{% include links/external-link.html name='dokumentacji języka Ruby' url='https://ruby-doc.org/' %}.

### Map / collect

`map` i `collect` to dokładnie ten sam iterator, który ma dwie rożne nazwy. Jego zachowanie różni się od zachowania iteratora `each`. Gdy iterator `each` zwraca nam pierwotną kolekcję, to iterator `map` zwraca nam kolekcję powstałą w wyniku kalkulacji znajdujących się wewnątrz `map`. Przyjrzyj się przykładowi poniżej:

```ruby
array = [1, 2, 3, 4, 5]

array.map do |item|
  item ** 2
end

#  => [1, 4, 9, 16, 25]

array
#  => [1, 2, 3, 4, 5]
```

Jak widać początkowa wartość zmiennej `array` nie uległa zmianie. Dalej pozostała równa `[1, 2, 3, 4, 5]`. Sytuacja wygląda inaczej jeżeli chodzi o to, co zostało zwrócone zaraz po wykonaniu iteratora. Dostałyśmy `[1, 4, 9, 16, 25]`, czyli dokładnie wynik obliczeń `item ** 2`, gdzie `item` to każda kolejna liczba znajdująca się w tablicy `array`.

Tego iteratora będziemy używać zawsze, gdy interesuje nas zwrócony z iteratora wynik, ale nie chcemy modyfikować początkowej kolekcji.

### Map! / collect!

Idźmy krok dalej. W przypadku iteratora `map!`, ten dołożony na końcu wykrzyknik `!` ma duże znaczenie. Gdy użyjemy iteratora `map!`, to nadpiszemy wartość kolekcji początkowej kalkulacjami z wnętrza iteratora `map!`. Zobaczmy to na przykładzie:

```ruby
array = [1, 2, 3, 4, 5]

array.map! do |item|
  item ** 2
end

#  => [1, 4, 9, 16, 25]

array
#  => [1, 4, 9, 16, 25]
```

Jak widać nie tylko zmienił się zwracany z `map!` wynik, ale również zmieniła się wartość zmiennej `array`. Na początku miałyśmy tam `[1, 2, 3, 4, 5]`, a po zakończeniu pracy naszego iteratora mamy `[1, 4, 9, 16, 25]`. Ten iterator może być przydatny, jeżeli chcemy pracować na tej samej zmiennej i modyfikować jej wartość w trakcie działania programu.

Warto tu zauważyć, że efekt jaki otrzymujemy dzięki `map!` możemy uzyskać również za pomocą zwykłego `map` ale z przypisaniem.

```ruby
array = [1, 2, 3, 4, 5]

array = array.map do |item|
  item ** 2
end

#  => [1, 4, 9, 16, 25]

array
#  => [1, 4, 9, 16, 25]
```

Jeszcze jedna rzecz. Bądź ostrożna gdy używasz `map!`. Ten iterator modyfikuje bieżący stan obiektu, na jakim został wywołany. Taka modyfikacja stanu zawsze wprowadza większą złożoność do naszego kodu. Bardzo często jest to odczuwalne dopiero wtedy, gdy chcemy zrozumieć, co dzieje się z naszymi zmiennymi i ich stanem w momencie wystąpienia jakiegoś błędu w systemie.

### Select

Teraz przejdziemy do czegoś zupełnie innego. Iterator `select` nie będzie wykonywał kalkulacji na elementach kolekcji. On będzie wybierał z kolekcji tylko te elementy, które spełniają zadany warunek logiczny. Pozostałe elementy zostaną z tej kolekcji usunięte.

```ruby
(1..10).select do |item|
  item.even?
end

#  => [2, 4, 6, 8, 10]
```

Całą kolekcję możemy otrzymać używając iteratora `select` tylko wtedy, gdy każdy z elementów kolekcji spełni zadany warunek.

```ruby
(1..10).select do |item|
  item.is_a?(Numeric)
end

#  => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

Ten iterator jest bardzo przydatny, gdy chcesz wybrać pewne elementy z większej grupy. Nie jesteś zainteresowana całą kolekcją, lecz jej konkretnym podzbiorem.

Analogicznie działają iteratory `filter` oraz `find_all`.

### Find

Iterator `find` jest w pewnym sensie podobny do iteratora `select`. Z tą jedną różnicą, że dzięki iteratorowi `select` możemy wybrać podzbiór początkowej kolekcji, a w przypadku iteratora `find` wybieramy zawsze **pierwszy element spełniający zadany warunek**. Otrzymany wynik po wykonaniu iteratora `find` jest więc pojedynczym elementem, a nie kolekcją.


```ruby
(1..10).find do |item|
  item.even?
end

#  => 2
```

Ten iterator wykorzystamy wtedy, gdy szukamy w kolekcji konkretnego, jednego elementu posiadającego pewne zadane przez nas cechy.

### All? / Any?

Dalej pozostajemy w temacie sprawdzania warunków logicznych na elementach kolekcji. Tym razem omówimy dwa iteratory zwracające po ich wykonaniu wartość logiczną typu `Boolean` czyli `true` bądź `false`. Jest to iterator `all?` oraz iterator `any?`. Pierwszy z nich, czyli iterator `all?` zwróci nam `true` wtedy i tylko wtedy, gdy **wszystkie elementy** kolekcji spełnią postawiony przed nimi warunek logiczny.

```ruby
(1..10).all? do |item|
  item.even?
end

#  => false
```

Ponieważ tylko połowa liczb między 1 a 10 jest parzysta, to jako wynik po użyciu iteratora `all?` dostajemy `false`. Sytuacja wygląda inaczej, gdy chodzi o iterator `any?`. W tym przypadku wystarczy, że **przynajmniej jeden element** spełni zadany warunek a otrzymamy `true`.

```ruby
(1..10).any? do |item|
  item.even?
end

#  => true
```

W przypadku przykładu powyżej już liczba `2` jest liczbą parzystą, warunek został spełniony, więc zostaje zwrócone `true`.

Możesz używać tych iteratorów, gdy chcesz sprawdzić czy elementy w Twojej kolekcji mają jakąś właściwość lub cechę. Nie jesteś jednak zainteresowana samym elementem bądź elementami, tylko informacją o posiadaniu przez nie danej właściwości, cechy.

### Times

Na koniec zostawiłam iterator `times`. Ten iterator służy do powtarzania danej czynności określoną ilość razy. Nie używamy tego iteratora na kolekcji, lecz na liczbie. Będzie on zawsze zwracał obiekt bazowy, czyli w naszym przypadku liczbę. Zobacz przykład użycia `times` w Ruby:

```ruby
5.times do
  puts 'Ruby `times` method repeat this line.'
end

# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
# Ruby `times` method repeat this line.
#  => 5
```

Oczywiście istnieje możliwość śledzenia, który raz zostaje wykonany kod w naszym iteratorze `times`. Możemy do tego użyć bieżący numer iteracji.

```ruby
5.times do |iterator|
  puts "#{iterator}. I repeat this text."
end

# 0. I repeat this text.
# 1. I repeat this text.
# 2. I repeat this text.
# 3. I repeat this text.
# 4. I repeat this text.
#  => 5
```

## Podsumowanie

Na początku przedstawiłam różnicę pomiędzy pętlą a iteratorem. W dalszej części artykułu omówione zostały następujące iteratory:
- [each](#each)
- [map/collect](#map--collect)
- [map!/collect!](#map--collect-1)
- [select](#select)
- [find](#find)
- [all?/any?](#all--any)
- [times](#times)

Mam nadzieję, że pozwoli Ci to lepiej zrozumieć w jaki sposób należy używać iteratorów i jakie są różnice między nimi.
