---
layout: post
title: Kolejność wykonywania działań w Ruby
description: Co powinnaś wiedzieć o regułach opuszczania nawiasów w Ruby?
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby]
lang: pl
---

Kolejność działań matematycznych w programowaniu jest bardzo ważna. Jeżeli nie znasz ich dobrze, możesz dostać całkowicie inny wynik, niż się spodziewasz. Twój program może nawet przestać działać. Dlatego warto znać zasady, na jakich jest oparta kolejność działań w programowaniu. W tym przypadku w języku Ruby. Czy powinnyśmy postępować zgodnie z zasadami jakich nauczyłyśmy się w szkole na lekcjach matematyki? A może wystarczy stosować kolejność od lewej do prawej? Sprawdźmy.

```ruby
2 + 2 * 2
 => 6
```

To wyrażenie nie jest równe 8. Jest równe 6. W tym przykładzie możesz zauważyć, że mnożenie jest na swój sposób _silniejsze_ od dodawania. W takim przypadku mówimy, że mnożenie jest bardziej priorytetowe lub że ma **wyższy priorytet**. W języku angielskim powiemy **higher operator precedence**. Tak, to jest dokładnie tak samo, czego uczyłyśmy się w szkole. By pokazać to jeszcze bardziej dokładnie, spójrz na przykład poniżej:

```ruby
2 + (2 * 2)
 => 6

(2 + 2) * 2
 => 8
```

Dobrze, ale w programowaniu, w szczególności w języku Ruby, mamy więcej możliwych operacji. Skąd będziemy wiedzieć jaka jest ich kolejność? Z pomocą przychodzi nam <a href="https://ruby-doc.org/core-2.2.0/doc/syntax/precedence_rdoc.html" title="Dokumentacja Ruby - kolejność działań" target="_blank" rel="nofollow noopener noreferrer">dokumentacja Ruby</a>:

```ruby
!, ~, unary +
**
unary -
*, /, %
+, -
<<, >>
&
|, ^
>, >=, <, <=
<=>, ==, ===, !=, =~, !~
&&
||
.., ...
?, :
modifier-rescue
=, +=, -=, etc.
defined?
not
or, and
modifier-if, modifier-unless, modifier-while, modifier-until
{ } blocks
```

Jak widzisz tutaj `*` (czyli mnożenie), ma większy priorytet niż `+`.

## Przykłady

### Operatory logiczne

Zacznijmy od operatorów logicznych. Zobaczmy jak kolejność wykonywania działań wygląda w tym przypadku.

```ruby
1 || 2 && nil
 => 1

1 or 2 and nil
 => nil
```

Przy pierwszym spojrzeniu logika (nie zapis) wygląda dokładnie tak samo. Jednak, gdy przyjrzymy się bliżej, zauważymy pewne różnice. Jak można się domyślić, chodzi o kolejność działań. W pierwszym przypadku kolejność wygląda następująco: `(1 || (2 && nil))`. Najpierw wykonujemy `2 && nil` i dostajemy `nil`. Następnie wyrażenie to, upraszcza się nam do postaci `1 || nil`, z czego otrzymujemy `1`. W zasadzie, to trochę Cię tu oszukałam. Nasz interpreter jest _mądrzejszy_ niż nam się mogło wydawać na początku. Wyrażenie logiczne zawierające `||` jest prawdziwe, gdy człon wyrażenia stojący po lewej stronie, jest prawdziwy. Dlatego w tym przypadku zostanie sprawdzona tylko pierwsza cześć warunku. O czym możesz przekonać się tutaj:

```ruby
a = 0
 => 0

a = 1 || a = 2
 => 1

a
 => 1
```

Przypisujemy do zmiennej `a` wartość `0`. I zaczynamy sprawdzać warunek razem z przypisaniem. Jeżeli druga część warunku byłaby wykonana, to na koniec `a` było by równe `2`. Tak się nie dzieje. Wywołanie prawej strony możemy uzyskać tylko w przypadku, gdy lewa strona nie jest prawdą.

```ruby
a = false || a = 2
 => 2

a
 => 2
```

W drugim przypadku, gdy mamy do czynienia z `1 or 2 and nil`, kolejność działań jest inna: `((1 or 2) and nil)`. Najpierw sprawdzamy `1 or 2`. Jako wynik otrzymujemy `1`. Następnie sprawdzamy `1 and nil`, więc końcowy wynik jest `nil`.

