---
layout: post
title: Ruby Refactoring – część 1
description: Sumowanie elementów tablicy względem kolumny - Refactoring
headline: My code is getting worse, please send more chocolate
categories: [ruby, refactoring]
tags: [ruby, refactoring]
comments: true
---

Tym razem będę zmieniać kody Ruby. Mój mały potwór wygląda następująco:

```ruby
def sum_by_column(data)
  sum_array =  data.group_by do |column|
    [column[0], column[2]]
  end.values.map { |item| item.transpose[1].inject(:+) }
  data.group_by do |column|
    [column[0], column[2]]
  end.keys.zip(sum_array).map { |first, last| [first[0], last, first[1]] }
end
```

Jeżeli na pierwszy rzut oka wiecie co ten kod robi, macie moje wyrazy szacunku. Ja osobiście stwierdzam, że ten kod jest straszny i muszę coś z nim zrobić. Dobrze, zacznijmy od początku. Metoda ta pobiera dane w postaci tablicy tablic liczby naturalnych np. `[[1, 2, 3], [4, 5, 6]]` . Następnie grupuje je względem pierwszej i ostatniej kolumny i sumuje po środkowej. Gdy macie dane jak te:

```ruby
data = [
  [1, 3, 1],
  [1, 1, 1],
  [1, 1, 2],
  [1, 1, 2],
  [2, 2, 1]
]
```

to metoda zwraca:

```ruby
result = [
  [1, 4, 1],
  [1, 2, 2],
  [2, 2, 1]
]
```

Zacznijmy zmiany. Metoda ta zwraca tablicę podobną do result. Zadeklarujmy więc tablicę na początku. Później pogrupujmy nasze dane po pierwszej i ostatniej kolumnie. Na koniec w pętli zsumujmy kolumnę środkową i zwróćmy dane w tablicy. Teraz metoda ta wygląda tak:

```ruby
def sum_by_column(data)
  array = []
  grouped_data = data.group_by { |column| [column[0], column[2]] }
  grouped_data.each do |key, value|
    sum = value.transpose[1].inject(:+)
    array << [key.first, sum, key.last]
  end
  array
end
```

Po tych zmianach doszłam do wniosku, że kolejność kolumn w danych wejściowych i wyjściowych nie ma dla mnie znaczenia. Oto jak wyglądają obecnie:

```ruby
data = [
  [1, 1, 3],
  [1, 1, 1],
  [1, 2, 1],
  [1, 2, 1],
  [2, 1, 2]
]

result = [
  [1, 1, 4],
  [1, 2, 2],
  [2, 1, 2]
]
```

Metoda zmieniła się tylko odrobinę:

```ruby
def sum_by_column(data)
  array = []
  grouped_data = data.group_by { |column| column[0..1] }
  grouped_data.each do |key, value|
    array << (key << value.transpose[2].inject(:+))
  end
  array
end
```

Teraz kod ten wygląda lepiej, ale czy da się jeszcze coś ulepszyć? Zobaczmy… może zamienimy each na map:

```ruby
def sum_by_column(data)
  grouped_data = data.group_by { |column| column[0..1] }
  grouped_data.map { |key, value| [*key, value.transpose[2].inject(:+)] }
end
```

Super! Teraz wygląda o wiele lepiej. To rozwiązanie jest dla mnie do przyjęcia ;p Jeżeli macie jeszcze jakieś propozycje jak można by zmienić tą metodę to zapiszcie je w komentarzach.
