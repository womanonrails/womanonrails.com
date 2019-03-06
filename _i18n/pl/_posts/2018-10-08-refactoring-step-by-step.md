---
layout: post
title: Refaktoring w Ruby krok po kroku - część 1
description: Jak zrobić refaktoring? <br> Od kodu proceduralnego do zorientowanego obiektowo.
headline: Premature optimization is the root of all evil.
categories: [refaktoring]
tags: [Ruby]
comments: true
---

Dużo czasu minęło od mojego ostatniego artykułu technicznego. Przez ten czas próbowałam wielu nowych rzeczy. Założyłam blog <a href="https://bemore.womanonrails.com/" title="Be More - moje przemyślenia na temat życia" target="_blank">Be more</a>, który dotyczy moich przemyśleń na temat życia, <a href="https://www.youtube.com/channel/UCudKRFuddrf8saaxUEoo0xQ" title="Woman on Rails - kanał YouTube" target="_blank" rel="nofollow noopener noreferrer">Kanał Woman on Rails na YouTube</a> i <a href="https://vimeo.com/womanonrails" title="Woman on Rails - kanał Vimeo" target="_blank" rel="nonofollow noopener noreferrer">podróżniczy kanał na Vimeo</a>. To był czas odkrywania, co sprawia mi przyjemność a co nie. Ale wracając do tematu. Do tego artykułu przygotowywałam się naprawdę długo. Może nawet za długo. Pomysł pojawił się już 2015 roku, a teraz możesz zobaczyć jego rezultaty. Zaczynajmy!

Refaktoring jest jednym z moich ulubionych tematów. Uwielbiam porządki w prawdziwym życiu, ale też w kodzie źródłowym. Pracowałam i nadal pracuję nad aplikacjami internetowymi. I wciąż poszukuje odpowiedzi na następujące pytania: Jak pisać dobry kod? Co powoduje, że po pewnym czasie nasz kod staje się brzydki i nieczytelny? Jak radzić sobie z rosnącą złożonością w projektach? Każdego dnia uczę się jak robić dobry refaktoring. Bazuję na zdobytym przeze mnie, jak i przez innych, doświadczeniu. Dziś chciałabym się podzielić z Tobą przykładem refaktoringu zrobionego krok po kroku.

Do tego celu wykorzystam kod, który został napisany dawno temu przez młodego programistę w <a href="https://fractalsoft.org/pl" title="Fractal Soft - Aplikacje internetowe w Ruby on Rails" target="_blank">mojej firmie</a>. Plan był następujący - ulepszyć ten kod źródłowy. W zasadzie cała logika to jedna klasa, którą możesz zobaczyć <a href="https://github.com/womanonrails/poker/blob/55c9ae0ab921f7aa95bb7e47676d87b970a32033/lib/poker/hand.rb" title="Kod przed refaktoringiem" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. W tej klasie znajdują się wszystkie zasady potrzebne do sprawdzenia tego, co mamy w ręce grając w pokera, ale bez użycia jokera. Kod nie jest zły. Kiedy znasz logikę biznesową (w tym przypadku zasady pokera), jesteś wstanie poruszać się po tym kodzie. Ten fragment kodu posiada też testy, co jest jego zaletą. Będzie nam o wiele łatwiej zmienić cokolwiek, gdy mamy testy pilnujące logiki. Jeżeli jednak nie cała logika jest przetestowana, to możemy zepsuć fragment funkcjonalności nie zdając sobie nawet z tego sprawy. Kod ten wygląda bardziej proceduralnie niż obiektowo i będę chciała się tym zająć w odpowiednim czasie. Posiada on też wiele powtórzeń. Czasami taki fragment kodu jest w zupełności wystarczający. Wszystko zależy od projektu i wymagań. Jeżeli kod został napisany raz, działa poprawnie i nikt do niego nie będzie musiał zaglądać, to może zostawienie go w takim stanie jest w jakiś sposób uzasadnione z biznesowego punktu widzenia. Natomiast jeżeli zdarzy się, że zmienią się wymagania, to prawdopodobnie kod źródłowy też ulegnie zmianie. To Ty musisz zdecydować, czy będziesz refaktoryzowała kod teraz czy później. Ja preferuje pierwszą opcję. Dopóki pamiętam logikę i zależności łatwiej jest mi kod zmienić. Po pewnym czasie trzeba najpierw jeszcze raz zrozumieć strukturę, zanim zacznie się coś modyfikować. No to zaczynamy!

