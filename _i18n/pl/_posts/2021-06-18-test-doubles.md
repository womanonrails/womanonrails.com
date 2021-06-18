---
layout: post
photo: /images/test-doubles/test-doubles
title: Czym różni się stub od mocka?
description: Test doubles, czyli fałszywe obiekty w testach
headline: Premature optimization is the root of all evil.
categories: [testowanie]
tags: [tdd, testy, mock, stub]
imagefeature: test-doubles/og_image-test-doubles.png
lang: en
---

W świecie testów istnieje wiele pojęć takich jak **stub**, **mock** czy **dummy object**. Może to być niejasne i mylące, co czym jest i gdzie tego należy użyć. Chcę usystematyzować te pojęcia w bardziej przystępny sposób. Ze względu jednak na rozbieżności dotyczące definicji tych terminów, w poniższym artykule przedstawię moje ich zrozumienie. Oczywiście będę bazować na wybranych źródłach zamieszczonych w <a href="#bibliografia">bibliografii</a>.

Zacznijmy od początku. Ogólnym pojęciem jest **test double**. Jest to termin określający dowolny obiekt użyty w celu testowania oprogramowania, który ma zastąpić prawdziwy obiekt. Możemy ten obiekt rozumieć jako dublera, jak w filmach. Test double udaje prawdziwy obiekt w trakcie trwania testów. Ze względu na różne cechy i przeznaczenie możemy wyróżnić następujące typy _fałszywych_ obiektów: <a href="#obiekt-dummy">dummy</a>, <a href="#obiekt-fake">fake</a>, <a href="#obiekt-stub">stub</a>, <a href="#obiekt-spy">spy</a> czy <a href="#obiekt-mock">mock</a>. Przejdźmy teraz do szczegółowego zapoznania się z nimi.

## Obiekt dummy

Obiekt **dummy** to obiekt podrobiony, **przekazywany w teście by zadowolić API testowanych metod, klas czy obiektów**. Zazwyczaj dummy obiekt przekazywany jest jako jeden z argumentów szeroko rozumianej metody, ale taki, którego nie potrzebujemy użyć. Taki dummy obiekt nie ma implementacji. Jest pustą wydmuszką, pudełkiem. Przykładowo, potrzebuję stworzyć instancję klasy. Konstruktor wymaga ode mnie dodatkowego argumentu, który nie ma wpływu na testowaną metodę. W takim przypadku mogę właśnie użyć obiektu typu dummy w moich testach.

#### Przykład użycia obiektu dummy

Zastanawiając się nad konkretnym przykładem zauważyłam, że nie używam zbyt często dummy obiektów. Jeżeli potrzebuję zastąpić prawdziwy obiekt, używam do tego innych obiektów typu double. Dlatego też, ten przykład będzie raczej poglądowy. Zarówno w nim jak i w następnych przykładach używam narzędzia **RSpec**.

```ruby
class EmailRecipient
  def initialize(recipient)
    @recipient = recipient
  end

  def message_already_received?
    false
  end

  ...
end

RSpec.describe EmailRecipient do
  describe '#message_already_received?' do
    it 'returns false' do
      recipient = double(Recipient)

      email_recipient = EmailRecipient.new(recipient)

      expect(recipient.message_already_received?).to eq false
    end
  end

  ...
end
```

Klasa `EmailRecipient` ma jeden argument w inicjalizerze, który nie jest używany w metodzie `message_already_received?`. W takim przypadku nie muszę się martwić, co znajduje się w zmiennej `recipient`. Zamiast obiektu `double` mogłabym użyć po prostu wartości `nil`. Pokazuje to dobrze pustość dummy obiektu.

## Obiekt fake

