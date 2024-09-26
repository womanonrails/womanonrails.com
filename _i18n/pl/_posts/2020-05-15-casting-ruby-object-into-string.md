---
excerpt: >
  Miałam do zrobienia prostą funkcjonalność.
  Należało przedstawić różne obiekty, znajdujące się w tablicy, w postaci jednego łańcucha znaków.
  Sam problem jest trywialny, ale podczas jego implementacji zaczęłam się zastanawiać:
  **Jak obiekty będą wyglądać po rzutowaniu na łańcuchy znaków?**
  Tu akurat odpowiedź jest krótka - dobrze ;)
  Ciekawsza jest jednak odpowiedź na pytanie:
  **Dlaczego po rzutowaniu obiekty wyglądają w określony sposób?**
  To właśnie tym zagadnieniem zajmiemy dzisiaj się.
  Poszukiwania odpowiedzi czas zacząć.
  Aha nie zapominajmy, że to będzie niezła zabawa.
  Zapraszam!
layout: post
photo: /images/casting-ruby-object-into-string/chain-to_s-vs-to_str
title: Jak Ruby rzutuje obiekty na łańcuchy znaków?
description: Różnica między metodą to_s a to_str
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
lang: pl
imagefeature: casting-ruby-object-into-string/og_image-to_s-vs-to_str.png
---

Miałam do zrobienia prostą funkcjonalność. Należało przedstawić różne obiekty, znajdujące się w tablicy, w postaci jednego łańcucha znaków. Sam problem jest trywialny, ale podczas jego implementacji zaczęłam się zastanawiać: **Jak obiekty będą wyglądać po rzutowaniu na łańcuchy znaków?** Tu akurat odpowiedź jest krótka - dobrze ;) Ciekawsza jest jednak odpowiedź na pytanie: **Dlaczego po rzutowaniu obiekty wyglądają w określony sposób?** To właśnie tym zagadnieniem zajmiemy dzisiaj się. Poszukiwania odpowiedzi czas zacząć. Aha nie zapominajmy, że to będzie niezła zabawa. Zapraszam!

## Rzutowanie obiektów na łańcuchy znaków

Zacznijmy od prostego przykładu. Mamy tablice, w której znajdują się dwa obiekty. Jeden obiekt typu `String`, a drugi typu `Symbol`:

```ruby
[:symbol, 'string'].join(' ')
 => "symbol string"
```

Wszystko wygląda dobrze. Można się było tego spodziewać. Po połączeniu tych dwóch obiektów, dostajemy łańcuch znaków. No dobrze, a co w przypadku tablicy tablic? Jak wtedy zachowa się metoda `join`?

```ruby
[[:symbol], 'string'].join(' ')
 => "symbol string"
```

Super! Nie musimy się przejmować tablicą. Dostajemy dokładnie to, co chciałybyśmy dostać. Podobnie jest w przypadku metody `puts`. Na ekranie zostają nam wyświetlone **elementy tablicy**. Każdy element w osobnej linii.

```ruby
puts [:one, :two, :three]
one
two
three
 => nil
```

I tu pojawia się najważniejsze pytanie! Dlaczego metody `join` i `puts` zachowują się w ten sposób? Jeżeli samodzielnie zamienimy tablice na łańcuch znaków to wygląda to inaczej niż w przypadku metody `join` czy `puts`.

```ruby
[:symbol].to_s
 => "[:symbol]"
```

Moja logika podpowiada: _Skoro metoda `to_s` zwraca `"[:symbol]"`, to metoda `join` powinna zwracać `"[:symbol] string"`. Tak niestety nie jest. Dlaczego?_ Tu zaczyna się prawdziwy research. Na początek skupimy się na różnicy między metodą `to_s` a `join`.

## Co kryje się wewnątrz metody join?

Najpierw odkryłam, że metoda `join` nie używa do rzutowania obiektów metody `to_s`. A przynajmniej tak mi się na początku wydawało, bo jak się później przekonamy jest to troszkę bardziej skomplikowane. Na razie idźmy tym tropem. Metoda `join` używa do rzutowania metody `to_str`. Zobaczmy to na przykładzie. Deklarujemy nowa klasę i sprawdzimy jak zachowa się na niej metoda `join`.

```ruby
class RubyStringTest
  def to_s
    'calls to_s'
  end

  def to_str
    'calls to_str'
  end
end

string_test = RubyStringTest.new

string_test.to_s
 => "calls to_s"

[:it, string_test, :method].join(' ')
 => "it calls to_str method"
```

