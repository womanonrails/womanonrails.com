---
layout: post
title: Małe zapachy kodu
description: Myślimy o wielkich koncepcjach architektonicznych a czasem mamy problem z małymi zapaszkami w kodzie.
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Visual Basic, code smells]
comments: true
---

Myślę, że każdy programista, na pewnym etapie rozwoju, chciałby zająć się rozwiązywaniem dużch problemów. Chciałby tworzyć systemy o złożonej strukturze i być tą osobą która za pomocą swoich rozwiązań zbawia świat. Czyłaś się kiedyś w ten sposób? Ja tak, i to conajmniej kilka razy. To zabawne ale w chwilach gdy właśnie tak się czuje chciałabym zmienić całkowicie architekturę aplikacji, oczywiście na lepsze ;] Zrobić refaktoring tu i tam. Byłabym w stanie zrobić to zupełnie sama, bez żadnej pomocy. Już widze to wspaniałe rozwiązanie w swoje głowie. Jest prawie gotowe do użycia. W takich chwilach zapominam całkowicie, że takie rzeczy nie dzieją sie same. O architekturę swoje aplikacji trzeba dbać każdego dnia w każdej linijce kodu. To jest ciężka praca. O wiele fajnie jest myśleć o integraci z Google Earth Engine niż o nazwie jakieś mało istotnej zmiennej. Prawda?

Oto co chciałabym Wam dzisiaj pokazać. Dostałam kod napisany w Visual Basic. Miałam ten kod przenieść do appliacji napisanej w Ruby. Nie mogę Wam pokazać całego tego kodu, dalej obowiązuje mnie NDA (ang. non-disclosure agreement), ale możecie sobie to wyobrazić. Otwieram plik. Jeden ogromny plik - 2000 linii kodu. Zaczynam go czytać, by zrozumieć logikę tego co jest w środku. To jest trudne, wrecz bolesne. Widzę wiele zmienny o nazwach od `a` do przwie `z`, a póżniej kolejne zmienne od `aa` do prawie `zz` bez jakiegokolwiej wytłumaczenia co osne znaczą. Jedna wielgachna metoda. Pełno powielenia kodu i na dodatek bez wcięć. Do tego rzecz, którą ostatni raz widzałam na studiach przy programowaniu mikrokontrolerów - komenda `goto`. Pełno jej wszędzie. rozumienie tego kodu zajeło mi trochę czasu. Po wielu godzinach czytania kodu okazało się że logika wcale nie była taka złożona. Co prawda było tam trochę równań matematycznych, ale były one liniowe wywoływane w pętlach. Gdyby osoba pisząca ten kod zadbała o niego w odpowieni sposób, ja miałabym znacznie mnie pracy. O wiele łatwiej było by zrozumieć ten program. Ja zaoszczędziłabym czas, a tej osobie pewnie też było by łatwiej poruszać się po tym co napisała.

Chciałabym Wam pokazać dwa przykłady prosto z tego kodu by w pewien sposób zobrazować problem:

```basic
For i = 1 To m1
For j = 1 To m1
If i <> j Then
s3(i, j) = 0
GoTo 410
End If
s3(i, j) = 1
410 Next j
Next i
```

Czy wiesz co ten kod robi? Pierwsza myśl jaka przychodzi Ci do głowy po spojrzeniu na ten kod. Moja była muszę to przeanalizować, by zrozumeić. Dam Ci małą podpowiedź:

```basic
m1 = 2
For i = 1 To m1
  For j = 1 To m1
    If i <> j Then
      s3(i, j) = 0
      GoTo 410
    End If
  s3(i, j) = 1
  410 Next j
Next i
```

Czy to coś ułatwia? Kod jest odrobinę bardziej czytelny. Przynajmniej widać które fragmenty kodu są gdzie wywoływane. Widzimy też, że te pętle są wywoływane tylko dla `m1 = 2`. Mamy więc tylko dwa kroki dla każdej pętli. Jednak ten `goto` spowalnia czytanie tego kodu. A co jeśli Ci powiem że ten kod robi tylko tyle:

```basic
array = [
  [1, 0],
  [0, 1]
]
```

Odrazu widać co się dzieje. Mogę podać jeszcze jedno rozwiązanie jeżeli chciałabyś by ta macież była generowana dynamicznie w zależności od wielkości. W przypadku tego kodu w Visual Basic nie ma to sensu bo zawsze jest on wywoływany dla wielkości 2, ale może w innych przypadkach ma to sens:

```basic
For i = 1 To m1
  For j = 1 To m1
    If i <> j Then s3(i, j) = 0
    If i = j Then s3(i, j) = 1
  Next j
Next i
```

Drugi przykład jest dość szybki. Czy wiesz czym różni się zmienna `n12` od `n1n2`? A może to po prostu pomyłka? No i co to wzasadzie znaczy to `n12`? Jaki jest sens tej zmiennej?

```basic
n12 = n1 ^ 2
n1n2 = n1 * n2
```

Widzimy już różnicę i widzimy że to dwie osobne zmienne. Jednak, uważam że bardzo łatwo tutaj o pomysłkę. Przez chwilę sie uwagi można zamienić zmienną `n12` na `n1n2` i ciężko będzie znaleść źródło błędu. Dodatkowo dalej nie znamy prawdziwego znaczenia tych zmiennych. Widzimy jak są tworzone ale nie wiemy co oznaczają. Im więcej tego typu zmiennych w kodzie tym trudniej nam je wszystkie zapamiętać.

Jeżeli chcemy by w naszej aplikacji panowała dobra architektura, powinniśmy zacząć od czagoś małego. Powinniśmy zwracać uwagę na każdą najmniejszą linię naszego kodu. Tworzyć go w taki sposób by jaknajwięcej rzeczy było jasnych od samego początku, bez potrzeby dodatkowego tłumaczenia czy opisu. Łatwo jest zrobić bałagan w kodzie, trudniej każdego dnia dbać i angażować się w jego jakość.

Dziękuję Ci za to że tu jesteś i że chcesz pracować nad jakością swojego kodu. Podziel się swoimi myślami w komentarzach i do zobaczenia następnym razem!
