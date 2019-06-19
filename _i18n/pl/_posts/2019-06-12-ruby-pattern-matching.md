---
layout: post
title: Pattern matching w Ruby
description: Dopasowywanie wzorców - nowa funkcjonalność w Ruby 2.7
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
lang: pl
---

Jakiś czas temu napisałam artykuł o <a href="{{ site.baseurl }}/elixir-pattern-matching" title="Elixir - Dopasowanie do wzorca">podstawach pattern matchingu w Elixirze</a>. Bardzo spodobała mi się idea dopasowywania do wzorca. Teraz możemy się nią cieszyć również w najnowszej wersji Ruby 2.7!!! Nie jest to co prawda ten sam pattern matching co w Elixirze, ale jest to ciekawa funkcjonalność. Trzeba też pamiętać, że **pattern matching w Ruby** jest funkcjonalnością eksperymentalną, więc może się zmieniać dynamicznie w następnych wersjach Rubiego. Nie zmienia to faktu, że już teraz możemy ją przetestować.

Zanim jednak zaczniemy, przypomnijmy sobie **Co to jest pattern matching?** Pattern matching, czyli inaczej **dopasowanie do wzorca** jest to sposób na przygotowywanie pewnych wzorców dla naszych danych, dzięki którym, jeżeli dane do tych wzorców pasują, możemy _rozebrać_ je na czynniki pierwsze bazując właśnie na podanych wzorcach. Innymi słowy pattern matching służy nam do wyciągania wybranych elementów ze skomplikowanych struktur danych, na podstawie pewnych reguł przez nas zdefiniowanych. Możemy też powiedzieć, że pattern matching jest jak _wyrażenie regularne_ z wielokrotnym przypisaniem wykorzystywane nie tylko dla łańcuchów znaków (string).

Na początku artykułu _Pattern matching w Elixirze - podstawy_ opisałam **operator match** w Elikxirze. Ponieważ Ruby jako język powstał na podstawie trochę innych koncepcji niż Elixir (choć trzeba tu pamiętać o ich powiązaniu), to nie zobaczymy w Ruby czegoś podobnego do **operatora match**. Ruby operuje na **przypisaniu**. Podczas gdy w Elixirze możemy zrobić:

```elixir
iex> x = 4
4

iex> 4 = x
4
```

to w języku Ruby jest to niemożliwe:

```ruby
irb> x = 4
 => 4
irb> 4 = x
Traceback (most recent call last):
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `<main>'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `load'
        1: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
SyntaxError ((irb):2: syntax error, unexpected '=', expecting end-of-input)
4 = x
  ^
```

Nie pokazuje tego by udowodnić, że Elixir jest lepszym językiem niż Ruby. Mówię o tym, by zaznaczyć, jak trudne zadanie stało przed twórcami języka Ruby, gdy postanowili wprowadzić pattern matching do języka. Tak jak wspominałam na początku, jest to funkcjonalność eksperymentalna, więc potrzeba czasu na jej dopracowanie, odpowiedzenie na wszystkie pojawiające się pytania i podjęcie decyzji w jakim kierunku dalej rozwijać pattern matching. Na tę chwilę możemy już teraz wypróbować to, co nam oferuje pattern maching w Ruby.

## Pattern matching w Ruby - podstawy

Na początku zapoznajmy się z nową składnią dla `case` jaką mamy dostępną:

```ruby
case exprestion
in pattern [if|unless condition]
  ...
in pattern [if|unless condition]
  ...
else
  ...
end
```

Pattern matching ma tą samą kolejność wykonywania działań co normalny `case`. Szukamy więc pierwszego dopasowania do wzorca. Jeżeli takie dopasowanie nie zostanie znalezione, wywołany będzie kod znajdujący się w `else`. Gdyby jednak tego `else` nie było i nie byłoby również dopasowania do żadnego zadeklarowanym przypadku, to zostałby wywołany wyjątek `NoMatchingPatternError`. Możesz to zobaczyć w poniższych przykładach.

## Pattern matching dla klasy Array w Ruby

Jednym z najprostszych przykładów dopasowania do wzorca dla tablic jest:

```ruby
case [1, 2]
in [2, a]
  :no_match
in [1, a]
  :match
end
 => :match

irb> a
 => 2
