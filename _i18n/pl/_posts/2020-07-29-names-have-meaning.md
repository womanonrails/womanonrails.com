---
layout: post
photo: /images/names-have-meaning/names-have-meaning
title: 'Nazwy mają znaczenie: 13&nbsp;sposobów na poprawienie czytelności nazw w projekcie'
description: Jak dobra nazwa może wpłynać pozytywnie na projekt?
headline: Premature optimization is the root of all evil.
categories: [refaktoring]
tags: []
imagefeature: names-have-meaning/og_image-names-have-meaning.png
lang: pl
---

Jako programiści często rozmawiamy o wysokopoziomowej architekturze. Mam tu na myśli DDD, architekturę heksagonalną i tym podobne. Chcemy wprowadzić choć część tych koncepcji do naszego projektu. I to najlepiej, teraz! Nowa architektura, nowy język programowania, nowy framework. Wpadamy w taką pułapkę nowinek technologicznych. Są one jak narkotyk. Chcemy więcej i więcej. Trochę nie myśląc przy tym o konsekwencjach. Cel jest szczytny. Chcemy mieć nowoczesny, dobrej jakości projekt, który łatwo da się dalej rozwijać. Niestety, trochę gubimy się w tym jak to osiągnąć. Nasz projekt potrzebuje ewolucji, a nie rewolucji. Dążenia małymi kroczkami do dobrej architektury. Jest to istotne, ale trudne do osiągnięcia. Potrzeba tu przede wszystkim cierpliwości i jasnego celu. Dziś zajmę się tematem, który jest właśnie takim małym kroczkiem do zbudowania dobrej architektury. Jest to odpowiednie **nazywanie rzeczy**.

## Dlaczego nazwy są ważne?

Pewnie myślisz: _"Nazywanie rzeczy?! To nuda!"_ Ja uważam, że wręcz przeciwnie. Jest to bardzo interesujący i dodatkowo trudny temat. To jak nazywamy rzeczy może zmienić całkowicie nasza perspektywę. Może dodać lub usunąć jakąś informacje z naszego kontekstu. A informacja w ręku programisty to bardzo potężna broń. Możesz nazwać swoją klasę `User`. Jaką ta nazwa daje Ci informację? Możemy założyć, że jest to programistyczna reprezentacja człowieka, który używa czegoś choć nie wiemy czego. To tyle. Natomiast jeżeli użyjesz nazwy takiej jak `Guest`, `Gamer` czy `Programmer`, tu mamy więcej informacji. Wiemy dokładnie co ta osoba robi lub kim jest. Najważniejsze pytanie to: Czy my potrzebujemy tej informacji w naszym kontekście? Czy jest ona dla nas ważna? Jak to zazwyczaj bywa odpowiedź na te pytania jest jedna - to zależy. Musisz znać cel jaki swoją nazwą chcesz osiągnąć. Czasami nazwa `User` będzie wystarczająca, a czasami nie.

## Nowa nazwa, nowa perspektywa

Zmiana nazwy może spowodować, że będziesz postrzegać swój kod z innej perspektywy. Może nawet odnajdziesz inny kontekst zastosowania swojego kodu, o którym wcześniej nie myślałaś. Pozwoli Ci spojrzeć na Twoje rozwiązanie z różnych stron. Trochę jak 6 myślowych kapeluszy doktora Edwarda de Bono. Za każdym razem gdy _zakładasz_ jeden z myślowych kapeluszy, myślisz w konkretny sposób, skupiasz się na konkretnej perspektywie. Podobny efekt uzyskujemy nadając konkretne nazwy rzeczom. Spójrz na przykład poniżej.

Chcemy dostać informacje na temat plików znajdujących się w bucket-cie na S3. Oczywiście posłuży nam do tego AWS SDK, ale my chciałybyśmy być bardziej konkretne. Dostosować to, co daje AWS SDK do naszych potrzeb. Opakujemy je więc własnym kodem. Stworzymy **wrapper**.

```ruby
module S3
 class Wrapper
   def image_url
   end

   def get_file
   end
   ...
 end
end
```

