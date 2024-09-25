---
excerpt: >
  Ruby jest językiem obiektowym.
  Nie znaczy to jednak,
  że nie możemy przy pomocy Rubiego programować bardziej funkcyjnie.
  Gdy przyjrzymy się historii języka Ruby zauważymy,
  że u jego podstaw leży wiele różnych technologi.
  Twórca Rubiego, Yukihiro Matsumoto, inspirował się takimi językami jak:
  Perl, Smalltalk, Eiffel, Ada, Basic czy Lisp.
  Dzięki tym wszystkich inspiracjom
  w języku Ruby możemy znaleźć nie tylko koncepcje programowania obiektowego,
  ale również odrobinę programowania funkcyjnego.
layout: post
title: Programowanie funkcyjne w Ruby
description: Krótkie wprowadzenie do bloków, lambd, domknięć i obiektów typu Proc.
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby, programowanie funkcyjne]
lang: pl
---

Ruby jest językiem obiektowym. Nie znaczy to jednak, że nie możemy przy pomocy Rubiego programować bardziej funkcyjnie. Gdy przyjrzymy się historii języka Ruby zauważymy, że u jego podstaw leży wiele różnych technologi. Twórca Rubiego, Yukihiro Matsumoto, inspirował się takimi językami jak: Perl, Smalltalk, Eiffel, Ada, Basic czy Lisp. Dzięki tym wszystkich inspiracjom w języku Ruby możemy znaleźć nie tylko koncepcje programowania obiektowego, ale również odrobinę programowania funkcyjnego.

Zanim jednak przejdziemy do szczegółów, wytłumaczę podstawowe pojęcia. Czym jest **programowanie funkcyjne**? Jest to **paradygmat programowania**. Znaczy to tyle, że jest to sposób klasyfikowania języka na podstawie jego cech. W takim razie jakimi cechami charakteryzuje się programowanie funkcyjne?

- Czyste funkcje (Pure functions) - Funkcja zawsze zwraca ten sam wynik dla tych samych argumentów i nie powoduje dodatkowego, obserwowalnego efektu ubocznego. Tak właśnie zachowują się funkcje w matematyce.
- Niezmienność (Immutability) - Po utworzeniu stanu (wpisaniu wartości do zmiennej) nie możemy go już zmienić. Zamiast zmieniać stan, tworzymy nowy.
- Przejrzystość referencyjna (Referential transparency) - jest to połączenie dwóch poprzednich pojęć.
- Memoization - Jest to efekt uboczny przejrzystości referencyjnej. Pozwala przyspieszyć obliczenia za pomocą zapamiętania już wcześniej wywołanych kalkulacji, które przy kolejnym wywołaniu dadzą ten sam wynik.
- Idempotentność (Idempotence) - Niezależnie ile razy wywołamy daną funkcję na sobie samej, da nam ona ten sam wynik. Jest to też konsekwencja przejrzystości referencyjnej.
- Funkcje wyższego rzędu (Higher-order functions) - Funkcja, która przyjmuje inną funkcję jako argument lub zwraca funkcję jako wynik.
- Rozwijanie funkcji (Currying) - Jest to operacja, która przekształca funkcję wieloargumentową w funkcję przyjmującą jeden argument, ale zwracającą na wyjście nową funkcję. Można powiedzieć, że to rodzaj generatora funkcji.
- Rekurencja (Recursion) - Wywołanie funkcji przez samą siebie. W programowaniu odbywa się to bardzo często tak długo, aż zostanie osiągnięty wcześniej zdefiniowany warunek zatrzymania.
- Wartościowanie leniwe (Lazy evaluation) - Podejście pozwalające na obliczanie zadanych kalkulacji (często argumentów wejściowych funkcji) dopiero wtedy, gdy są one potrzebne, a nie na początku po ich zadeklarowaniu.

Teraz gdy już wiemy trochę o samej koncepcji programowania funkcyjnego możemy przejść do funkcyjnego podejścia do programowania w języku Ruby.

## Bloki w Ruby

**Blok jest funkcją bez nazwy w języku Ruby.** Funkcją anonimową, o której powiem więcej w części dotyczącej lambdy. Taki blok możemy podać, jako ostatni argument do innej funkcji i może być on **tylko jeden**. W języku Ruby bloki są też związane z funkcjami wyższego rzędu. Często wykorzystywanym blokiem kodu jest `each`:

