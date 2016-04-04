---
layout: post
title: Triki dla obiektu Hash w Ruby
description: Czego ciekawego dowiedziałam się o obiekcie Hash
headline: My code is getting worse, please send more chocolate
categories: [Ruby, tips]
tags: [Ruby, tips]
comments: true
---

Dzisiaj chciałabym opowiedzieć Wam trochę o obiekcie Hash i metodach, których często do niego wykorzystuje. Ale zanim o metodach to zacznijmy od tego co to jest właściwie Hash?

Hash to bardzo specyficzna tablica. Jako klucz możemy użyć cokolwiek i przyporządkować mu odpowiednią wartość lub wartości. Przykładowo: Jeżeli mamy nasze ulubione książki i chciałybyśmy je uporządkować według ich autorów to jako klucz możemy użyć imię i nazwisko autora a jako wartość jego lub jej książki.

```ruby
hash = {
  'Carlos Ruiz Zafon' => ['La Sombra del Viento', 'El Juego del Angel'],
  'Antoine de Saint-Exupery' => 'Le Petit Prince'
}

hash['Carlos Ruiz Zafon']        # => ['La Sombra del Viento', 'El Juego del Angel']
hash['Antoine de Saint-Exupery'] # => 'Le Petit Prince'
```

Gdy chcemy dodać kolejnego autora, zachowujemy się jak przy zwykłej tablicy:

```ruby
hash['autor'] = ['jego znana książka']
```

To wszystko! Teraz możemy przejść do kilku fajnych metod dla obiektu Hash:

## 1. Tworzenie obiektu Hash z domyślna wartością

Jeżeli stworzymy ten obiekt w następujący sposób:

```ruby
hash = {} lub hash = Hash.new
hash[:key] # => nil
```

naszą domyślną wartością będzie `nil`. Ale co jeżeli chciałybyśmy zliczać jakieś elementy (np. ilość wystąpień danej litery w zdaniu). Możemy to zrobić tak:

```ruby
hash = {}
hash[:key] = 0 unless hash.has_key?(:key)
hash[:key] += 1

hash # => {:key=>1}
```

lub tak:

```ruby
hash = Hash.new(0)
hash[:key] += 1

hash # => {:key=>1}
```

Sposób drugi deklaruje domyślną wartość dla obiektu Hash na zero. Nasz kod wygląda lepiej i jest znacznie bardziej przejrzysty.

Dorze to co się stanie jeżeli postanowimy zadeklarować jako domyślną wartość pustą tablicę? Sprawdźmy

```ruby
hash = Hash.new([])
hash[:ala] << 1
hash        # => {}
hash[:ala]  # => [1]

hash[:bela] << 2
hash        # => {}
hash[:ala]  # => [1, 2]
hash[:bela] # => [1, 2]
```

Upsss! Coś jest nie tak. Nasz obiekt wydaje się być pusty ale gdy szukamy konkretnego klucza okazuje się, że ta sama tablica jest przywiązana do różnych kluczy. Możemy powiedzieć tak jeżeli jako klucza używamy liczby lub napisu to jest to coś lekkiego. Natomiast jeżeli jako kluczy zaczynamy używać tablic to są to już obiekty znacznie cięższe. Hash jest dość leniwy i nie chce mu się dźwigać ciężkich rzeczy, więc zapamiętuje tylko adres do tej tablicy (czyli to gdzie ta tablica się znajduje). Teraz za każdym razem gdy pojawia się nowa wartość dla dowolnego klucza to Hash odsyła ją pod ten jeden zapamiętany adres. Jeżeli chcemy by każdy klucz miał swój własny adres to trzeba to powiedzieć naszemu obiektowi Hash. Możemy to zrobić w następujący sposób:

```ruby
hash = Hash.new { |hash, key| hash[key] = [] }
hash[:a]
hash # => {:a=>[]}
hash[:b] << 3
# => {:a=>[], :b=>[3]}
```

## 2. Łączenie razem dwóch obiektów typu Hash i dodawanie do nich nowych kluczy

Możemy to zrobić na kilka sposobów. Ja pokaże tutaj trzy. Najprostszy sposób dodania nowego klucza już znamy:

```ruby
hash = {a: 3, b: 4}
hash[:c] = 6
hash # => {a: 3, b: 4, c: 6}
```

Drugi sposób na dodanie jednego klucza z wartością to

```ruby
hash = {a: 3, b: 4}
hash.store(:c, 6)
hash # => {a: 3, b: 4, c: 6}
```

Natomiast gdy chcemy sumować dwa obiekty Hash to możemy zrobić to tak:

```ruby
first_hash = {a: 3, b: 4}
second_hash = {c: 7, d: 9}
first_hash.merge(second_hash) # => {a: 3, b: 4, c: 7, d: 9}
```

Ten kod nie modyfikuje obiektu `first_hash` i `second_hash` zastały takie same jak na początku. Gdybyśmy jednak chciały zmodyfikować obiekt `first_hash` to powinnyśmy użyć metody z wykrzyknikiem `merge!`

```ruby
first_hash = {a: 3, b: 4}
second_hash = {c: 7, d: 9}
first_hash.merge!(second_hash) # => {a: 3, b: 4, c: 7, d: 9}
first_hash                     # => {a: 3, b: 4, c: 7, d: 9}
second_hash                    # => {c: 7, d: 9}
```

#### Uwaga

W tym przypadku musimy uważać. Możemy łatwo nadpisać sobie wartość dla konkretnego klucza jeżeli on znajduje się w obu obiektach. Przetrwa tylko wartość z ostatniego obiektu. Co widać na przykładzie:

```ruby
first_hash = {a: 3, b: 4}
second_hash = {b: 5, d: 9}
first_hash.merge(second_hash) # => {a: 3, b: 5, d: 9}
```

## 3. Wiemy już teraz jak dodawać do siebie obiekty Hash. A co jeżeli chcemy z nich coś usunąć?

Zacznijmy od usunięcia jednego elementu:

```ruby
hash = {a: 3, b: 4}
hash.delete(:b) # => 4
hash            # => {a: 3}
```

Jak widzimy po usunięciu jednego klucza metoda zwraca nam wartość jaka kryła się pod tym kluczem. Natomiast w naszym obiekcie nie ma już usuniętego klucza.

Jeżeli chcemy usunąć wiele kluczy i wartości możemy to zrobić następująco:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.delete_if { |key, value| value % 2 == 0 } # => {a: 3}
hash                                           # => {a: 3}
```

Tym razem wywołana metoda zwraca nie usunięte elementy ale te które zostają. Dodatkowo widać że nasz obiekt hash uległ zmianie.

Ten sam efekt możemy uzyskać wykorzystując metodę `reject`.

```ruby
hash = {a: 3, b: 4, c: 2}
hash.reject { |key, value| value % 2 == 0 } # => {a: 3}
hash                                        # => {a: 3, b: 4, c: 2}
```

Metoda ta nie zmienia obiektu hash. Gdy chcemy go zmodyfikować to używamy `reject!`

Możemy spojrzeć na problem z innej strony zamiast wyrzucać elementy których nie chcemy, możemy zatrzymać te które nas interesują:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.keep_if { |key, value| value == 3 } # => {a: 3}
hash                                     # => {a: 3}
```

lub za pomocą metody `select`:

```ruby
hash = {a: 3, b: 4, c: 2}
hash.select { |key, value| value == 3 } # => {a: 3}
hash                                    # => {a: 3, b: 4, c: 2}
```

**Uwaga:** Metoda `select!` modyfikuje obiekt hash podobnie jak to robi metoda `keep_if`

```ruby
hash = {a: 3, b: 4, c: 2}
hash.select! { |key, value| value == 3 } # => {a: 3}
hash                                     # => {a: 3}
```

## Podsumujmy. Dowiedziałyśmy się już:

- jak się tworzy obiekt z domyślna wartością,
- jak dodawać elementy do obiektu Hash i jak łączyć dwa takie obiekty,
- oraz jak usuwać klucze z obiektu Hash.

Myślę, że to był dobry początek. Na dziś starczy. Dziękuje za przeczytanie i do zobaczenia wkrótce.