# Krok 1 - Przygotowanie środowiska

Zaczęłam od zaktualizowania wszystkich gemów w projekcie oraz doinstalowania narzędzi takich jak Rubocop czy Reek. Są to **metryki czyli pewnego rodzaju wskaźniki jakości kodu**. Pomogą nam sprawdzić na czym stoimy i gdzie można zacząć robić porządki. Trzeba jednak pamiętać, że są to tylko narzędzia. A narzędzia mogą się mylić i można je łatwo oszukać. Ale to temat na osobny artykuł.

## Statystyki (bazując na metrykach):
- **LOC** (Line of code - liczba linii kodu) - 194
- **LOT** (Line of tests - liczba linii testów) - 168
- **Flog** - 112.8
- **Flay** - 123
- **Testy** - 12 examples, 0 failures (12 przypadków testowych, 0 nieprzechodzących)

# Krok 2 - Pierwsze porządki

Bazując na testach i metrykach, nie wchodząc w głębsze zrozumienie logiki, zrobiłam pierwsze usprawnienia. Usunęłam niektóre warunki i uprościłam kod.

Kod przed zmianami:

```ruby
def straight_flush?(array)
  if straight?(array) and flush?(array)
    return true
  else
    return false
  end
end
```

Kod po zmianach:

```ruby
def straight_flush?(array)
  straight?(array) && flush?(array)
end
```

Cały kod możesz znaleźć <a href="https://github.com/womanonrails/poker/blob/148429e4591638aef38b5b7abaab5e0198d805c0/lib/poker/hand.rb" title="Drugi krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Te zmiany moim zdaniem poprawiły odrobinę czytelność kodu.

Po tym kroku, wszystkie testy przechodziły.

# Krok 3 - Zrozumienie logiki i dalsze uproszczenia

Teraz gdy kod jest dla mnie bardziej przejrzysty, mogę przejść do właściwej zmiany logiki. Mam testy, więc każda zmiana będzie się na nich opierała. Cel polegała na ich spełnieniu, czyli sprawieniu, że testy przechodza. Wzięłam pierwszą metodę i usunęłam całe jej wnętrze. Oto co dostałam:

Kod przed zmianą:

```ruby
def one_pair?(array)
  tmp = array.clone
  tmp.collect!{|x| x / 4 }

#  (0..8).each do |elem|
#    tmp.delete(elem)
#  end

  helper_array = [0] * 13

  tmp.each do |elem|
    helper_array[elem] += 1
  end

  helper_array.delete(0)

  helper_array.include?(2)
end
```

Kod po zmianie:

```ruby
def one_pair?(array)
  hash = Hash.new(0)
  array.each { |item| hash[item / 4] += 1 }
  hash.values.include?(2)
end
```

Dla każdej metody w tej klasie powtarzałam następujące kroki:

1. Brałam metodę i usuwałam jej zawartość
2. Uruchamiałam testy (niektóre z nich przestały przechodzić) i na ich podstawie starałam się zrozumieć logikę
3. Pisałam nowy kod w prostszy sposób
4. Sprawdzałam czy wszystkie testy przechodzą

Kod po moich zmianach możesz znaleźć <a href="https://github.com/womanonrails/poker/blob/a0bb2f6ab99bf8d977c1b68a53774b2eef7a46ac/lib/poker/hand.rb" title="Trzeci krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Podczas tego kroku usunęłam również zakomentowany kod, komentarze po polsku i dodałam kilka testów jednostkowych, których moim zdaniem brakowało.

## Statystyki:
- **LOC** - 73
- **LOT** - 170
- **Flog** - 76.3
- **Flay** - 63
- **Testy** - 12 examples, 0 failures

