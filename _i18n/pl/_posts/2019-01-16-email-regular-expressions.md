---
layout: post
title: Wyrażenia regularne - co może pójść nie tak?
description: Wyrażenia regularne to tylko narzędzie. My, jako programiści, musimy używać ich odpowiedzialnie.
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby, wyrażenia regularne]
comments: true
---

Ktoś kiedyś powiedział: _Masz problem, użyj wyrażeń regularnych. Będziesz mieć dwa problemy._ To po części prawda. Przynajmniej w niektórych przypadkach. Jako programiści powinniśmy być odpowiedzialni za to, co piszemy, za swój kod. Powinniśmy zatrzymać się i pomyśleć dwa razy o wszystkich możliwych przypadkach użycia swojego kodu. I mieć na to wszystko dowody, czyli testy. Dzisiaj chciałaby podzielić się z Tobą pewnym przypadkiem problemów z wyrażeniami regularnymi. Przypadkiem, gdzie brak dobrego przygotowania i sprawdzenia zaowocował błędem w aplikacji. W tym artykule nie będę poruszać podstaw dotyczących wyrażeń regularnych. Chcę pokazać na co warto zwrócić uwagę, korzystając z wyrażeń regularnych.

Dostałam błąd do naprawienia. Tak zaczyna się wiele historii. Ta też. Dostałam więc błąd w jednym z pól tekstowym w aplikacji. Do tego pola użytkownik mógł wpisać listę emalii i zaimportować je do swoich kontaktów. Problem był taki, że raz mu się to udawało a raz nie. Czasem tylko część poprawnych adresów zostawała zapisana do bazy. Moje zadanie polegało na znalezieniu przyczyny i naprawieniu problemu. W takich sytuacjach lubię myśleć o sobie jak o detektywie, więc zabrałam się za moje małe śledztwo.

Kod w Ruby dla tej funkcjonalności wyglądał tak:

```ruby
emails = params[:enter_emails].delete(' ')
if emails =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  emails = emails.split(/,/)
  # do something (for example add to contact list)
else
  # render error
end
```

Na wejście kod dostawał tekst. Później następowało usunięcie białych znaków, w zasadzie tylko spacji. Dalej używając wyrażenia regularnego sprawdzaliśmy poprawność formatu danych i dzieliliśmy tekst na części na podstawie przecinków. Na koniec poprawne dane zostawały poddane dalszym działaniom. Przykładowo importowane do listy kontaktów użytkownika. Patrząc na ten kod można dostrzec dwa podstawowe problemy:

  1. **Dzielenie tekstu względem przecinków** - Co stanie się gdy użytkownik nie będzie myślał tak jak my i oddzieli od siebie kolejne maile za pomocą średników, tylko spacji lub nowych linii? Jest to zwykłe pole tekstowe. Użytkownicy może to zrobić. My jednak nie obsługujemy tych przypadków.

  2. **Walidacja tylko ostatniej części naszego tekstu** - Gdy przyjrzymy się bliżej zauważymy, że podając na wejście `"aaa@excom, bbb@ex.com"` dane zostaną potraktowane jako poprawne. Natomiast gdy odwrócimy kolejność `"bbb@ex.com, aaa@excom"` już nie.

Co tu się dzieje? By lepiej zrozumieć problem dobrze jest sprawdzić różne przypadki zachowania danych wejściowych dla wybranego przez nas wyrażenia regularnego. Można to zrobić za pomocą interaktywnej konsoli Rubiego lub używając jakiegoś narzędzia. Ja często używam i również polecam <a href="https://rubular.com/" title="Rubular - regular expressions" target="_blank" rel="nofollow noopener noreferrer">Rubular</a>. Jest to prosta stronka internetowa, gdzie łatwo można sprawdzić działanie swoich wyrażeń regularnych.

<figure>
  <a href="{{ site.baseurl_root }}/images/email-regular-expressions/rubular.png"><img src="{{ site.baseurl_root }}/images/email-regular-expressions/rubular.png" title="Rubular - wyrażenia regularne" alt="Dopasowywanie do wyrażenia regularnego"></a>
</figure>

Jak możesz zauważyć, sprawdzamy tylko ostatnią część naszego testu. Gdy ostatni fragment jest poprawnym adresem email, cały tekst traktowany jest jako poprawny. To nie dobrze. Gdy znamy już przyczynę problemu, czas go rozwiązać. Można to zrobić na wiele sposobów. Ja zdecydowałam się najpierw podzielić ten tekst na części używając do tego wyrażenia regularnego: `/\s+|\s*,\s*|\s*;\s*/` a dopiero później sprawdzać drugim wyrażeniem czy dana część jest poprawnym adresem email. Warto tu wspomnieć o jednej rzeczy. Gdy zastosujesz to samo wyrażenie regularne co ja, które dzieli tekst względem przecinków, średników i dowolnych białych znaków, po podzieleniu możesz otrzymać tablicę z pustymi łańcuchami. Tak jak w przykładzie poniżej:

```ruby
emails = "aaa@excom,, , ,  bbb@ex.com aa".split(/\s+|\s*,\s*|\s*;\s*/)
 => ["aaa@excom", "", "", "", "bbb@ex.com", "aa"]
```

To może być dla Ciebie wystarczające lub nie. Tu musisz o tym zdecydować. Dalej można już sprawdzić poprawność wszystkich elementów w tablicy:

```ruby
emails.all? { |email| email =~ /\b[A-Z0-9._%a-z\-\+]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
 => false
```

lub wybrać tylko elementy będące poprawnymi adresami email:

```ruby
emails.select { |email| email =~ /\b[A-Z0-9._%a-z\-\+]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
 => ["bbb@ex.com"]
```

Wszystko zależy od tego, czego potrzebujesz.

Teraz możesz zapytać: po co to wszystko? Jaki był cel tego artykułu? Odpowiedź jest prosta. Ja widzę takie rzeczy bardzo często. Jako programiści, nie przywiązujemy zbyt dużej uwagi do naszego kodu lub może po prostu zbyt się śpieszymy przy tworzeniu rozwiązań. W ten sposób wprowadzając do aplikacji błędy. Czasami to nie jest duży problem, ale czy chciałabyś by operował Cię lekarz, który nie przywiązuje wagi do szczegółów Twojego stany zdrowia podczas operacji? Czasem oprogramowanie, które tworzymy służy do błahych celów, ale co w przypadku wypełniania dokumentów urzędowych, dawkowania leków lub sterowanie systemem hamowania w samochodzie? W _Małym Księciu_ lis powiedział: _"Stajesz się na zawsze odpowiedzialny za to co oswoiłeś"_. W tym przypadku ja mówię: _"Stajesz się na zawsze odpowiedzialny za to co wykodziłeś."_

Jeśli masz ochotę, to podziel się swoimi myślami w komentarzach. Dzięki za przeczytanie artykułu i do następnego razu. Pa!

