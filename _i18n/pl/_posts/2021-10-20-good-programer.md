---
layout: post
photo: /images/programmers-skills/programmers-skills
title: Umiejętności przydatne w programowaniu
description: Co programistki i programiści powinni wiedzieć? Moja subiektywna opinia.
headline: Premature optimization is the root of all evil.
categories: [praca]
tags: [kariera, samoświadomość]
imagefeature: programmers-skills/og_image-programmer-skills.png
lang: pl
---

Często dostaje pytanie: _Co mam zrobić by stać się programistką/programistą?_ Oczekiwana odpowiedź to: przeczytaj tę książkę, naucz się tej technologii, zrób ten kurs. Osoby pytające chciały by znać prostą odpowiedź. Jak zrobisz to, to będziesz programistką/programistą. Niestety to nie takie proste. Oczywiście można skończyć studia informatyczne (ja tak zrobiłam), by czuć się w programowaniu pewniej, jednak studia nie są gwarancją bycia dobrą programistką lub programistą. Programowanie to jedna z tych dziedzin, które wymagają od nas ciągłego doskonalenia umiejętności, uczenia się nowych rzeczy i nowego spojrzenia na różne problemy. Myślę jednak, że są pewne uniwersalne umiejętności, które moim zdaniem przydają się przy pracy z kodem. Chciałabym się nimi z Tobą podzielić.

## Dokładność

Jak już wpada się w wir pracy, to zawsze jest coś do zrobienia. Wszystko jest ważne, ma wysoki priorytet. To powoduje, że robimy za dużo rzeczy w tym samym czasie. Utrudnia nam to <a href="{{ site.baseurl }}/how-to-focus" title="Jak się skupić?">skupienie</a> i źle wpływa na jakość wykonywanego zadania. Nowe funkcjonalności nie są do końca zrobione lub koncentrujemy się tylko na głównej ścieżce (happy path) nie uwzględniając np. błędów. Warto się tutaj zatrzymać. Kiedy zaczynamy robić jakieś zadanie, to 100% naszego skupienia powinno być właśnie na tym zadaniu od początku do końca. To my odpowiadamy za dobre wykonanie zadania. Pomocna może się okazać lista TODO, czyli lista rzeczy, które należy sprawdzić, uwzględnić przed zakończeniem zadania. Część z tych rzeczy będzie wspólna dla wielu zadań. Inne będą bardzo specyficzne dla konkretnego problemu. By ułatwić sobie pracę możemy odpowiedzieć na następujące pytania:
- Czy ta funkcjonalność robi dokładnie to co powinna?
- Czy kod jest sprawdzony? (Code review)
- Czy funkcjonalność jest przetestowana? (testy automatyczne, QA)
- Czy spełniamy standardy wyznaczone dla naszego kodu? (lintery)
- Czy uwzględniamy wszystkie możliwe przypadki/problemy?
- Jak dbamy o obsługę błędów (zły format danych, brakujące parametry)?
- Czy obsługujemy autoryzację lub uwierzytelnianie?
- Czy nazwy jakich używamy są znaczące? (nazwy plików, zmiennych, metod, itd.)

To dobre pytania by zacząć ustalać sobie standardy jakie musi spełnić przygotowywana funkcjonalność czy fragment kodu. Najważniejsze jest by zadbać o dobrą jakość. Nie chodzi o to by wszystko było idealne, tak się nie da, ale by spełniało nasze kryteria akceptacyjne dotyczące kodu, architektury czy użyteczności.

## Zaangażowanie