Moment, nasz kod dotyczy tylko operacji na plikach. Szukamy ścieżki dla obrazka i chcemy ten obrazek przeczytać, pobrać. Może to nie koniecznie jest taki `Wrapper`? Może jest to coś w rodzaju zdalnego dostępu do plików? Może to jest coś w rodzaju klasy `File`? Taki zdalny plik z S3? Może powinnyśmy zmienić sposób myślenia o naszej klasie:

```ruby
module S3
  class File
    def public_url
    end

    def read
    end
    ...
  end
end
```

Czy nie uważasz, że zmiana tych nazw zmienia też sposób postrzegania tego kodu? Ja tak. Czy pierwsze nazwy są złe? To zależy. Istotne jest co chcemy osiągnąć. Parafrazując Billa Gates **Context is the king** (kontekst jest najważniejszy). I tak właśnie jest w naszym przykładzie. Nasza intencja, to co chcemy uzyskać się liczy. Dobre nazwy są bardzo istotne do zrozumienia kodu. Czasami by nazwać coś dobrze musimy zrobić wiele iteracji. Przecież chodzi o to by nazwa opisywała to, co ma sobą reprezentować. Chcemy by była jednoznacznie lub prawie jednoznacznie rozumiana przez wszystkich członków zespołu. Nawet lepiej, by była zrozumiana w ten sam sposób również przez klienta. Idealna sytuacja jest wtedy, gdy zarówno klient jak i zespół developerski porozumiewa się tym samym językiem. Gdy wspólnie tworzą ten język. Język, który w Domain Driven Design nazywany jest **Ubiquitous Language**. Co w języku polskim funkcjonuje jako **język wszechobecny, wszędobylski**. Taki język jest bardzo pomocny przy lepszym zrozumieniu domeny w której się pracuje, problemu jaki chce się rozwiązać. Pozwala zobaczyć odpowiednie rzeczy i połączenia między nimi.

## Stwórz kontekst projektu za pomocą nazw

Nazywamy rzeczy, które mają dla nas znaczenie. Nasze słowa i język kształtują nasz świat, nasza rzeczywistość (problem, domenę). Oto dwa przykłady z życia codziennego. Czy kiedykolwiek potrzebowałaś jednego słowa, które opisze Ci osobę bardzo wrażliwą na zimno? Hiszpanie maja takie słowo - friolero. A może potrzebujesz jednego słowa na opisanie stąpania na palcach po gorącym piasku? W Nairobi istnieje takie słowo - hanyauku. Słowa te wyrażają świat i kulturę konkretnych ludzi. Dobrze wróćmy teraz do programowania.

Mamy dwie nazwy (zmienne) w kodzie:

```ruby
n1n2
n12
```

Możemy patrzeć na nie godzinami a i tak raczej nie domyślimy się co sobą reprezentują. Można nawet pomyśleć, że wystąpiła tu literówka. Ktoś zapomniał litery `n` w drugim wywołaniu zmiennej. Trzeba wczytać się w kod, co może zając trochę czasu, by zrozumieć co te nazwy oznaczają. Co można znaleźć w kodzie? Po pierwsze, obie te zmienne są zadeklarowane i wykorzystywane w kodzie. Nie jest to więc żadna pomyłka czy literówka. Po drugie, znaczenie tych nazw nie jest takie oczywiste. Dla roślin, w naszym przypadku roślin uprawnych, została przygotowana skala wzrostu podzielona na etapy, zwana skalą BBCH. Etapy te są grupowane np. etapy związane ze wzrostem, kwitnięciem lub dawaniem owoców. To właśnie od tych zgrupowanych etapów wzrostu biorą się cyfry 1 i 2 w nazwie zmiennych. Etapy te są odpowiednio określone w czasie i kolejności. Natomiast litera `n` bierze się od zawartości azotu (ang. nitorgen) w glebie w tych konkretnych etapach rozwoju rośliny. Tak więc nazwa `n1n2` reprezentuje iloczyn wartości `n1` i `n2`, a nazwa `n12` mówi o drugiej potędze wartości `n1`. Nie jest to coś, czego możemy domyślić się w prosty sposób patrząc na te bardzo skrótowe nazwy. Całkowicie została tu pominięta możliwość zbudowania kontekstu dla kodu. Te nazwy nie tłumaczą co jest pod nimi ukryte. Nie dbają o język projektu czy problemu.

