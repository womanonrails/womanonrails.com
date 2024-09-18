---
excerpt: >
  Myślę, że każdy programista, na pewnym etapie rozwoju,
  chciałby zająć się rozwiązywaniem dużych problemów.
  Chciałby tworzyć systemy o złożonej strukturze i być tą osobą,
  która za pomocą swoich rozwiązań zbawi świat.
  Czułaś się kiedyś w ten sposób?
  Ja tak, i to nie jeden raz.
  To zabawne, ale w chwilach, gdy właśnie tak się czuje,
  chciałabym zmienić całkowicie architekturę aplikacji, oczywiście na lepsze. ;]
  Zrobić refaktoring to tu, to tam.
  Byłabym w stanie zrobić to zupełnie sama, bez żadnej pomocy.
  Już widzę to wspaniałe rozwiązanie w swojej głowie.
  Jest prawie gotowe do użycia.
  W takich chwilach zapominam całkowicie, że takie rzeczy nie dzieją się same.
  O architekturę aplikacji trzeba dbać każdego dnia, w każdej linijce kodu.
  To jest ciężka praca.
  O wiele fajniej jest myśleć o integracji z Google Earth Engine,
  niż o nazwie jakieś mało istotnej zmiennej.
  Prawda?
layout: post
title: Małe zapachy kodu
description: Myślimy o wielkich koncepcjach architektonicznych a czasem mamy problem z małymi zapaszkami w kodzie.
headline: Premature optimization is the root of all evil.
categories: [refaktoring]
tags: [Visual Basic, code smells]
lang: pl
---

Myślę, że każdy programista, na pewnym etapie rozwoju, chciałby zająć się rozwiązywaniem dużych problemów. Chciałby tworzyć systemy o złożonej strukturze i być tą osobą, która za pomocą swoich rozwiązań zbawi świat. Czułaś się kiedyś w ten sposób? Ja tak, i to nie jeden raz. To zabawne, ale w chwilach gdy właśnie tak się czuje, chciałabym zmienić całkowicie architekturę aplikacji, oczywiście na lepsze. ;] Zrobić refaktoring to tu, to tam. Byłabym w stanie zrobić to zupełnie sama, bez żadnej pomocy. Już widzę to wspaniałe rozwiązanie w swojej głowie. Jest prawie gotowe do użycia. W takich chwilach zapominam całkowicie, że takie rzeczy nie dzieją się same. O architekturę swojej aplikacji trzeba dbać każdego dnia w każdej linijce kodu. To jest ciężka praca. O wiele fajniej jest myśleć o integracji z Google Earth Engine niż o nazwie jakieś mało istotnej zmiennej. Prawda?

Oto co chciałabym Ci dzisiaj pokazać. Dostałam kod napisany w Visual Basic. Miałam ten kod przenieść do aplikacji napisanej w Ruby. Nie mogę Ci pokazać całego tego kodu, dalej obowiązuje mnie NDA (ang. non-disclosure agreement), ale możesz sobie to wyobrazić. Otwieram plik. Jeden ogromny plik - 2000 linii kodu. Zaczynam go czytać, by zrozumieć logikę tego, co jest w środku. To jest trudne, wręcz bolesne. Widzę wiele zmiennych o nazwach od `a` do `z`, a później kolejne zmienne od `aa` do `zz` bez jakiegokolwiek wytłumaczenia, co one znaczą. Jedna wielgachna metoda. Pełno powielenia kodu i na dodatek bez wcięć. Do tego rzecz, którą ostatni raz widziałam na studiach przy programowaniu mikro-kontrolerów - komenda `goto`. Pełno jej wszędzie. Zrozumienie tego kodu zajęło mi trochę czasu. Po wielu godzinach czytania kodu okazało się, że logika wcale nie była taka złożona. Co prawda było tam trochę równań matematycznych, ale były one liniowe wywoływane w pętlach. Gdyby osoba pisząca ten kod zadbała o niego w odpowiedni sposób, ja miałabym znacznie mniej pracy. O wiele łatwiej byłoby zrozumieć ten program. Ja zaoszczędziłabym czas, a tej osobie pewnie też byłoby łatwiej poruszać się po tym co napisała.

Chciałabym Ci pokazać dwa przykłady prosto z tego kodu, by w pewien sposób zobrazować problem:

```visualbasic
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

Czy wiesz co ten kod robi? Pierwsza myśl, jaka przychodzi Ci do głowy po spojrzeniu na ten kod. Moja była muszę to przeanalizować, by zrozumieć. Dam Ci małą podpowiedź:

```visualbasic
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

Czy to coś ułatwia? Kod jest odrobinę bardziej czytelny. Przynajmniej widać, które fragmenty kodu są gdzie wywoływane. Widać też, że te pętle są wywoływane tylko dla `m1 = 2`. Mamy, więc tylko dwa kroki dla każdej pętli. Jednak ten `goto` utrudnia czytanie tego kodu. A co jeśli Ci powiem że ten kod robi tylko tyle:

```visualbasic
array = [
  [1, 0],
  [0, 1]
]
```

Od razu widać, co się dzieje. Mogę podać jeszcze jedno rozwiązanie jeżeli chciałabyś, by ta macierz była generowana dynamicznie w zależności od wielkości. W przypadku tego kodu w Visual Basic nie ma to sensu, bo zawsze jest on wywoływany dla wielkości 2, ale może w innych przypadkach ma to sens:

```visualbasic
For i = 1 To m1
  For j = 1 To m1
    If i <> j Then s3(i, j) = 0
    If i = j Then s3(i, j) = 1
  Next j
Next i
```

Drugi przykład jest znacznie krótszy. Czy wiesz czym różni się zmienna `n12` od `n1n2`? A może to po prostu pomyłka? No i co to w zasadzie znaczy to `n12`? Jaki jest sens tej zmiennej?

```visualbasic
n12 = n1 ^ 2
n1n2 = n1 * n2
```

Widzimy już różnicę i widzimy, że to dwie osobne zmienne. Jednak, uważam że bardzo łatwo tutaj o pomyłkę. Przez chwilę uwagi można zamienić zmienną `n12` na `n1n2` i ciężko będzie znaleźć źródło błędu. Dodatkowo dalej nie znamy prawdziwego znaczenia tych zmiennych. Widzimy jak są tworzone, ale nie wiemy co oznaczają. Im więcej tego typu zmiennych w kodzie tym trudniej nam je wszystkie zapamiętać.

Jeżeli chcemy by w naszej aplikacji panowała dobra architektura, powinniśmy zacząć od czegoś małego. Powinniśmy zwracać uwagę na każdą najmniejszą linię naszego kodu. Tworzyć go w taki sposób, by jak najwięcej rzeczy było jasnych od samego początku, bez potrzeby dodatkowego tłumaczenia czy opisu. Łatwo jest zrobić bałagan w kodzie, trudniej każdego dnia dbać o jego jakość.

Dziękuję Ci za to, że tu jesteś i że chcesz pracować nad jakością swojego kodu. Podziel się swoimi myślami w komentarzach i do zobaczenia następnym razem!