Kiedy zaczynasz jakieś zadanie, jesteś za nie w pełni odpowiedzialna. Oczywiście możesz prosić o pomoc, umówić się na sesje wspólnego programowania (pair programming) czy omówienie architektury, jednak koniec końców to Ty odpowiadasz za dostarczenie gotowego rozwiązania. Ty odpowiadasz za szukanie rozwiązania, jakość kodu, dobre zrozumienie zadania czy obsłużenie wszystkich wyjątkowych sytuacji. Twoi koledzy i koleżanki mogą Cię wspierać, ale to Ty powinnaś wziąć odpowiedzialność za przypisane do Ciebie zadanie od przygotowania propozycji rozwiązania aż do wypuszczenia nowej wersji na produkcję. Wiem, że istnieją różne zespoły. Jedne dają więcej autonomii, inne miej. Jedne osoby bardziej się specjalizują, a inne mają szeroką wiedzę i umiejętności. Nie zmienia to faktu, że odpowiadasz za zadanie nad którym pracujesz. Najgorszą rzeczą jaką możesz zrobić to przerzucić odpowiedzialność na inne osoby. Mówiąc coś w stylu: _To nie jest moja odpowiedzialność, to oni powinni się tym zająć._ Wiem, że branie na siebie odpowiedzialności jest trudne i wymaga od nas więcej zaangażowania, ale to też powoduje największy wzrost naszych umiejętności. Trzeba naprawić style na stronie? Inni, którzy się w tym specjalizują są zajęci? Ja chce dokończyć zadanie, czemu więc nie spróbować tego zrobić? Może zajmie to trochę więcej czasu, ale zadanie będzie już ukończone.

## Samodzielność

Kiedy pojawia się problem, umiejętność poradzenia sobie z nim samodzielnie to duży plus. Czasem jest to proste. Wystarczy znaleźć coś w dokumentacji. Czasem jednak może sprawić kłopot. Wtedy przydają się umiejętności samodzielnego szukania rozwiązań czy informacji: forum internetowe, artykuły czy StackOverflow. Najczęściej rozwiązanie naszego problemu już istnieje i trzeba je tylko znaleźć. Nie chodzi mi o to, że nie możemy szukać pomocy u naszych koleżanek czy kolegów w pracy. Warto jednak samodzielnie poszukać rozwiązania zanim zajmiemy komuś czas.

## Komunikacja

To duży temat, zwłaszcza w zespołach pracujących zdalnie. Cel to komunikować się pro-aktywnie. Innymi słowy: _Tell, don't ask._ Mów co się dzieje tak by inni nie musieli pytać, by mieli już tą informację. Podsumuj co zrobiłaś danego dnia, opisz jakie były problemy, na co trzeba zwrócić uwagę. Umieść to w jednej dłuższej opisowej wiadomości, zamiast w 10 mniejszych. To znacznie mniej rozprasza innych podczas pracy. W takiej wiadomości, nie musisz się rozdrabniać, ale warto zaznaczyć ogólny wygląd sytuacji. Jednak komunikacja to nie tylko wiadomości, to też sposób w jaki piszemy kod, jaką mamy <a href="{{ site.baseurl }}/names-have-meaning" title="Jak tworzyć lepsze nazwy w kodzie?">konwencję nazewniczą</a>, jak używamy git-a, jak opisujemy Pull Request, zadania, problemy czy błędy. Istotne jest to, by opisywać rzeczy tak, że nawet po kilku miesiącach czy latach wiemy o co chodziło. Czytasz opis i nie potrzebujesz pytać o dodatkowe informacje.

## Dociekliwość

Coś w kodzie nie działa, albo właśnie działa a Ty nie wiesz dlaczego? To dobre miejsce by się zatrzymać i sprawdzić. Może właśnie znalazłaś błąd, a może nauczysz się czegoś o działaniu aplikacji. Im więcej pytań zadajesz, tym lepiej znasz system z którym pracujesz. Co również przekłada się na poprawę jego jakości. Taka dociekliwość nie jest łatwa i też nie zawsze jest na nią czas, ale możesz się dzięki niej wiele nauczyć.

## Logiczne/analityczne myślenie

Nic w programowaniu nie działa magicznie. Na wszystko jest wytłumaczenie, choć nie zawsze widoczne na pierwszy rzut oka. To dlatego logiczne myślenie jest tak ważne. Dzięki niemu jesteś w stanie zrozumieć co Twój program robi i dlaczego. Świadomie pomijam tu dziedziny takie jak uczenie maszynowe, gdzie zrozumienie jak działa program jest bardziej skomplikowane.

#### Dodatkowe przydatne umiejętności

