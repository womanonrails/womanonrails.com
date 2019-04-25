---
layout: post
title: Refaktoring w Ruby krok po kroku - część 2
description: Jak zrobić refaktoring? <br> Od kodu zorientowanego obiektowo do kompozycji.
headline: Premature optimization is the root of all evil.
categories: [refaktoring]
tags: [Ruby]
lang: pl
---

Ostatnim razem w artykule [Refactoring w Ruby krok po kroku - część 1](https://womanonrails.com/pl/refactoring-step-by-step) przeszłyśmy od kodu proceduralnego do kodu bardziej zorientowanego obiektowo. Tym razem będziemy kontynuować naszą podróż przez refaktoring. Będziemy mówić o małych obiektach zastępujących duże klasy, o kompozycji i o wstrzykiwaniu konkretnych zachowań do obiektów. Zaczynajmy!

# Krok 8 - Bardziej opisowe wyniki

Ten krok zaczynamy od <a href="https://github.com/womanonrails/poker/blob/46e12428d0d67cb90d17f417147dc936815a69e7/lib/poker/hand.rb" title="Siódmy krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">kodu</a> i skupimy się na czytelności tej metody:

```ruby
def check
  return 9 if straight_flush?
  return 8 if four_of_a_kind?
  return 7 if full_house?
  return 6 if flush?
  return 5 if straight?
  return 4 if three_of_a_kind?
  return 3 if two_pair?
  return 2 if one_pair?
  return 1 if high_card?
  return 0
end
```

Muszę przyznać, że to dość ważny krok. Kiedy myślimy o czytelności kodu o wiele łatwiej zrozumieć nam tekst `:straight_flush` niż zwykłą liczbę `9`. W przypadku tekstu nie musisz głęboko wchodzić w szczegóły implementacji kodu by wiedzieć, co on będzie robił. Z drugiej strony, podeszłam do tej zmiany dość egoistycznie. Myślałam tylko o tej klasie bez zastanowienia nad konsekwencjami dla całego systemu. Zmieniłam to, co zwraca metoda `check`. W niektórych przypadkach taka zmiana może być bardzo trudna do wprowadzenia lub nawet niemożliwa, przy bieżącym stanie kodu. W moim przypadku zmiana ta wymagała poprawy wszystkich testów. Dlatego musisz być ostrożna i świadoma przy wprowadzaniu takich zmian. W każdym razie, uważam że w moim przypadku zmiana była warta zachodu.

Kod po zmianie:

```ruby
def check
  return :straight_flush if straight_flush?
  return :four_of_a_kind if four_of_a_kind?
  return :full_house if full_house?
  return :flush if flush?
  return :straight if straight?
  return :three_of_a_kind if three_of_a_kind?
  return :two_pair if two_pair?
  return :one_pair if one_pair?
  return :high_card if high_card?
  return :none
end
```

Nową wersję kodu możesz znaleźć <a href="https://github.com/womanonrails/poker/blob/4896498a348db52d5c884a522a132eae5b2c4f60/lib/poker/hand.rb" title="Ósmy krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>

## Statystyki:
- **LOC**  - 80
- **LOT**  - 190
- **Flog** - 62.5
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Krok 9 - Meta-programowanie

Ten krok jest całkowicie opcjonalny. Zrobiłam go ponieważ nie podobał mi się wygląd metody `check` i te powtórzenia wewnątrz. Uważam, że po tej zmianie kod jest dalej czytelny, ale za to krótszy. Niestety nie zawsze tak jest. Czasem meta-programowanie bardzo pogarsza czytelność kodu. Dlatego zawsze jako programistka Ty jesteś odpowiedzialna za swój kod i to Ty musisz wybrać rozwiązanie, które Twoim zadaniem jest lepsze. W moim przypadku stworzyłam tablicę z poprawną kolejnością sprawdzania ręki pokerowej i użyłam jej w metodzie `check`.

Kod przed zmianą:


```ruby
def check
  return :straight_flush if straight_flush?
  return :four_of_a_kind if four_of_a_kind?
  return :full_house if full_house?
  return :flush if flush?
  return :straight if straight?
  return :three_of_a_kind if three_of_a_kind?
  return :two_pair if two_pair?
  return :one_pair if one_pair?
  return :high_card if high_card?
  return :none
end
```

Kod po zmianie:

```ruby
def check
  @order_checking.each do |name|
    method_name = (name.to_s + '?').to_sym
    return name if send(method_name)
  end
end
```

gdzie `@order_checking` to tablica ustawień ręki w pokerze.

```
@order_checking = [
  :straight_flush, :four_of_a_kind, :full_house, :flush, :straight,
  :three_of_a_kind, :two_pair, :one_pair, :high_card, :none
]
```

Cały kod możesz znaleźć <a href="https://github.com/womanonrails/poker/blob/4d649a25af020c7f862b3c6ed964f1b2e73a0f60/lib/poker/hand.rb" title="Dziewiąty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>

## Statystyki
- **LOC**  - 82
- **LOT**  - 190
- **Flog** - 59.3
- **Flay** - 0
- **Tests** - 104 examples, 0 failures

# Krok 10 - Małe obiekty

Ten krok był dość duży ale również ważny. Może nawet najważniejszy. Zaczęłam od zasad **SOLID**. Jeśli nie słyszałaś o tych zasadach lub chciałabyś szybko odświeżyć sobie pamięć, to zajrzyj na <a href="https://pl.wikipedia.org/wiki/SOLID_(programowanie_obiektowe)" title="SOLID (programowanie obiektowe)" target="_blank" rel="nofollow noopener noreferrer">stronę Wiki</a>. Polecam też prezentację <a href="https://www.youtube.com/watch?v=v-2yFMzxqwU" title="Sandy Metz - SOLID Object-Oriented Design" target="_blank" rel="nofollow noopener noreferrer">Sandy Metz - SOLID Object-Oriented Design</a>. Zaczęłam od **S - Single responsibility principle** - zasady pojedynczej odpowiedzialności. Kiedy popatrzysz na kod klasy `Hand`, stwierdzisz, że ta klasa wie i robi wszystko. Tak jak już mówiłam w poprzednim artykule ten kod jest bardziej proceduralny niż obiektowy. Zaczęłam, więc wyciągać funkcjonalności jedna po drugiej. Każdy etap był dość podobny do poprzedniego, dlatego pokażę go na jednym przykładzie. Na przykładnie metody `four_of_a_kind`:

- Przeniosłam logikę metody `four_of_a_kind` do osobnej klasy. Tak, to wytworzy w kodzie pewne powtórzenia, ale jak mówi Sandi *duplication is better than a wrong abstraction* (powtórzenia są lepsze od złej abstrakcji).

```ruby
module Poker
  class FourOfAKind
    def initialize(array)
      @array = array.sort
      @figures, @colors = cards_figures_and_colors
      @frequency = cards_frequency.values
    end

    def check
      :four_of_a_kind if @frequency.include?(4)
    end

    private

    def cards_figures_and_colors
      @array.map { |item| [item / 4, item % 4] }.transpose
    end

    def cards_frequency
      @figures.each_with_object(Hash.new(0)) do |item, hash|
        hash[item] += 1
      end
    end
  end
end
```

- Tworzę a w późniejszych krokach modyfikuję brzydko wyglądający warunek `if` w klasie `Hand` tak by obsłużył on nowy kod.

```ruby
def check
  @order_checking.each do |name|
    if name == :four_of_a_kind
      return name if FourOfAKind.new(@array).check == name
    else
      method_name = (name.to_s + '?').to_sym
      return name if send(method_name)
    end
  end
end
```

- Przygotowuję testy dla nowej klasy. Tak, powieliłam już istniejące testy dla metody `check` w tej nowej klasie. Na tą chwilę musi to tak zostać.

```ruby
require 'spec_helper'

describe Poker::FourOfAKind do
  [
    [0, 1, 2, 3, 4],
    [4, 5, 6, 0, 7],
    [8, 9, 0, 10, 11],
    [12, 0, 13, 14, 15],
    [0, 16, 17, 18, 19],
    [20, 21, 22, 23, 0].shuffle,
    [24, 25, 26, 27, 0].shuffle,
    [28, 29, 30, 31, 0].shuffle,
    [32, 33, 34, 35, 0].shuffle,
    [36, 37, 38, 39, 0].shuffle
  ].each do |cards|
    it "detects four_of_a_kind for #{cards}" do
      hand = described_class.new(cards)
      expect(hand.check).to eq :four_of_a_kind
    end
  end
end
```

Podczas tego procesu zrobiłam jeszcze jedną rzecz. Wstrzyknęłam kolejność sprawdzania ręki pokerowej do inicjalizera klasy `Hand`. `ORDER_CHECKING` to stała, którą można traktować jako konfigurację i wyciągnąć do osobnego pliku jeżeli zajdzie taka potrzeba. Zrobiłam to na wypadek gdybym chciała szybko zmienić kolejność sprawdzania tego, co gracz ma w ręce w testach lub w aplikacji.

```ruby
def initialize(array, order_checking = ORDER_CHECKING)
  ...
end
```

Kod dla tego etapu znajdziesz <a href="https://github.com/womanonrails/poker/tree/0c5d6850d40f899d98ff531e4a2b948d469c3d84/lib/poker" title="Dziesiąty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Został on powtórzony przeze mnie dla każdej ręki pokerowej. Po każdej iteracji wszystkie testy przechodziły. Jeżeli chciałabyś zobaczyć jak to wygląda z większej perspektywy, to zajrzyj <a href="https://github.com/womanonrails/poker/tree/08631288c747a2a9fda3d986f4046e9e363ea027/lib/poker" title="3 klasy stworzone na bazie powyższych kroków" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. W tym miejscu istnieją już 3 klasy stworzone na bazie powyższych kroków.

## Statystyki
- **LOC**  - 85
- **LOT**  - 200
- **Flog** - 65.5
- **Flay** - 0
- **Tests** - 116 examples, 0 failures

# Krok 11 - Usuwanie powieleń

W tym kroku zajęłam się usuwaniem analogii w kodzie. A muszę przyznać, że było tego dość sporo. Za każdym razem przy tworzeniu nowej klasy zmieniałam tylko dwie rzeczy: nazwę klasy i jedną linię w metodzie `check`. By pozbyć się tego powielenia, musiałam wydzielić jakieś zachowanie, może metodę lub nawet klasę, która zajmie się pewnego rodzaju sortowaniem kart i będzie miała wiedzę na temat kolorów i figur. Zdecydowałam, że stworzę normalizację kart. Dzięki temu powstała klasa `CardsNormalization`, która jest pewnego rodzaju reprezentacją dość ogólnej klasy `Normalization`. Możesz zapytać mnie dlaczego stworzyłam 2 klasy, kiedy potrzebuje tylko jedną? No cóż, mam przeczucie, że tworzę mały interfejs, który będzie miał wiele różnych reprezentacji. Na tą chwilę istnieje tylko jedna reprezentacja, ale kto wie, co będzie w przyszłości? Przykładem innej reprezentacji (innej normalizacji) jest gra w kości. Zasady są bardzo podobne, ale normalizacja wprowadzanych danych będzie wyglądać inaczej. Kod tych dwóch nowych klas znajdziesz <a href="https://github.com/womanonrails/poker/tree/a668a538cb86dd17e946157c5d62373fe2266c0e/lib" title="Jedenasty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Kod który był powielony w nowych klasach znalazł się w klasie `Normalization`:

```ruby
class Normalization
  attr_reader :figures, :colors, :figures_frequency
  def initialize(array)
    @array = array.sort
    @figures = prepare_figures
    @colors = prepare_colors
    @figures_frequency = prepare_figures_frequency.values
  end
  private
  def prepare_colors
    @array
  end
  def prepare_figures
    @array
  end
  def prepare_figures_frequency
    @figures.each_with_object(Hash.new(0)) do |item, hash|
      hash[item] += 1
    end
  end
end
```

a tutaj klasa `CardsNormalization`:

```ruby
class CardsNormalization < Normalization
  private
  def prepare_colors
    @array.map { |item| item % 4 }
  end
  def prepare_figures
    @array.map { |item| item / 4 }
  end
end
```

Podczas tego kroku zrobiłam jeszcze jedną rzecz. Wstrzyknęłam normalizację jako argument do inicjalizera klasy `Hand`:

```ruby
def initialize(array, order_checking = ORDER_CHECKING, normalization = CardsNormalization)
```

Po tych wszystkich zmianach moja klasa `OnePair` wygląda następująco:

```ruby
module Poker
  class OnePair
    def initialize(array, normalization = Normalization)
      @normalize_array = normalization.new(array)
    end

    def check
      :one_pair if @normalize_array.figures_frequency.include?(2)
    end
  end
end
```

Tylko jedna metoda wygląda okropnie. To metoda `check`. Posiada ona teraz wiele warunków. Wiem jednak, że jest to stan przejściowy. Zajmę się tą metodą, jak tylko zakończę wyciąganie kolejnych funkcjonalności z klasy `Hand`. Na tą chwilę metoda ta wygląda tak:

```ruby
def check
  @order_checking.each do |name|
    if [:one_pair].include? name
      class_name  = 'Poker::' + name.to_s.split('_').collect(&:capitalize).join
      return name if Object.const_get(class_name).new(@array, @normalization).check == name
    end
    if [:four_of_a_kind, :three_of_a_kind, :one_pair].include? name
      class_name  = 'Poker::' + name.to_s.split('_').collect(&:capitalize).join
      return name if Object.const_get(class_name).new(@array).check == name
    else
      method_name = (name.to_s + '?').to_sym
      return name if send(method_name)
    end
  end
end
```

Następnie, powtórzyłam to samo rozumowanie dla reszty istniejących klas. Użyłam `CardsNormalization` dla `FourOfAKind` i `ThreeOfAKind`. Kod znajdziesz <a href="https://github.com/womanonrails/poker/tree/87891306fe875bd415554a6eb5ebc0b46f893c9d/lib/poker" title="Kod po jedenastym kroku refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

## Statystyki:
- **LOC**  - 87
- **LOT**  - 200
- **Flog** - 82.5
- **Flog total** - 122.4
- **Flay** - 0
- **Tests** - 124 examples, 0 failures

# Krok 12 - Usunięcie kolejnych powtórzeń

Tym razem skupiłam się na innych powtórzeniach w nowych klasach. W kilku miejscach sprawdzam podobny warunek: `@normalize_array.figures_frequency.include?(4)` zmienia się tylko liczba. Jest to dla mnie pewnego rodzaju *zasada*. Sprawdzamy czy w kartach mamy 2, 3, lub 4 te same figury. Zdecydowałam, że stworzę klasę `FrequencyRule` a tak wygląda jej kod:

```ruby
module Rules
  class FrequencyRule
    def initialize(frequency_array, count)
      @frequency_array = frequency_array
      @count = count
    end

    def check?
      @frequency_array.include?(@count)
    end
  end
end
```

następnie dodałam `@rule = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 3)` do inicjalizera i użyłam metody `@rule.check?` zamiast `@normalize_array.figures_frequency.include?(3)`. Tak wygląda klasa `ThreeOfAKind` po tej zmianie:

```ruby
class ThreeOfAKind
  def initialize(array, normalization = Normalization)
    @normalize_array = normalization.new(array)
    @rule = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 3)
  end

  def check
    :three_of_a_kind if @rule.check?
  end
end
```

Cały kod wygląda <a href="https://github.com/womanonrails/poker/tree/d66590842ef194a9218dea70ccd083212b5d43b2/lib" title="Dwunasty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tak</a>. Po tej zmianie i napisaniu nowych testów, wszystkie nowe i stare testy przechodzą.

## Statystyki
- **LOC**  - 87
- **LOT**  - 161
- **Flog** - 82.5
- **Flog total** - 134.9
- **Flay** - 0
- **Tests** - 95 examples, 0 failures

# Krok 13 - Łączenie wielu zasad

Teraz interesująca sprawa. Czas na fula. W tym przypadku potrzebujemy sprawdzić czy mamy 3 i 2 te same figury w tym samym czasie. Tak jak tutaj: 2&#9824; 2&#9827; <span class='red-text'>2&#9829; 3&#9829; 3&#9830;</span>. Musimy więc sprawdzić tą samą zasadę dla dwóch i trzech tych samych figur. To dobry czas by stworzyć klasę, która będzie łączyć wiele różnych zasad. Nazwałam ją `RulesFactory`. Kod wygląda następująco:

```ruby
class RulesFactory
  def initialize(*rules)
    @rules = rules
  end

  def check?
    @rules.each do |rule|
      return false unless rule.check?
    end
    true
  end
end
```

A tak wygląda kod klasy `FullHouse` (karety):

```ruby
module Poker
  class FullHouse
    def initialize(array, normalization = Normalization)
      @normalize_array = normalization.new(array)
      rule1 = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 2)
      rule2 = Rules::FrequencyRule.new(@normalize_array.figures_frequency, 3)
      @rules = RulesFactory.new(rule1, rule2)
    end

    def check
      :full_house if @rules.check?
    end
  end
end
```

Widzisz schemat? Oczywiście, trzeba jeszcze zrobić parę ulepszeń w klasie `Hand`. Dopisać nowe testy i sprawdzić czy przechodzą. Cały kod jest dostępny <a href="https://github.com/womanonrails/poker/tree/d18cf1f273c9fdcb97e21067d3411938beefdf36/lib" title="Trzynasty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

# Krok 14 - Powtarzanie kroków

Nadszedł czas by powtórzyć krok, który już wcześniej opisałam. Tworzymy nowe zasady: `StraightnessRule`, `FlushnessRule` i `RoyalnessRule`. Tworzymy nowe klasy: `Straight`, `Flush` i `RoyalFlush`. Kod po tej zmianie znajduje się <a href="https://github.com/womanonrails/poker/tree/0985c071c87de56c8c49307d6d20963aced7ff79/lib" title="Czternasty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

Chciałabym wspomnieć o jednej magicznej sprawie. Kiedy zaczęłam tworzyć małe klasy z pojedyńczymi odpowiedzialnościami, klasy te stały się w dość proste. Dzięki temu można używać ich w nieoczekiwany sposób. Oto przykład:

```ruby
module Rules
  class FlushnessRule
    def initialize(color_array)
      @color_array = color_array
    end
    def check?
      @color_array.uniq.size == 1
    end
  end
end
```

To co klasa powinna robić:

```ruby
rule = FlushnessRule.new([1,1])
 => #<FlushnessRule:0x00000001eced60 @color_array=[1, 1]>
rule.check?
 => true
```

to co może robić:

```ruby
rule = FlushnessRule.new(['#fff','#fff'])
 => #<FlushnessRule:0x00000001ebc020 @color_array=["#fff", "#fff"]>
rule.check?
 => true
```

Kiedy tworzyłam tą klasę nie przypuszczałam, że będę mogła ją wykorzystać w taki sposób. Nie myślałam, że będzie się ona nadawać do obsługi zarówno tablic jak i ciągów znaków. Wiem, że to poniekąd jest to zasługa samego języka Ruby i jego <a href="https://pl.wikipedia.org/wiki/Duck_typing" title="Duck typing in Ruby" target="_blank" rel="nofollow noopener noreferrer">**duck typing'u**</a> ale myślę, że też prostoty kodu.

## Statystyki:
- **LOC**  - 94
- **LOT**  - 171
- **Flog** - 69.7
- **Flog total** - 191.2
- **Flay** - 0
- **Tests** - 142 examples, 0 failures

# Krok 15 - Zasada dla Niczego

Kiedy grasz w pokera możesz mieć w ręce jedno z punktowanych ustawień figur lub po prostu nic. To "nic" trzeba obsłużyć w kodzie. Stworzyłam więc klasę dla "niczego" - `None`. Dodatkowo zrobiłam też trochę porządków w klasie `Hand`.

```ruby
module Poker
  class None
    def initialize(array, normalization = Normalization)
      @normalize_array = normalization.new(array)
    end

    def check
      :none
    end
  end
end
```

Cały kod związany z tym krokiem znajdziesz <a href="https://github.com/womanonrails/poker/tree/03a356a42afed39fffd98ceff0b7b1311f7b05ec/lib" title="Piętnasty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Jak zawsze wszystkie testy po tym kroku przechodzą.

## Statystyki
- **LOC**  - 55
- **LOT**  - 171
- **Flog** - 56.0
- **Flog total** - 180.8
- **Flay** - 0
- **Tests** - 145 examples, 0 failures

# Krok 16 - MultiFrequencyRule

To będzie nasz ostatni krok. Możesz wierzyć lub nie ale najtrudniejsza do sprawdzenia zasada to dwie pary. Do tej pory stworzyłyśmy zasadę do sprawdzania liczby tych samych figur w ręce - `FrequencyRule`. Ta zasada jednak tu nie zadziała, ponieważ chcemy sprawdzić czy mamy 2 pary. Musimy więc stworzyć inną zasadę, inną logikę. Postanowiłam nazwać ją `MultiFrequencyRule`:

```ruby
module Rules
  class MultiFrequencyRule
    def initialize(frequency_array, count, times = 1)
      @frequency_array = frequency_array
      @count = count
      @times = times
    end

    def check?
      selected_frequency = @frequency_array.reject { |number| number < @count }
      selected_frequency.count >= @times
    end
  end
end
```

Tym razem sprawdzamy tylko wybraną liczbę wystąpień w `@frequency_array`. Ile razy ona pojawia się w tej tablicy. Chwila! Jeżeli mamy taką kombinację kart 2&#9824; 2&#9827; <span class='red-text'>2&#9829; 3&#9829; 3&#9830;</span> mamy w ręce fula ale również dwie pary. Zasada do sprawdzania czy mamy w naszej ręce dwie pary też powinna zwrócić `true`. Dlatego też sprawdzamy warunek: `number < @count` i usuwamy te elementy z tablicy. Kod dla tego kroku znajdziesz <a href="https://github.com/womanonrails/poker/blob/6a3af1c900c88477097ac00d405fef59866eb06b/lib/rules/multi_frequency_rule.rb" title="Kod klasy MultiFrequencyRule" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

**Uwaga!** Jeżeli przyjrzysz się bliżej, to zauważysz, że ten kod ma pewien problem. Przy ustawieniu 2&#9824; 2&#9827; <span class='red-text'>2&#9829; 2&#9830; 3&#9829;</span> też mamy dwie pary. Zmodyfikujmy naszą metodę `check?`:

```ruby
def check?
  selected_frequency = @frequency_array.map { |number| number / @count }
  selected_frequency.sum >= @times
end
```

Nareszcie możemy całkowicie wyczyścić logikę klasy `Hand`. Możemy też zastąpić klasę `FrequencyRule`, klasą `MultiFrequencyRule`, która jest bardziej ogólna. Kod znajdziesz <a href="https://github.com/womanonrails/poker/tree/277d2893ffac1318c2a64fca2704e1c8258856e1/lib" title="Szesnasty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Sprawdźmy jak wygląda teraz nasza klasa `Hand`:

```ruby
module Poker
  ORDER_CHECKING = [
    :royal_flush, :straight_flush, :four_of_a_kind, :full_house, :flush,
    :straight, :three_of_a_kind, :two_pair, :one_pair, :high_card, :none
  ].freeze

  # Poker hand
  class Hand
    def initialize(
      array,
      order_checking = ORDER_CHECKING,
      normalization = CardsNormalization
    )
      @array = array.sort
      @order_checking = order_checking
      @normalization = normalization
    end

    def check
      @order_checking.each do |name|
        return name if class_name(name).check == name
      end
    end

    private

    def class_name(name)
      class_name = 'Poker::' + name.to_s.split('_').collect(&:capitalize).join
      Object.const_get(class_name).new(@array, @normalization)
    end
  end
end
```

Jestem dumna z tej klasy. Jeżeli chciałabyś porównać tą klasę z początkową implementacją zajrzyj <a href="https://github.com/womanonrails/poker/blob/55c9ae0ab921f7aa95bb7e47676d87b970a32033/lib/poker/hand.rb" title="Pierwsza wersja kodu klasy Poker" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

## Statystyki końcowe:
- **LOC**  - 37
- **LOT**  - 173
- **Flog** - 28.0
- **Flog total** - 182.4
- **Flay** - 0
- **Tests** - 145 examples, 0 failures

# Podsumowanie

Podsumuję teraz to co udało nam się osiągnąć:

- Użyłyśmy bardziej opisowych nazw w kodzie.
- Uprościłyśmy kod używając odrobiny meta-programowania.
- Stworzyłyśmy małe obiekty z małą odpowiedzialnością (wiedzą).
- Przygotowałyśmy całe zaplecze klas sprawdzających zasady pokera.

# Co dalej?

Myślisz, że to już koniec refaktoringu? Ja myślę o tym w zupełnie inny sposób. Moim zadaniem refaktoring nigdy się nie kończy. To nie znaczy, że trzeba go robić w nieskończoność. Zawsze będzie coś do zmiany, do ulepszenia. Z czasem mamy więcej informacji o tym jaką logikę kod ma reprezentować. Wiemy dokładnie, co się stanie. Na bazie tej wiedzy możemy podejmować kolejne kroki dotyczące naszej architektury.

Kiedy teraz patrzę na ten kod, zmieniłabym go. Zaczęłabym od powtórzeń, które jeszcze widzę w istniejących klasach. Pewnie zauważyłaś też, że część tych klas jest dość generyczna i wyglądają dość podobnie. W następnym etapie usunęłabym te klasy i stworzyłabym jedną klasę, która pobierałaby nazwę i logikę potrzebnej zasady. Później zrobiłabym porządek w testach. Może wyciągnęłabym konfigurację z klasy `Hand` do jakiegoś osobnego pliku np. `.yml`. A może to konfiguracja mogłaby przygotowywać kod związany z zasadami? Czy to za dużo refaktoringu dla tak małej funkcjonalności? Pewnie tak, jest to tylko przykład co można zrobić w prawdziwym kodzie by ułatwić jego rozumienie.

# Czego się nauczyłam?
- małe, czytelne i proste do testowania klasy wiele ułatwiają
- przy małych klasach, kod staje się bardziej elastyczny (Mogę używać kodu w różny, czasem nieoczekiwany, sposób)
- mniej zależności, w łatwy sposób możemy usuwać i dodawać nowe zasady
- jesteśmy otwarci na rozszerzanie kodu - nie musimy modyfikować istniejącego kodu by dodać nową logikę, wystarczy stworzyć nową klasę i przygotować odpowiednią konfigurację. Możemy też pomyśleć o konwencji, która przygotuje konfigurację za nas. Wtedy wszystko działałoby automatycznie.
- To była czysta zabawa!

# Moje zasady na refaktoring

- po każdym kroku refaktoringu testy muszą przechodzić
- zacznij od detali a później przejdź do bardziej ogólnego spojrzenia
- nie zmieniaj wszystkiego naraz
- kod powinien być napisany tak, by nie potrzebował komentarzy, powinien być samo-komentujący się (są przypadki gdy warto umieścić komentarz w kodzie, ale nieczytelny kod nie powinien być do tego wymówką)
- narzędzia takie jak Rubocop lub Reek są po to, by pomóc; nie wiedzą jednak wszystkiego
- staraj się zapobiegać powtórzeniom w kodzie, jednak pamiętaj, że lepiej zostawić kod powielony niż wyciągnąć złą abstrakcję (sprawdź prezentację Sandi Mezt w bibliografii)
- publiczny interfejs powinien być mały
- zawsze myśl o całym swoim systemie, jak duży wpływ na niego będzie miała Twoja zmiana?
- pamiętaj o zasadach takich jak **SOLID**
- usuwaj powtórzenia w mądry sposób
- myśl ogólnie i zawsze pamiętaj o spojrzeniu całościowym

# Na koniec

Chciałabym wspomnieć jeszcze o jednej rzeczy na koniec. Przy każdym kroku zamieszczałam statystyki (wyniki różnych metryk). Nie wiem czy zwróciłaś na to uwagę ale w trakcie trwania refaktoringu te statystyki były gorsze niż na początku. Nigdy nie rezygnuj z refaktoringu z tego powodu. Jeżeli masz dobrą intuicję i plan gdzie chcesz być na jego końcu, krok po kroku kontynuuj swoją podróż a zobaczysz efekty.

To wszystko. W tym artykule zamieściłam kilka pomysłów na refaktoring. Możesz ich używać całkowicie niezależenie. Kroki mogą być wykonywane w innej kolejności (nie wszystkie, ale część z pewnością). Nie musisz też wykorzystywać ich wszystkich. Jeżeli podobał Ci się ten artykuł, podziel się swoimi przemyśleniami poniżej w komentarzach. Do zobaczenia następnym razem!

<hr>

### Bibliografia

#### Książki
- <a href="https://helion.pl/view/10301k/refukv.htm#format/d" title="Refaktoryzacja. Ulepszanie struktury istniejącego kodu" target="_blank" rel="nofollow noopener noreferrer">Refaktoryzacja. Ulepszanie struktury istniejącego kodu - Martin Fowler</a>
- <a href="https://helion.pl/view/10301k/czykov.htm#format/d" title="Czysty kod. Podręcznik dobrego programisty" target="_blank" rel="nofollow noopener noreferrer">Czysty kod. Podręcznik dobrego programisty - Robert C. Martin</a>
- <a href="https://helion.pl/view/10301k/rubywz.htm#format/d" title="Ruby. Wzorce projektowe" target="_blank" rel="nofollow noopener noreferrer">Ruby. Wzorce projektowe - Russ Olsen</a>
- <a href="https://helion.pl/view/10301k/tddszt.htm#format/d" title="TDD. Sztuka tworzenia dobrego kodu" target="_blank" rel="nofollow noopener noreferrer">TDD. Sztuka tworzenia dobrego kodu - Ken Beck</a>
- <a href="https://helion.pl/view/10301k/pragpv.htm#format/d" title="Pragmatyczny programista. Od czeladnika do mistrza" target="_blank" rel="nofollow noopener noreferrer">Pragmatyczny programista. Od czeladnika do mistrza - Andrew Hund, David Thomas</a>
- <a href="https://www.amazon.com/Practical-Object-Oriented-Design-Ruby-Addison-Wesley/dp/0321721330" title="Practical Object-Oriented Design in Ruby: An Agile Primer" target="_blank" rel="nofollow noopener noreferrer">Practical Object-Oriented Design in Ruby: An Agile Primer - Sandi Metz [EN]</a>

#### Prezentacje angielskojęzyczne
- <a href="https://www.youtube.com/watch?v=8bZh5LMaSmE" title="All the Little Things by Sandi Metz" target="_blank" rel="nofollow noopener noreferrer">All the Little Things by Sandi Metz</a>
- <a href="https://www.youtube.com/watch?v=5yX6ADjyqyE" title="Fat Models with Patterns by Bryan Helmkamp" target="_blank" rel="nofollow noopener noreferrer">LA Ruby Conference 2013 Refactoring Fat Models with Patterns by Bryan Helmkamp</a>
- <a href="https://www.youtube.com/watch?v=OMPfEXIlTVE" title="Nothing is something by Sandi Metz" target="_blank" rel="nofollow noopener noreferrer">Nothing is something by Sandi Metz</a>
- <a href="https://infinum.co/the-capsized-eight/best-ruby-on-rails-refactoring-talks" title="8 best Ruby on Rails refactoring talks" target="_blank" rel="nofollow noopener noreferrer">Best Ruby on Rails refactoring talks</a>





