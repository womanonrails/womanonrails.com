---
layout: post
title: Zastosowanie metody each_with_object w Ruby
description: Przykłady użycia each_with_object
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
lang: pl
---

Ostatnio pracowałam z metodą `each_with_object`. Jak zazwyczaj w takich sytuacjach zawsze staram się przed użyciem jakiejś metody sprawdzić jej dokumentację. Weszłam więc na
{% include links/external-link.html
   name='APIdock'
   url='https://apidock.com/ruby/Enumerable/each_with_object' %}
przeglądam zastosowanie oraz przykłady. Okazało się że nie było tam jednego z przypadków zastosowania. Chciałam go dodać, lecz bez powodzenia. Postanowiłam więc, że skoro czekam na rozwiązanie problemu ze strony APIdock mogę napisać krótką notatkę na temat metody `each_with_object` tutaj.

Najbardziej pożytecznym i wydaje mi się również popularnym użyciem tej metody jest podanie jako argumentu tablicy lub hasha (tablicy słownikowej). Można to zrobić przykładowo:

```ruby
[:foo, :bar, :jazz].each_with_object({}) do |item, hash|
  hash[item] = item.to_s.upcase
end
 => {:foo=>"FOO", :bar=>"BAR", :jazz=>"JAZZ"}
```

lub

```ruby
(1..10).each_with_object([]) do |item, array|
  array << item ** 2
end
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

Wiem te przykłady są trywialne, ale chodzi o to by zrozumieć samą konstrukcję użycia. Dzięki tej metodzie nie musimy deklarować tablicy przed pętlą:

```ruby
array = []
(1..10).each do |item|
  array << item ** 2
end
array
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

Oczywiście dla tego przykładu można by to zrobić z użyciem metody `map`:

```ruby
(1..10).map { |item| item ** 2 }
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

Innym ciekawym zastosowaniem `each_with_object` jest zliczanie częstotliwości występowania:


```ruby
['one', 'two', 'one', 'one'].each_with_object(Hash.new(0)) do |item, hash|
  hash[item] += 1
end
 => {"one"=>3, "two"=>1}
```

W tym przypadku ustawiamy domyślną wartość dla tablicy słownikowej na `0`. Dzięki temu zliczanie ilości wystąpień elementów w tablicy jest szybkie i proste. Nie potrzebujemy warunku `if` by zabezpieczyć się przed nieoczekiwaną wartością `nil`:

```ruby
if hash[item]
  hash[item] += 1
else
  hash[item] = 0
end
```

**Uwaga**

W metodzie `each_with_object` nie można użyć niemutowalnych (inmutable) obiektów jak liczby. Przykład poniżej nie zwróci Wam 55 tylko 0.

```ruby
(1..10).each_with_object(0) do |item, sum|
  sum += item
end
 => 0
```

Możemy to zrobić też inaczej:

```ruby
(1..10).reduce(:+)
 => 55
```

lub

```ruby
(1..10).inject(:+)
 => 55
```

lub w Ruby on Rails:

```ruby
(1..10).sum
 => 55
```

Przy okazji czy wiecie jaka jest różnica między metodą `reduce` a `inject`? Nie ma różnicy. Te dwie metody to tak naprawdę jedna i ta sama metoda, ale mająca dwie nazwy tzw.
{% include links/external-link.html
   name='alias'
   url='http://ruby-doc.org/core/Enumerable.html#method-i-inject' %}.

W tym momencie powinniśmy jeszcze wspomnieć o jednej rzeczy. Metodę `inject` możemy stosować też bardzo podobnie do `each_with_object`. Różnica jest w kolejności argumentów w bloku i tym że w ostatniej linii bloku dla metody `inject` zawsze musimy zwrócić naszą wartość agregującą (przykładowo sumującą). Popatrzcie tutaj:

```ruby
(1..10).inject([]) do |array, item|
  array << item ** 2
end
 => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

lub

```ruby
[:foo, :bar, :jazz].inject({}) do |hash, item|
  hash[item] = item.to_s.upcase
  hash
end
 => {:foo=>"FOO", :bar=>"BAR", :jazz=>"JAZZ"}
```

**Uwaga**

Kiedy używamy `array << item ** 2` zawsze zostaje tu zwrócona cała tablica, ale dla przykładu drugiego `hash[item] = item.to_s.upcase` zwraca `item.to_s.upcase` a nie `hash` więc musimy pamiętać by w ostatniej linii bloku zawsze zwrócić `hash`.

A teraz brakujący przypadek. Metodę `each_with_object` można nie tylko używać na tablicy czy enumeratorze ale również na hashu (tablicy słownikowej). Taki przypadek wygląda troszkę inaczej. Zobaczcie sami:

```ruby
{ foo: 1, bar: 2, jazz: 3 }.each_with_object({}) do |(key, value), hash|
  hash[key] = value**2
end
 => {:foo=>1, :bar=>4, :jazz=>9}
```

lub

```ruby
{ foo: 1, bar: 2, jazz: 3 }.each_with_object([]) do |(key, value), array|
  array << { id: value, name: key }
end
 => [{:id=>1, :name=>:foo}, {:id=>2, :name=>:bar}, {:id=>3, :name=>:jazz}]
```

To był krótki przegląd tego co można zrobić z metodą `each_with_object`. Mam nadzieje, że zastosowanie tej metody podoba się Wam tak samo jak mnie. Jeżeli macie jakieś pytania zostawcie je poniżej w komentarzach. Do zobaczenia następnym razem!