Mam nadzieję, że na podstawie tych przykładów udało mi się przekonać Cię, że nazywanie rzeczy jest bardzo ważne. Nazwy mogą zmienić perspektywę. Pokazać zagadnienie z innej strony, pomóc w jego zrozumieniu czy stworzeniu takiego projektowego języka, którym mogą porozumiewać się wszyscy zainteresowani. Co może pomóc w lepszym zrozumieniu projektu i pokazać głębsze znaczenie, inną perspektywę.

## 13 sposobów na poprawienie czytelności nazw

Teraz czas na kilka moich wskazówek, jak możesz przenieść swoje nazwy w projekcie na wyższy poziom czytelności:

1. **Nadaj nazwę logicznym krokom w kodzie**

   Kiedy masz w kodzie skomplikowane obliczenia warto podzielić je na mniejsze kroki i nadać im opisowe nazwy. W ten sposób Ty i Twój zespół będziecie mogli szybciej zrozumieć kod i kryjącą się pod nim logikę.

   ```ruby
   def remaining_amount
     total_amount = room_price * days * guest_amount
     paid_amount = room_price * guest_amount
     total_amount - paid_amount
   end
   ```

2. **Nazwy metod powinny informować o tym naprawdę robią**

   Przykładowo Twoja metoda zmienia stan obiektu. Jej nazwa powinna o tym informować. W języku Ruby w takich przypadkach dodajemy na koniec nazwy wykrzyknik `!`. Oczywiście jest to tylko konwencja, więc można znaleźć takie miejsca w kodzie gdzie ktoś tą konwencję łamie. Moim zdaniem jednak dobrze z takich rzeczy korzystać. Najważniejsze jest przekazanie informacji o tym, co kod naprawdę robi.

3. **Nazwij swoje magiczne stałe wartości w kodzie**

   Nazwij wszystkie stałe liczbowe lub łańcuchy znaków w Twoim kodzie. Nie używaj bezbarwnej wartości 24. Zamiast tego stwórz stałą i nazwij ją tak by wskazywała czym jest np. reprezentuje dobę - `HOURS_PER_DAY`. Jeżeli masz w kodzie liczbę `7`, to niech ona powie Twojemu zespołowi co oznacza. Napisz jasno i wyraźnie, że chodzi ci o tydzień - `WEEK`. To bardzo pomoże w zrozumieniu kodu.

4. **Używaj opisowych nazw**

   Nigdy więcej jedno literowych nazw. Używaj opisowych nazw dla swoich zmiennych, metod, modułów czy klas. Stwórz kontekst dla swojego kodu używając opisowych nazw. Pozwól swojemu zespołowi szybko zrozumieć, co dzieje się w kodzie dzięki jasnym, znaczącym nazwom. Jeżeli nazwa nie jest tak precyzyjna jak byś chciała, zmień ją. Czasem potrzeba kilku iteracji zanim uda nam się znaleźć odpowiednią nazwę. To normalne.

5. **Wybierz nazwę dostosowaną do poziomu abstrakcji**

   Czasem nasza nazwa może spełniać wymaganie bycia opisową jednak może mówić nam za mało lub za dużo na konkretnym poziomie abstrakcji. Przykładowo:

   ```ruby
   def create_tmp_file(image_path)
     ...
   end
   ```

   Myślę że nazwa `image_path` dość dobrze mówi nam, co się może kryć pod tą zmienną. Ścieżka do pliku graficznego. Ale moment! Czy tylko pliki graficzne mogą zostać obsłużone przez metodę `create_tmp_file`? A może metoda ta ma szersze zastosowanie? Kiedy używamy nazwy `image_path` zawężamy sobie użycie metody tylko do plików graficznych. Jest to zawężanie na poziome kontekstu a nie kodu, jednak może spowodować, że rzadziej będziemy jej używać lub stworzymy podobną metodę dla innych plików. Zamiast nazwy `image_path` w tym przypadku lepszą nazwą okazać się może `file_path`. Nazwa ta lepiej pokaże jakie jest zastosowanie naszej metody.