Na koniec, chciałabym podzielić się jeszcze kilkoma wskazówkami, które mogą pomóc Ci w podszkoleniu programistycznych umiejętności:
- <a href="{{ site.baseurl }}/what-is-git" title="Czym jest Git?">nauka narzędzia Git</a> - Git to bardzo przydatne narzędzie, pozwalające przechowywać Ci całą historię zmian Twojego projektu. Umiejętność posługiwania się tym narzędziem może znacznie przyśpieszyć Twoją pracę. Jeżeli chcesz dowiedzieć się więcej o narzędziu Git, polecam moją <a href="{{ site.baseurl }}/kategoria/git" title="Artykuły na temat narzędzia Git">serię artykułów</a> na ten temat.
- <a href="{{ site.baseurl }}/tdd-basic" title="Test-Driven Development dla początkujących">nauka testowania</a> - Wiem, są zespoły w których istnieją całe działy zajmujące się testowaniem oprogramowania. To jednak nie zwalnia Ciebie jako programistki/programisty z pisania własnych testów automatycznych przynajmniej do kodu, który sama piszesz. Testy znacznie przyśpieszają możliwość weryfikacji poprawnego działania systemu już od najmniejszych jego elementów. Takie testy początkowo mogą dokładać dodatkową pracę, ale szybko się zwracają gdy system zaczyna się powiększać.
- nauka wzorców projektowych - Posiadanie wiedzy o wzorcach projektowych w znacznym stopniu ułatwia porozumiewanie się w zespole. Daje Wam dodatkowy język, dodatkową warstwę abstrakcji dzięki której szybciej możecie ustalić co dokładnie macie na myśli. Nie musicie wszystkiego wyjaśniać, wystarczy powiedzieć _Użyjmy tutaj <a href="{{ site.baseurl }}/mvc-design-pattern" title="Wprowadzenie do wzorca projektowego Model-View-Controller">MVC</a>_ i wszyscy wiedzą co to oznacza. Wszyscy znający ten wzorzec projektowy.
- używaj **linterów** - Kiedy zaczynasz programować w nowym języku lub w nowym projekcie, reguły dotyczące formatowania kodu mogą być na początku przytłaczające. Trudno je spamiętać. W takiej sytuacji przydają się lintery. Nie tylko sprawdzą czy nasz kod jest zgodny z przyjętym standardem, ale często potrafią też samodzielnie poprawić formatowanie.
- używaj skrótów klawiszowych - to znacznie przyśpieszy Twoją pracę. Zamiast przełączać się z myszki na klawiaturę, z klawiatury na myszkę najważniejsze funkcję będą w zasięgu Twoich palców. Wiele narzędzi posiada swoje własne skróty klawiszowe: przeglądarki, <a href="{{ site.baseurl }}/visual-studio-code" title="Visual Studio Code - skróty klawiszowe">edytory tekstu</a> czy <a href="{{ site.baseurl }}/guake-terminal" title="Guake terminal - skróty klawiszowe">terminale</a>.
- popraw swoje środowisko pracy - By przyśpieszyć swoją pracę warto zautomatyzować powtarzalne czynności pisząc własne skrypty czy skróty/aliasy, tak by skupić się na pracy kreatywnej a nie na automatycznych zadaniach.
- zadbaj o swój angielski - Język angielski jest bardzo ważny zwłaszcza w komunikacji. Zazwyczaj dokumentacja, fora czy artykuły związane z IT są napisane właśnie w tym języku. Dodatkowo dobrą praktyką jest utrzymywanie dokumentacji projektu w języku angielskim. To ułatwia wprowadzanie nowych osób do projektu, gdy nie mówią w Twoim języku. Angielski to pewien standard w IT.

## Przydatne książki
- {% include books/pl/pragmatic_programmer-andrew_hund_david_thomas.html %}
- {% include books/pl/refactoring-martin_fowler.html %}
- {% include books/pl/clean_code-robert_martin.html %}
- {% include books/pl/design_patterns_in_ruby-russ_olsen.html %}
- {% include books/pl/test_driven_development-ken_beck.html %}
- {% include books/pl/practical_object_oriented_design_in_ruby-sandi_metz.html %}
