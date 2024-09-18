---
excerpt: >
  Na początku roku 2021 kupiłam klawiaturę **Logitech G915 TKL**.
  Klawiatura ta współpracuje z systemem operacyjnym Windows
  i oprogramowaniem Logitech G Hub.
  Ma wiele możliwości personalizacji, co trzeba przyznać sprawia frajdę.
  Problem pojawia się gdy klawiaturę Logitech G915 TKL chce się użyć z Linuxem.
  Nie działa tam oprogramowanie G Hub.
  W tym artykule pokaże jak, przynajmniej częściowo,
  skonfigurować klawiaturę Logitech G915 TKL używając Linuxa, a dokładnie Ubuntu.
layout: post
photo: /images/logitech-g915-tkl/logitech-g915-tkl
title: Klawiatura Logitech G915 TKL używana z Ubuntu
description: Jak skonfigurować klawiaturę Logitech G915 TKL na Linuksie?
headline: Premature optimization is the root of all evil.
categories: [narzędzia]
tags: [klawiatura]
imagefeature: logitech-g915-tkl/og_image-logitech-g915-tkl.png
lang: pl
last_modified_at: 2021-10-06 15:00:00 +0200
---

Na początku roku 2021 kupiłam klawiaturę **Logitech G915 TKL**. Klawiatura ta współpracuje z systemem operacyjnym Windows i oprogramowaniem Logitech G Hub. Ma wiele możliwości personalizacji, co trzeba przyznać sprawia frajdę. Problem pojawia się gdy klawiaturę Logitech G915 TKL chce się użyć z Linuxem. Nie działa tam oprogramowanie G Hub. W tym artykule pokaże jak, przynajmniej częściowo, skonfigurować klawiaturę Logitech G915 TKL używając Linuxa, a dokładnie Ubuntu.

Na początku chciałabym zaznaczyć, że to nie będzie recenzja klawiatury Logitech G915 TKL. Nie będę mówić tu o jej właściwościach, zaletach czy wadach. Powiem tylko, że Logitech G915 TKL to bezprzewodowa, mechaniczna klawiatura gamingowa z podświetleniem RGB i niskim profilem przełączników. W moim przypadku to przełączniki liniowe. Jeszcze jedna uwaga. Używając tej klawiatury z Ubuntu nie miałam żadnych problemów z przyciskami multimedialnymi czy trybem gamingowym. Wszystko działało i działa dobrze. Główny problem w moim przypadku to było podświetlenie klawiatury i na tym przede wszystkim się skupię.

## Ustawienia domyślne

Klawiatura po włączeniu domyślnie ma ustawiony tryb podświetlania klawiszy, który ja nazywam oddychającą tęczą. Każdy kto widział jak to wygląda, rozumie co mam na myśli. Ten tryb wygląda imponująco przez pierwsze 15 minut. Później, gdy człowiek chce się skupić na pracy działa po prostu rozpraszająco. Zaczęłam więc szukać innych opcji. Logitech G915 TKL ma na starcie zdefiniowane 10 przykładowych trybów podświetlenia klawiatury. Oto jak można sobie je ustawić:

- `☀` (przycisk jasności) - cyklicznie pozwala ustawiać poziom podświetlenia klawiszy od maksymalnego podświetlenia do jego braku.
- `☀ + 1` - efekt kolorowej fali (od lewej do prawej)
- `☀ + 2` - efekt kolorowej fali (od prawej do lewej)
- `☀ + 3` - efekt kolorowej fali (od środka na zewnątrz)
- `☀ + 4` - efekt kolorowej fali (od dołu do góry)
- `☀ + 5` - efekt cyklicznej zmiany kolorów
- `☀ + 6` - efekt kolorystycznej fali rozchodzącej się po naciśnięciu klawisza
- `☀ + 7` - efekt oddychania
- `☀ + 8` - miejsce na ustawienie efektu wybranego przez użytkownika
- `☀ + 9` - miejsce na ustawienie efektu wybranego przez użytkownika
- `☀ + 0` - podświetlenie kolorem jasno niebieskim
- `☀ + -` - zmniejszenie prędkości animacji
- `☀ + +` - zwiększenie prędkości animacji

Niestety gdy wybierzemy jeden z tych trybów podświetlenia i przez dłuższą chwilę nie będziemy używać klawiatury, to przywrócone zostaną ustawienia domyślne, czyli oddychająca tęcza.

