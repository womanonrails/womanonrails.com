---
layout: post
photo: /images/pattern-matching/pattern-matching
title: Drugie spojrzenie na pattern matching w Ruby
description: Co nowego w dopasowaniu do wzorca w Ruby?
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
imagefeature: pattern-matching/og_image-pattern-matching.png
lang: pl
last_modified_at: 2022-01-19 16:00:00 +0200
---

Gdy pojawiają się nowości w naszym języku programowania czasami jesteśmy z tego powodu zadowolone, a czasami nie. Dziś chciałabym porozmawiać o zmianach, z których ja osobiście bardzo się cieszę. Mam na myśli **dopasowanie do wzorca**  w języku Ruby, czyli pattern matching. Jakiś czas temu napisałam artykuł na temat <a href="{{ site.baseurl }}/ruby-pattern-matching" title="Podstawy dopasowania do wrorca w języku Ruby">Pattern Matching-u w języku Ruby</a>. Zachęcam do zapoznania się z nim, ponieważ będę odwoływała się do omawianych tam przykładów. A teraz zanurzmy się jeszcze bardziej w świat dopasowania do wzorca w języku Ruby. Zaczynamy!

### 1. Jednolinijkowe dopasowanie do wzorca w Ruby

Jest to jedna z tych rzeczy, których brakowało mi w dopasowaniu do wzorca w Ruby, a o istnieniu której nie wiedziałam.

W Ruby 3.0 mamy dwa sposoby na użycie jednolinijkowego dopasowania do wzorca. Są to `in` oraz `=>`. Warto zwrócić uwagę, że zachowują się one trochę inaczej. W przypadku `in` zostanie zwrócone `true` bądź `false`. Nie dostaniemy wyjątku. Dzięki temu możemy wykorzystywać to dopasowanie do wzorca w blokach takich jak `any?` czy `all?`. Opowiem o tym trochę później. W drugim przypadku, czyli przy wykorzystaniu `=>` dostaniemy albo przypisanie do wzorca, a więc również przypisanie do zmiennych, albo wyjątek. Oto jak wyglądają przykłady:

##### Jednolinijkowy Pattern Matching dla tablicy słownikowej (Hash)

Kiedy mamy dopasowanie do wzorca dla `in`

```ruby
{ foo: 1, bar: 2 } in { foo: f }
 => true

3.0.0> f
 => 1
```

bez dopasowania

```ruby
{ foo: 1, bar: 2 } in { baz: b }
 => false

3.0.0> b
 => nil
```

Podobnie wygląda to bez deklaracji zmiennej

```ruby
{ foo: 1, bar: 2 } in { foo: }
 => true

3.0.0> foo
 => 1
```

Dla `=>` mamy natomiast

```ruby
{ foo: 1, bar: 2 } => { foo: f }
 => nil

3.0.0> f
 => 1
```

oraz wyjątek przy braku dopasowania

```ruby
{ foo: 1, bar: 2 } => { baz: }

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        1: from (irb):7:in `<main>'
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

##### Jednolinikowy Pattern Matching dla tablicy

Analogiczne zachowanie możemy zaobserwować dla tablic. W przypadku `in` mamy

```ruby
[1, 2, 3] in [a, 2, 3]
 => true

3.0.0> a
 => 1
```

a w przypadku `=>` mamy

```ruby
[1, 2, 3] => [a, 2, 3]
 => nil

3.0.0> a
 => 1
```

##### Jednolinikowy Pattern Matching w Ruby 3.1

Po pierwsze, jednolinijkowe dopasowanie do wzorca w Ruby 3.1 nie jest już eksperymentalne. Po drugie, możemy pominąć nawiasy dla tablic i tablic słownikowych, co nie było możliwe we wcześniejszych wersjach Ruby.

Do tej pory w Ruby 3.0 działał pattern matching:

```ruby
3.0.0> [0, 1] => [_, x]
3.0.0> x
 => 1
```

Ale nie można było pominąć nawiasów. Wtedy pojawiał się błąd składniowy:

```ruby
3.0.0> [0, 1] => _, x
Traceback (most recent call last):
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        1: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
SyntaxError ((irb):6: syntax error, unexpected ',', expecting end-of-input)
[0, 1] => _, x
```

W wersji Ruby 3.1 jest to możliwe.

```ruby
3.1.0> [0, 1] => _, x
 => nil
3.1.0> x
 => 1
```

Analogicznie wygląda sytuacja dla tablic słownikowych czyli _hash-y_.

### 2. Pattern matching dla dopasowania tablicy z zadeklarowanym początkiem i końcem

```ruby
[1, 2, 3, 4, 5, 6] in [first, *middle, last]

3.0.0> first
 => 1

3.0.0> middle
 => [2, 3, 4, 5]

3.0.0> last
 => 6
```

lub w przypadku gdy nie interesuje nas środkowa część tablicy

