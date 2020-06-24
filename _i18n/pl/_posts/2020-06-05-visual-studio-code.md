---
layout: post
photo: /images/visual-studio-code/visual-studio-code
title: Visual Studio Code - edytor tekstowy
description: Moje ulubione skróty klawiszowe
headline: Premature optimization is the root of all evil.
categories: [narzędzia]
tags: [IDE, edytor tekstowy]
imagefeature: visual-studio-code/og_image-visual-studio-code.png
lang: pl
---

Jakiś czas temu napisałam artykuł o <a href="{{ site.baseurl }}/sublime" title="Sublime Text edytor - przydatne funkcjonalności">edytorze tekstu Sublime Text</a>. O tym jak bardzo lubię to narzędzie i dlaczego. Jednak czas płynął i po kilku latach używania pewne rzeczy przestały działać tak dobrze jak na początku. Zaczęłam szukać innego rozwiązania. Takiego, które da mi to czego zaczęło brakować mi w Sublime Text. Znalazłam takie narzędzie - to **Visual Studio Code**. Darmowe, udostępnione jako Open Source narzędzie do edycji tekstu, ale nie tylko. VS Code to narzędzie, które łączy najczęściej używane przez programistów funkcjonalności/narzędzia w jedno. Jest czymś pomiędzy zwykłym edytorem, a IDE. To właśnie o VS Code chciałabym Ci dziś trochę powiedzieć.

## Dlaczego nie używam już Sublime Text edytora?

Jak już wspomniałam na wstępie bardzo lubiłam to narzędzie. Jednak z czasem, gdy aplikacje nad którym pracowałam zaczęły być coraz większe, a dodatkowo wszystkie uruchamiałam w dockerowych kontenerach okazało się, że Sublime nie radzi sobie z tym wyzwaniem zbyt dobrze. Po prostu zamarza. Zatrzymuje swoje działanie i przez dłuższą chwilę nie odpowiada na żądania. Na początku były to pojedyncze, sporadyczne sytuacje, ale z czasem wszystko zaczęło się pogarszać. Niestety nie dało się już na nim pracować. Dodatkowo ten brak odpowiedzi ze strony Sublime rozwalał całkowicie moje flow. Podjęłam decyzję, że nie ma na co czekać, trzeba znaleźć inne narzędzie, które udźwignie moje projekty. Znalazłam.

## Co lubię w VS Code?

Przyznam szczerze, że gdy szukałam nowego edytora tekstu, szukałam czegoś podobnego do edytora Sublime Text. Szukałam narzędzia, które posiada te wszystkie fajne cechy, za które ceniłam Sublime Text. Taki właśnie jest Visual Studio Code. A oto kilka cech, jakie posiada:

1. **Mogę podzielić okno edytora na tyle paneli ile potrzebuję** - bardzo przydatna funkcjonalność. W większości przypadków wystarczają mi dwa panele poziome. W jednym mam otwarty kod, a w drugim pisane przeze mnie testy. Bardzo to ułatwia i przyśpiesza <a href="{{ site.baseurl }}/tdd-basic" title="Jak programować używając TDD?">pisanie kodu sterowanego testami (TDD)</a>.

2. **VS Code w linii poleceń** - VS Code ma swoje własne komendy dla wiersza poleceń (CLI), które ułatwiają dostosowanie edytora do bieżących potrzeb. Dzięki temu można VS Code otworzyć w różnych kontekstach dla wielu projektów/folderów. Wszystkie ustawienia zostają zachowane. Przyśpiesza to znacząco pracę. Nie trzeba kolejny raz otwierać potrzebnych plików czy katalogów, ustawiać języka programowania czy konfiguracji paneli. Wszystko jest tak ustawione w danym projekcie jak zostawiłyśmy to przy ostatnim użytkowaniu. Poniżej przedstawiam najczęściej wykorzystywana przez mnie polecenia:

    - `code .` - otwiera VS Code w bieżącym katalogu z zachowaniem poprzednich ustawień
    - `code --diff <file1> <file2>` - otwiera edytor do porównywania plików
    - `code --goto package.json:10:5` - otwiera plik w konkretnej linii i kolumnie `<file:line[:character]>`

