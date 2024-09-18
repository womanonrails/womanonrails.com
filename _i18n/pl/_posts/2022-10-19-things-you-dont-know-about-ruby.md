---
excerpt: >
  Od czasu do czasu zdarza mi się usłyszeć od innych
  w trakcje programowania _To naprawdę działa w Ruby?_
  albo _Nie wiedziałam/nie wiedziałem, że to tak działa_.
  W końcu zrozumiałam, że to co dla mnie jest czymś normalnym,
  inne osoby niekoniecznie znają.
  Dziś chciałabym się podzielić kilkoma takimi smaczkami z języka Ruby,
  o których nie wszyscy wiedzą. Mam nadzieję, że Ci się spodobają.
layout: post
photo: /images/ruby-tricks/ruby-tricks
title: Rzeczy, których nie wiesz o języku Ruby
description: Ciekawe smaczki języka Ruby
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
imagefeature: ruby-tricks/og_image.png
lang: pl
---

Od czasu do czasu zdarza mi się usłyszeć od innych w trakcje programowania _To naprawdę działa w Ruby?_ albo _Nie wiedziałam/nie wiedziałem, że to tak działa_. W końcu zrozumiałam, że to co dla mnie jest czymś normalnym, inne osoby niekoniecznie znają. Dziś chciałabym się podzielić kilkoma takimi smaczkami z języka Ruby, o których nie wszyscy wiedzą. Mam nadzieję, że Ci się spodobają.

## 1. Domyślna wartość dla metody `dig` i zagnieżdżone obiekty typu Hash/Array

Domyślnie, gdy użyjemy metody `dig` z kluczem, którego nie ma w obiekcie Hash, jako wynik dostaniemy `nil`. Ale możemy zmienić to zachowanie metody `dig`.

Zachowanie domyślne:

```ruby
hash = { foo: { bar: [:a, :b, :c] } }
hash.dig(:hello)

# => nil
```

Nasze nowe zachowanie:

```ruby
hash = { foo: { bar: [:a, :b, :c] } }
hash.default_proc = -> (hash, _key) { hash }
hash.dig(:hello, :world)

# => {:foo=>{:bar=>[:a, :b, :c]}}

hash.dig(:hello, :world, :foo, :bar, 2)

# => :c
```

Możemy tu zauważyć jeszcze jedną interesującą rzecz. Kiedy używamy metody `dig` na bardziej złożonym obiekcie typu Hash niż `{ foo: 1, bar: 2}`, możemy bez problemu poruszać się po kolejnych zagnieżdżeniach (nawet tych typu Array) by wybrać interesującą nas wartość.

```ruby
hash = { foo: { bar: [:a, :b, :c] } }
hash.dig(:foo, :bar, 2)

# => :c
```

## 2. Szybki sposób na debugowanie z metodą `tap`

Moim zdaniem najciekawszym użyciem metody `tap` w Ruby, jest możliwość stworzenia szybkiego debuggera.

```ruby
class Object
  def debug
    tap { |object| p object }
  end
end

"foo".upcase.debug.reverse

# "FOO"
# => "OOF"
```

Teraz dzięki rozszerzeniu klasy `Object`, mamy możliwość wglądu w środek łańcucha wywołań metod.

## 3. Różnica między `concat` a `+=` dla klasy Array

Zazwyczaj metod `concat` i `+=` używamy naprzemiennie w naszym kodzie. Lub czasem ktoś woli jedną metodę bardziej niż drugą. Różnice pomiędzy nimi nie są wtedy dla nas istotne lub zauważalne. Ale jest jedna różnica, o której warto pamiętać.

Zazwyczaj interesuje nas wyniki końcowy tych dwóch operacji, który jest ten sam.

```ruby
array = [1, 2, 3]
array.concat([4, 5, 6])

# => [1, 2, 3, 4, 5, 6]


array = [1, 2, 3]
array += [4, 5, 6]

# => [1, 2, 3, 4, 5, 6]
```

Ale co jeżeli użyjemy tych metod w połączeniu z metodą `tap`?

```ruby
array = [1, 2, 3]
array.tap { |a| a.concat([4, 5, 6]) }

# => [1, 2, 3, 4, 5, 6]
```

Metoda `concat` zachowuje się tak jakbyśmy tego oczekiwali. Nie możemy tego samego powiedzieć o metodzie `+=`.

```ruby
array = [1, 2, 3]
array.tap { |a| a += [4, 5, 6] }

# => [1, 2, 3]
```