```ruby
[1, 2, 3, 4].each do |item|
  p item
end

1
2
3
4
 => [1, 2, 3, 4]
```

Stwórzmy teraz nasz własny blok:

```ruby
def my_own_block
  p 'before'
  yield if block_given?
  p 'after'
end

irb> my_own_block
"before"
"after"
 => "after"
```

Jak widzisz `my_own_block` zachowuje się jak normalna funkcja, ponieważ nią właśnie jest. Magia zaczyna się dopiero wtedy, gdy zaczniemy używać `yield`. Ale co to tak właściwie jest ten `yield`? Jest to wywołanie bloku kodu, naszej funkcji niemającej nazwy, którą możemy podać jako argument metody `my_own_block`. Zobaczmy, jak można to zrobić:

```ruby
irb> my_own_block { p 5 }
"before"
5
"after"
 => "after
```

By wywołać nasz blok kodu jako argument funkcji, potrzebujemy użyć nawiasów klamrowych `{}` lub klauzuli `do end`. Nie możemy użyć naturalnych dla nas w takim przypadku nawiasów okrągłych `()`. Gdybyśmy tak zrobiły, dostałybyśmy błąd:

```ruby
irb> my_own_block(p 5)
5
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):13
        2: from (irb):13:in `rescue in irb_binding'
        1: from (irb):4:in `my_own_block'
ArgumentError (wrong number of arguments (given 1, expected 0))
```

Na samym początku widzimy liczbę `5`, ponieważ Ruby zaczyna od wywołania (obliczenia) wszystkich argumentów funkcji. Przy okazji możemy powiedzieć, że jest to **zachłanne wartościowanie** (strict evaluation), czyli coś odwrotnego do wartościowania leniwego, o którym była mowa na początku artykułu. Dalej widzimy wyjątek `wrong number of arguments (given 1, expected 0)` mówiący nam, że nasza metoda spodziewa się zerowej ilości argumentów, a otrzymała jeden. Oznacza to, że argumenty typu blokowego są traktowane przez język Ruby w inny sposób niż pozostałe argumenty. Nie możemy ich użyć, jak normalnych argumentów. Przynajmniej na razie. W dalszej części artykułu pokażę jak to zrobić.

W tym przykładzie nie powiedziałam Ci jeszcze o jednej rzeczy. Co to jest `block_given?`? Jest to metoda, która pomaga nam sprawdzić, czy blok kodu został podany jako argument do metody `my_own_block`. Gdybyśmy tego nie sprawdziły w przypadku braku podania bloku do naszej metody, otrzymałybyśmy błąd. Zobaczmy, jak to wygląda na przykładzie:

```ruby
def my_own_block
  p 'before'
  yield
  p 'after'
end

irb> my_own_block
"before"
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):19
        1: from (irb):16:in `my_own_block'
LocalJumpError (no block given (yield))
```

## Obiekt Proc

**Proc** jest jedną z klas dostępnych w języku Ruby (w standardowej bibliotece tego języka). `Proc` jest obiektem, który enkapsuluje (hermetyzuje) blok kodu i pozwala wpisać go do zmiennej. Taka zmienna może zostać przekazana jako argument do metody i tam wywołana jak normalny blok kodu. To właśnie obiekt `Proc` jest jedną z podstawowych koncepcji programowania funkcyjnego w języku Ruby.

We wcześniejszych przykładach widziałaś już jeden sposób deklarowania metody z argumentem typu blok. Oto inny sposób deklaracji:

```ruby
def my_block(&block)
  p 'before'
  p block.class
  block.call
  p 'after'
end
```

Możemy wywołać naszą metodę w ten sam sposób jak poprzednio:

```ruby
irb> my_block { p 4 }
"before"
Proc
4
"after"
 => "after"
```

Podczas wywołania naszej metody widzimy, że obiekt znajdujący się pod zmienną `block` jest instancją klasy `Proc`. Tym razem by wywołać nasz blok kodu używamy `block.call` zamiast metody `yield`. Jednak obiekt typu `Proc` jest jeszcze ciekawszy niż taki zwykły blok. Możemy wiele takich obiektów przekazać jako argumenty funkcji:

```ruby
def run_proc(first, last)
  first.call
  last.call
