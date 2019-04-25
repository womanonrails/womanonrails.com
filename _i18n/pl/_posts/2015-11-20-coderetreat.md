---
layout: post
type: photo
title: Coderetreat 2015 Kraków
photo: coderetreat/session5.jpg
description: Coderetreat - szlifowanie warsztatu programistycznego
headline: My code is getting worse, please send more chocolate
categories: [warsztaty]
tags: [coderetreat]
place: Kraków
lang: pl
---

W zeszłą sobotę uczestniczyłam w niesamowitym wydarzeniu – [Global Day of Coderetreat](https://www.coderetreat.org/) w Krakowie. **Coderetreat** to szczególny dzień w roku, w którym programiści poświęcają swój czas nie tyle tworzeniu nowych funkcjonalności, ale skupiają się na **kodzie dobrej jakości**. Jest to dzień, w którym zatrzymujemy się na chwilę, by poświęcić czas na bycie lepszym programistą/programistką.

## Jak wygląda taki Coderetreat?

Cały dzień podzielony jest na 6-7 sesji kodowania. W naszym przypadku było ich dokładnie 6. W każdej z tych sesji staramy się rozwiązać problem [Gry w życie](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life). Jest to dość prosty problem, ale rozwiązanie go nie jest głównym celem Coderetreat. Ważniejszy jest sposób dojścia do rozwiązania. Każda sesja trwa 45 minut, po czym następuje 15 minut podsumowania tego, co zostało zrobione i w jaki sposób. Przez wszystkie sesje procujemy w trybie **ping pong pair porgramming** z narzuconymi pewnymi ograniczeniami. Pair programming ponieważ pracujemy w parach, ping pong bo zmieniamy się przy klawiaturze. Pierwsza osoba pisze test, druga pisze kod a później pierwsza robi refaktoryzację. Teraz nadszedł czas by powiedzieć coś na temat ograniczeń. Mogą być one na prawdę różne. Jedne są prostsze a inne trudniejsze. Poniżej zamieszczam Wam ograniczenia, jakie mieliśmy podczas naszych sesji.

1. **Bez typów prymitywnych** – opakuj wszystkie typy prymitywne i ciągi znaków

    W tej sesji nie można było przekazywać typów prostych pomiędzy klasami/obiektami. Każdy taki element musiał być otoczony bardziej złożonym obiektem. Na początku posiadanie takich prostych obiektów w projekcie jest przyjemne i łatwe. W przyszłości jednak, takie zachowanie może nas dużo kosztować, nie tylko czasu. Teraz wiem, że muszę się dwa razy zastanowić zanim zostawię taki prosty obiekt w swoim kodzie. Dodatkowo sesja ta był ciekawa jeszcze z jednego powodu. Miałam możliwość wymienienia się poglądami na ten temat z inną kobietą. Co jeszcze na razie w świecie IT jest luksusem ;]