By lepiej zrozumieć różnice pomiędzy tymi operatorami, przejrzyj poniższa tabelę wartość logicznych dla każdego możliwego przypadku:

<table class='table'>
  <thead>
    <tr>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>a || b && c</th>
      <th>a or b and c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
      <td><strong><code>true</code></strong></td>
      <td><strong><code>false</code></strong></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><strong><code>true</code></strong></td>
      <td><strong><code>false</code></strong></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>false</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
  </tbody>
</table>

W naszej tabeli są dwa przypadki gdzie można dostrzec różnice między operatorami `||` i `&&` a operatorami `or` i `and`.

### Przypisanie

W najbliższych kilku przykładach będziemy krążyć wokół tematyki operatorów logicznych, ale zobaczymy też jak zachowują się one w stosunku do operatora przypisania:

```ruby
foo = 1 && 2
 => 2
foo
 => 2

foo = 1 and 2
 => 2
foo
 => 1
```

W obu przypadkach wartość końcowa wyrażenia jest `2`. Jednak to, co zostało przypisane do zmiennej `foo` różni się od siebie. W pierwszym przypadku `foo` jest równe `2`. Jest to związane oczywiście z kolejnością działań. Operator `&&` ma wyższy priorytet niż operator `=`. W tym przypadku mamy dokładnie:

```ruby
foo = (1 && 2)
```

W drugim przypadku jest na odwrót. To operator `=` ma wyższy priorytet niż `and`.

```ruby
(foo = 1) and 2
```

Podobne zachowanie zaobserwujemy dla `||` i `or`. Rożnica będzie widoczna tylko w przypadku, gdy po lewej stronie wyrażenia logicznego będzie wartość fałszywa np. `false`. Gdy będzie tam jednak jakaś wartość prawdziwa, nie zauważymy różnicy. Oto przykład:

```ruby
# first part of condition is falsy
foo = false || 2
 => 2
foo
 => 2

foo = false or 2
 => 2
foo
 => false

# first part of condition is truthy
foo = 1 || 2
 => 1
foo
 => 1

foo = 1 or 2
 => 1
foo
 => 1
```

Chciałabym tutaj wyjaśnić, dlaczego w jednym z tych przypadków nie widzimy różnicy. Otóż, dla wyrażenia `foo = 1 || 2` rozkład nawiasów wygląda następująco: `foo = (1 || 2)`. Z warunku logicznego `||` otrzymujemy `1`. Co zostaje wpisane do zmiennej `foo`. W drugim przypadku `foo = 1 or 2`, najpierw realizowane jest przypisanie a dopiero później wyliczany jest warunek logiczny. Wynik jest ten sam, ale kolejność działań jest inna. Warto o tym pamiętać!

Na koniec tej sekcji, chciałabym pokazać Ci jeszcze jeden przykład. Moim zdaniem jest on bardzo interesujący. Dodatkowo jest odrobinę bardziej złożony od poprzedniego, ponieważ poza `=`, `&&`, `and` mamy jeszcze `<<`.

```ruby
s = '2'

s = '1' && s << '3'
 => "23"

s = '2'

s = '1' and s << '3'
 => "13"
```

Rozpracujmy go krok po korku. Wiemy już, że operator `&&` ma dość wysoki priorytet, jednak operator `<<` ma większy priorytet od `&&`. Kolejność działań będzie wyglądać następująco: `s = ('1' && (s << '3'))`. Na początek dopiszemy do zmiennej `s` wartość `'3'`. Dostaniemy wtedy wyrażenie `s = ('1' && '23')`, a w zmiennej `s` będzie `'23'`. Teraz wykonamy operację logiczną `&&`, z której otrzymamy wynik `23`. Nadpisze on w ten sposób bieżącą wartość zmiennej `s`, dokładnie tą samą wartością. Końcowy rezultat będzie równy właśnie `'23'`.

W drugim przypadku kolejność jest następująca: `(s = '1') and (s << '3')`. Zaczynamy od przypisania. W zmiennej `s` zamiast `'2'` mamy teraz `'1'`. Następnie wykonujemy operację `<<` i w zmiennej `s` mamy `'13'`. Na koniec wykonuje się operacja logiczna `and` i otrzymujemy wynik `'13'`.

### Metody i operatory logiczne