## Oprogramowanie G Hub

Oprogramowanie G Hub wygląda OK. Można tam ustawić niemal każdy najmniejszy detal tego jak nasza klawiatura ma być podświetlana (oczywiście można tam konfigurować nie tylko podświetlenie). Przeczytałam (niestety obecnie nie potrafię znaleźć jeszcze raz tego źródła), że za pomocą oprogramowania G Hub można ustawić własne preferencje podświetlania klawiatury i zapisać je bezpośrednio na klawiaturze. Tak by pamiętała ona te ustawienia. Niestety to nie działa, przynajmniej w moim przypadku. Za każdym razem, gdy ustawię jakieś preferencje, działają one do momentu odłączenia klawiatury od oprogramowania G Hub.

## Libratbag i Ratbagctl

Kiedy zawiodły przewidziane przez producenta sposoby konfiguracji klawiatury zaczęłam szukać projektów Open Source, które pozwoliłyby mi na dostosowanie ustawień klawiatury z poziomu Ubuntu. W ten sposób znalazłam **Libratbag**. Biblioteka ta dostarcza **Ratbagd**. To DBus daemon do konfiguracji urządzeń wejścia, przede wszystkim myszy. Na szczęście projekt ten obsługuje również klawiatury, w tym Logitech G915 TKL. W moim przypadku nie byłam w stanie uruchomić graficznej wersji tego oprogramowania, ale wersja konsolowa działa dobrze.

By użyć Ratbagctl zainstalowałam odpowiedni pakiet przygotowany dla Ubuntu (wszystkie linki na dole artykułu). Podłączyłam klawiaturę do komputera przy użyciu kabla i mogłam już bez problemu używać polecenia `ratbagctl`.

Do wyświetlenia listy urządzeń wystarczy użyć:

```bash
$ ratbagctl list
warbling-mara:       Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
```

Teraz wiemy jak nazywa się klawiatura z poziomu narzędzia `ratbagctl`. Wykorzystamy tę nazwę w dalszych poleceniach. Wyświetlmy informacje o naszym urządzeniu:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" info
warbling-mara - Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
             Model: usb:046d:c343:0
 Number of Buttons: 15
    Number of Leds: 2
Number of Profiles: 3
Profile 0: (active)
  Name: n/a
  Report Rate: 1000Hz
  Button: 0 is mapped to macro '↕F1'
  Button: 1 is mapped to macro '↕F2'
  Button: 2 is mapped to macro '↕F3'
  Button: 3 is mapped to macro '↕F4'
  Button: 4 is mapped to macro '↕F5'
  Button: 5 is mapped to macro '↕F6'
  Button: 6 is mapped to macro '↕F7'
  Button: 7 is mapped to macro '↕F8'
  Button: 8 is mapped to macro '↕F9'
  Button: 9 is mapped to macro '↕F10'
  Button: 10 is mapped to macro '↕F11'
  Button: 11 is mapped to macro '↕F12'
  Button: 12 is mapped to 'unknown'
  Button: 13 is mapped to 'unknown'
  Button: 14 is mapped to 'unknown'
  LED: 0, depth: rgb, mode: on, color: 0000ff
  LED: 1, depth: rgb, mode: on, color: 0000ff
Profile 1:
  Name: n/a
  Report Rate: 1000Hz
  Button: 0 is mapped to macro '↕F1'
  Button: 1 is mapped to macro '↕F2'
  Button: 2 is mapped to macro '↕F3'
  Button: 3 is mapped to macro '↕F4'
  Button: 4 is mapped to macro '↕F5'
  Button: 5 is mapped to macro '↕F6'
  Button: 6 is mapped to macro '↕F7'
  Button: 7 is mapped to macro '↕F8'
  Button: 8 is mapped to macro '↕F9'
  Button: 9 is mapped to macro '↕F10'
  Button: 10 is mapped to macro '↕F11'
  Button: 11 is mapped to macro '↕F12'
  Button: 12 is mapped to 'unknown'
  Button: 13 is mapped to 'unknown'
  Button: 14 is mapped to 'unknown'
  LED: 0, depth: rgb, mode: breathing, color: 00dcff, duration: 3000, brightness: 255
  LED: 1, depth: rgb, mode: breathing, color: 00dcff, duration: 3000, brightness: 255