6. **Używaj konwencji i standardów swojego języka**

   W języku Ruby w przypadku metod, które zwracają wartość logiczną (typ Boolean) używamy na końcu nazwy znak zapytania `?`. Tak jak w przypadku metody `blank?`. Takich konwencji w językach programowania jest dość sporo. Innym przykładem z języka Ruby jest metoda `to_s` używana, gdy chcemy rzutować nasz obiekt na łańcuch znaków.

7. **Powiedz jakiego używasz wzorca**

   Uważam że podanie nazwy wzorca projektowego w nazwie klasy ułatwia i przyśpiesza zrozumienie kodu i jego architektury. Przykładowo, masz klasę `User` i chcesz ją udekorować. Możesz stworzyć dla niej dekorator o nazwie `UserDecorator`. A może nawet `AdminUserDecorator`, jeżeli Twój `User` faktycznie jest administratorem. Im bardziej precyzyjna nazwa tym lepiej.

8. **Używaj konwencji i standardów swojego projektu**

   Gdy Twój projekt ma złożoną logikę domenową, będziesz potrzebować więcej niż tylko konwencję jaką dostarcza Ci Twój język programowania. Dlatego dobrze jest stworzyć wewnętrzny język projektu, język wszędobylski - **Ubiquitous Language** - i używać go w całym projekcie.

9. **Jednoznaczne nazwy**

   Zawsze staraj się tworzyć nazwy tak by mówiły dokładnie to, co mają robić. Nazwa taka jak `create_record` może okazać się zbyt ogólna dla Twojego kodu. Jeżeli Twoja metoda tworzy pusty obiekt, to bardziej odpowiednie będzie użycie nazwy `create_blank_record`. Nie bój się długich nazw. Jeżeli używasz danej nazwy raz lub dwa razy możesz pozwolić sobie na dokładnie sprecyzowanie, co ona oznacza.

10. **Im dłuższy zakres, tym dłuższa nazwa**

    Jeżeli w Twoim kodzie masz krótką pętlę, to użycie `i` na nazwę zmiennej reprezentującą bieżący stan w pętli jest OK (choć może nie idealne). Natomiast gdy Twój zakres życia zmiennej się zwiększa na przykład do zakresu całej klasy, to stanowczo warto zainwestować w dłuższe opisowe nazwy. To pozwoli Ci lepiej kreować kontekst. Pamiętaj tylko by nie przesadzić z długością nazw. Zbyt długie nazwy też mogą zmniejszyć czytelność kodu.

11. **Nie umieszczaj typu lub sub-domeny w prefiksie ani sufiksie**

    Ten punkt jest związany między innymi z notacją węgierską, a w zasadzie z jej nie używaniem. Nie twórz nazw takich jak `i_age` tylko dlatego że wiek jest typu `Integer`. Podobnie sprawa ma się w przypadku nazw takich jak `CRMInvoice`. Jeżeli chcesz zaznaczyć, że dana klasa jest częścią jakiejś domeny lepiej umieścić ją w module `CRM::Invoice`. A jeżeli cały Twój projekt to `CRM`, to może nawet lepiej pozbyć się tego przedrostka. W przypadku, gdy `CRM` to tylko część systemu, warto zachować informację do jakiego modułu klasa należy. Pamiętaj, wszystko zależy od kontekstu.

12. **Nazwa powinna opisywać efekty uboczne**

    Jeżeli w Twoim kodzie metoda szuka określonego obiektu, a w przypadku gdy go nie znajduje tworzy nowy obiekt, to nazwa tej metody powinna o tym mówić. W takim przypadku lepiej użyć nazwy `find_or_create` zamiast tylko `find`.

13. **Nie używaj skrótów myślowych**

    Dla Ciebie `id_url` może wskazywać na URL do dokumentu identyfikacyjnego (ID - Identity Document). Natomiast dla innej osoby nazwa ta może się bardziej kojarzyć z `id`, które często występuje w tabelach bazy danych i reprezentuje klucz główny. Jeżeli nie jesteś pewna co do nazwy po prostu zapytaj resztę zespołu jak rozumieją daną nazwę.

To moje sposoby na tworzenie czytelnych i jednoznacznych nazw w projekcie. Jeżeli masz własne przemyślenia dotyczące tworzenia dobrych nazw, podziel się nimi w komentarzu.



