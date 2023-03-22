---
layout: post
photo: /images/ruby-to-ary/ruby-to-ary
title: Różnice między to_a i to_ary w Ruby
description: Porównanie metod to_a i to_ary
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
imagefeature: ruby-to-ary/og_image.png
lang: pl
---

Czy zastanawialiście się kiedyś nad metodami `to_a` i `to_ary` w Ruby? Czy to w zasadzie dwie nazwy na tą samą metodę? A może jest między nimi jakaś różnica? Co jeżeli zaimplementujemy te metody w naszej własnej klasie? W tym artykule postaram się odpowiedzieć na te pytania. Zaczynamy!

Na początek zacznijmy od definicji metod `to_a` i `to_ary` w klasie `Array`, jakie możemy znaleźć w dokumentacji <a href='https://ruby-doc.org/core-3.0.0/Array.html#method-i-to_a' title='Dokumentacja Ruby' target='_blank' rel='nofollow'>Ruby Doc</a>:

>`to_a` - Kiedy  `self` jest instancją klasy `Array`, zwróć `self`. W przeciwnym wypadku, zwróć nowy obiekt klasy `Array` zawierający elementy z `self`.

>`to_ary` - Zwróć `self`.

Już na tym etapie widzimy, że definicje te są podobne ale nie dokładnie takie same. W przypadku implementacji tych metod w naszych własnych klasach możemy powiedzieć, że metoda `to_ary` jest używana do konwersji _implicit_, natomiast `to_a` do konwersji _explict_. To może brzmieć nie zrozumiale, dlatego napisze to innymi słowami. Metoda `to_ary` pozwala obiektowi **zachowywać się** jak obiekt klasy `Array`, a metoda `to_a` **zamienia czyli konwertuje** nasz obiekt na obiekt klasy `Array`. Ten wzorzec postępowania jest wykorzystywany wielokrotnie w języku Ruby. Między innymi dla par metod takich jak `to_s` i `to_str` oraz `to_i` i `to_int`.

Teraz możemy już przejść do przykładów. Stwórzmy klasę `Point`, która będzie implementować metody `to_a` i `to_ary` tak byśmy mogli zobaczyć ich użycie.

```ruby
class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_a
    puts 'to_a method called'
    [x, y]
  end

  def to_ary
    puts 'to_ary method called'
    [x, y]
  end

  def inspect
    "#<#{self.class.name} (#{x}, #{y})>"
  end

  private

  attr_reader :x, :y
end
```

Sprawdźmy co stanie się gdy użyjemy _splat_ operatora `*` na obiekcie klasy `Point`.

```ruby
point = Point.new(1, 3)
#  => #<Point (1, 3)>

Point.new(*point)
# to_a method called
#  => #<Point (1, 3)>
```

Jak widzimy została wywołana metoda `to_a`. Z drugiej strony kiedy spróbujemy przypisać obiekt klasy `Point` do zmiennych zostanie użyta metoda `to_ary`.

```ruby
x, y = point
# to_ary method called
#  => #<Point (1, 3)>
```

Jako następny krok sprawdźmy, co się dzieje gdy użyjemy `each` na kolekcji punków.

```ruby
[point].each { |item| item }
#  => [#<Point (1, 3)>]

[point].each { |(x, y)| [x, y] }
# to_ary method called
#  => [#<Point (1, 3)>]
```

W pierwszym przykładzie nie dzieje się nic szczególnego. Po prostu iterujemy przez kolekcję punktów. Natomiast w drugim przykładzie widzimy, że została wywołana metoda `to_ary`. Stało się tak dlatego, że podobnie jak powyżej i tym razem przypisaliśmy obiekt klasy `Point` do dwóch zmiennych. Warto tu wspomnieć, że w implementacji klasy `Point` koordynaty punktu są prywatne a dzięki metodzie `to_ary` możemy się do nich w łatwy sposób dostać podczas używania metody `each`.

Jakiś czas temu napisałam artykuł <a href="{{ site.baseurl }}/casting-ruby-object-into-string" title="Różnice między metodami to_s i to_str">Jak Ruby rzutuje obiekty na łańcuchy znaków?</a>, w którym opisywałam jak zachowuje się metoda `puts` dla obiektów typu `Array`. Zobaczmy co się stanie w przypadku klasy `Point`, która ma się zachowywać podobnie do `Array`.