Pozostajemy w temacie operatorów logicznych. Tym razem sprawdzimy, co dzieje się, gdy połączymy je z metodami. W języku Ruby mamy możliwość opuszczenia nawiasów, nawet podczas wywołania metod. W takim przypadku też musimy pamiętać o kolejności działań. Tym razem konsekwencje błędu są jeszcze bardziej widoczne.

Zacznijmy od deklaracji naszej metody oraz pierwszego przykładu:

```ruby
# declare method
def method(char)
  puts "My char id #{char}"
end

# example 1
method 'a' || 'b'
My char id a
 => nil
```

W tym przypadku najpierw wywołany zostanie operator `||`. Wynikiem tego działania będzie `'a'`, które zostanie przekazane jako argument do metody i pojawi się w napisie widocznym na ekranie: `"My char id a"`. Ponieważ metoda zajmuje się tylko wypisaniem na ekran napisu i nic nie zwraca, jako końcowy efekt naszych działań zobaczymy `nil`. Ten szczegół przyda się nam w dalszych przykładach. Kolejność wykonywanych operacji jest taka: `method('a' || 'b')`.

Przejdźmy do następnego przykładu:

```ruby
# example 2
method 'a' && 'b'
My char id b
 => nil
```

W tym przypadku, kolejność działań jest taka sama: `method('a' && 'b')`. Najpierw operator `&&` a dopiero później wywołanie metody z argumentem `'b'`. To dlatego widzimy `'b'` w wyświetlonym napisie. Ponieważ metoda zwraca `nil`, to końcowym wynikiem jest właśnie `nil`

```ruby
# example 3
method 'a' or 'b'
My char id a
 => "b"
```

W trzecim przykładzie mamy do czynienia z innym zachowaniem. Dla operatora `or` kolejność działań jest: `method('a') or 'b'`. Widzimy, że najpierw wykonujemy metodę, wyświetlamy tekst zawierający `'a'`, a dopiero na koniec zajmujemy się operatorem logicznym `or`. Ponieważ nasza ostatnia operacja wygląda tak: `nil or 'b'`, to ostatecznym wynikiem będzie `'b'`, a nie `nil` jak w poprzednich przykładach.

```ruby
# example 4
method 'a' and 'b'
My char id a
 => nil
```

W czwartym przypadku mamy podobne zachowanie jak w trzecim. Wyrażenie z nawiasami wygląda tak: `method('a') and 'b'`. Wyświetla się napis `"My char id a"`, ze względu na argument metody równy `'a'`. Dalej metoda zwraca `nil`, więc końcowy rezultat po sprawdzeniu warunku logicznego jest `nil`.

Teraz chciałabym Ci pokazać bardzo ważny przykład. Na początek zadeklarujmy dwie metody: jedną bez argumentów a drugą z jednym argumentem.

```ruby
def method1
  puts 'Call Method 1'
end

def method2(text)
  puts "Call Method 2 with #{text}"
end
```

A teraz sprawdzimy, co się stanie w przypadku użycia tych metod z `or` i `||`.

```ruby
method1 or method2 'foo'
Call Method 1
Call Method 2 with foo
 => nil
```

Pierwszy przypadek wygląda OK. Wywołujemy metodę `method1`, która wyświetla `"Call Method 1"` i zwraca `nil`. Później wywołujemy metodę `method2` z argumentem `'foo'`. Wyświetla tekst i zwraca `nil`. Kolejność działań wygląda następująco: `method1() or method2('foo')`. Wszystko jest dobrze. Przejdźmy teraz do drugiego przypadku:

```ruby
method1 || method2 'foo'
Traceback (most recent call last):
        1: from /home/agnieszka/.rvm/rubies/ruby-2.5.3/bin/irb:11:in `<main>'
SyntaxError ((irb):32: syntax error, unexpected tSTRING_BEG, expecting keyword_do or '{' or '(')
method1 || method2 'foo'
                   ^
