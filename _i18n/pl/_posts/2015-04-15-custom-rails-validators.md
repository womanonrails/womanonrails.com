---
layout: post
title: Własne walidatory w Ruby on Rails
description: Jak napisać własny walidator?
headline: My code is getting worse, please send more chocolate
categories: [Ruby, Ruby on Rails]
tags: [Ruby, Ruby on Rails, validators]
comments: true
---

Przez kilka ostatnich dni pracowałam z walidatorami w Railsach. Ale zanim opowiem o tym, co zrobiłam kilka słów na temat tego czym są walidatory. Kiedy chcemy sprawdzić czy dane, które otrzymuje nasza aplikacja spełniają pewne założenia, wtedy używamy walidatorów. Przykładowo gdy chcemy sprawdzić:

- czy dane mają odpowiedni format,
- czy liczba jest parzysta,
- lub po prostu czy nazwa jest wymagana

dla wszystkich tych przypadków korzystamy właśnie z walidatorów.

Railsy mają wbudowane wiele walidatorów. Jeżeli jesteście zainteresowani poznaniem ich to zajrzyjcie do [dokumentacji](https://guides.rubyonrails.org/active_record_validations.html#validation-helpers). Czasem jednak to nie wystarcza, potrzeba czegoś więcej. W moim przypadku chciałam sprawdzić, czy konkretne pole tekstowe nie zawiera słów będących na czarnej liście. Wiem, że istnieje [wbudowany walidator](https://guides.rubyonrails.org/active_record_validations.html#exclusion), który mógłby mi pomóc, ale zależało mi na czymś więcej:

1. Moja czarna lista słów była dość długa.
2. Nie chciałam tych wszystkich słów umieszczać w pliku Ruby.
3. Chciałam mieć łatwy dostęp do rozszerzania mojej listy, bez modyfikacji kodu aplikacji.

## Zdecydowałam, więc że stworze swój własny walidator.

Zajrzałam do dokumentacji i znalazłam [to](https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations). Wybrałam `ActiveModel::EachValidator`, gdzie mam dostęp do całego weryfikowanego rekordu, nazwy atrybutu, który podlega walidacji i wartości tego atrybutu. To było wszystko czego potrzebowałam. Jedyne, co trzeba było zrobić, to napisać jedną metodę: `validate_each`. Całość wyglądała następująco:

```ruby
# app/validators/blacklist_validator.rb

# Validate list of words that can not be use in specifig field
class BlacklistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :on_blacklist) if blacklist.include? value
  end

  private

  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist.txt')).map(&:strip)
  end
end
```

## Jak to działa?

Dodaje błąd `:on_blacklist` do record tylko wtedy gdy value znajduje się na czarnej liście. Plik z czarną listą słów nazwałam `blacklist.txt` i umieściłam w Railsowym katalogu `config`. By teraz móc używać tego walidatora wystarczy dodać do naszego modelu:

```ruby
validates :name, blacklist: true
```

## Zapamiętajcie konwencje:

Kiedy Wasz walidator nazywa się `BlacklistValidator` to w modelu używacie parametru do walidacji w następujący sposób: `blacklist: true`.

To rozwiązanie było dla mnie idealne. Ale co jeżeli chcielibyśmy przekazać do walidatora jakiś dodatkowy parametr. Przykładowo:

```ruby
validates :age, numericality: { greater_than: 18 }
```

To żaden problem. We własnych walidatorach mamy dostęp do zmiennej `options`, która mówi nam dokładnie jakie parametry zostały przekazane. Jeżeli wywołamy options dla naszego przykładu zobaczymy następujący wynik:

```ruby
 => { greater_than: 18 }
```

Użyłam tej funkcjonalności, by sprawdzić za pomocą walidatora minimalną długość tablicy:

```ruby
# app/validators/array_lenght_validator.rb

# Validate if array is not too short
class ArrayLenghtValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless options.key?(:minimum)
    array_size = (value.try(:size) || 0)
    minimum = options[:minimum]
    return if array_size >= minimum
    record.errors.add(attribute, :too_short_array, count: minimum)
  end
end
```

### Co się tutaj dzieje?

Na początku sprawdzam, czy w ogóle parametr `:minimum` został ustawiony. Liczę ilość elementów w tablicy i sprawdzam czy `array_size` jest mniejsze od `minimum`. Jeżeli tak jest dodaje do rekordu błąd `:too_short_array`.

Walidator mogę wywołać następująco:

```ruby
validates :array, array_lenght: { minimum: 1 }
```

Została jeszcze jedna kwestia do omówienia. **W jaki sposób dodać tłumaczenia błędów w katalogu `locales`?**

Używamy konwencji w Rails. Poniżej przedstawiam jeden ze sposobów (inne możliwości dostępne w dokumentacji [https://guides.rubyonrails.org/i18n.html#error-message-scopes](https://guides.rubyonrails.org/i18n.html#error-message-scopes)):

```
pl:
  activerecord:
    errors:
      models:
        our_model_name:
          attributes:
            name:
              on_blacklist: jest na czarnej liście
            array:
              too_short_array:
                one: jest za krótka (minimalnie 1 element)
                other: jest za krótka (minimalnie %{count} elementów)
```

W klucz `our_model_name:` wpisujemy nazwę naszego modelu. Na przykład jeżeli mamy model `User`, to kluczem będzie `user:`. Następnie ustawiamy nazwy naszych walidowanych pól:

- `name:` pole dla którego używamy walidatora czarnej listy,
- `array:` pole dla którego używamy walidatora długości tablicy.

Dalej ustawiamy nazwy naszych błędów: `on_blacklist:` i `too_short_array:`. Dla `on_blacklist:` to już wszystko. Jeżeli chodzi o `too_short_array:` dodatkowo podawaliśmy parametr `count`. Rails Internalization rozpoznaje czy `count` jest w liczbie pojedynczej czy mnogiej i serwuje `one:` lub `other:` z tłumaczeń. Ostatnia rzecz: W kluczu `other:` wstawiliśmy parametr `count` za pomocą `%{}`. Wtedy Railsy wiedzą gdzie mają wstawić wartość parametru `count`.

To już wszystko. Mam nadzieję, że będzie to dla Was przydatne.
Jeżeli macie jakieś pytania lub sugestie, proszę zostawcie komentarze.
Do następnego razu!