Profile 2:
  Name: n/a
  Report Rate: 1000Hz
  Button: 0 is mapped to macro '↕F1'
  Button: 1 is mapped to macro '↕F2'
  Button: 2 is mapped to macro '↕F3'
  Button: 3 is mapped to macro '↕F4'
  Button: 4 is mapped to macro '↕F5'
  Button: 5 is mapped to macro '↕F6'
  Button: 6 is mapped to macro '↕F7'
  Button: 7 is mapped to macro '↕F8'
  Button: 8 is mapped to macro '↕F9'
  Button: 9 is mapped to macro '↕F10'
  Button: 10 is mapped to macro '↕F11'
  Button: 11 is mapped to macro '↕F12'
  Button: 12 is mapped to 'unknown'
  Button: 13 is mapped to 'unknown'
  Button: 14 is mapped to 'unknown'
  LED: 0, depth: rgb, mode: cycle, duration: 3000, brightness: 255
  LED: 1, depth: rgb, mode: off
```

Analizując otrzymane informacje można zauważyć, że mamy do dyspozycji dwie sekcje LED. Jedna jest odpowiedzialna za logo (G w lewym górnym rogu), a druga sekcja odpowiada za wszystkie pozostałe klawisze. Nie jest to sytuacja idealna. W takim przypadku możemy ustawić tylko jeden typ podświetlenia dla wszystkich klawiszy. Można też zauważyć, że klawiatura ma 3 profile do ustawiania własnych makr. Ja tej funkcjonalności do tej pory nie potrzebowałam, więc nie będę się tym tematem zajmować. Wspomnę tylko jak można z poziomu klawiatury przełączać się między tymi profilami. Do tego służy kombinacja `fn + F1-3` (klawisz funkcyjny i jeden z klawiszy `F1`, `F2`, `F3`).

Przejdźmy teraz do ustawienia podświetlenia klawiatury. Do sprawdzenia bieżącego ustawienia służy:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led get
LED: 0, depth: rgb, mode: on, color: 0000ff
LED: 1, depth: rgb, mode: on, color: 0000ff
```

Do zmiany trybu użyjemy:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set mode breathing
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set duration 3000
```

Jak widać do włączenia efektu oddychania potrzebujemy podać też czas trwania jednego cyklu. Bez tego nie zauważymy działania tego efektu. Dla Logitech G915 TKL z poziomu `ratbagctl` mamy możliwość ustawienia 4 trybów:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 capabilities
Modes: breathing, cycle, off, on
```

Zachęcam do samodzielnego popróbowania różnych ustawień i wybrania najlepiej pasującego rozwiązania. Ja najbardziej lubię tryb `on` gdzie mam przez cały czas ustawiony jeden kolor.

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set mode on
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set color 0000FF
```

Narzędzie `ratbagctl` umożliwia konfigurację też innych opcji, nie tylko podświetlenia. Dlatego zachęcam do zapoznania się z instrukcją. W moim przypadku można ją znaleźć używając polecenia `ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" --help`. Jest tam możliwość konfiguracji profili czy też makr.