```

Pierwszy wzorzec nie został dopasowany do tablicy `[1, 2]`, więc wywołany został drugi przypadek, w którym dopasowanie zostało znalezione. Dodatkowo otrzymałyśmy przypisanie `a = 2`.

Jeżeli nie znasz rozmiaru tablicy lub po prostu chcesz dostać dostęp do jej części możesz skorzystać z **operatora splat**.

```ruby
case [1, 2, 3, 4]
in [1, *a]
end
 => nil

irb> a
 => [2, 3, 4]
```

Pamiętaj jednak o różnicy między zmienną `a` a splat operatorem `*a`:

```ruby
# normal variable
case [1, 2, 3]
in [1, a, 3]
end
 => nil

irb> a
 => 2

# splat operator
case [1, 2, 3]
in [1, *a, 3]
end
 => nil

irb> a
 => [2]
```

Splat operator zawsze zwróci Ci tablicę. Możesz też użyć `_` do pominięcia części danych we wzorcu:

```ruby
case [1, 2, 3]
in [_, a, 3]
end
 => nil

irb> a
 => 2
```

Istnieje też możliwość pominięcia nawiasów:

```ruby
case [1, 2, 3]
in 1, a, 3
end
 => nil

irb> a
 => 2
```

Pattern matching może być użyteczny dla tablic z bardziej skomplikowaną strukturą:

```ruby
case [1, [2, 3, 4]]
in [a, [b, *c]]
end
 => nil

irb> a
 => 1
irb> b
 => 2
irb> c
 => [3, 4]
```

## Pattern matching dla klasy Hash w Ruby

Kiedy mówimy o dopasowaniu do wzorca dla klasy `Hash` musimy pamiętać, że obecnie istnieje tylko wsparcie dla tablic słownikowych o kluczach w postaci symboli. Klucze w postaci łańcuchów znaków lub bardziej skomplikowanych obiektów nie są jeszcze wspierane. Jeżeli chciałabyś wiedzieć więcej na temat problemów dotyczących klasy `Hash` odsyłam Cię do <a href="https://speakerdeck.com/k_tsj/pattern-matching-new-feature-in-ruby-2-dot-7" title="Pattern matching w Ruby 2.7" target="_blank" rel="nofollow noopener noreferrer">prezentacji Kazuki Tsujimoto</a> na temat _Pattern matching w Ruby_.

Zacznijmy od prostego przykładu:

```ruby
case { foo: 1, bar: 2 }
in { foo: 1, baz: 3 }
  :no_match
in { foo: 1, bar: b }
  :match
end
 => :match

irb> b
 => 2
```

Podobnie jak w przypadku tablic gdzie mamy operator splat w tablicy słownikowej też możemy dostać się do części naszego obiektu, tym razem jednak za pomocą **podwójnego operatora splat**:

```ruby
case { foo: 1, bar: 2, baz: 3 }
in { foo: 1, **rest }
end
 => nil

irb> rest
 => {:bar=>2, :baz=>3}
```

Tak samo jak dla tablic możemy opuścić nawiasy:

```ruby
case { foo: 1, bar: 2 }
in foo: foo, bar: bar
end
 => nil

irb> foo
 => 1
irb> bar
 => 2
```

Dzięki cukrowi składniowemu (syntactic sugar) możemy również opuścić zmienne i zostać przy samych symbolach:

```ruby
case { foo: 1, bar: 2 }
in foo:, bar:
end
 => nil

irb> foo
 => 1
irb> bar
 => 2
```

Chciałabym też zwrócić uwagę na jeszcze jedną rzecz. **Dokładne dopasowanie (exact matching)** zachowuje się inaczej w przypadku tablic, a inaczej w przypadku tablic słownikowych (`Hash`). Popatrz na przykład poniżej. Dla zwykłej tablicy dostaniemy wyjątek `NoMatchingPatternError`:

```ruby
case [1, 2]
in [1]
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):33
NoMatchingPatternError ([1, 2])
```

Natomiast dla tablicy słownikowej mamy:

```ruby
case { foo: 1, bar: 2 }
in foo:
  :match
end
 => :match

irb> foo
 => 1