# Krok 4 - Od kodu proceduralnego do obiektowego

Nie wiem czy to zauważyłaś, ale do każdej metody przekazujemy argument `array`. Kod jest zamknięty w klasę, ale nie używamy tam inicjalizera (metody inicjującej instancję klasy). Poza tym mamy wiele miejsc, gdzie używamy `array.each {|item| hash [item / 4] += 1}`. Zacznijmy od przeniesienia tego fragmentu do inicjalizera i użyjmy stanu obiektu do przechowania tej wartości, zamiast wyliczać ją wielokrotnie.

#### Szybkie wyjaśnienie:
Myślę, że to dobry moment aby wytłumaczyć choć odrobinę, jak ten kod działa. Każdą kartę z talii reprezentuje jedna liczba od 0 do 51. Tak więc liczby od 0-3 reprezentują dwójki we wszystkich kolorach, liczby 4-7 reprezentują trójki itd. Całość tej zależności przedstawiona jest w tabeli poniżej:

<table class='table refactoring-step-by-step'>
  <tbody>
    <tr>
      <td>0 </td> <td>2&spades;</td>
      <td>4 </td> <td>3&spades;</td>
      <td>8 </td> <td>4&spades;</td>
      <td>12</td> <td>5&spades;</td>
      <td>16</td> <td>6&spades;</td>
      <td>20</td> <td>7&spades;</td>
      <td>24</td> <td>8&spades;</td>
    </tr>
    <tr>
      <td>1 </td> <td>2&clubs;</td>
      <td>5 </td> <td>3&clubs;</td>
      <td>9 </td> <td>4&clubs;</td>
      <td>13</td> <td>5&clubs;</td>
      <td>17</td> <td>6&clubs;</td>
      <td>21</td> <td>7&clubs;</td>
      <td>25</td> <td>8&clubs;</td>
    </tr>
    <tr class='red-text'>
      <td>2 </td> <td class='red'>2&hearts;</td>
      <td>6 </td> <td class='red'>3&hearts;</td>
      <td>10</td> <td class='red'>4&hearts;</td>
      <td>14</td> <td class='red'>5&hearts;</td>
      <td>18</td> <td class='red'>6&hearts;</td>
      <td>22</td> <td class='red'>7&hearts;</td>
      <td>26</td> <td class='red'>8&hearts;</td>
    </tr>
    <tr class='red-text'>
      <td>3 </td> <td class='red'>2&diams;</td>
      <td>7 </td> <td class='red'>3&diams;</td>
      <td>11</td> <td class='red'>4&diams;</td>
      <td>15</td> <td class='red'>5&diams;</td>
      <td>19</td> <td class='red'>6&diams;</td>
      <td>23</td> <td class='red'>7&diams;</td>
      <td>27</td> <td class='red'>8&diams;</td>
    </tr>
  </tbody>
</table>

<br>

<table class='table refactoring-step-by-step'>
  <tbody>
    <tr>
      <td>28</td> <td>9&spades;</td>
      <td>32</td> <td>10&spades;</td>
      <td>36</td> <td>J&spades;</td>
      <td>40</td> <td>D&spades;</td>
      <td>44</td> <td>K&spades;</td>
      <td>48</td> <td>A&spades;</td>
    </tr>
    <tr>
      <td>29</td> <td>9&clubs;</td>
      <td>33</td> <td>10&clubs;</td>
      <td>37</td> <td>J&clubs;</td>
      <td>41</td> <td>D&clubs;</td>
      <td>45</td> <td>K&clubs;</td>
      <td>49</td> <td>A&clubs;</td>
    </tr>
    <tr class='red-text'>
      <td>30</td> <td class='red'>9&hearts;</td>
      <td>34</td> <td class='red'>10&hearts;</td>
      <td>38</td> <td class='red'>J&hearts;</td>
      <td>42</td> <td class='red'>D&hearts;</td>
      <td>46</td> <td class='red'>K&hearts;</td>
      <td>50</td> <td class='red'>A&hearts;</td>
    </tr>
    <tr class='red-text'>
      <td>31</td> <td class='red'>9&diams;</td>
      <td>35</td> <td class='red'>10&diams;</td>
      <td>39</td> <td class='red'>J&diams;</td>
      <td>43</td> <td class='red'>D&diams;</td>
      <td>47</td> <td class='red'>K&diams;</td>
      <td>52</td> <td class='red'>A&diams;</td>
    </tr>
  </tbody>