3. **Wszystko można dostosować do swoich potrzeb** - gdy chcesz zmienić jakieś ustawienia użyj skrótu klawiszowego `Ctrl + ,`, pozwoli Ci on przeglądać i modyfikować ustawienia w jednym miejscu. Można to zrobić dla konkretnego środowiska pracy lub dla użytkownika.

4. **Dodatki i rozszerzenia** - VS Code ma bardzo dużo przydatnych narzędzi domyślnie wbudowanych w edytor np. Emmet, Terminal, Debugger, czy Git. Jeżeli jednak są jeszcze jakieś funkcjonalności, które lubisz używać a VS Code nie posiada ich domyślnie, to wystarczy znaleźć odpowiednie rozszerzenie/dodatek. Muszę tu przyznać, że jest ich naprawdę sporo. Oto te, których sama używam:

    - **Code Spell Checker** - Rozszerzenie do sprawdzania podstaw ortografii kodu zapisanego w camelCase.
    - **Spell Right** - Narzędzie do sprawdzania ortografii w różnych językach.
    - **GitLens** - Git supercharged - Dodatkowe wsparcie dla obsługi Gita w VS Code. Pozwala na przeglądanie historii zmian bezpośrednio z poziomu konkretnych linii kodu w edytorze.
    - **JSON Tools** - Dodatek służący do manipulacji sposobem zapisu danych typu JSON. Istnieje możliwość czytelnego sformatowania danych lub ich minifikacji.
    - **Markdown Preview Enhanced** - Pozwala na podgląd zmian w plikach typu markdown w czasie rzeczywistym.
    - **ruby-rubocop** - Rubocop dla VS Code.
    - **Slim** - Wsparcie dla Slim.
    - **Sort lines** - Rozszerzenie do sortowania linii.

5. **Skróty klawiszowe** - ❤️ Uwielbiam skróty klawiszowe. Pozwalają mi skupić się na tym co mam zrobić, a nie na tym jak mam to zrobić. Nie muszę przeskakiwać z klawiatury na myszkę i z powrotem. Co pozwala mi łatwiej wpaść w flow. Zanim jednak przejdę do listy moim zdaniem najbardziej przydatnych skrótów klawiszowych w VS Code chciałabym jeszcze wspomnieć o dwóch rzeczach. Po pierwsze **keymaps**, czyli możliwość zaimportowania sobie do VS Code skrótów klawiszowych z innych edytorów tekstu. Jeżeli jesteś przyzwyczajona do skrótów z innego edytora, to dzięki keymaps możesz ustawić tak VS Code by korzystał z tych samych skrótów klawiszowych. Druga sprawa to możliwość własnoręcznej zmiany skrótów za pomocą `Ctrl + K Ctrl + S`. Dzięki temu będziesz mieć dostęp do listy skrótów klawiszowych, które możesz nie tylko przeglądać, ale też edytować.

### Lista skrótów klawiszowych

Postanowiłam nauczyć się domyślnych skrótów klawiszowych z VS Code. Oto moje ulubione:

