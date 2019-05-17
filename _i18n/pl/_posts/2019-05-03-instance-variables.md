---
layout: post
title: Dlaczego przestałam używać zmiennych instancji w klasach Ruby?
description: Wskazówka jak wyeliminować literówki ze swojego kodu.
headline: Przedwczesna optymalizacja to źródło wszelkiego zła.
categories: [programowanie]
tags: [Ruby]
comments: true
lang: pl
---

Klasę w Ruby możesz stworzyć na wiele różnych sposobów. Z jednej strony to jest super. Możesz być kreatywna i dostosować kod do swoich potrzeb. Z drugiej strony może to powodować pewne problemy z podjęciem decyzji. Co wybrać? Która opcja jest najlepsza? To pytanie może być frustrujące, zwłaszcza gdy zaczyna się przygodę z programowaniem. Dlatego też chciałabym dziś pokazać Ci szybkie sposoby na polepszenie Twojego kodu już na samym początku drogi.

Tytuł tego artykułu może być odrobinę mylący. Jeżeli chcesz stworzyć klasę, która przechowuje informacje o stanie obiektu, to będziesz potrzebować zmiennych instancji. Nie da się ich całkowicie wyeliminować i to nie jest nasz cel. Chciałabym Ci tylko pokazać, jak zmniejszyć ilość wywołań zmiennych instancji i dlaczego to może być korzystne. Dodatkowo pokażę też kilka rzeczy, na które warto zwrócić uwagę.

Kiedy tworzę nową klasę w języku Ruby, zawsze staram się udostępnić na zewnątrz jak najmniejszą ilość informacji. To zawsze jest dobra praktyka. Nikt nie może użyć tych dodatkowych (często niezabezpieczonych) danych przeciwko Tobie. Ja idę z tym założeniem jeszcze trochę dalej. Nawet wewnątrz klasy staram się przekazywać, jak najmniej informacji.

Dobrze, ale zacznijmy od przykładu:

```ruby
class Wheel
  attr_accessor :radius

  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @radius
  end
end
```

Mamy prostą klasę, która zajmuje się obliczaniem obwodu okręgu. Dodatkowo jednak udostępnia również informację o promieniu i pozwala go **zmieniać**. W tym miejscu prosimy się o kłopoty. Po jakimś czasie w kodzie może pojawić się coś podobnego:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bdda946a0 @radius=5>

wheel.perimeter
 => 31.41592653589793

wheel.radius = 2
wheel.perimeter
 => 12.566370614359172
```

To tak jakbyś dała dostęp do swojego konta osobie całkowicie obcej. Nie będziesz nawet wiedzieć kiedy Twoje pieniądze znikną. Zmieńmy to:

```ruby
class Wheel
  attr_reader :radius

  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @radius
  end
end
```

Teraz wygląda to odrobinę lepiej, ale dalej dajemy dostęp do informacji, ile tych pieniędzy jest na naszym koncie. To może doprowadzić do czegoś takiego:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bdda72ff0 @radius=5>
diagonal = wheel.radius * 2
 => 10
```

Może nie widzisz w tym nic złego, czasem jest to problematyczne. Logika związana z naszym okręgiem znajduje się poza ciałem naszej klasy. W wielu przypadkach nawet lepiej zachować informację taką, jak `radius` w obrębie klasy. Trzeba też jednak pamiętać, by **nie tworzyć metod w klasie na zapas**. Zobaczmy, jak będzie nasz kod wyglądał po zmianie:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @radius
  end

  def diagonal
    2 * @radius
  end
end
```

Tym razem to klasa `Wheel` odpowiada za logikę związaną z przekątną i nie możemy jej obliczać na zewnątrz.

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bddb31f68 @radius=5>
diagonal = wheel.diagonal
 => 10
diagonal = wheel.radius * 2
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):15
NoMethodError (undefined method `radius' for #<Wheel:0x000055a962b0c780 @radius=5>)
```

Teraz możemy przejść do odpowiedzi na nasze główne pytanie: _Dlaczego przestałam używać zmiennych instancji w klasach Ruby?_ Prawdopodobnie już wiesz z poprzednich artykułów, że jestem mistrzem literówek. Przestawianie kolejności liter, to moja specjalność. Bardzo często, gdy tworzę nową klasę (nawet jak mam dla niej testy), dostaję komunikat błędu, który nie jest dla mnie jasny w konkretnym kontekście. Może masz podobnie. Spójrz na kod poniżej:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * @raidus
  end

  def diagonal
    2 * @radius
  end
end
```

Widzisz problem? Jeżeli tak, to gratulacje! Dla mnie jest on trudny do zauważenia. Oczywiście po latach pracy wiem, jak sobie radzić sobie z takimi problemami, ale to nie zmienia faktu, że są one dość męczące. Błąd w tym wypadku może wyglądać tak:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x000055a962b79628 @radius=5>

wheel.perimeter
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):69
        2: from (irb):61:in `perimeter'
        1: from (irb):61:in `*'