```ruby
puts point
# to_ary method called
# 1
# 3
#  => nil
```

Kiedy metoda `to_ary` jest zaimplementowana w klasie `Point`, metoda `puts` postara się użyć `to_ary` by podzielić nasz obiekt na mniejsze części i wywołać `puts` rekursywnie. Czyli na każdym pojedynczym elemencie.

Teraz jest dobry moment by wspomnieć o ważnej rzeczy. Gdy nasz obiekt typu `Point` nie implementuje metody `to_ary` przypisanie do zmiennej oraz inne zachowania będą wyglądać inaczej, ale nie dostaniemy wyjątku. Oto przykład:

```ruby
class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_a
    puts 'to_a method called'
    [x, y]
  end

  def inspect
    "#<#{self.class.name} (#{x}, #{y})>"
  end

  private

  attr_reader :x, :y
end

point = Point.new(1, 3)
#  => #<Point (1, 3)>

x, y = point
#  => #<Point (1, 3)>

x
#  => #<Point (1, 3)>

y
#  => nil
```

Jak widać obiekt klasy `Point` nie został w tym momencie podzielony na składowe. Zerknijmy jeszcze na zachowanie względem metody `puts` bez implementacji metody `to_ary`.

```ruby
point = Point.new(1, 3)
#  => #<Point (1, 3)>

puts point
#  #<Point:0x00007f6e92b2a8b0>
#  => nil
```

W tym przypadku również metoda `puts` nie iteruje przez składowe obiektu klasy `Point`. Podobne obserwacje możemy zauważyć też dla metody `flatten` gdy  metoda `to_ary` nie jest definiowana.

```ruby
point_1 = Point.new(1, 3)
#  => #<Point (1, 3)>

point_2 = Point.new(1, 5)
#  => #<Point (1, 5)>

[point_1, point_2].flatten
#  => [#<Point (1, 3)>, #<Point (1, 5)>]
```

Z drugiej strony, gdy użyjemy jej na obiekcie klasy `Point` z zaimplementowaną metodą `to_ary` wynik będzie inny.

```ruby
point_1 = Point.new(1, 3)
#  => #<Point (1, 3)>

point_2 = Point.new(1, 5)
#  => #<Point (1, 5)>

[point_1, point_2].flatten
#  to_ary method called
#  to_ary method called
#  => [1, 3, 1, 5]
```

Metoda `flatten` wywoła metodę `to_ary` na każdym elemencie tablicy. Zachęcam do samodzielnego sprawdzenia co się stanie w przypadku metody `join`.

## Podsumowanie
1. Dwie metody pozwalają nam na zachowywanie się jak `Array`:
    - metoda `to_a` - pozwala na rzutowanie obiektu na obiekt typu `Array`.
    - metoda `to_ary` - pozwala nam _zachowywać się_ jak obiekt typu `Array`.
2. Splat operator używa metody `to_a`.
3. Przypisanie obiektu do zmiennych będzie chciało użyć metody `to_ary` jeżeli taka istnieje. Jeżeli nie, przypisanie nastąpi tylko dla pierwszej zmiennej. Reszta pozostanie z wartością `nil`.
4. `puts` będzie starać się użyć metody `to_ary` jeżeli jest ona zaimplementowana w obiekcie
5. Metody `flatten` i `join` będą się zachowywać podobnie jak `puts`. Jeżeli w obiekcie będzie zaimplementowana metoda `to_ary` to z niej skorzystają.

## Linki
- <a href="{{ site.baseurl }}/casting-ruby-object-into-string" title="Różnice między metodami to_s i to_str">Jak Ruby rzutuje obiekty na łańcuchy znaków?</a>
- <a href='https://ruby-doc.org/core-3.0.0/Array.html#method-i-to_a' title='Dokumentacja Ruby dla klasy Array' target='_blank' rel='nofollow'>Array Ruby Doc - EN</a>
- <a href='https://stackoverflow.com/questions/9467395/whats-the-difference-between-to-a-and-to-ary' title='Wątek na Stack Overflow na temat method to_a i to_ary' target='_blank' rel='nofollow'>What's the difference between to_a and to_ary? - Stack Overflow - EN</a>
