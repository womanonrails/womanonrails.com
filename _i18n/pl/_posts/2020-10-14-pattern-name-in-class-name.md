---
excerpt: >
  W jednym z moich ostatnich artykułów pisałam na temat
  [poprawiania czytelności nazw w projekcie](/pl/names-have-meaning "Jak tworzyć nazwy, które mają znaczenie? 13 sposobów na poprawienie czytelności nazw.").
  Jednym ze sposobów, o którym pisałam było **powiedz jakiego wzorca używasz**.
  Jakiś czas później przeczytałam newsletter od Sandi Metz
  > _"Don't Name Classes After Patterns. Mostly"_.
  Sandi przedstawia tam inny punkt widzenia na używanie nazw wzorców w nazwach klas, z małym wyjątkiem.
  Myślę, że to dobry temat by na chwilę się nad tym zastanowić.
  W programowaniu nie ma jednej złotej zasady, jak tworzyć nazwy.
  Są wskazówki, jak to robić, ale one maja nam tylko pokazać drogę.
  Nie są jedynym źródłem prawdy.
  Każde rozwiązanie ma swoje wady i zalety,
  dlatego dobrze mieć szerszą perspektywę na problem z jakim się mierzymy.
layout: post
photo: /images/pattern-name-in-class-name/pattern-name-in-class-name
title: Nazwa wzorca w nazwie klasy. Dobra czy zła praktyka?
description: Czy warto używać nazwy wzorca w nazwie klasy?
headline: Premature optimization is the root of all evil.
categories: [refaktoring]
tags: [refaktoring]
imagefeature: pattern-name-in-class-name/og_image-pattern-name-in-class-name.jpg
lang: pl
---

W jednym z moich ostatnich artykułów pisałam na temat [poprawiania czytelności nazw w projekcie]({{site.baseurl}}/names-have-meaning "Jak tworzyć nazwy, które mają znaczenie? 13 sposobów na poprawienie czytelności nazw."). Jednym ze sposobów, o którym pisałam było **powiedz jakiego wzorca używasz**. Jakiś czas później przeczytałam newsletter od Sandi Metz _"Don't Name Classes After Patterns. Mostly."_. Sandi przedstawia tam inny punkt widzenia na używanie nazw wzorców w nazwach klas, z małym wyjątkiem. Myślę, że to dobry temat by na chwilę się nad tym zastanowić. W programowaniu nie ma jednej złotej zasady, jak tworzyć nazwy. Są wskazówki, jak to robić, ale one maja nam tylko pokazać drogę. Nie są jedynym źródłem prawdy. Każde rozwiązanie ma swoje wady i zalety, dlatego dobrze mieć szerszą perspektywę na problem z jakim się mierzymy.

Zacznijmy od mojej sugestii by _mówić jakiego wzorca się używa_. Dalej uważam, że nazwa wzorca może dać nam dodatkową informacje, która pozwoli lepiej zrozumieć architekturę. Kiedy mamy klasę `User` i stworzymy `UserDecorator` od razu wiemy, co to za wzorzec. Wiemy, że `UserDecorator` to `User` z jakimś dodatkowym lub zmienionym zachowaniem. Ta nazwa pokazuje nam, jaką decyzję architektoniczną podjęłyśmy. Myślę, że jeśli chcemy zwrócić uwagę właśnie na architekturę to taka nazwa jest OK. Nazwy wzorców są po to, by pomóc nam, jako programistom, komunikować się w szybki i precyzyjny sposób. Ponieważ wzorce mają dla nas znaczenie, więc dodajemy je do nazw klas.

Z drugiej strony mamy zasadę Sandi Metz dotyczącą _nie używania nazw wzorców w nazwach klas_. Za tym podejściem przemawiają następujące argumenty:
  - Dodanie nazwy wzorca do nazwy klasy zaśmieca domenę biznesową programistycznymi terminami, nie związanymi z samą domeną.
  - Wzorzec powie nam w jaki sposób coś zostało stworzone a nie w jakim celu. Nie będziemy wiedzieć czym dana klasa jest lub czym się zajmuje.
  - Użycie nazwy wzorca sprawia wrażenie jakbyśmy się starały przy tworzeniu nazwy klasy, wcale tego nie robiąc.