Widzimy, że przy metodzie `join` zostaje wywołana metoda `to_str`. Tylko dlaczego mamy te dwie metody? Wygląda na to, że robią to samo. To po co się powtarzać? Otóż nie zawsze robią to samo i nie maja tego samego przeznaczenia.

```ruby
"String".to_s
 => "String"

"String".to_str
 => "String"
```

## Różnica między metodą to_s a metodą `to_str

Metoda `to_s` jest zdefiniowana w klasie `Object`, więc wszystkie obiekty w języku Ruby posiadają tę metodę. Natomiast metoda `to_str` nie jest zaimplementowana we wszystkich klasach Rubiego. Kiedy spróbujemy wywołać ją na tablicy dostaniemy wyjątek:

```ruby
[:symbol].to_str
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):7
NoMethodError (undefined method `to_str' for [:symbol]:Array)
Did you mean?  to_set
               to_s
```

Wynika to ze znaczenia tych dwóch metod. Metoda `to_s` pozwala nam na rzutowanie obiektów na łańcuchy znaków. Metoda `to_str` pozwala naszemu obiektowi zachowywać się jak łańcuch znaków. By to zademonstrować wróćmy do przykładu z `RubyStringTest`:

```ruby
string_test = RubyStringTest.new

"This test #{string_test}"
 => "This test calls to_s"

"This test " + string_test
 => "This test calls to_str"
```

Widzisz różnicę? W pierwszym przypadku obiekt jest rzutowany na łańcuch znaków, w drugim chcemy by zachowywał się jak łańcuch znaków. Chcemy by tak samo jak łańcuch znaków odpowiadał na metodę `:+`. Kiedy spojrzymy na przykład z tablicą zobaczymy, że tablica nie zachowuje się jak łańcuch znaków. Tablica co prawda ma zaimplementowaną metodę `:+` ale metoda ta nie łączy się z łańcuchami znaków.

```ruby
"This is an array #{[:symbol]}"
 => "This is an array [:symbol]"

'This is an array' + [:symbol]
Traceback (most recent call last):
        6: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        5: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):8
        2: from (irb):8:in `rescue in irb_binding'
        1: from (irb):8:in `+'
TypeError (no implicit conversion of Array into String)
```

Oczywiście w języku Ruby możemy sprawić by tak się stało. Nie jest to jednak domyślne zachowanie.

```ruby
class Array
  def to_str
    to_s
  end
end

'This is an array ' + [:symbol]
 => "This is an array [:symbol]"
```

No dobrze, ale to nie jest odpowiedź na nasze pytanie. W końcu w poprzednim przykładzie widać było, że tablica nie zachowuje się jak łańcuch znaków i domyślnie nie ma zaimplementowanej metody `to_str`. Jeżeli spróbujemy wywołać metodę `to_str` na tablicy dostaniemy wyjątek:

```ruby
[:symbol].to_s
 => "[:symbol]"