**Fake** to obiekt z działającą implementacją, ale prostszą niż w przypadku produkcyjnego użycia. Dlatego też takie obiekty nie są wykorzystywane na produkcji. Zadaniem obiektu typu fake jest **uproszczenie sposobu w jaki testujemy kod**. Usuwa on lub minimalizuje złożone zależności, tak by można było skupić się na testowaniu swojego kodu, a nie na przykład na interakcjach z zewnętrzną infrastrukturą. Najczęstsze przypadki wykorzystania obiektu typu fake to:
- baza danych w pamięci lub w pliku np. SQLite - Jest lżejsza od _prawdziwej_ bazy danych, ale w większości przypadku nie będzie wykorzystywana produkcyjnie.
- zapis danych do pliku na dysku lub w pamięci zamiast na zewnętrznych serwisach takich jak Amazon S3. - W takim przypadku _zapis do lokalnego pliku_ jest obiektem fake. Na produkcji natomiast będziemy wykorzystywać prawdziwy zewnętrzny serwis. Jednak w przypadku testów zwłaszcza jednostkowych dobrą praktyką jest nie wchodzić w interakcję z zewnętrznymi serwisami. Tak by testy jednostkowe były szybkie i nie miały zbędnych, na tym poziomie, zależności.

#### Przykład użycia obiektu fake

Przykład będzie związany z funkcjonalnością **Active Storage** pochodzącą z Railsów. Upraszcza ona wrzucanie plików do chmury i łączy je z obiektami Active Record. W wersji produkcyjnej ustawienia mogą wyglądać następująco:

```ruby
# config/environments/production.rb
config.active_storage.service = :amazon
```

Natomiast w przypadku testów mamy:

```ruby
# config/environments/test.rb

# Store uploaded files on the local file system in a temporary directory.
config.active_storage.service = :test
```

Ustawienia `storage.yml` mogą wyglądać tak:

```yml
# config/storage.yml

test:
  service: Disk
  root: <%= Rails.root.join('tmp/storage') %>

amazon:
  service: S3
  access_key_id: <%= ENV.fetch('AWS_DOCUMENT_ACCESS_KEY_ID') %>
  secret_access_key: <%= ENV.fetch('AWS_DOCUMENT_SECRET_ACCESS_KEY') %>
  bucket: <%= ENV.fetch('AWS_DOCUMENT_BUCKET') %>
  region: <%= ENV.fetch('AWS_IMAGE_REGION') %>
```

Dzięki tym ustawieniom testy będą wykorzystywać zapis plików lokalnie, natomiast produkcja korzystać będzie z zewnętrznego serwisu. Uprościło to sposób w jaki możemy testować kod.

```ruby
module Admin
  module Book
    class AttachmentsController < ApplicationController
      ...

      def update
        book_form.files.attach(params[:book][:files])
        book_form.save

        flash[:notice] = 'Document has been uploaded for this book'
        redirect_to admin_book_path(book)
      end

      ...
    end
  end
end

module Admin
  module Book
    RSpec.describe AttachmentsController, type: :controller do
      describe '#update' do
        it 'adds file to book' do
          admin = create(:user, :confirmed, :admin)
          login_user(admin)
          book = create(:book)
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/support/fixtures/test.png'), 'image/png'
          )

          expect {
            put :update, params: { book_id: book.id, book: { files: [file] } }
          }.to change { book.reload.files.attached? }.from(false).to(true)
        end
      end

      ...
    end
  end
end
```

## Obiekt stub

**Stub** to obiekt zawierający zakodowaną odpowiedź (bez wykonywania jakichkolwiek obliczeń) na wywoływane podczas testu metody. Odpowiada on tylko na wcześniej określone do celów testowych metody. Możemy powiedzieć, że stub nadpisuje prawdziwe metody obiektu i zwraca dla nich określone wartości. **Zadaniem obiektu typu stub jest przygotowanie określonego stanu systemu dla celów testowych.**

Przykładowo, chcemy przetestować klasę, która zależy od dość długich i złożonych obliczeń. Te obliczenia są testowane osobno. W tym przypadku chcemy przetestować działanie naszej klasy dla konkretnych wartości zwróconych przez te kalkulacje. Chcemy przygotować konkretny stan naszego systemu dla celów testowych. Zależy nam na sprawdzeniu jak system zachowa się w tym konkretnym stanie. Nie zależy nam jednak, jak do tego stanu dojdziemy. W tym przypadku wykorzystamy _skrót_, czyli nasz stub.

#### Przykład 1