</table>

Jeżeli mamy kod `array.map {|item| item / 4}` to tak naprawdę sprawdzamy jaką figurę od 2 do Asa reprezentuje liczba. Natomiast jeżeli mamy `array.map {|item| item % 4}` sprawdzamy jakiego koloru jest dana karta (&spades;, &clubs;, &hearts;, &diams;).

Gdybyś potrzebowała dokładniejszego wytłumaczenia zasad pokera, to sprawdź <a href="https://en.wikipedia.org/wiki/List_of_poker_hands" title="Pokerowe ustawienia ręki" target="_blank" rel="nofollow noopener noreferrer">listę wszystkich pokerowych ustawień ręki na Wikipedii</a>.

Dodajemy inicjalizer:

```ruby
def initialize(array)
  @array = array.sort
  @cards = @array.map { |item| item / 4 }
end
```

Przykład metody przed zmianą:

```ruby
def three_of_a_kind?(array)
  hash = Hash.new(0)
  array.each { |item| hash[item / 4] += 1 }
  hash.values.include?(3)
end
```

Po zmianie:

```ruby
def three_of_a_kind?
  hash = Hash.new(0)
  @cards.each { |item| hash[item] += 1 }
  hash.values.include?(3)
end
```

Usunęłam tutaj powtarzające się fragmenty kodu, używając stanu trzymanego w instancji klasy. Kod po tym kroku możesz znaleźć <a href="https://github.com/womanonrails/poker/blob/83d230e969df4d27ffa5e5e34a2cf1aa43e76d90/lib/poker/hand.rb" title="Czwarty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. Mała uwaga - dodatkowo zrobiłam refaktoring w testach. Postanowiłam przenieść wszystkie możliwe przypadki testowe do tablicy by uniknąć powtórzeń, jakie były widoczne również w testach.

## Statystyki:
- **LOC** - 76
- **LOT** - 190
- **Flog** - 70.9
- **Flay** - 57
- **Testy** - 104 examples, 0 failures

# Krok 5 - Usuwanie powtórzeń (duplikacji)

Bazując na metryce Reek zauważyłam dużo powtórzeń w kodzie. Zdecydowałam, że jeszcze raz wykorzystam stan obiektu, by się ich pozbyć. Wszystkie zmiany związane z tym krokiem możesz znaleźć <a href="https://github.com/womanonrails/poker/blob/74c05d7480e7857d1e99d604169f6eed46279758/lib/poker/hand.rb" title="Piąty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>. A poniżej zamieszczam skrót tego co zrobiłam:

Zmiana w inicjalizerze:

```ruby
def initialize(array)
  @array = array.sort
  @cards = @array.map { |item| item / 4 }
  @frequency = cards_frequency
end
```

Dodanie nowej metody `cards_frequency`:

```ruby
def cards_frequency
  hash = Hash.new(0)
  @cards.each { |item| hash[item] += 1 }
  hash.values
end
```

Przykład jednej metody przed zmianą:

```ruby
def four_of_a_kind?
  hash = Hash.new(0)
  @cards.each { |item| hash[item] += 1 }
  hash.values.include?(4)
end
```

Po zmianie:

```ruby
def four_of_a_kind?
  @frequency.include?(4)
end
```

## Statystyki:
- **LOC** - 76
- **LOT** - 190
- **Flog** - 61.0
- **Flay** - 0
- **Testy** - 104 examples, 0 failures

# Krok 6 - Mały publiczny interface