end
proc1 = Proc.new { p 'first' }
proc2 = Proc.new { p 'last' }

irb> run_proc proc1, proc2
"first"
"last"
 => "last"
```

Obiekt typu `Proc` możemy wywołać również poza metodą i to na wiele różnych sposobów:

```ruby
my_proc = Proc.new do |item|
  p "Text: #{item}"
end

irb> my_proc.call 10
"Text: 10"
 => "Text: 10"

irb> my_proc.(20)
"Text: 20"
 => "Text: 20"

irb> my_proc[30]
"Text: 30"
 => "Text: 30"

irb> my_proc === 40
"Text: 40"
 => "Text: 40"
```

To pozwala nam na wykorzystanie obiektu `Proc` również w klauzuli `case`:

```ruby
proc1 = Proc.new { |number| number % 3 == 0 }
proc2 = Proc.new { |number| number % 3 == 1 }

case 3
when proc1 then p 'proc1'
when proc2 then p 'proc2'
else
  p 'not a proc'
end
"proc1"
 => "proc1"
```

Ponieważ `case` podczas sprawdzania warunków używa operatora porównania (equality operator) `===`, a obiekt `Proc` implementuje tą metodę, możemy używać obiektu `Proc` wewnątrz `case`. Przy okazji z tego samego powodu w `case` możemy używać również obiektów typu `Range`:

```ruby
irb> (4..7) === 5
 => true

irb> (4..7) === 8
 => false
```

A teraz pokażę Ci jeszcze jeden sposób na zadeklarowanie metody z wykorzystaniem obiektu `Proc`:

```ruby
def run_proc
  p 'before'
  my_proc = Proc.new
  my_proc.call
  p 'after'
end

irb> run_proc { p 6 }
"before"
6
"after"
 => "after"
```

Kiedy przyjrzysz się tej implementacji bliżej, może się ona wydać dziwna. Nie deklarujemy argumentu dla naszej metody, więc jak `Proc.new` wie co robić? Normalnie gdy użyjemy `Proc.new` bez deklaracji bloku kodu dostaniemy wyjątek `tried to create Proc object without a block`. W tym przypadku `Proc.new` nie ma swojej deklaracji bloku, więc będzie szukał jego deklaracji w bieżącym zakresie (scope). Kiedy więc uruchamiamy metodę `run_proc` wraz z blokiem kodu, wszystko działa jak należy.

## Lambdy

**Lambda** to funkcja anonimowa. Jest to definicja funkcji, która nie ma swojej nazwy. Nie ma swojego identyfikatora. Ale taką funkcję możesz wpisać do zmiennej, a później wywołać ją w dowolnym miejscu. Funkcje anonimowe są często wykorzystywane i przekazywane jako argumenty do innych funkcji, funkcji wyższego rzędu. W języku Ruby lambda jest bardzo podobna do obiektu `Proc`, choć istnieją pomiędzy nimi małe różnice. Oto one:

#### Kontrola ilości argumentów

Zadeklarujemy sobie lambdę i obiekt typu `Proc`. Przy okazji w dalszej części artykułu będę zamiennie stosować dwie formy deklaracji obiektu `Proc`: `Proc.new` i `proc`.

```ruby
my_proc = Proc.new { |item| p "==#{item}==" }
my_lambda = lambda { |item| p "==#{item}==" }
```

Te dwa obiekty mają tą samą klasę:

```ruby
irb> my_proc.class
 => Proc

irb> my_lambda.class
 => Proc
```

Mają też tą samą ilość argumentów (tą samą arność):

```ruby
irb> my_proc.arity
 => 1

irb> my_lambda.arity
 => 1
```

Istnieje jednak pomiędzy nimi różnica, gdy wywołamy je bez argumentów lub ze złą ilością argumentów. `Proc` wykona się natomiast lambda zwróci wyjątek:

```ruby
irb> my_proc.call
"===="
 => "===="

irb> my_lambda.call
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):77
        1: from (irb):62:in `block in irb_binding'
ArgumentError (wrong number of arguments (given 0, expected 1))
```

Jak już pokazałam wcześniej nie da się rozróżnić obiektu `Proc` i lambdy na podstawie klasy. Da się je rozróżnić używając metody `lambda?`.