```ruby
[1, 2, 3, 4, 5, 6] in [first, *, last]

3.0.0> first
 => 1

3.0.0> last
 => 6
```

### 3. Dokładne dopasowanie dla tablicy słownikowej (Hash)

Jak wspominałam w moim poprzednim artykule na ten temat, dokładne dopasowanie dla tablic i tablic słownikowych różni się od siebie. W skrócie sprawa wygląda następująco.

Gdy szukamy dokładnego dopasowanie do wzorca dla tablicy i tego dopasowania nie ma, dostajemy błąd.

```ruby
case [1, 2]
in [1]
  :no_match
end

Traceback (most recent call last):
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        1: from (irb):12:in `<main>'
NoMatchingPatternError ([1, 2])
```

W przypadku tablicy słownikowej częściej nazywanej hashem sprawa wygląda inaczej. Nie potrzebujemy dokładnego dopasowania, więc błąd też się nie pojawi.

```ruby
case { foo: 1, bar: 2 }
in foo:
  :match
end
 => :match

3.0.0> foo
 => 1
```

Gdybyśmy jednak chciały dokładnego dopasowania trzeba to zrobić w następujący sposób:

```ruby
case { foo: 1, bar: 2 }
in foo:, **rest if rest.empty?
  :no_match
end

Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        2: from (irb):15:in `<main>'
        1: from (irb):16:in `rescue in <main>'
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

lub w trochę prostszy sposób:

```ruby
case { foo: 1, bar: 2 }
in foo:, **nil
  :no_match
end

Traceback (most recent call last):
        5: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        4: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
        2: from (irb):19:in `<main>'
        1: from (irb):20:in `rescue in <main>'
NoMatchingPatternError ({:foo=>1, :bar=>2})
```

### 4. Pominięcie dokładnego dopasowania dla tablicy

W Ruby 2.7 nie było możliwości częściowego dopasowania zwykłej tablicy tak jak w przypadku tablicy słownikowej. Mogłyśmy dopasować zaczynając od pierwszego lub ostatniego elementy tablicy. Jak na poniższych przykładach:

```ruby
case [1, 2, 3]
in [1, *]
  :match
end
 => :match

case [1, 2, 3]
in [*, 3]
  :match
end
 => :match
```

Ale od wersji Ruby 3.0 możemy także szukać dopasowania dowolnego elementu w tablicy.

```ruby
case [1, 2, 3, 4]
in [*, 2, a, *]
  :match
end
 => :match

3.0.0> a
 => 3
```

Możemy nawet nazwać `*`

```ruby
case [1, 2, 3, 4]
in [*first, 2, a, *last]
  :match
end
 => :match

3.0.0> a
 => 3
3.0.0> first
 => [1]
3.0.0> last
 => [4]
```

Przydatność tego rozwiązania jest na pewno bardziej widoczna na danych z przykładu poniżej:

```ruby
json = {
  name: "Woman on Rails",
  friends: [{ name: "Alex", age: 24 }, { name: "Tom", age: 25 }]
}
json in { name: "Woman on Rails", friends: [*, { name: "Alex", age: age }, *] }

3.0.0> age
 => 24
```

### 5. Wzór alternatywny (ang. alternative pattern) dla zmiennych

Wiemy z poprzedniego artykułu, że w przypadku alternative pattern nie możemy używać zmiennych

```ruby
case [1, 2]
in [1, 3] | [1, c]
  :match
end

Traceback (most recent call last):
        1: from (irb)
SyntaxError ((irb):55: illegal variable in alternative pattern (c))
```

jest jednak jeden wyjątek. Możemy użyć podkreślenia `_`:

```ruby
case [1, 2]
in [1, 3] | [1, _]
  :match
end
 => :match

3.0.0> _
 => :match
```

Możemy to podkreślenie nazwać:

```ruby
case [1, 2]
in [1, 3] | [1, _last]
  :match
end
 => :match

3.0.0> _last
 => 2
```

### 6. Kilkukrotne przypisanie tej samej zmiennej we wzorcu

Dzięki `^` możemy sprawdzać dopasowanie używając tej samej zmiennej kilkukrotnie we wzorcu. W naszym przykładzie jest to `name` użyte dwa razy.

```ruby
case { name: "Woman on Rails", people: [{ name: "Alex", age: 24 }, { name: "Woman on Rails", age: 25 }] }
in name:, people: [*, {age:, name: ^name}]
  :match
end

 => :match
3.0.0> name
 => "Woman on Rails"
3.0.0> age
 => 25
```

### 7. Nieskończone zakresy dla dopasowania do wzorca

Jest to funkcjonalność bardziej związana ze zmianami w samym Ruby, ale myślę że warto o niej wspomnieć. Od niedawana mamy dostęp do nieskończonych zakresów w Ruby, które można wykorzystać w dopasowaniu do wzorca.

