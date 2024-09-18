---
excerpt: >
  Wysyłanie wiadomości email przez aplikację do jej użytkowników
  jest czymś bardzo powszechnym.
  Wysyłamy maile związane z rejestracją, nowymi zmianami w aplikacji,
  reklamami, ostatnimi aktywnościami czy z zaproszeniem do grona znajomych.
  Można powiedzieć, że jest to chleb powszedni dzisiejszych aplikacji internetowych.
  Pomimo tego, że tak często aplikacje posiadają tą funkcjonalność,
  zdarzają się w niej błędy.
  Dziś chciałabym się takim błędem z Tobą podzielić.
layout: post
title: Dlaczego nie powinnyśmy wysyłać maili z modelu w Railsach?
description: Co może pójść nie tak gdy korzystasz z workerów do wysyłania maili? - studium przypadku.
headline: Przedwczesna optymalizacja to źródło wszelkiego zła.
categories: [programowanie]
tags: [Ruby]
lang: pl
namespace: rails-mailer-problem
---

Wysyłanie wiadomości email przez aplikację do jej użytkowników jest czymś bardzo powszechnym. Wysyłamy maile związane z rejestracją, nowymi zmianami w aplikacji, reklamami, ostatnimi aktywnościami czy z zaproszeniem do grona znajomych. Można powiedzieć, że jest to chleb powszedni dzisiejszych aplikacji internetowych. Pomimo tego, że tak często aplikacje posiadają tą funkcjonalność, zdarzają się w niej błędy. Dziś chciałabym się takim błędem z Tobą podzielić.

Jako ludzie mamy problem z robieniem dwóch rzeczy równocześnie. Nie jesteśmy dobrzy w multitaskingu. Zawsze coś lub ktoś cierpi przy takim podejściu. Czasami jest to dość błaha sprawa. Przykładowo nie pamiętamy ostatniego paragrafu tekstu, który czytaliśmy. Czasem jest to jednak coś o wiele bardziej poważnego. Jak prowadzenie samochodu i korzystanie z telefonu komórkowego. I muszę przyznać, że zdarza się to obecnie coraz częściej. Ludzie z tego powodu wjeżdżają na przeciwległy pas, gubią drogę lub nie zauważają samochodu przed nimi. To wszystko może doprowadzić do wypadku drogowego. Dlatego proszę nie prowadź samochodu jednocześnie korzystając z telefonu! Dobrze, ale wracając do tematu. Tak samo, jak trudno przychodzi nam równoczesne prowadzenie samochodu i korzystanie z telefonu, tak samo trudno jest nam zrozumieć równoległe procesy w komputerze. Nie jest to niemożliwe, ale trudne. Niezwykle ciężko jest przewidzieć jakie sytuacje i komplikacje mogą się w takim momencie zdarzyć. O wiele łatwiej myśleć o rzeczach sekwencyjnie. Najpierw to, a później tamto. Krok po kroku widzimy, co się będzie działo. Dlatego też tak nie lubimy mechanizmu callbacków w JavaScript ;] Trudno jest przewidzieć w jakim stanie będzie aplikacja, gdy zacznie wywoływać się kod znajdując się w callbacku.

Przykład, który chciałabym Ci pokazać jest jednym z tych _równoległych_. Znalazłam ten problem jakiś czas temu. A był on w aplikacji zanim ja zaczęłam nad nią pracować. Aplikacja pozwalała na zapraszanie znajomych. Kiedy użytkownik chciał zaprosić znajomego dwie rzeczy działy się w aplikacji równocześnie. Tworzony był obiekt `Invitation` odpowiedzialny za zaproszenie i zostawał wysyłany email do osoby z tego właśnie zaproszenia. Kiedy aplikacja była jeszcze mała - na początku rozwoju aplikacji, wszystko działało jak należy. Później aplikacja zaczęła się rozrastać. Podjęto decyzję o dockeryzacji. Od tej pory bazy danych, główna aplikacja, workery i wiele innych usług zostało zamknięte w dockerowych kontenerach. Powstały osobne kolejki dla różnych zadań. W tym dla wysyłania wiadomości email. Wtedy zaczęło dziać się coś dziwnego.

## Problem