```ruby
class UserDuplicates
  ...

  def each
    duplicate_users.each do |user_duplicate|
      mismatched_attributes = mismatched_attributes(user_duplicate)
      match_level = TypeOfUserMatch.result_for(user, user_duplicate: user_duplicate)

      yield user_duplicate, match_level, mismatched_attributes
    end
  end

  ...
end
```

Załóżmy, że klasa `TypeOfUserMatch` ma do przeprowadzenia dość skomplikowane kalkulacje trwające kilka sekund. Nie chcemy czekać w teście aż te kalkulacje będą gotowe. Dlatego użyjemy obiektu typu stub, by podać konkretną wartość jaką powinny one zwracać.

```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'yields fully duplicated objects' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)
      allow(TypeOfUserMatch).to receive(:result_for).and_return(:full)

      expect { |n| UserDuplicates.new(user).each(&n) }.to yield_successive_args([
        user_duplicate, :full, []
      ])
    end

    ...
  end
end
```

Uwaga! Jeżeli z jakiegoś powodu przestaniemy używać klasy `TypeOfUserMatch`, ale założenia testu będą spełnione (np. `match_level = :full`), test nam przejdzie. Nie dowiemy się, że klasa `TypeOfUserMatch` nie jest już używana. Ważne by pamiętać o tym. Wrócę do tego trochę później w sekcji dotyczącej obiektu typu <a href="#obiekt-mock">mock</a>.

Chciałabym tu jeszcze wspomnieć o jednej rzeczy. Gdyby zrobić tu pewne drobne zmiany w kodzie i wykorzystać dependency injection (wstrzyknięcie zależności). Mogłabym skorzystać z innego mechanizmu oferowanego przez RSpec, z `class_double`. Jest to mechanizm podobny do `instance_double`. Oba są bardzo pożyteczne. Sprawdzają czy nasz _fałszywy_ obiekt jest zgodny z interfejsem klasy czy instancji obiektu. Dzięki temu test nie przejdzie w przypadku zmiany nazwy metody lub jej całkowitego usunięcia. Poniżej zamieszczam przykład zawierający `class_double`.

```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'yields fully duplicated objects' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)
      user_match_double = class_double(TypeOfUserMatch, result_for: :full)

      expect { |n| UserDuplicates.new(user, user_match_double).each(&n) }.
        to yield_successive_args([
          user_duplicate, :full, []
        ])
    end

    ...
  end
end
```

### Zastosowanie stuba przy testowaniu zewnętrzego API

Innym przykładem zastosowania obiektu stub jest zewnętrzne REST API. Ogólnie dobrą praktyką jest nie odpytywanie zewnętrznego API w testach (zwłaszcza tych niskopoziomowych jak testy jednostkowe), tak by nie zależeć od tego API. To dobre miejsce na użycie obiektu stub. Można wtedy przygotować kilka różnych odpowiedzi, łącznie z tymi dotyczącymi błędów. Dzięki temu sprawdzamy jak system reaguje na takie odpowiedzi API.

#### Przykład 2

Zobaczmy jak może to wyglądać. Korzystamy z API z cytatami. Oto jak wygląda kod:

```ruby
class Client
  BASE_URI = 'http://quotes.rest'

  def get_qod(category)
    response = HTTParty.get(
      "#{BASE_URI}/qod.json",
      headers: headers,
      query: "category=#{category}"
    )
    parse_response(response)
    ...
  end

  ...
end
```

Teraz test. Oczywiście takie podejście nie da nam 100% pewności że kod działa. To tylko stub. Istnieją sposoby by dodatkowo zabezpieczyć nasz kod, ale skupmy się teraz na naszym teście.

```ruby
RSpec.describe Client do
  describe '#get_qod' do
    it 'returns quote object' do
      body = {
        'success' => { 'total' => 1 },
        'contents' => {
          'quotes' => [
            {
              'quote' => 'A leader is the wave pushed ahead by the ship.',
              'length' => '46',
              'author' => 'Leo Nikolaevich Tolstoy',
              'tags' => ['leadership', 'management'],
              'category' => 'management',
              ...
            }
          ],
          ...
        }
      }
      stub_request(:get, 'http://quotes.rest/qod.json').
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          },
          query: { 'category' => 'management' }
        ).
        to_return(body: body.to_json)

      result = Client.new.get_qod('management')

      expect(result).to match(body)
    end
  end
end
```