Kiedy spojrzysz na kod z <a href="https://github.com/womanonrails/poker/blob/74c05d7480e7857d1e99d604169f6eed46279758/lib/poker/hand.rb" title="Piąty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">kroku 5</a>, to na pewno zauważysz, że mamy bardzo dużo metod dostępnych publicznie do wykorzystania na obiekcie naszej klasy. **Duży publiczny interface jest ciężki w utrzymaniu.** Jeżeli chciałybyśmy zastąpić naszą klasę `Hand` inną klasą, to będziemy potrzebować dokładnie tyle samo metod publicznych, jak w przypadku klasy `Hand`. Dodatkowo każda publicznie dostępna metoda może zostać wykorzystana przez inny fragment kodu, co może powodować niepotrzebne zależności między obiektami. W naszym przypadku, jak przyjrzymy się bliżej okaże się, że nawet testy nie sprawdzają wszystkich dostępnych metod. Zajmują się tylko sprawdzeniem metody `check`. Zdecydowałam więc, że jedyną publicznie dostępną metodą będzie metoda `check`. Pozostałe metody będą pomocniczymi metodami prywatnymi. Zmiany możesz zobaczyć <a href="https://github.com/womanonrails/poker/blob/ef117a56e3cc0fbfae9de4821ac61e5489f704fc/lib/poker/hand.rb" title="Szósty krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

## Statystyki:
- **LOC** - 77
- **LOT** - 190
- **Flog** - 59.9
- **Flay** - 0
- **Testy** - 104 examples, 0 failures

# Krok 7 - Jeszcze więcej porządków

Ten krok jest podobny do kroku 5. Usuwam dodatkowe powtórzenia w kodzie i zmieniam nazwy na bardziej opisowe, by ułatwić późniejsze czytanie kodu. Stworzyłam nową metodę `cards_figures_and_colors`, która przygotuje dwie rzeczy: `figures` czyli figury i `colors` czyli kolory kart. Możesz teraz powiedzieć: _a gdzie jest zasada **pojedynczej odpowiedzialności**_ lub _**to jest mikro optymalizacja**_, ponieważ zamiast dwóch pętli masz tylko jedną. Moja intuicja podpowiada mi że to, co zrobiłam jest ok. Ale Ty możesz mieć inne zdanie i to też jest ok. Szanuję je. Oto jak wygląda ta metoda:

```ruby
def cards_figures_and_colors
  @array.map { |item| [item / 4, item % 4] }.transpose
end
```

Jestem otwarta na dyskusję, czy moje podejście jest dobre czy nie. Ta zmiana pociąga za sobą także zmiany w metodzie `initialize`:

```ruby
def initialize(array)
  @array = array.sort
  @figures, @colors = cards_figures_and_colors
  @frequency = cards_frequency.values
end
```

W tym kroku postanowiłam zmienić również metodę `cards_frequency`. Zamiast używać `each` używam `each_with_object`. Jeżeli jesteś zainteresowana większą ilością informacji na temat `each_with_object` zachęcam Cię do przeczytania mojego artykułu o <a href="https://womanonrails.com/pl/each-with-object" title="Zastosowanie metody each_with_object w języku Ruby">użyciu metody each\_with\_object w Ruby</a>. Oto jak teraz wygląda kod:

```ruby
def cards_frequency
  @figures.each_with_object(Hash.new(0)) do |item, hash|
    hash[item] += 1
  end
end
```

Dzięki zmiennej `@colors` mogę zmienić metodę `flush?` z:

```ruby
def flush?
  color = @array.map { |item| item % 4 }
  color.uniq.size == 1
end
```

na:

```ruby
def flush?
  @colors.uniq.size == 1
end
```

Wszystkie zmiany możesz zobaczyć <a href="https://github.com/womanonrails/poker/blob/46e12428d0d67cb90d17f417147dc936815a69e7/lib/poker/hand.rb" title="Siódmy krok refaktoringu" target="_blank" rel="nofollow noopener noreferrer">tutaj</a>.

## Statystyki:
- **LOC** - 80
- **LOT** - 190
- **Flog** - 64.5
- **Flay** - 0
- **Testy** - 104 examples, 0 failures