```

Coś ewidentnie poszło nie tak. Problem wynika z kolejności działań. Oto jak kolejność wygląda w tym przypadku: `(method1 || method2) 'foo'`. By pokazać, co się dokładnie dzieje, zapiszemy to tak: `(method1() || method2()) 'foo'`. Nasz interpreter nie wie, co zrobić z dwóch powodów. Po pierwsze, `method2` powinna mieć jeden argument a nie ma. Po drugie, w naszym wyrażeniu pojawia się _wolno stojący_ napis `'foo'`. Nie jest on połączony z resztą wyrażenia operatorem czy metodą, stąd błąd który dostajemy. By naprawić ten problem trzeba wprost napisać, o co nam chodzi: `method1 || method2('foo')`.

To samo zachowanie interpretera możemy obserwować w przypadku konkretnych metod. Takich jak: `raise` czy `return`. Zapraszam Cię do samodzielnego sprawdzenia wyników.

### Bloki

Czas na zajęcie się blokami (ang. blocks). Musimy być świadome, że **blok `{}` ma większy priorytet, niż blok `do ... end`**. Nie zobaczymy tego w naszej tabeli z kolejnością operacji w języku Ruby. W dokumentacji jest jednak mała informacja na ten temat. Sprawdźmy to! Zdefiniujemy dwie metody. Jedną z nich wywołamy z blokiem `{}` a drugą z `do ... end`.

```ruby
def foo(options = {}, &block)
  puts "Foo has block: #{block_given?}"
end

def bar(options = {}, &block)
  puts "Bar has block: #{block_given?}"
end

foo a: bar { 1 }
Bar has block: true
Foo has block: false
 => nil

foo a: bar do 1 end
Bar has block: false
Foo has block: true
 => nil
```

W pierwszym przypadku kolejność jest: `foo(a: (bar { 1 }))`. Najpierw wywołujemy metodę `bar` z blokiem. Po wywołaniu zwróci ona `nil`. Nasze wyrażenie uprości się w tym momencie do `foo(a: nil)`. Metoda `foo` zostanie wywołana z argumentem w postaci hasha, ale bez bloku.

W drugim przypadku kolejność wygląda następująco: `foo(a: bar) do 1 end`. Będzie przejrzyściej, gdy podzielimy sobie to wyrażenie na osobne linie:

```ruby
foo(a: bar) do
  1
end
```

Na początku wywoływana jest metoda `bar` bez argumentów i również bez bloku. Dlatego widzimy tekst: `"Bar has block: false"`. Później wywołana zostaje metoda `foo` z argumentem `{ a: nil }` jako `options` oraz z blokiem. W naszym przykładzie mogłybyśmy całkowicie pominąć argument `options`. Działanie kodu będzie takie same. Przynajmniej jeżeli chodzi o wyświetlane napisy. Sprawdź sama: `foo bar { 1 }` oraz `foo bar do 1 end`.

### Inne przykłady

```ruby
array = []
a = 1
b = 2
array << a + b
 => [3]
```

Ten przypadek zachowuje się tak, jakbyśmy tego oczekiwały. Najpierw wywołana jest suma `a` i `b`, a dopiero później wynik jest wstawiany do tablicy za pomocą operatora `<<`. Jak wynika z naszej tabeli `+` ma większy priorytet od `<<`.

W następnym przykładzie też wszystko wykona się po naszej myśli. Operatory `+=` i `*=` mają niższy priorytet od `+` i `*`. Dlatego możemy pominąć nawiasy:

```ruby
a = 1
b = 2
sum = 0
multiply = 1

sum += a + b
 => 3
sum
 => 3

multiply *= a * b
 => 2
multiply
 => 2
```

A teraz jak wygląda priorytet dla zakresów. Ponieważ `+` i `-` mają wyższy priorytet, nawiasy są nam nie potrzebne:

```ruby
n = 9
 => 9

1..n - 1
 => 1..8

(1..n - 1).to_a
 => [1, 2, 3, 4, 5, 6, 7, 8]
```

To jak zrobienie: `1..(n - 1)`.

## Podsumowanie

- Bądź świadoma kolejności działań w języku Ruby.
- Jeżeli nie jesteś pewna kolejności, dodaj nawiasy, a najlepiej sprawdź w dokumentacji. Napisz też testy. ;]
- Czasami, nawet jeżeli wiem, jaka jest kolejność wykonywania działań w Ruby, wolę zostawić nawiasy dla większej czytelności. Tak jak w tym przypadku: `method('a' && 'b')`. Wiem, że mogę zrobić tak: `method 'a' && 'b'`. To poprawna notacja i robi dokładnie to co chcę, jednak wole zostawić nawiasy. Jest to podejście w stylu **"Tell don't ask"**.

To tyle na dzisiaj. Jeżeli znasz inne ciekawe przykłady z kolejnością działań w Ruby, podziel się w komentarzu. Dzięki i do zobaczenia następnym razem!