```

Na początku może być to mylące. Dla obiektu typu `Hash` dopasowanie nie odbywa się _dokładnie_. Jednak muszę przyznać, że sama z tego korzystałam wielokrotnie podczas moich testów. Gdyby jednak, to zachowanie miało się zmienić nie powinnam mieć problemu z dostosowaniem się do składni typu:

```ruby
case { foo: 1, bar: 2 }
in foo:, **_
end
```

Żeby jednak osiągnąć ten sam efekt, jaki otrzymałyśmy dla zwykłych tablic, potrzebujemy zrobić:

```ruby
case { foo: 1, bar: 2 }
in foo:, **rest if rest.empty?
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.7.0-preview1/lib/ruby/gems/2.7.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):37
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

Jest to bardzo istotne by pamiętać o różnicy w dopasowaniu dla obiektów typy `Hash`, ponieważ w niektórych momentach możemy się zdziwić odnośnie dopasowania do wzorca:

```ruby
case { foo: 1, bar: 2 }
in { foo: 1 }
  :it_will_match_here
in { foo: 1, bar: b }
  :no_match
end
 => :it_will_match_here
```

Mogłybyśmy oczekiwać dopasowania do drugiego wzorca, a w tym przypadku dostaniemy dopasowanie już dla pierwszego z nich.

## Pattern matching - strażnicy (guards)

Mogłaś zauważyć wykorzystanie strażników w poprzednim przykładzie. Do naszego wzorca możemy dodać jeszcze dodatkowy warunek logiczny (guard), który operuje na zmiennych zadeklarowanych we wzorcu:

```ruby
case [1, 2, 3]
in [a, *c] if a != 1
  :no_match
in [a, *c] if a == 1
  :match
end
 => :match

irb> a
 => 1
irb> c
 => [2, 3]
```

## Czego możemy używać w dopasowaniu do wzorca?

#### Literały

Pattern matching dla języka Ruby może używać literałów czyli: wartości logicznych (Booleans), `nil`, liczb (Numbers), łańcuchów znaków (Strings), symboli (Symbols), tablic (Arrays), tablic słownikowych (Hashes), zakresów (Ranges), wyrażeń regularnych (Regular Expressions) i Procs.

```ruby
case 2
in (1..3)
  :match
in Integer
  :too_late_for_match
end
 => :match
```

#### Zmienne

Możemy też używać zmiennych, co pokazywałam już w poprzednich przykładach. Chciałabym tylko zwrócić uwagę na jedną rzecz. Podczas sprawdzania wzorca zawsze następuje przypisanie:

```ruby
irb> array = [1, 2, 3]
 => [1, 2, 3]

case [1, 2, 4]
in array
  :match
end

irb> array
 => [1, 2, 4]
```

Gdy chcemy sprawdzić, czy nasze dane pasują do wzorca wpisanego już wcześniej do zmiennej musimy użyć operatora `^`:

```ruby
irb> array
 => [1, 2, 4]

case [1, 2, 3]
in ^array
  :no_match
else
  :match
end

irb> array
 => [1, 2, 4]
```

#### Wzór alternatywny

Kolejną rzeczą jaką możemy użyć jest **wzór alternatywny** (alternative pattern):

```ruby
case 5
in 6
  :no_match
in 2 | 3 | 5
  :match
end
 => :match
```

#### As pattern

Ten typ wzorca nazwałabym po prostu przypisaniem. **As pattern** pozwala nam na przypisanie do zmiennej bardziej skomplikowanego wyrażenia:

```ruby
case [1, 2, [3, 4]]
in [1, 2, [3, b] => a]
end
=> nil

irb> a
 => [3, 4]
irb> b
 => 4
```

## Pattern matching dla innych obiektów

Do tej pory pokazałam Ci jak wygląda dopasowanie do wzorca dla tablicy i dla tablicy słownikowej. Na tą chwilę Ruby obsługuje pattern matching tylko dla kilku obiektów. Do tej grupy zalicza się również `Struct`.

```ruby
Point = Struct.new(:latitude, :longitude)
point = Point[50.29543618146685, 18.666200637817383]

case point
in latitude, longitude
end
 => nil

irb> latitude
 => 50.29543618146685
irb> longitude
 => 18.666200637817383
```

