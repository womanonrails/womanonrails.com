---
excerpt: >
 Alek Od czasu do czasu programując w języku Ruby,
 a nawet częściej używając frameworka Ruby on Rails,
 potrzebuję stworzyć plik konfiguracyjny zawierający na przykład prywatne klucze do API.
 Oczywiście nie chcę tych danych śledzić w
 [systemie kontroli wersji](/pl/what-is-git "Wstęp do rozproszonego systemu kontroli wersji Git").
 Natomiast na dodanie ich do bazy danych jest jeszcze za wcześnie.
 W takiej sytuacji mogą pomóc zmienne środowiskowe zapisane w pliku `.env`.
 W tym przypadku jest jeszcze jeden mały haczyk.
 Chciałam by wszystkie dane były ustrukturyzowane w jednym pliku.
 Dlatego też użyłam kombinacji pliku YAML
 (akronim rekurencyjny od ang. _YAML Ain’t Markup Language_) ze zmiennymi środowiskowymi
 i ERB (Embedded Ruby).
 Oto jak wygląda to rozwiązanie.
layout: post
photo: /images/dynamic-yaml-configuration/ruby-yaml
title: Dynamiczna konfiguracja przy użyciu YAML w Ruby
description: Jak użyć zmiennych środowiskowych w pliku konfiguracyjnym YAML?
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [TIL, Ruby, Ruby on Rails]
imagefeature: dynamic-yaml-configuration/og_image.png
lang: pl
---

Od czasu do czasu programując w języku Ruby, a nawet częściej używając frameworka Ruby on Rails, potrzebuję stworzyć plik konfiguracyjny zawierający na przykład prywatne klucze do API. Oczywiście nie chcę tych danych śledzić w <a href="{{ site.baseurl }}/what-is-git" title="Wstęp do rozproszonego systemu kontroli wersji Git">systemie kontroli wersji</a>. Natomiast na dodanie ich do bazy danych jest jeszcze za wcześnie. W takiej sytuacji mogą pomóc zmienne środowiskowe zapisane w pliku `.env`. W tym przypadku jest jeszcze jeden mały haczyk. Chciałam by wszystkie dane były ustrukturyzowane w jednym pliku. Dlatego też użyłam kombinacji pliku YAML (akronim rekurencyjny od ang. _YAML Ain’t Markup Language_) ze zmiennymi środowiskowymi i ERB (Embedded Ruby). Oto jak wygląda to rozwiązanie.

Do pliku YAML wpisałam konfigurację potrzebną do obsługi dwóch kont Stripe.

```yml
new_york:
  name: 'New York Cafe'
  token: <%= ENV.fetch('NEW_YORK_TOKEN') %>
  secret_api_key: <%= ENV.fetch('NEW_YORK_API_KEY') %>

los_angeles:
  name: 'Los Angeles Cafe'
  token: <%= ENV.fetch('LOS_ANGELES_TOKEN') %>
  secret_api_key: <%= ENV.fetch('LOS_ANGELES_API_KEY') %>
```

Jak można zauważyć użyłam zmiennych środowiskowych do obsługi wrażliwych danych, które zostaną wstrzyknięte do do pliku YAML przy użyciu `ERB`. Teraz wystarczy już tylko wczytać dane. Do tego stworzyłam sobie metodę klasy.

```ruby
class StripeAccount
  def self.configuration
    YAML.safe_load(ERB.new(File.read('path_to_my_file.yml')).result)
  end

  ...
end
```

Gdziekolwiek będę teraz potrzebować mojej konfiguracji mogę uruchomić kod:

```ruby
StripeAccount.configuration['new_york']['name']
 => "New York Cafe"
```

Oczywiście w przypadku wielokrotnego używania tej metody warto pomyśleć o zapamiętaniu konfiguracji zamiast za każdym razem wczytywać ją jeszcze raz.