Kiedy jeden z użytkowników zaprosił swojego znajomego, Sidekiq (narzędzie do obsługi procesów w tle w Ruby) zwrócił nam (programistom) informację, że takie zaproszenie nie istnieje w bazie danych: `Invitation not found`. Sprawdziłam czy jest tak faktycznie. Okazało się, że zaproszenie jest w bazie zapisane poprawnie. Po jakimś czasie Sidekiq ponowił próbę wysłania wiadomości email i wszystko poszło jak należy. Mail został wysłany. Pomyślałam: _Zdarzył się tylko jeden taki przypadek, może to po prostu jakaś pomyłka?_ Postanowiłam na razie odłożyć sprawę i monitorować, czy wszystko działa jak należy. Problem jednak powrócił. Tym razem to nie mógł być już przypadek. Zaczęłam, więc sprawdzać w kodzie, co się dzieje:

```ruby
class Invitation < ActiveRecord::Base
  after_save :send_invitation_email

  # (...)

  def send_invitation_email
    AppMailer.invitation_email(
      user_id: user.id, recipient_email: email, invitation_id: self.id
    ).deliver_later
  end
end
```

Kod wyglądał OK. No może nie był piękny, ale nic złożonego. Wywoływany był callback `after_save`, który odpowiadał za wysłanie wiadomości email. Spróbowałam odtworzyć problem lokalnie. Nic z tego. Zostało prześledzenie błędu na serwerze testowym.

## Znalezienie powodu

Po głębszym zapoznaniu się z logiką. Zrozumiałam gdzie leży problem. Po pierwsze trzeba przyjrzeć się kolejności callbacków dla modelu w Railsach:

```ruby
before_validation
after_validation
before_save
around_save
before_create
around_create
after_create
after_save
after_commit/after_rollback
```

Callback `after_save` nie jest ostatnią rzeczą dziejącą się w trakcie i po zapisaniu na trwałe obiektu w bazie danych. W tym momencie mamy już informację o `id` obiektu, ale transakcja w bazie danych jeszcze się nie zakończyła. Po drugie nasz problem występował tylko, gdy Sidekiq nie miał nic w swojej kolejce do wysyłania emaili. Okazało się, że proces zlecenia wysłania wiadomości email (1) i (2) odbywał się tak szybko, w tym przypadku, że transakcja w bazie danych (3) nie zdążała się zakończyć. Dlatego też proces wysyłania wiadomości email nie widział odpowiedniego rekordu w bazie danych. W tamtej chwili faktycznie go tam jeszcze nie było.

<figure>
  <img src="{{ site.baseurl_root }}/images/rails-mailer-problem/mailer-in-rails-model.jpg" alt='Schemat model - baza danych - worker'>
  <figcaption>Schemat zapisu zaproszenia w bazie danych i wysyłania wiadomości email</figcaption>
</figure>
<br>

Nie sądzisz, że nie jest to intuicyjne? Logiczne, na pewno, gdy już się pozna przyczynę problemu, ale na pewno nie intuicyjne. Przynajmniej nie dla mnie.

## Możliwe rozwiązania

Mnie osobiście do głowy przyszły 3 sposoby naprawienia tego błędu:

- zmienić  `after_save` na `after_commit`  - W tym przypadku będziemy pewni, że rekord jest zapisany w bazie. Jednak nasz model dalej będzie zajmować się wysyłaniem wiadomości email.
- zmienić `deliver_later` na `deliver_later(wait: 10.seconds)` - jest to jakieś rozwiązanie, ale co jeżeli zapis do bazy z jakichś przyczyn zajmowałby więcej niż 10 sekund?
- wyciągnąć wysyłanie maili z modelu - To nie jest odpowiedzialność modelu by wysyłać maile z zaproszeniami do korzystania aplikacji. Myślę, że powinien być za to odpowiedzialny pewnego rodzaju proces (możemy go nazwać serwisem lub workflow), który dokładnie wie jakie trzeba podjąć kroki przy zaproszeniu użytkownika do aplikacji. W tym przypadku są 2 kroki: stworzenie obiektu `Invitation` i wysyłanie emaila.

Myślę, że ostatni sposób jest najlepszy. Nie powinniśmy zaśmiecać naszego modelu. Jego odpowiedzialnością jest przetwarzanie danych z bazy danych.

A Ty jak myślisz? Które rozwiązanie byś wybrała i dlaczego? A może przychodzi Ci do głowy jeszcze inna możliwość rozwiązania tego problemu? Podziel się swoimi przemyśleniami w komentarzu poniżej. Jeśli podobał Ci się artykuł, wyślij go znajomym a ja będę wdzięczna za każdą informację zwrotną.