Dodatkowo możemy też sprawdzić jak nasz kod reaguje na błędy w odpowiedzi z API.

```ruby
RSpec.describe Client do
  describe '#get_qod' do
    ...

    it 'returns empty hash when there is a Net::ReadTimeout' do
      allow(HTTParty).to receive(:get).and_raise(Net::ReadTimeout)

      result = Client.new.get_qod('management')

      expect(result).to match({})
    end
  end
end
```

## Obiekt spy

W moim rozumieniu obiektu **spy**, jest on pewnym szczególnym przypadkiem obiektem typu stub. Poza zwracaniem określonej wartości może zapamiętać pewne dodatkowe informacje o tym jak został wywołany. Jest to fragment kodu, który przejmuje pewne wywołania skierowane do prawdziwego obiektu i weryfikuje je bez zastępowania całego oryginalnego obiektu. Może to brzmieć bardzo podobnie do obiektu typu fake, ale dla mnie obiekt typu fake jest bardziej transparentną warstwą służącą do uproszczenia środowiska testowego. Natomiast spy to obiekt służący do weryfikacji pewnych informacji. Powiedziałabym, że **celem obiektu typu spy jest pomoc w sprawdzeniu informacji dotyczących prawdziwego obiektu, które są normalnie trudne do weryfikacji**.

Uwaga! W narzędziu RSpec istnieje coś takiego jak metoda **spy**. Moim zdaniem zachowaniem bliżej jej do obiektu typu <a href="#obiekt-mock">mock</a> omówionego poniżej.

Przykładowo, gdy chcemy sprawdzić co dzieje się z wiadomością email. Dzięki obiektowi spy możemy dostać informację na temat wysłania wiadomości, ilości wysłanych wiadomości czy nawet o zawartości tej wiadomości.

#### Przykład użycia obiektu spy

Taki mechanizm do weryfikacji wiadomości email możemy znaleźć w Railsach. Konfiguracja wygląda następująco:

```ruby
# config/environments/test.rb

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
```

Teraz możemy już sprawdzać w testach ile wiadomości email zostało wysłanych:

```ruby
RSpec.describe SendDailyNewsletter do
  describe '.call' do
    it 'delivers daily newsletter for subscriber' do
      ...

      expect {
        SendDailyNewsletter.call
      }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end
```

## Obiekt mock

**Mock** to taka część testu, dzięki której możesz ustawić pewne oczekiwania względem zachowania (nie wartości). Jest to obiekt zaprogramowany by oczekiwać wywołań pewnych zachowań/metod. **Zadaniem obiektu mock jest oczekiwanie pewnych interakcji systemu z zależnościami.** Innymi słowy, mock sprawdza interakcje między obiektami. Od obiektu mock nie oczekujemy, że coś zwróci (jak w przypadku obiektu stub), oczekujemy że zweryfikuje wywołanie konkretnych metod.

Na przykład, po wywołaniu metody `save` dla nowego obiektu `User` oczekujemy wywołania serwisu `SendConfirmationEmail`.

#### Przykład 1

Wróćmy do przykładu z `UserDuplicates`. Chciałabym sprawdzić czy metoda `result_for` zostanie wywołana:

```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'calls result_for method for each user duplicate' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)
      allow(TypeOfUserMatch).to receive(:result_for).and_return(:full)

      UserDuplicates.new(user).each {}

      expect(TypeOfGuestMatch).to have_received(:result_for).
        with(user, user_duplicate: user_duplicate)
    end

    ...
  end
end
```

W przykładzie powyżej deklaruję, że będę obserwować metodę `result_for`. Robię to za pomocą `allow`. Dalej wywołuje kod `UserDuplicates.new(user).each {}`. Na koniec sprawdzam czy metoda `result_for` faktycznie została wywołana za pomocą  `expect`.

#### Przykład 2

W tym przypadku najpierw deklaruje czego oczekuję za sprawą `expect`. Następnie wywołuje kod `UserDuplicates.new(user).each {}`. Sama weryfikacja odbywa się już automatycznie podczas uruchomienia kodu.