```ruby
irb> my_proc.lambda?
 => false

irb> my_lambda.lambda?
 => true
```

Chciałabym dodać tu jeszcze jedną rzecz. Jeżeli zadeklarujemy w lambdzie listę argumentów w postaci tablicy, ilość argumentów będzie widoczna jako `-1`.

```ruby
irb> lambda { |*items| }.arity
 => -1
```

Na koniec pokażę Ci jeszcze jeden sposób na zadeklarowanie lambdy przy pomocy operatora strzałkowego (arrow operator) `->`.

```ruby
my_lambda = -> (item) { p "==#{item}==" }

irb> my_lambda.lambda?
 => true
```

#### Używanie z return

Na początek zadeklarujemy metodę, która będzie wywoływać obiekt typu `Proc` lub lambdę.

```ruby
def run(proc)
  p 'before'
  proc.call
  p 'after'
end
```

Uruchommy naszą metodę `run` z lambdą:

```ruby
irb> run lambda { p 'in'; return }
"before"
"in"
"after"
 => "after"
```

Wszystko wygląda w porządku. To teraz przejdźmy do `Proc`:

```ruby
irb> run proc { p 'in'; return }
"before"
"in"
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):91
        2: from (irb):87:in `run'
        1: from (irb):91:in `block in irb_binding'
LocalJumpError (unexpected return)
```

Widzimy błąd. Nasze wywołanie zaczyna się od `"before"`, później obiekt `Proc` wypisuje `"in"` i zaraz po tym dostajemy wyjątek. Dzieje się tak dlatego, że `Proc` nie zwraca bieżącego kontekstu ale **zwraca kontekst w którym został zdefiniowany**. To znaczy, że w tym konkretnym przypadku próbuje wyjść z głównego kontekstu naszej interaktywnej konsoli irb. Ponieważ `Proc` nie ma uprawnień do wyjścia z głównego kontekstu my widzimy błąd. Spróbujmy w takim razie zmienić kontekst:

```ruby
def change_context
  run lambda { p 'in'; return }
  run proc { p 'in'; return }
end
```

Uruchommy teraz metodę `change_context`:

```ruby
irb> change_context
"before"
"in"
"after"
"before"
"in"
 => nil
```

Na początku zostaje wywołana lambda. A na ekranie zostaje wypisane: `"before"`, `"in"` i `"after"`. Później zostaje wywołany obiekt `Proc`. I widzimy `"before"`, `"in"`. Po tym nasza metoda się kończy. Nasz `Proc` wyszedł z kontekstu w którym został utworzony, czyli wyszedł z metody `change_context` a drugi `"after"` nigdy nie został wyświetlony.

## Domknięcia (Closures)

**Domknięcie** to technika tworzenia funkcji na podstawie innej funkcji korzystając z jej kontekstu (środowiska stworzenia). Ten **kontekst ma wpływ na funkcję podczas jej deklaracji**. Domknięcie jest to jeden ze sposobów na generowanie nowych funkcji i jest on związany z tematem funkcji wyższego rzędu. By lepiej zobrazować czym jest domknięcie przejdźmy do przykładu:

```ruby
def multiple(m)
  lambda { |n| n * m }
end

double = multiple(2)
triple = multiple(3)

# Execute
irb> double[5]
 => 10
irb> triple[5]
 => 15
```

Deklarujemy funkcję `multiple`, która posiada jeden argument. W środku tej funkcji używamy lambdy, która również przyjmuje jeden argument, ale dodatkowo używa zmiennej `m` zadeklarowanych w zakresie funkcji `multiple`. Teraz możemy generować funkcje na podstawie metody `multiple`. Gdy podstawiamy wartość `2` za `m` otrzymujemy funkcję anonimową (lambdę) `double`. Wewnętrznie ta lambda wraz z kontekstem, w którym została stworzona wygląda tak: `lambda { |n| n * 2 }`. Teraz gdy będziemy chciały użyć funkcji `double` z argumentem `5`, wartość ta zostanie podstawiana do zmiennej `n`. Otrzymamy `5 * 2` czyli `10`.