TypeError (nil can't be coerced into Float)
```

Najistotniejsza informacja `nil can't be coerced into Float` nie mówi wiele, co się stało. Mówi tylko, że wystąpił `nil` i niemożna tej wartości używać podczas mnożenia. Może nie koniecznie w tym przypadku, ale na pewno wtedy, gdy kalkulacje są bardziej skomplikowane. Trudno jest znaleźć tą zmienną, która zawiera `nil`. Trzeba przejrzeć je wszystkie po kolei. W naszym przypadku jest to po prostu `@raidus`. Czasami sytuacja może być nawet bardziej poważna. Możemy błędu w ogóle nie dostać. Przykład, rzutowanie wartości `nil` na ciąg znaków (string). Zobaczmy poniżej:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  # ...

  def to_s
    "Wheel information: radius = #{@raidus}"
  end
end
```

A oto wywołanie naszego kodu:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bdd850fb0 @radius=5>

wheel.to_s
 => "Wheel information: radius = "
```

Dostajemy niepoprawną informację. Dlatego też **stosuję metody prywatne klasy, zamiast zmiennych instancji**.

Zobacz przykład poniżej:

```ruby
class Wheel
  def initialize(radius)
    @radius = radius
  end

  def perimeter
    2 * Math::PI * raidus
  end

  def diagonal
    2 * radius
  end

  def to_s
    "Wheel information: radius = #{raidus}"
  end

  private

  attr_reader :radius
end
```

Do mojego kodu dodałam prywatny getter dla zmiennej instancji `@radius`. W tym przypadku błąd będzie wyglądał następująco:

```ruby
wheel = Wheel.new(5)
 => #<Wheel:0x0000559bddafea50 @radius=5>

wheel.perimeter
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):89
        1: from (irb):76:in `perimeter'
NameError (undefined local variable or method `raidus' for #<Wheel:0x0000559bddafea50 @radius=5>)
Did you mean?  radius
               @radius
```

Podobnie błąd będzie wyglądał w przypadku łańcucha znaków:

```ruby
wheel.to_s
Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        2: from (irb):137
        1: from (irb):129:in `to_s'
NameError (undefined local variable or method `raidus' for #<Wheel:0x0000559bddaf30b0 @radius=5>)
Did you mean?  radius
               @radius
```

Komunikat błędu jest znacznie bardziej przystępny. Dodatkowo Ruby podpowiada nam, czy zamiast metody `raidus` nie chciałyśmy użyć zmiennej `@radius` lub metody `radius`.

Ja widzę tutaj jeszcze jedną zaletę. Kiedy korzystam z prywatnego gettera (i tylko gettera), mam mniejszą pokusę, by zmieniać stan klasy podczas jej wywołania. O wiele łatwiej przychodzi mi natomiast zrobienie tego `@radius = 2`, gdy korzystam ze zmiennych instancji.

Zadaję sobie sprawę, że moje rozwiązanie nie jest idealne. Jeżeli w kodzie pojawiłaby się zmienna lokalna o tej samej nazwie, co metoda to mogę już nie dostać tak ładnego komunikatu błędu. Ale dalej uważam, że to podejście jest warte spróbowania.

## Podsumowanie

Kiedy tworzysz swoje klasy, warto pamiętać o takich prostych zasadach:

- **Pokazuj minimalną ilość informacji** na temat swojej klasy - dawaj tylko dostęp do wyników obliczeń a nie do samej logiki.
- Używaj **metod prywatnych** zamiast **zmiennych instancji** - dostaniesz jaśniejszy komunikat błędu
- Używaj paradygmatu programowania funkcyjnego (jeżeli to możliwe) - używaj nie mutowanego stanu w swojej klasie
- Używaj **zasady open/closed** - Klasa (ale nie tylko) ma być otwarta na rozszerzenia, ale zamknięta na modyfikację
- Używaj **zasady jednej odpowiedzialności (single responsibility)** - Nie wspominałam o tych dwóch ostatnich zasadach w tym artykule, ale są one jednak bardzo użyteczne. Mówiłam o nich w krótkiej serii artykułów o <a href="{{ site.baseurl }}/refactoring-part2" title="Refaktoring w języku Ruby - krok po kroku">refaktoryzacji na przykładzie logiki do pokera</a>.

Jeżeli jesteś zainteresowana innymi dobrymi praktykami to zachęcam do zerknięcia na poniższe książki:

- {% include helion_book.html
     key='rubywz'
     name='Ruby. Wzorce projektowe - Russ Olsen'
     title='Ruby. Wzorce projektowe'
  %}
- {% include helion_book.html
     key='tddszt'
     name='TDD. Sztuka tworzenia dobrego kodu - Ken Beck'
     title='TDD. Sztuka tworzenia dobrego kodu'
  %}
- <a href="https://www.amazon.com/Practical-Object-Oriented-Design-Ruby-Addison-Wesley/dp/0321721330" title="Practical Object-Oriented Design in Ruby: An Agile Primer" target="_blank" rel="nofollow noopener noreferrer">Practical Object-Oriented Design in Ruby: An Agile Primer - Sandi Metz [EN]</a>
- {% include helion_book.html
     key='pragpv'
     name='Pragmatyczny programista. Od czeladnika do mistrza - Andrew Hund, David Thomas'
     title='Pragmatyczny programista. Od czeladnika do mistrza'
  %}