```ruby
case { a: 1, b: 2 }
in a: 0.. => first
  :match
end

:match
3.0.0> first
 => 1

case { a: 1, b: 2 }
in b: ..3 => first
  :match
end

 => :match
3.0.0> first
 => 2
```

### 8. Wyrażenia regularne w dopasowaniu do wzorca

Na koniec zostawiłam możliwość wykorzystania wyrażeń regularnych jako wzorca w pattern matching-u:

```ruby
website = 'womanonrails.com'

case website
  in /\w*\.com/ => favorite_website
end

3.0.0> favorite_website
 => "womanonrails.com"
```

### 9. Zastosowanie dopasowania do wzorca wewnątrz bloku

W blokach takich jak `any?`, `'all?`, `select` czy `find` możemy użyć jednolinijkowego dopasowania do wzorca `in`.

```ruby
users = [{ name: "Woman on Rails", age: 22 }, { name: "Alex", age: 23 }]

users.any? { |user| user in { name: /C/, age: 20.. } }
 => false

users.any? { |user| user in { name: /A/, age: 20.. } }
 => true
```

### 10. Pin operator (^)  i złożone wyrażenia

Od Ruby 3.1 mamy możliwość korzystania ze złożonych wyrażeń przy pomocy pin operatora `^`. W poprzednich wersjach Ruby była możliwość używania tylko stałych, literałów i zmiennych lokalnych.

Przykładowo, w Ruby 3.0 można było użyć obiektu typu `Range` z liczbami całkowitymi:

```ruby
3.0.0> { version: 12 } in { version: 10..15 }
 => true
```

ale nie z bardziej skomplikowanymi obiektami:

```ruby
3.0.0> { version: 12 } in { version: (BigDecimal('10')..BigDecimal('15')) }
Traceback (most recent call last):
        3: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `<main>'
        2: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/bin/irb:23:in `load'
        1: from /home/agnieszka/.rvm/rubies/ruby-3.0.0/lib/ruby/gems/3.0.0/gems/irb-1.3.0/exe/irb:11:in `<top (required)>'
SyntaxError ((irb):19: syntax error, unexpected .., expecting ')')
...n {version: (BigDecimal('10')..BigDecimal('15'))}
...                             ^~
(irb):19: syntax error, unexpected ')', expecting end-of-input
...ecimal('10')..BigDecimal('15'))}
...                              ^
```

Teraz w Ruby 3.1 te obliczenia są możliwe dzięki zastosowaniu pin operatora `^`:

```ruby
3.1.0> require 'bigdecimal'
 => true
3.1.0> { version: 12 } in { version: ^(BigDecimal('10')..BigDecimal('15')) }
 => true
```

Jak widać złożone wyrażenia są teraz poprawnie interpretowane. Trzeba tylko pamiętać, że **nawiasy przy stosowaniu pin operatora `^` są obowiązkowe**. Nie można zrobić:

```ruby
3.1.0> Time.now.year in ^rand(2021..2023)
/home/agnieszka/.rvm/rubies/ruby-3.1.0/lib/ruby/3.1.0/irb/workspace.rb:119:in `eval': (irb):16: rand: no such local variable (SyntaxError)
(irb):16: syntax error, unexpected '(', expecting end-of-input
Time.now.year in ^rand(2021..2023)
                      ^
        from /home/agnieszka/.rvm/rubies/ruby-3.1.0/lib/ruby/gems/3.1.0/gems/irb-1.4.1/exe/irb:11:in `<top (required)>'
        from /home/agnieszka/.rvm/rubies/ruby-3.1.0/bin/irb:25:in `load'
        from /home/agnieszka/.rvm/rubies/ruby-3.1.0/bin/irb:25:in `<main>'
```

ale za to działa:

```ruby
3.1.0 :017 > Time.now.year in ^(rand(2021..2023))
 => false
```

To wszystko co przygotowałam na dzisiaj. Znasz jeszcze więcej ciekawostek dotyczących dopasowania do wzorca w języku Ruby? Podziel się nimi w komentarzach.

### Bibliografia
- <a href="{{ site.baseurl }}/ruby-pattern-matching" title="Podstawy dopasowania do wrorca w języku Ruby">Pattern Matching-u w języku Ruby</a>
- <a href="https://docs.ruby-lang.org/en/2.7.0/NEWS.html#label-Pattern+matching" title="Nowości dla Ruby 2.7.0" target='_blank' rel='nofollow'>Ruby lang docs [EN] - nowości dla Ruby 2.7.0</a>
- <a href="https://docs.ruby-lang.org/en/master/doc/syntax/pattern_matching_rdoc.html" title="Nowości o Pattern Matching" target='_blank' rel='nofollow'>Ruby lang docs [EN] - nowości o Pattern Matching</a>
- <a href="https://blog.saeloun.com/2020/08/17/find-pattern-in-pattern-matching" title="Short post by Vamsi Pavan Mahesh" target='_blank' rel='nofollow'>Ruby introduces find pattern in pattern matching [EN]</a>