Jest jeszcze jedna rzecz, którą warto zapamiętać. W języku Ruby podczas tworzenia domknięcia zapamiętywana jest referencja do zmiennej, a nie jej wartość. To dość istotne, bo w innych językach programowania spotyka się raczej sytuację, gdy to wartość jest zapamiętywana. Ta cecha domknięcia w języku Ruby powoduje, że jesteśmy w stanie zmienić kontekst po jego deklaracji. Nie możemy natomiast stworzyć (zadeklarować) kontekstu po deklaracji domknięcia. Zobaczmy to na przykładach poniżej, zaczynając od sytuacji, gdy kontekst nie był zadeklarowany w chwili tworzenia domknięcia:

```ruby
my_proc = proc { p first_name }

irb> my_proc.call
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):107
        1: from (irb):105:in `block in irb_binding'
NameError (undefined local variable or method `first_name' for main:Object)
```

Dostajemy błąd. Nie pomoże nam nawet próba do deklarowania brakującego kontekstu:

```ruby
first_name = "Agnieszka"
 => "Agnieszka"

irb> my_proc.call
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):109
        1: from (irb):105:in `block in irb_binding'
NameError (undefined local variable or method `first_name' for main:Object)
```

Nie jest możliwe dodanie kontekstu po deklaracji naszego domknięcia. Natomiast jak zobaczysz w następnym przykładzie możemy zmienić już istniejący kontekst:

```ruby
name = 'Agnieszka'
my_proc = proc { p name }

irb> my_proc.call
"Agnieszka"
 => "Agnieszka"

name = 'Ula'
irb> my_proc.call
"Ula"
 => "Ula"
```

#### Metoda jako "lambda"

Możemy zdefiniować metodę, a później użyć jej jako coś w rodzaj funkcji anonimowej:

```ruby
def my_method
  p 'Hello word'
end

my_proc = method(:my_method)

irb> my_proc.call
"Hello word"
 => "Hello word"
```

#### Typy domknięć w języku Ruby

Mamy kilka typów domknięć w języku Ruby:
- block + `yield`
- block + `&b`
- `Proc.new`
- `proc`
- `lambda`
- `method`

#### Gdzie używamy domknięć?

Czysty Ruby:

```ruby
[1, 2, 3].each { |item| p item }

[1, 2, 3].each_cons(2).map { |x, y| x + y }

[1, 2, 3].map { |item| item.next }

[1, 2, 3].inject(0) { |sum, item| sum + item }
[1, 2, 3].inject(0, :+)
```

W Ruby on Rails:

```ruby
respond_to do |format|
  format.html # index.html.erb
  format.xml  { render :xml => @items }
end
```

## Ciekawostka - Lisp w języku Ruby

By stworzyć listy podobne do list jakie występują w języku Lisp, będziemy potrzebować leniwego wartościowania i rekurencji. Ale najpierw zobaczmy jak wyglądają listy w języku Lisp.

```common-lisp
(write '(1 2 3 4))
 => (1 2 3 4)

(write (car '(1 2 3 4)))
 => 1

(write (cdr '(1 2 3 4)))
 => (2 3 4)
```

Jeżeli czytałaś mój artykuł o [podstawach języka Elixir]({{site.baseurl}}/elixir-pattern-matching "Elixir - Dopasowanie do wzorca") możesz porównać `car` i `cdr` do  `head` i `tail` w Elixirze. `car` zawsze zwróci pierwszy element listy, natomiast `cdr` zwróci listę bez pierwszego elementu. Zacznijmy od przygotowania tablicy w języku Ruby, która będzie się zachowywać jak lista w języku Lisp.

```ruby
car, cdr = [1,[2,[3]]]

irb> car
 => 1

irb> cdr
 => [2, [3]]
```

Teraz przygotujemy własny enumerator, który będzie mógł iterować po takich listach:

```ruby
class LispyEnumerable
  include Enumerable

  def initialize(tree)
    @tree = tree
  end

  def each
    while @tree
      car, cdr = @tree
      yield car
      @tree = cdr
    end
  end
end
```

To pozwoli nam na zrobienie pewnych operacji na `car` początkowym elemencie listy i nadpisze zmienną `@tree` nową krótszą o jeden element tablicą `cdr`. Nasz kod możemy wywołać w następujący sposób:

```ruby
list = [1,[2,[3]]]
irb> LispyEnumerable.new(list).each { |item| p item }
1
2
3
 => nil
```

Na tą chwilę nasza lista nie jest leniwie wartościowana. Aby to zmienić użyjemy lambdy:

```ruby
class LazyLispyEnumerable
  include Enumerable

  def initialize(tree)
    @tree = tree
  end

  def each
    while @tree
      car, cdr = @tree.call
      yield car
      @tree = cdr
    end
  end
end
```

Zmieniłyśmy tylko jedną linię. Za każdym razem gdy będziemy wchodzić do kolejnego kroku naszej pętli, będziemy wykonywać kolejny element naszej tablicy za pomocą `@tree.call`. Żeby jednak użyć tego nowego enumeratora musimy zmienić również naszą listę.

```ruby
list = lambda { [1, lambda { [2, lambda { [3] } ] } ] }
irb> LazyLispyEnumerable.new(list).each { |item| p item }
1
2
3
 => nil
```

Na tą chwilę nie widać różnicy. By ją zobaczyć zmienimy naszą listę. Jeżeli jest to zachłanne wartościowanie, to przy nowej deklaracji listy powinniśmy dostać wszystkie wypisania od razu na ekranie. Natomiast jeżeli jest to wartościowanie leniwe, będziemy je dostawać krok po kroku podczas wykonywania naszej pętli.

```ruby
list = lambda do
  p '1 is called'
  [1, lambda do
    p '2 is called'
    [2, lambda { p '3 is called'; [3] }]
  end]
end

irb> LazyLispyEnumerable.new(list).each { |item| p item }
"1 is called"
1
"2 is called"
2
"3 is called"
3
 => nil
```

Jak widać udało się nam zadeklarować leniwe wartościowanie. Przyszedł czas by napisać ciąg Fibonacci'ego przy użyciu naszego leniwego wartościowania:

```ruby
def fibo(a, b)
  lambda { [a, fibo(b, a + b)] }
end

LazyLispyEnumerable.new(fibo(1, 1)).each do |item|
  puts item
  break if item > 100
end
1
1
2
3
5
8
13
21
34
55
89
144
 => nil
```

Do kodu dodałam warunek zatrzymania, bez niego Ruby mógłby teoretycznie robić te kalkulacje w nieskończoność. W pewnym sensie nie jest to do końca rekurencja. Możemy powiedzieć, że jest to nieskończona pętla. Jeżeli chciałybyśmy tu użyć prawdziwej rekurencji kod wyglądałby następująco:

```ruby
def recursive_fibo(n)
  return 1 if n == 0
  return 1 if n == 1
  recursive_fibo(n -1) + recursive_fibo(n - 2)
end

irb> recursive_fibo(11)
 => 144
```

W tym przypadku gdy usuniemy warunki zatrzymania otrzymamy wyjątek `SystemStackError (stack level too deep)`. To rozwiązanie będzie też znacznie wolniejsze niż nasze _"leniwe rozwiązanie"_.

Na koniec chciałabym tylko wspomnieć że od wersji Ruby 2.0 możemy używać leniwych enumeratorów (lazy enumerators) za pośrednictwem samego języka:

```ruby
irb> (1..Float::INFINITY).lazy.select(&:even?).first(5)
 => [2, 4, 6, 8, 10]
```

Jeżeli chciałabyś dowiedzieć się o nich czegoś więcej, to odsyłam Cię do
[dokumentacji leniwych enumeratorów](https://ruby-doc.org/core/Enumerator/Lazy.html).

To wszystko na dzisiaj. Mam nadzieję, że Cię to zainteresowało. Jeżeli masz jakieś pytania, to umieść je w komentarzu na dole. Do zobaczenia!

## Bibliografia:

- {% include links/youtube-link.html
     name='Wideo o programowaniu funkcyjnym (Proc, Lambda, Closure) w Ruby [EN]'
     video_id='VBC-G6hahWA' %}
- [Prezentacja o programowaniu funkcyjnym w Ruby [EN]](https://www.slideshare.net/tokland/functional-programming-with-ruby-9975242)
- [Artykuł na temat domknięć w Ruby [EN]](https://innig.net/software/ruby/closures-in-ruby)
- [Dokumentacja Ruby [EN]](https://ruby-doc.org/)