Co właściwie się tu stało? By dobrze to zrozumieć zacznijmy od zapoznania się z definicją metody `tap` z [dokumentacji](https://ruby-doc.org/core-2.6.1/Object.html#method-i-tap "Ruby documentation Object#tap") Rubiego:

> `tap` - Yields `self` to the `block`, and then returns `self`. The primary purpose of this method is to “tap into” a method chain, in order to perform operations on intermediate results within the chain.

Najważniejsza informacja z tej definicja to ta mówiąca o zwracaniu z metody `tap` obiektu `self`: _and then returns `self`_. Zobaczmy w takim razie, co dzieje się z `array` w przypadku obu metod.

```ruby
array = []
array.object_id

# => 260

array += [4, 5, 6]
array.object_id

# => 280
```

W przypadku metody `+=` otrzymujemy nowy obiekt, jednak metoda `tap` zwraca nam obiekt, na którym została wywołana. Czyli obiekt początkowy. Porównajmy to z metodą `concat`.

```ruby
array = []
array.object_id

# => 300

array.concat([4, 5, 6])
array.object_id

# => 300
```

Jak widać metoda `concat` zwraca ten sam obiekt, który był na początku. Podsumowując metoda `concat` **dołącza** do już istniejącego obiektu dodatkowe elementy. Natomiast metoda `+=` **tworzy nowy obiekt** zawierający wszystkie elementy (te początkowe i te dodane późnej).

Na koniec chciałabym dodać, że jeżeli chcemy otrzymać ten sam efekt jaki otrzymujemy przy użyciu `concat` i `tap` dla `+=` możemy użyć innej metody a dokładnie metody `then`. Sprawdzając jej definicję w [dokumentacji](https://ruby-doc.org/core-2.6.1/Object.html#method-i-then "Ruby documentation Object#then") otrzymujemy:

> `then` - Yields `self` to the `block` and returns the result of the `block`.

```ruby
array = [1, 2, 3]
array.then { |a| a += [4, 5, 6] }

# => [1, 2, 3, 4, 5, 6]
```

## 4. Metoda `split` z dwoma argumentami

Często używamy metody `split` by rozdzielić jakiś tekst, tak jak tutaj:

```ruby
"ruby:python:java".split(':')

# => ["ruby", "python", "java"]
```

ale poza tym możemy powiedzieć metodzie `split` na ile dokładnie kawałków chcemy podzielić początkowy tekst:

```ruby
"ruby:python:java".split(':', 1)

# => ["ruby:python:java"]

"ruby:python:java".split(':', 2)

# => ["ruby", "python:java"]

"ruby:python:java".split(':', 3)

# => ["ruby", "python", "java"]
```

## 5. Konkatenacja łańcuchów znaków

W języku Ruby istnieje wiele możliwości by połączyć dwa łańcuchy znaków. Niektóre z nich zamieściłam poniżej:

```ruby
first_name = 'Agnieszka'
last_name = 'Małaszkiewicz'

name = first_name + ' ' + last_name
name

# => "Agnieszka Małaszkiewicz"

name = first_name << ' ' << last_name
name

# => "Agnieszka Małaszkiewicz"

name = "#{first_name} #{last_name}"
name

# => "Agnieszka Małaszkiewicz"

name = [first_name, last_name].join(' ')
name

# => "Agnieszka Małaszkiewicz"
```

Istnieje jeszcze jeden dość ciekawy sposób na łączenie łańcuchów znaków:

```ruby
name = "Agnieszka" " " "Małaszkiewicz"
name

# => "Agnieszka Małaszkiewicz"
```

lub trochę prościej by załapać ideę:

```ruby
name = "Agnieszka " "Małaszkiewicz"
name

# => "Agnieszka Małaszkiewicz"
```

Na początku wygląda to dość dziwnie. I tu może pojawić się pytanie: _Czy to naprawdę działa w Ruby?_ Jednak jeżeli zastanowimy się przez chwilę to na pewno zdarzało Ci się podzielić łańcuch znaków pomiędzy dwie linie. Ja czasem używam tego w testach:

```ruby
it 'calls DeliverCheckInInstructionsForProperty service for properties ' \
    'with check-in instructions delivery enabled' do
  # ...
end
```

Teraz ważne pytanie: **Dlaczego to działa?** Z tego, co udało mi się ustalić, to funkcjonalność ta jest związana z [kodem źródłowym języka Ruby](https://github.com/ruby/ruby/blob/eab191040e9356a8ed4aaa418a7904d6f94064b9/parse.y#L3889-L3891 "Kod źródłowy Rubiego: tCHAR") dla `parse.y`. Bazując na odpowiedzi z [Stack Overflow](https://stackoverflow.com/a/23811744 "Stack Overflow - Why do two strings separated by space concatenate in Ruby?") mamy:

> A Ruby string is either a `tCHAR` (e.g. `?q`), a `string1` (e.g. `"q"`, `'q'`, or `%q{q}`), or a recursive definition of the concatenation of `string1` and `string` itself, which results in string expressions like `"foo" "bar"`, `'foo' "bar"` or `?f "oo" 'bar'` being concatenated.

## 6. Tworzenie obiektu Hash z domyślnymi wartościami

Na temat obiektu `Hash` napisałam osobny artykuł [Triki dla obiektu Hash w Ruby]({{site.baseurl}}/ruby-hash-tips "Ruby - przegląd metod dla obiektu Hash"), gdzie podaję więcej szczegółów. Tutaj chciałabym się skupić na dwóch zastosowaniach domyślnej wartości.

Po pierwsze, możemy ustawić jedną i tą samą wartość dla wszystkich kluczy. To zastosowanie przydaje się gdy chcemy coś zliczać.

```ruby
hash = Hash.new(0)
hash[:foo]

# => 0
```

Teraz używając `+=` możemy sumować.

```ruby
hash[:bar] += 1
hash[:bar]

# => 1
```

Po drugie, możemy zadeklarować domyślną wartość inną dla każdego klucza. Jak na przykład:

```ruby
hash = Hash.new { |hash, i| i }
hash[1]

# => 1

hash[35]

# => 35
```

## 7. Użycie obiektu `proc` w `case`

`proc` to jedna z klas w języku Ruby, która pomaga nam w [programowaniu funkcyjnym]({{site.baseurl}}/functional-programming-ruby "Programowanie funkcjyjne w języku Ruby"). Jedno z ciekawych zastosowań obiektu `proc`, to użycie go w warunku `when` dla `case`. Możemy stworzyć `proc` i wstawić go bezpośrednio w `when`. A oto przykład:

```ruby
payload_1 = {
  event_type: 'ConversationAdded',
  body: 'Test'
}
payload_2 = {
  event_type: 'MessageAdded',
  body: 'Test'
}
payload_3 = {
  body: 'Test'
}

def payload_object(payload)
  message_type_event = proc { |event_type| event_type.include?('Message') }

  case payload[:event_type]
  when nil then 'Message'
  when message_type_event then 'ConversationMessage'
  else
    'None'
  end
end

payload_object(payload_1)

# => "None"

payload_object(payload_2)

# => "ConversationMessage"

payload_object(payload_3)

# => "Message"
```

## 8. Wywołanie metody na różne sposoby

Ruby to naprawdę fantastyczny język. Daje nam duże możliwości. Przykładem tego może być możliwość wywołania metody na wiele różnych sposobów. Jeżeli interesuje Cię ile jest takich możliwości, to zachęcam Cię do zapoznania się z artykułem Grzegorza Witka [12 ways to call a method in Ruby](https://www.notonlycode.org/12-ways-to-call-a-method-in-ruby/ "12 ways to call a method in Ruby"). Ja chciałabym podzielić się jeszcze dwoma dodatkowymi sposobami na wywołanie metody. Zastosuje do tego ten sam przykład, który w swoim artykule umieścił Grzegorz.

```ruby
class User
  def initialize(name)
    @name = name
  end

  def hello
    puts "Hello, #{@name}!"
  end

  def method_missing(_)
    hello
  end
end
```

Pierwszy sposób odkryłam oglądając prezentacje z RailsConf 2022 [Ruby Archaeology by Nick Schwaderer](https://www.youtube.com/watch?v=VPXHclib7X4 "RailsConf 2022 - Ruby Archaeology by Nick Schwaderer"):

```ruby
user = User.new('Agnieszka')
user::hello

# Hello, Agnieszka!
# => nil
```

Drugi sposób jest związany z programowaniem funkcyjnym. Możemy zamienić metodę na obiekt typu `proc` i wywołać na nim metodę `===`:

```ruby
user = User.new('Agnieszka')
:hello.to_proc === user

# Hello, Agnieszka!
# => nil
```

Jeżeli chcesz dowiedzieć się więcej na temat obiektu `proc` i metody `===`, to zachęcam Cię do zapoznania się z moim artykułem na temat [programowania funkcyjnego]({{site.baseurl}}/functional-programming-ruby "Programowanie funkcyjne w języku Ruby").