2. **Programowanie funkcyjne**

    Nasz cały kod nie mógł być mutowalny, to znaczy że stanu obiektu nie mógł się zmieniać wewnątrz metody. Czy pamiętacie funkcje z matematyki? One zawsze dostawały jakiś argument i zwracały wartość. Tak było też podczas tej sesji. Dodatkowo tym razem ustawiałam sobie poprzeczkę jeszcze wyżej. Nie programowałam w Ruby ale w [LiveScript](https://livescript.net/). Było to moje pierwsze zetknięcie z tym językiem. Jest on bardzo podobny do [CoffeeScript](https://coffeescript.org/), więc ciekawie było go spróbować. Podczas tej sesji zwróciłam szczególną uwagę na to, jak prosto testuje się takie matematyczne metody. Wystarczy sprawdzić, co zostaje zwrócone dla konkretnych argumentów i koniec.

3. **Rozkazuj, nie proś** – brak właściwości, brak metod ustawiających i odczytujących pola obiektu (setter, getter)

    Tym razem nasze metody nie mogły pytać o dane, miały mówić obiektom co mają zrobić. Każda metoda nic nie zwracała. Taki kod jest bardzo ciężki do testowania. Obiekty są w tym przypadku jak czarne skrzynki – nie wiemy co się znajduje w środku. Kod jest enkapsulowany, czyli oddzielony od tego co jest na zewnątrz, obiekty zajmują się same sobą i niczym więcej. Była to dla mnie bardzo interesująca sesja, nie tylko ze względu na ograniczenie jakie otrzymaliśmy, ale również ze względu na programowanie w parze z programistą języka Java. Kiedy pracuje się w konkretnej technologi/języku zaczynamy myśleć przez pryzmat tego języka. Nasz mózg skupia się tylko na rozwiązaniu problemu w taki sposób, jaki oferuje nam język/technologia. Nawet nie wiemy, że obok jest inne rozwiązanie. Dlatego tak ważne jest ciągłe doskonalenie i rozwijanie swoich umiejętności, **wychodzenie poza strefę komfortu**. Jest to prawda nie tylko w programowaniu, ale także w życiu. Duże podziękowania i szacunek dla mojego programistycznego partnera, który ciągle chce się rozwija.

4. **3 minutowe cykle**

    W bieżącej sesji mieliśmy tylko 3 minuty by zakończyć jeden cykl TDD. Test, kod, refaktoring. Jeżeli nie udało nam się zakończyć całego cyklu, musieliśmy usunąć wszystko, co w tym cyklu zrobiliśmy i zacząć cykl od nowa. Ta sesja pozwoliła mi zrozumieć, że często w pracy chcemy od razu ogarnąć cały problem. Tworzymy ogrom jeszcze nie użytecznego kodu, tu trochę tam trochę, wszędzie panuje bałagan bo przecież “to nie jest jeszcze skończone”. Czasem jednak warto podejść do problemy za pomocą [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product) (Minimum Vable Product). Małe elementy, które działają już teraz. Tak było właśnie w tej sesji. Po każdych 3 minutach mieliśmy gotową działającą małą cząstkę oprogramowania. Malutką ale działającą.

5. **Brak pętli, brak warunków**

    Podczas tej sesji pisałam kod w [JavaScript ES6](http://es6-features.org/) (poza moją strefą komfortu). Tym razem nie mogliśmy używać ani warunków ani pętli. To była dla mnie najtrudniejsza sesja. Każdego dnia podczas pisania kodu wielokrotnie korzystamy z pętli i warunków. Nawet nie zdajemy sobie sprawy, jak często. Zamiast pętli można wykorzystać rekurencję tylko jak wyznaczyć warunek zatrzymania? To nie było takie trywialne. Bardzo przydało się w tym momencie myślenie całkowicie poza schematem. Sesja ta dała mi dużo do myślenia.

6. **Milcząca sesja**

    Ostatnia sesja nie pozwalała nam się ze sobą komunikować. Nie mogliśmy mówić, pisać ani pokazywać. Jedyna komunikacja jaka była dozwolona, to komunikacja testy – kod. Najciekawsze jest to, że każdego dnia się z tym spotykamy. Dostajemy jakiś fragment kodu do zmiany i nie mamy możliwości porozmawiania z osobą, która go napisała. Musimy domyślić się, co dany kod robi z testów (jeżeli takie są) i z tego jak jest napisany. Podczas tej iteracji pracowałam w parze z moim najlepszym przyjacielem. Oby dwoje myśleliśmy, że skoro tak długo i dobrze się znamy, to będzie to bułka z masłem. Ale gdy nie można sobie pewnych spraw wyjaśnić lub ustalić wspólnego planu działania nie jest tak łatwo. Każdy z nas miał inne spojrzenie na ten problem. Każdym myślał o nim w innym sposób. Tylko dobre, czytelne testy i dobrej jakości, przejrzysty kod mógł pomóc w tej sytuacji. To jest po protu coś o czym każdy programista powinien pamiętać.

<figure>
  <a href="{{ site.baseurl_root }}/images/coderetreat/first-session.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/first-session.jpg"></a>
</figure>
<figure class="third">
  <a href="{{ site.baseurl_root }}/images/coderetreat/summary.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/summary.jpg"></a>
  <a href="{{ site.baseurl_root }}/images/coderetreat/summary2.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/summary2.jpg"></a>
  <a href="{{ site.baseurl_root }}/images/coderetreat/summary3.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/summary3.jpg"></a>
</figure>
<figure>
  <a href="{{ site.baseurl_root }}/images/coderetreat/session5.jpg"><img src="{{ site.baseurl_root }}/images/coderetreat/session5.jpg"></a>
  <figcaption>Kilka wspomnień z tego krakowskiego Coderetreat</figcaption>
</figure>

<br>
I oto koniec. Nasza ostatnia sesja zakończona. Podsumowując ten dzień uważam, że to był dobrze zainwestowany czas. Wiele przemyśleń i nowe spojrzenie. Kolejny raz Coderetreat otworzył mi oczy i pokazał jak ważne jest dbanie o jakość kodu. Życzę każdemu wzięcia udziału w tym wydarzeniu, zwłaszcza tak dobrze przygotowanym jak w Krakowie. Do zobaczenia w krótce. Pa!
