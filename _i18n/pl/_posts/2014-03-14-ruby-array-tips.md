---
layout: post
title: Triki dla tablic w Ruby
description: 10 troków na tablicach w Ruby
headline: My code is getting worse, please send more chocolate
categories: [programowanie]
tags: [Ruby]
lang: pl
---

Ruby ma naprawdę świetną dokumentację. Metody dla tablic też są dobrze opisane na przykład tutaj. Dziś chciałabym się skupić na kilku trikach jakie znam na tablicach w Ruby. No to zaczynamy:

- Tworzenie tablicy składającej się z napisów:

```ruby
%w{ 1 2 3 4 }
 => ["1", "2", "3", "4"]
```

- Tworzenie tablicy składającej się z tej samej liczby:

```ruby
[2]*5
 => [2, 2, 2, 2, 2]
```

- Tworzenie tablicy z kolejnych liczb naturalnych:

```ruby
(1..4).to_a
 => [1, 2, 3, 4]
```

- Tworzenie tablicy z kolejnych liczb parzystych:

```ruby
(2..10).step(2).to_a
 => [2, 4, 6, 8, 10]
```

- Pokazanie ostatniego elementu tablicy:

```ruby
array = [1, 2, 3, 4]
array[-1]
 => 4
```

- Pokazanie wybranego fragmentu tablicy:

```ruby
array = [1, 2, 3, 4]
array[1..2]
 => [2, 3]
array[1...3]
 => [2, 3]
array[1, 2]
  => [2, 3]
```

- Dekompozycja tablicy:

```ruby
a, b, c = [1, 2, 3, 4]
a => 1
b => 2
c => 3
```

lub

```ruby
a, b, *c = [1, 2, 3, 4]
a => 1
b => 2
c => [3, 4]
```

- Suma wszystkich elementów tablicy:

```ruby
array = [1, 2, 3, 4]
array.inject(&:+)
 => 10
```

lub

```ruby
array.reduce(&:+)
 => 10
```

- Usunięcie określonej części tablicy:

```ruby
array = [1, 2, 3, 4]
array.slice!(1..2)
array => [1, 4]
```

- Operacje na tablicy:

```ruby
# Suma
[1, 2, 3] | [1, 4] => [1, 2, 3, 4]
# Konkatenacja
[1, 2, 3] + [1, 4] => [1, 2, 3, 1, 4]
# Iloczyn
[1, 2, 3] & [1, 4] => [1]
# Różnica
[1, 2, 3] - [1, 4] => [2, 3]
```