Jeżeli chciałabyś użyć dopasowania do wzorca dla innych obiektów, to należy do tego celu użyć metody `deconstruct` lub `deconstruct_keys`. W zależności, którą z nich użyjesz, Twoje obiekty podczas dopasowywania będą się zachowywać odpowiednio jak `Array` lub jak `Hash`. W przypadku powyżej `Struct` zachowuje się jak `Array`. Poniżej zamieściłam bardzo prosty przykład, gdzie obiekt klasy `Date` będzie zachowywał się podczas dopasowywania do wzorca jak `Hash`:

```ruby
class Date
  def deconstruct_keys(keys)
    { year: year, month: month, day: day }
  end
end

date = Date.new(2019, 9, 21)

case date
in year:
end
 => nil

irb> year
 => 2019
```

## Dane w formacie JSON

Moim zdaniem bardzo ładnie prezentują się zalety stosowania pattern matching w przypadku danych w formacie JSON:

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [
          18.666200637817383,
          50.29543618146685
        ]
      }
    }
  ]
}
```

W tym przypadku dopasowanie do wzorca może wyglądać następująco:

```ruby
case JSON.parse(json, symbolize_names: true)
in { type: "FeatureCollection", features: [{type: "Feature", geometry: { type: "Point", coordinates: [longitude, latitude]}}]}
end

irb> longitude
 => 18.666200637817383
irb> latitude
 => 50.29543618146685
```

Jeżeli użyłybyśmy do tego celu warunków logicznych kod wyglądałby następująco:

```ruby
point = JSON.parse(json, symbolize_names: true)
if point[:type] == "FeatureCollection"
  features = point[:features]
  if features.size == 1 && features[0][:type] == "Feature"
    geometry = features[0][:geometry]
    if geometry[:type] == "Point" && geometry["coordinates"].size == 2
      longitude, latitude = geometry["coordinates"]
    end
  end
end

irb> longitude
 => 18.666200637817383
irb> latitude
 => 50.29543618146685
```

Myślę że widać różnicę w czytelności.

## Zakresy - dziwne zachowanie

W obecnej wersji pattern matching w Ruby 2.7 ma pewne dziwne zachowanie, o którym wiadomo i które będzie zmienione w następnych wersjach języka Ruby. Chodzi o problem przypisywania wartości do zmiennych, nawet jeżeli warunek (nasz wzorzec) nie został dopasowany. Oto przykład:

```ruby
case[1, 2]
in x, y if y > 3
  :no_match
in x, z if y < 3
  :match
end
 => :match

irb> x
 => 1
irb> z
 => 2

# unexpected assignment for y when pattern matching failed
irb> y
 => 2
```

## Moje propozycje

Kiedy testowałam sobie pattern matching w Ruby, przyszły mi do głowy pewne dodatkowe funkcjonalności, które moim zdaniem mogłyby być przydatne. Oto one:

- pattern matching w jednej linii - Mamy `each` zapisywany w jednej linijce. Dlaczego nie mieć czegoś podobnego dla dopasowania do wzorca? Mogłoby to wyglądać następująco: `case [1, 2, [3, 4]] { [1, 2, [3, b] => a] }` i służyć do przypisywania wartości do zmiennych.
- obliczenia we wzorcach - Czasami chciałoby się zrobić szybkie obliczenia, których wynik zostanie potraktowany jako wzorzec. Tak jak w przypadku `in (1..3).to_a`. Na ta chwilę nie jest to jednak możliwe. Ten problem da się obejść wpisując wynik działania do zmiennej `array = (1..3).to_a` a później używając go jako `in ^array`.
- pozwolić na używanie zmiennych w wzorcach alternatywnych - byłoby fajnie móc zrobić `[1, 2] | [1, 2, c]`.

Wiem że moje pomysły mogą być trudne do osiągnięcia lub może nawet niemożliwe, ale jest to moja taka mała lista życzeń. ;]

## Podsumowanie

Bardzo podoba mi się się funkcjonalność dopasowania do wzorca w Ruby. Cieszę się, że mogłam się nią pobawić. Wiem, że to rozwiązanie nie jest jeszcze gotowe do używania produkcyjnie, ale podoba mi się jego czytelność i potencjał jaki ma w sobie.

A Ty co myślisz o pattern matchingu w Ruby? Podziel się swoimi przemyśleniami w komentarzach.