**Tip [@yawor-a](https://github.com/yawor "@yawor GitHub page")**, osoby stojącej za pull requestem dla Logitech G915 w projekcie g810-leds (więcej na ten temat poniżej):

> Trzeba uważać przy używaniu ratbag. Kiedy ustawia się LEDy za pomocą ratbagctl, to konfiguracja jest zapisywana na onboard flash. Co powoduje nadpisanie istniejących tam profili użytkownika (można nawet wybrać, który z 3 profili chcemy nadpisać). Ja miałem pewne trudności przy ustawianiu niektórych kolorów. Dodatkowo zauważyłem, że to polecenie namieszało w moich ustawieniach oszczędzania baterii oraz podświetleniu klawiatury (po około 30 sekundach braku aktywności świeciło tylko logo G).

## G810-led

Innym projektem, który stara się obsłużyć klawiatury Logitech pod Linuksem jest **G810-led**. Oferuje on wsparcie dla klawiatur takich jak: G213, G410, G413, G512, G513, G610, G810, G815, G910 i GPRO. W chwili gdy piszę ten artykuł istnieje pull request oferujący wsparcie dla klawiatury Logitech G915. Klawiatura Logitech G915 TKL powinna być kompatybilna z G915. Kiedy pierwszy raz próbowałam uruchomić ten projekt ze zmianami z PR nie miałam szczęścia. Nie mogłam się połączyć z klawiaturą. Jednak koniec końców udało się za pomocą polecenia:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 -a 0000ff
```

To polecenie pozwala ustawić wszystkie klawisze na jeden kolor. Czasami jednak nie działa prawidłowo - część klawiszy pozostaje w poprzednim kolorze. Najwidoczniej ten PR nie do końca działa z klawiaturą Logitech G915 TLK. Można ten problem ominąć dwa razy uruchamiając to samo polecenie lub przez osobne ustawianie brakujących klawiszy lub grup klawiszy.

Do ustawienia pojedynczego klawisza (na przykład `w`) użyjemy:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 -k w ff0000
```

Do ustawienia grupy klawiszy (przykładowo klawiszy funkcyjnych -  `F1-F12`) użyjemy:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 -g fkeys ff00ff
```

Do wyświetlenia listy dostępnych klawiszy służy parametr `--help-keys`:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 --help-keys
```

Nie będę pokazywać tutaj wszystkich możliwości tego narzędzia, zachęcam do zajrzenia na stronę główną projektu g810-led.

Teraz na chwilę chciałabym się skupić na parametrze `-c`, który początkowo źle zrozumiałam. Proces ustawiania kolorów dla LEDów przy pomocy Logitech's HID API jest dwu etapowy. Pierwszy etap to ustawianie konkretnych kolorów dla klawiszy. Ten krok nie powoduje żadnych widocznych efektów na klawiaturze. Zapisuje tylko zmiany w pamięci RAM klawiatury. Drugi krok to zatwierdzenie tych zmian. To właśnie zadanie parametru `-c`. Po zatwierdzeniu zmiany nowe podświetlenie jest widoczne na klawiaturze.

Gdy ustawiamy podświetlenie za pomocą parametrów `-a`, `-g` lub `-k`, zmiany te są automatycznie zatwierdzane. Istnieją też odpowiedniki powyższych parametrów ale bez automatycznego zatwierdzenia. To `-an`, `-gn` oraz `-kn`. Po ich użyciu trzeba zmiany jeszcze zatwierdzić używając polecania `g810-leds -c`.

**Ważne!** Wszystkie podane powyżej polecenia działają tylko przy użyciu adaptera bezprzewodowego. Połączenie po kablu nie jest na tę chwilę wspierane.

Na zakończenie tej sekcji chciałabym dodać jeszcze jedną rzecz. Próbowałam na różne sposoby, ale nie udało mi się zapisać moich ustawień na stałe. Za każdym razem gdy klawiatura przechodziła w stan czuwania, po jej przebudzeniu pojawiały się domyślne ustawienia. Wynika to ze sposobu zapisu ustawień za pomocą g810-led. Nie są one zapisywane w onboard flash. Podobnie zachowuje się narzędzie keyleds opisane poniżej. W obu przypadkach nadpisujemy tylko chwilowo stan bieżących ustawień. A te ustawienia są resetowane za każdym razem po wybudzeniu klawiatury z funkcji oszczędzania baterii. Niestety, żadne z obecnie istniejących rozwiązań nie wspiera detekcji wybudzenia klawiatury, by można było na nowo przypisać wybrane ustawienia. Niemniej jednak miałam dużo frajdy bawiąc się różnymi sposobami podświetlania klawiatury.

**Kolejny tip [@yawor-a](https://github.com/yawor "@yawor GitHub page")**, osoby stojącej za pull requestem dla Logitech G915 w projekcie g810-leds:

> Istnieje pewne obejście tego problemu. Można przełączyć klawiaturę w tryb software, który wyłącza takie ustawienia jak oszczędzanie baterii czy zarządzanie podświetleniem i pozwala na kontrolowanie tego za pomocą oprogramowania. Po ustawieniu tego trybu klawiatura od razu przestaje być podświetlana, ale dalej działa. Teraz można ustawić dowolną kolorystykę podświetlenia używając do tego g810-led. Trzeba jednak pamiętać że tryb oszczędzania baterii jest wyłączony. To oprogramowanie powinno sterować ściemnianiem klawiatury. Niestety nie ma na razie takiego oprogramowania dla Linuksa. Dodatkowo po wyłączeniu i ponownym włączeniu klawiatury przechodzimy z powrotem to trybu board zamiast software.

Komenda pozwalająca na skorzystanie z tego obejścia to:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 --on-board-mode software
```
## Keyleds

Jest jeszcze jeden projekt, o którym chciałabym wspomnieć. To **Keyleds**. Co prawda główny projekt nie wspiera klawiatury Logitech G915 TKL, ale istnieje fork z gałęzią G915, który już takie wsparcie częściowo oferuje. Po kompilacji tego projektu lokalnie, byłam w stanie użyć go z poziomu linii poleceń. Na tę chwilę funkcjonalność nie jest imponująca, ale może w przyszłości będzie dostępne całkowite wsparcie dla klawiatury Logitech G915 TKL.

By uruchomić projekt Keyleds użyjemy:

```bash
$ killall keyledsd
$ keyledsd --verbose
```

Aby zobaczyć dokładne informacje o urządzeniu (ja mam tylko jedno urządzenie) uruchom:

```bash
$ keyledsctl info
Name:           G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
Type:           keyboard
Model:          b35f408ec343
Serial:         ede0b9c9
Firmware[0000]: bootloader BL1 v112.0.17
Firmware[0000]: (null)  v100.0.a9
Firmware[c343]: application MPK v114.0.17 [active]
Firmware[0000]: (null)  v100.0.0
Firmware[0000]: (null)  v100.0.0
Features:       [0001, 0003, 0005, 1d4b, 0020, 1001, 1814, 1815, 8071, 8081, 1b04, 1bc0, 4100, 4522, 4540, 8010, 8020, 8030, 8040, 8100, 8060, 00c2, 00d0, 1802, 1803, 1806, 1813, 1805, 1830, 1890, 1891, 18a1, 1e00, 1eb0, 1861, 18b0]
Known features: feature version name gamemode layout2 gkeys mkeys mrkeys reportrate
G-keys: 12
Report rates:   [1ms] 2ms 4ms 8ms
```

Jeżeli masz więcej niż jedno urządzenie dostępne, skorzystaj z polecenia `keyledsctl list` i wybierz interesujące Cię urządzenie.

W tym momencie za pomocą projektu Keyleds byłam w stanie skonfigurować tylko tryb gamingowy:

```bash
$ keyledsctl gamemode h
$ keyledsctl gamemode
```

## Podziękowania

Chciałabym podziękować [@yawor-owi](https://github.com/yawor "@yawor GitHub page") za przeczytanie tego artykułu i podzielenie się swoimi przemyśleniami.

## Linki
- [Instrukcja obsługi klawiatury Logitech G915 TKL](https://www.logitech.com/assets/65920/g915-g913-tkl-qsg.pdf "[EN] Logitech user manual for G915 TKL")
- [Wątek dotyczący Logitech G915 TKL na stronie Reddit](https://www.reddit.com/r/linuxhardware/comments/k76ruy/remarks_on_the_logitech_g915_with_ubuntu_2004/ "[EN] Remarks on the Logitech G915 with Ubuntu 20.04")
- [Wątek dotyczący Logitech G915 TKL na stronie Ask Ubuntu](https://askubuntu.com/questions/1300455/how-to-control-logitech-g915-tkl-keyboard-lightning-in-linux-ubuntu "[EN] How to control Logitech G915 TKL keyboard lightning in Linux Ubuntu?")
- [Instukcja obsługi i informacje o instalacji Ratbagctl](https://github.com/libratbag/libratbag/wiki/ratbagctl "[EN] Short manual for Ratbagctl")
- [Wątek dotyczący problemów ze wsparciem gamingowych klawiatur wraz z listą dostępnych możliwych rozwiązań](https://github.com/libratbag/libratbag/issues/172 "[EN] Add support in libratbag for a subset of gaming keyboards")
- [Projekt G810-led](https://github.com/MatMoul/g810-led "[EN] G810-led project")
- [Github issue w projekcie G810-led na temat klawiatury Logitech G915](https://github.com/MatMoul/g810-led/issues/198 "[EN] G810-led issue about Logitech G915 keyboard")
- [Pull request dla wsparcia kalwiatury Logitech G915 - project G810-led](https://github.com/MatMoul/g810-led/pull/267 "[EN] G810-led pull request for Logitech G915 keyboard support")
- [Projekt Keyleds](https://github.com/keyleds/keyleds "[EN] Keyleds project")
- [Instalacja projektu Keyleds](https://github.com/keyleds/keyleds/wiki/Installing "[EN] How to install Keyleds project?")
- [Fork projektu Keyleds dla klawiatury Logitech G915 TKL](https://github.com/yawor/keyleds/tree/g915 "[EN] G915 fork of Keyleds project")