[:symbol].to_str
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):2
NoMethodError (undefined method `to_str' for [:symbol]:Array)
Did you mean?  to_set
               to_s
```

## Jak metoda join działa na tablicach?

By zrozumieć metodę `join` musimy udać się do źródła, a dokładnie do
[kodu źródłowego języka Ruby](https://github.com/ruby/ruby/blob/ruby_2_7/array.c#L2384).
Zobaczymy tam następujące wyjaśnienie:

```ruby
/*
 *  call-seq:
 *     ary.join(separator=$,)    -> str
 *
 *  Returns a string created by converting each element of the array to
 *  a string, separated by the given +separator+.
 *  If the +separator+ is +nil+, it uses current <code>$,</code>.
 *  If both the +separator+ and <code>$,</code> are +nil+,
 *  it uses an empty string.
 *
 *     [ "a", "b", "c" ].join        #=> "abc"
 *     [ "a", "b", "c" ].join("-")   #=> "a-b-c"
 *
 *  For nested arrays, join is applied recursively:
 *
 *     [ "a", [1, 2, [:x, :y]], "b" ].join("-")   #=> "a-1-2-x-y-b"
 */
```

To jest opis, jak działa metoda `join`. Możemy tu zauważyć dwa istotne dla nas zdania: _Returns a string created by **converting** each **element** of the array **to a string**, separated by the given separator. For nested arrays, join is applied recursively._ Tłumacząc na język polski: _Zwraca łańcuch znaków **konwertując** każdy **element** tablicy na **łańcuch znaków** odzielony podanym separatorem. Dla zagnieżdżonej tablicy metoda join zachowuje się rekurencyjnie._ Znaczy to, że metoda `to_str` nie jest wywoływana na całej tablicy, ale na każdym jej elemencie. Co pasuje do następującego przykładu:

```ruby
[[:symbol], 'string'].join(' ')
 => "symbol string"

:symbol.to_str
Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):17
NoMethodError (undefined method `to_str' for :symbol:Symbol)
Did you mean?  to_s
               to_sym
```

Moment! Przecież nie pasuje! Klasa `Symbol` podobnie jak tablica nie implementuje metody `to_str`. Wróćmy jeszcze raz do naszego przykładu `RubyStringTest`, otwórzmy nową konsole i zróbmy to powoli:

```ruby
class RubyStringTest
end

string_test = RubyStringTest.new

string_test.to_s
 => "#<RubyStringTest:0x000055567edb0bd0>"

[:it, string_test, :method].join(' ')
 => "it #<RubyStringTest:0x000055567edb0bd0> method"
```

W tym momencie `join` używa metody `to_s`, a nie `to_str` jak na początku zakładałyśmy. Kiedy nadpiszemy metodę `to_s` zobaczymy naszą implementację:

```ruby
class RubyStringTest
  def to_s
    'calls to_s'
  end
end

string_test = RubyStringTest.new

string_test.to_s
 => "calls to_s"

[:it, string_test, :method].join(' ')
 => "it calls to_s method"
```

Natomiast kiedy zaimplementujemy jeszcze metodę `to_str`, to `join` zacznie jej używać.

```ruby
class RubyStringTest
  def to_s
    'calls to_s'
  end

  def to_str
    'calls to_str'
  end
end

string_test = RubyStringTest.new

string_test.to_s
 => "calls to_s"

[:it, string_test, :method].join(' ')
 => "it calls to_str method"
```

Wyciągając wniosek z tego przykładu, metoda `join` na początku swojego działania próbuje wywołać metodę `to_str`. Gdy ta metoda nie jest zaimplementowana w obiekcie, to wykorzystuje metodę `to_s`. To wytłumaczenie pasuje do naszych obserwacji:

```ruby
[[:symbol], 'string'].join(' ')
 => "symbol string"

:symbol.to_s
 => "symbol"
```

## Jak na tablicy działa metoda puts?

Podobne zachowanie możemy zauważyć dla metody `puts`. Kiedy wywołamy ją na tablicy, na ekranie zobaczymy elementy tej tablicy. Każdy z elementów będzie się znajdował w osobnej linii.

```ruby
[1, 2, 3].to_s
 => "[1, 2, 3]"

puts [1, 2, 3]
1
2
3
 => nil
```

Zarówno `join` jak i `puts` wywołują metodę `to_str` czy metodę `to_s` na elementach tablicy, a nie na samej tablicy. Podobnie jak w przypadku metody `join`, dla metody `puts` też  możemy to sprawdzić w
[kodzie Rubiego](https://github.com/ruby/ruby/blob/ruby_2_7/io.c#L7720).

```ruby
/*
 *  call-seq:
 *     ios.puts(obj, ...)    -> nil
 *
 *  Writes the given object(s) to <em>ios</em>.
 *  Writes a newline after any that do not already end
 *  with a newline sequence. Returns +nil+.
 *
 *  The stream must be opened for writing.
 *  If called with an array argument, writes each element on a new line.
 *  Each given object that isn't a string or array will be converted
 *  by calling its +to_s+ method.
 *  If called without arguments, outputs a single newline.
 *
 *     $stdout.puts("this", "is", ["a", "test"])
 *
 *  <em>produces:</em>
 *
 *     this
 *     is
 *     a
 *     test
 *
 *  Note that +puts+ always uses newlines and is not affected
 *  by the output record separator (<code>$\\</code>).
 */
```

## Podsumowanie

1. Istnieją dwie metody pozwalające nam być jak łańcuch znaków:
    - metoda `to_s` - pozwala rzutować obiekty na łańcuch znaków. Każdy obiekt ma tą metodę.
    - metoda `to_str` - pozwala na zachowywanie się jak łańcuch znaków. Nie wszystkie obiekty posiadają tą metodę.
2. Metoda `join` używa metody `to_str`, gdy ta metoda jest zaimplementowana. W przeciwnym wypadku używa metody `to_s`.
3. Metoda `puts` zawsze używa pod spodem metody `to_s`.
4. W przypadku tablicy metody `join` i `puts` wywołują metody `to_str` i `to_s` na każdym elemencie tablicy.
5. Klasy `Symbol` i `Array` nie implementują metody `to_str` z automatu.