```ruby
RSpec.describe UserDuplicates do
  describe '#each' do
    it 'calls result_for method for each user duplicate' do
      user_data = {
        ...
      }
      user = create(:user, **user_data)
      user_duplicate = create(:user, **user_data)

      expect(TypeOfUserMatch).to receive(:result_for).
        with(user, user_duplicate: user_duplicate).
        and_return(:full)

      UserDuplicates.new(user).each {}
    end

    ...
  end
end
```

Osobiście wolę używać pierwszego sposobu. Jest dla mnie łatwiejszy w czytaniu i zrozumieniu. Nie ma takich przeskoków myślowych jak drugi sposób, ale każdy może mieć swoje preferencje.

## Jaka jest różnica między stub a mock?

W mojej opinii stub to obiekt z zakodowaną odpowiedzią. Reprezentuje określony stan prawdziwego obiektu. Mock natomiast weryfikuje czy metoda została wywołana. Testuje zachowanie. Bardzo podoba mi się porównanie obiektu stub do odpowiedzi na pytanie, a obiektu mock do sprawdzenia czy pytanie zostało zadane.

## Jakie są wady i zalety obiektów test double?

#### Zalety
- minimalizują skomplikowane dane początkowe dla testu - kiedy pracujemy z prawdziwymi obiektami w testach,  ustawienie stanu wejściowego zanim zacznie się prawdziwy test, może być dość skomplikowane. Zwłaszcza w dużych systemach i wtedy gdy chcemy przetestować wiele przypadków.
- przyśpieszają testy - skoro nie musimy tworzyć całego prawdziwego obiektu (przykładowo w bazie danych) lub nie musimy robić czasochłonnych obliczeń nasze testy mogą być szybsze.
- wspierają niezależność testów - gdy używamy prawdziwych obiektów w testach, nawet mała zmiana w kodzie może spowodować dużą liczbę nieprzechodzących testów.

#### Wady
- mogą dać fałszywą pewność - czasem nasze fałszywe obiekty mogą być po prostu nieprawidłowe. Testy jednostkowe będą przechodzić, ale nasz kod wcale nie będzie robić tego, co powinien. Dlatego sugeruję tworzenie różnorodnych testów tych z prawdziwymi obiektami i tych z test doubles.
- przywiązanie do implementacji - w przypadku obiektów typu mock testy są mocno związane z implementacją metody lub klasy. W takiej sytuacji sprawdzamy przecież, co dzieje się w środku metody/klasy. Nie traktujemy jej jak czarnej skrzynki, sprawdzając tylko poprawność wyników. Kiedy zmieni się implementacja metody/klasy, nawet jeżeli zwracane wyniki są prawidłowe, test prawdopodobnie nam nie przejdzie.
- problem z refaktoringiem - skoro w przypadku obiektów mock jesteśmy ściśle związani z implementacją metody/klasy to ciężko może nam być ją zrefaktoryzować bez popsucia testów.

## Bibliografia
- <a href="https://martinfowler.com/articles/mocksArentStubs.html" title="Martin Fowler - Mocks Aren't Stubs" target='_blank' rel='nofollow'>Mocks Aren't Stubs - Martin Fowler</a>
- <a href="https://blog.cleancoder.com/uncle-bob/2014/05/14/TheLittleMocker.html" title="Robert C. Martin - The Little Mocker" target='_blank' rel='nofollow'>The Little Mocker - Robert C. Martin</a>
- <a href="https://stackoverflow.com/questions/3459287/whats-the-difference-between-a-mock-stub" title="What's the difference between a mock & stub?" target='_blank' rel='nofollow'>What's the difference between a mock & stub?</a>
- <a href="https://stackoverflow.com/questions/346372/whats-the-difference-between-faking-mocking-and-stubbing" title="What's the difference between faking, mocking, and stubbing?" target='_blank' rel='nofollow'>What's the difference between faking, mocking, and stubbing?</a>
- <a href="https://relishapp.com/rspec/rspec-mocks/docs" title="RSpec Mocks" target='_blank' rel='nofollow'>RSpec Mocks</a>
- <a href="https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles" title="RSpec verifying doubles" target='_blank' rel='nofollow'>RSpec verifying doubles</a>