# Podsumowanie

Podsumujmy co do tej pory udało nam się osiągnąć:

- Użyłyśmy metryk do pierwszych, wstępnych porządków
- Uprościłyśmy kod bazując na testach i zrozumieniu logiki
- Zmieniłyśmy kod proceduralny na obiektowy
- Usunęłyśmy powtórzenia w kodzie
- i stworzyłyśmy mały publiczny interface

W następnym artykule chciałabym wejść jeszcze głębiej w temat tego refaktoringu i skupić się na:

- Bardziej opisowym kodzie
- Meta-programowaniu jako sposobie na pisanie elastycznego kodu
- Przygotowaniu małych niezależnych klas, zamiast jednej dużej klasy
- Budowaniu klas jako elementów wymiennych i takich, które można ze sobą łączyć
- Wyjaśnieniu po co podawałam metryki na każdym kroku i co one nam wlaściwie mówią

Trzymaj się! Mój następny artykuł pojawi się już wkrótce! Jeżeli masz jakieś pytania lub przemyślenia, to podziel się nimi w komentarzach. Do zobaczenia następnym razem. Cześć!

<hr>

### Bibliografia

#### Książki
- <a href="https://helion.pl/view/10301k/refukv.htm#format/d" title="Refaktoryzacja. Ulepszanie struktury istniejącego kodu" target="_blank" rel="nofollow noopener noreferrer">Refaktoryzacja. Ulepszanie struktury istniejącego kodu - Martin Fowler</a>
- <a href="https://helion.pl/view/10301k/czykov.htm#format/d" title="Czysty kod. Podręcznik dobrego programisty" target="_blank" rel="nofollow noopener noreferrer">Czysty kod. Podręcznik dobrego programisty - Robert C. Martin</a>
- <a href="https://helion.pl/view/10301k/rubywz.htm#format/d" title="Ruby. Wzorce projektowe" target="_blank" rel="nofollow noopener noreferrer">Ruby. Wzorce projektowe - Russ Olsen</a>
- <a href="https://helion.pl/view/10301k/tddszt.htm#format/d" title="TDD. Sztuka tworzenia dobrego kodu" target="_blank" rel="nofollow noopener noreferrer">TDD. Sztuka tworzenia dobrego kodu - Ken Beck</a>
- <a href="https://helion.pl/view/10301k/pragpv.htm#format/d" title="Pragmatyczny programista. Od czeladnika do mistrza" target="_blank" rel="nofollow noopener noreferrer">Pragmatyczny programista. Od czeladnika do mistrza - Andrew Hund, David Thomas</a>
- <a href="https://www.amazon.com/Practical-Object-Oriented-Design-Ruby-Addison-Wesley/dp/0321721330" title="Practical Object-Oriented Design in Ruby: An Agile Primer" target="_blank" rel="nofollow noopener noreferrer">Practical Object-Oriented Design in Ruby: An Agile Primer - Sandi Metz [EN]</a>

#### Prezentacje angielsko języczne
- <a href="https://www.youtube.com/watch?v=8bZh5LMaSmE" title="All the Little Things by Sandi Metz" target="_blank" rel="nofollow noopener noreferrer">All the Little Things by Sandi Metz</a>
- <a href="https://www.youtube.com/watch?v=5yX6ADjyqyE" title="Fat Models with Patterns by Bryan Helmkamp" target="_blank" rel="nofollow noopener noreferrer">LA Ruby Conference 2013 Refactoring Fat Models with Patterns by Bryan Helmkamp</a>
- <a href="https://www.youtube.com/watch?v=OMPfEXIlTVE" title="Nothing is something by Sandi Metz" target="_blank" rel="nofollow noopener noreferrer">Nothing is something by Sandi Metz</a>
- <a href="https://infinum.co/the-capsized-eight/best-ruby-on-rails-refactoring-talks" title="8 best Ruby on Rails refactoring talks" target="_blank" rel="nofollow noopener noreferrer">Best Ruby on Rails refactoring talks</a>