Patrząc z tej perspektywy używanie nazwy wzorca w nazwie klasy nie wygląda już tak dobrze i może być problematyczne.

Myślę, że te argumenty dość dobrze opisują dlaczego tak nie powinnyśmy robić. Od razu pojawia się w mojej głowie czerwone światełko i pytanie: _Czy wystarczająco postarałam się przy stworzeniu tej nazwy klasy?_ Może zamiast `UserDecorator` bardziej odpowiednia byłaby nazwa `AdminUser`. Ta nazwa o wiele lepiej wskazuje nam czym klasa `AdminUser` jest, sugerując też czym będzie się zajmować. Nie mówi natomiast jak została zbudowana, co pozwala w przyszłości zmienić jej wewnętrzną implementację bez konieczności zmiany nazwy.

Ale to nie koniec. Pomimo tego, że w większości zgadzam się z nieużywaniem nazw wzorów w nazwach klas, to są sytuacje, gdzie i tak sięgnęłabym po nazwę wzorca. Zaczęłam się, więc przyglądać gdzie i kiedy bym tak zrobiła. Po pierwsze, nie zmieniałabym konwencji przyjętej w Railsach czy innych gemach bądź bibliotekach. Dostosowałabym się do tego, co jest tam już używane. Jeżeli według konwencji w mojej aplikacji pojawiłaby się klasa `UserController`, to nie będę jej zmieniać tylko dlatego by nie mieć nazwy wzorca w nazwie klasy. Po drugie, są też klasy, gdzie mogłabym się zdecydować na użycie wzorca w nazwie. Przykładem może być fabryka (ang. Factory). W tym przypadku zadaniem klasy jest właśnie produkowanie innych obiektów. Choć dobrze by było uwzględnić kontekst w jakim ta klasa jest tworzona zanim zdecydujemy się na konkretną nazwę. Natomiast w przypadku klasy implementującej wzorzec adapter, raczej skupiłabym się na tym dla jakiej klasy jest ta klasa adapterem niż na samym fakcie bycia nim. Kiedy dobrze znamy domenę to jesteśmy w stanie używać tych samych nazw jakie używa klient. Nie ma konieczności wymyślania nazw na podstawie użytych wzorców.

Myślę, że używanie nazw wzorców w nazwach klasy można potraktować jako stan miedzy kiepską nazwą, która niewiele wnosi, a nazwą, która oddaje sens danej klasy. Nazwa z nazwą wzorca nie jest idealna, ale daje nam jakąś informację. Czasami, gdy nie jesteśmy jeszcze pewne czym dana klasa będzie, można sięgnąć po nazwę wzorca. Trzeba jednak pamiętać, że **nazwa klasy może, a nawet powinna się zmienić**. Dostosować do zmieniającego się otoczenia. Często o tym zapominamy i kończymy w miejscu, gdzie już dawno nazwa klasy nie odzwierciedla celu jej istnienia. A przecież to dość prosta zmiana do wprowadzenia. Większość obecnych IDE czy edytorów tekstu ma możliwość zamiany nazwy we wszystkich miejscach za pomocą kilku kliknięć. **Nazwa nie jest czymś stałym, powinna się zmienić kiedy nie spełnia już swojego celu.**

Podsumowując, nie ma złotego środka na nazywanie klas, metod czy zmiennych. Są oczywiście pewne zasady, które mogą pomóc zaoszczędzić nam czas, pieniądze, nauczyć się na czyichś błędach lub po prostu zapobiec własnym błędom. Warto brać je pod uwagę, ale na koniec dnia to my podejmujemy decyzję i to my musimy się liczyć z jej konsekwencjami. Daj znać co myślisz na ten temat. Czy używasz nazw wzorców w nazwach klas? Kiedy ich używasz, a kiedy nie? Zostaw swój komentarz poniżej.