#### Zarządzanie panelami, oknami i paskami bocznymi
- `Ctrl + B` - włącza/wyłącza panel boczny (możesz tam znaleźć listę katalogów, okno wyszukiwania czy panel do zarządzania rozszerzeniami)
- `Ctrl + Shift + X` - panel do wyszukiwania nowych rozszerzeń oraz listy rozszerzeń już zainstalowanych
- `Ctrl + Shift + E` - panel z listą katalogów i plików
- `Crtl + J` - włącza/wyłącza panel dolny (możesz tam znaleźć listę błędów, terminal czy narzędzia developerskie do debugowania)
- `Ctrl + Shift + M` - pokazuje panel z błędami i ostrzeżeniami dotyczącymi bieżącego kontekstu
- `F8` - przechodzi do następnego błędu (gdy dolny panel z błędami jest otwarty)
- `Shift + F8` - przechodzi do poprzedniego błędu (gdy dolny panel z błędami jest otwarty)
- <code class='language-plaintext highlighter-rouge'>Ctrl + `</code> - otwiera terminal w dolnym panelu
- `Ctrl + 0` - przechodzi do panelu bocznego (jeżeli znajduje się tam lista katalogów i plików za pomocą strzałek można poruszać się po niej, naciskając `enter ↩` otwierany jest plik w oknie głównym i przenoszony jest tam kursor)
- `Ctrl + 1,2,3,4` - przenosi kursor pomiędzy panelami wewnątrz okna głównego (w zależności od wybranej liczby paneli)
- `Ctrl + PgUp, PgDn` - przechodzi do poprzedniej/następnej zakładki/pliku
- `Ctrl + Shift + T` - otwiera ostatni zamknięty plik/tab (tak jak w przeglądarce)
- `Ctrl + \` - dzieli bieżące okno na dwa osobne panele
- `Ctrl + N` - otwiera nową zakładkę/plik
- `Ctrl + O` - otwiera wybrany istniejący plik
- `Ctrl + Shift + N` - otwiera nowe okno
- `Ctrl + W` - zamyka bieżący plik/zakładkę
- `Ctrl + K Ctrl + ←` - przechodzi do poprzedniej grupy/poprzedniego panelu
- `Ctrl + K Ctrl + →` - przechodzi do następnej grupy/poprzedniego panelu
- `Ctrl + Shift + PgUp` - przesuwa bieżącą zakładkę w lewo wewnątrz panelu/grupy
- `Ctrl + Shift + PgDn` - przesuwa bieżącą zakładkę w prawo wewnątrz panelu/grupy
- `Ctrl + K ←, →` - przenosi bieżący panel/grupę na lewą/prawą stronę
- `Ctrl + K ↑, ↓` - przenosi bieżący panel/grupę na górę/dół

#### Nawigacja
- `Ctrl + G` - pozwala na przejście do linii o wybranym numerze
- `Ctrl + R` - szybkie otwieranie ostatnio używanych plików i folderów
- `Ctrl + P` - pozwala na szybkie wyszukanie i otwarcie pliku w projekcie (można wyszukiwać nawet po pierwszych literach każdego członu nazwy przykładowo wpisując `mnf` można znaleźć plik `my_new_file.txt`), kiedy użyjesz `→` możesz otworzyć wiele plików
- `Ctrl + T` - wyszukuje wybranego symbolu (funkcji, metody, klasy) w projekcie
- `Ctrl + Shift + O` - wyszukuje wybranego symbolu (funkcji, metody, klasy) w pliku, możesz grupować symbole dodając przecinek i `@:`

#### Historia nawigacji
- `Ctrl + Tab` - przeglądanie całej historii, wybieranie następnego pliku z bieżącego panelu
- `Ctrl + Shift + Tab` - przeglądanie całej historii, wybieranie poprzedniego pliku z bieżącego panelu
- `Ctrl + Alt + -` - nawiguje wstecz
- `Ctrl + Shift + -` - nawiguje do przodu

#### Format JSON
- `Ctrl + Alt + M` - pokazuje w czytelny sposób pliki w formacie JSON dzięki dodatkowi JSON Tools
- `Alt + M` - minifikuje pliki w formacie JSON dzięki dodatkowi JSON Tools
- `Ctrl + Shift + I` - pokazuje w czytelny sposób pliki w formacie JSON, obsługiwane domyślnie przez VS Code, by skrót zadziałał trzeba ustawić format pliku na JSON

#### Format Markdown (rozszerzenie Markdown Preview Enhanced)
- `Ctrl + Shift + V` - otwiera podgląd dla formatu Markdown
- `Ctrl + K V` - otwiera możliwość podglądu dla formatu Markdown w panelu obok (pozwala obserwować zmiany w czasie rzeczywistym)
- `Ctrl + Shift + S` - synchronizacja z podglądem formatu Markdown

#### Kursor w wielu liniach
- `Shift + Alt + ↑, ↓` - dodaje kursor do linii powyżej/poniżej bieżącej linii
- `Ctrl + Shift + ↑, ↓` - dodaje kursor do linii powyżej/poniżej bieżącej linii
- `Ctrl + Shift + L` - dodaje dodatkowe kursory do wszystkich linii wybranej sekcji
- `Ctrl + U` - usuwa/cofa ostatnio dodany kursor
- `Shift + Alt + I` - dodaje kursor na koniec każdej zaznaczonej linii
- `Ctrl + ←, →` - przechodzi na początek/koniec słowa

#### Wielokrotne zaznaczenia
- `Ctrl + D` - zaznacza słowo (powtarzając ten sam skrót klawiszowy można zaznaczyć kolejne wystąpienia tej samej frazy, a później je równocześnie edytować)
- `Ctrl + F2` - zaznacza wszystkie wystąpienia bieżącego słowa
- `Ctrl + A` - zaznacza cały plik
- `Ctrl + L` - zaznacza całą linię
- `Shift + Alt` - podczas przeciągania myszy (analogicznie jak robimy to przy zwykłym zaznaczaniu tekstu z pomocą myszy) zaznacza kolejne kolumny/bloki, a nie całe linie
- `Ctrl + Shift + ←, →` - zaznacza poprzednie/następne słowo

#### Wcięcia
- `Ctrl + ]` - dodaje wcięcie do zaznaczonych linii
- `Ctrl + [` - usuwa wcięcie z zaznaczonych linii
- `Tab` - kiedy kursor jest na początku linii dodaje wcięcie
- `Tab + Shift` - kiedy kursor jest na początku linii usuwa wcięcie
- `Ctrl + Shift + I` - formatuje plik według standardu wybranego języka programowania lub typu danych

#### Edycja tekstu
- `F9` - porządkuje linie w kolejności alfabetycznej dzięki rozszerzeniu Sort lines
- `Alt + ↑, ↓` - przesuwa wybraną linię w górę/dół
- `Ctrl + ↩` - dodaje dodatkową linię poniżej nawet jak kursor jest na środku bieżącej linii
- `Ctrl + Shift + D` - powiela wybrane linie (jest to mój własny skrót klawiszowy, który dodałam do VS Code), gdy używasz systemu innego niż Ubuntu powinien automatycznie działać Ci skrót klawiszowy `Ctrl + Shift + Alt + ↑, ↓`, w Ubuntu jest to systemowy skrót klawiszowy do przesuwania okien pomiędzy wirtualnymi pulpitami
- `Ctrl + C` - kopiuje zaznaczony tekst lub całą linię (jeżeli tekst nie był zaznaczony) do schowka
- `Ctrl + V` - wkleja tekst lub linię ze schowka
- `Ctrl + X` - usuwa zaznaczony tekst lub linię i umieszcza w schowku
- `Ctrl + Z` - cofa ostatnie zmiany
- `Ctrl + Shift + Z` - przywraca ostatnie zmiany
- `Ctrl + Y` - przywraca ostatnie zmiany
- `Ctrl + Backspace` - usuwa poprzednie słowo (nie dodaje do schowka)
- `Ctrl + Delete` - usuwa następne słowo (nie dodaje do schowka)
- `Ctrl + Shift + K` - usuwa całą linię (nie dodaje do schowka)
- `Ctrl + K Ctrl + X` - usuwa dodatkowe białe znaki

#### Programowanie
- `Crtl + /` - zakomentuje/odkomentuje fragment kodu (odpowiednio w zależności od wybranego języka programowania)
- `Ctrl + K  Ctrl + L` - otwiera/zamyka sekcję/wcięcie w kodzie
- `Ctrl + Shift + \` - zaznacza pasujące do siebie nawiasy

#### Wyszukiwanie i zamiana
- `Ctrl + F` - szuka wybranej frazy w bieżącym pliku
- `F3` - przechodzi do następnej znalezionej frazy
- `F3 + Shift` - przechodzi do poprzedniej znalezionej frazy
- `Ctrl + H` - zastępuje wybraną frazę inną w bieżącym pliku
- `Ctrl + Shift + F` - wyszukuje daną frazę w całym projekcie
- `Ctrl + Shift + H` - zastępuje wybraną frazę inną w całym projekcie

#### Inne
- `Ctrl + ↑,↓` - przesuwa plik w górę/dół (zachowanie podobne do scrolla w myszy)
- `Ctrl + S` -  zapisuje plik
- `Ctrl + K M` - wybór języka programowania
- `Ctrl + K P` - kopiuje ścieżkę bieżącego pliku do schowka
- `F2` -  zmienia nazwę symbolu (pliku, klasy, metody) np. nazwę pliku w bocznym panelu
- `Ctrl + Shift + P` - paleta komend (Command Palette), daje dostęp do wszystkich możliwych poleceń w bieżącym kontekście

