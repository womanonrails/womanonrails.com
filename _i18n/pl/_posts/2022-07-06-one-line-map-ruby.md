---
excerpt: >
  Kilka dni temu, pracowałam nad projektem dla klienta i
  chciałam użyć metody `map` w jednej linijce,
  ale z dodatkowym argumentem w środku.
  Nigdy wcześniej nie miałam takiej potrzeby.
  Zazwyczaj wystarczał mi `.map(&:next)`.
  Tym razem potrzebowałam czegoś troszeczkę innego.
  Zaczęłam od szybkiego przeszukania Internetu.
  Wyniki moich poszukiwań były na tyle interesujące,
  że postanowiłam napisać na ten temat artykuł.
layout: post
photo: /images/ruby-and-map/ruby-map
title: Jak działa map(&:method) w Ruby?
description: Jednolinijkowy map w Ruby
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby, programowanie funkcyjne]
imagefeature: ruby-and-map/og_image.png
lang: pl
---

Kilka dni temu, pracowałam nad projektem dla klienta i chciałam użyć metody `map` w jednej linijce, ale z dodatkowym argumentem w środku. Nigdy wcześniej nie miałam takiej potrzeby. Zazwyczaj wystarczał mi `.map(&:next)`. Tym razem potrzebowałam czegoś troszeczkę innego. Zaczęłam od szybkiego przeszukania Internetu. Wyniki moich poszukiwań były na tyle interesujące, że postanowiłam napisać na ten temat artykuł.

Metody `map`, podobnie jaki innych iteratorów, możemy użyć w wersji blokowej:

```ruby
[1, 2, 3, 4, 5].map do |item|
  item + 1
end
# => [2, 3, 4, 5, 6]
```

Czasami logika znajdująca się wewnątrz bloku jest na tyle prosta (jak w przykładzie powyżej), że możemy zamienić ją na kod w jednej linijce.

```ruby
[1, 2, 3, 4, 5].map { |item| item + 1 }
# => [2, 3, 4, 5, 6]
```

Lub nawet skorzystać z:

```ruby
[1, 2, 3, 4, 5].map(&:next)
# => [2, 3, 4, 5, 6]
```

To właśnie `map(&...)` przykuł moją uwagę. Czy to jest skrócona wersja, któregoś z wcześniejszych przykładów? A może coś zupełnie innego? Jak możemy użyć tej metody z dodatkowym argumentem? Czy istnieją jakieś ciekawe zastosowania tej metody? No i najważniejsze pytanie: Co się właściwie dzieje, gdy wywołamy `map(&...)`?

#### Uwagi początkowe

1. Po pierwsze, wszystko o czym będę dziś mówić można wykorzystać dla innych [iteratorów w Ruby]({{site.baseurl}}/ruby-iterators "Iteratory w Ryby - przegląd"). Takich jak: `each`, `inject` czy `select`. Oczywiście nie zawsze te triki będą miały sens, ale są możliwe do wykonania.
2. W tym artykule skupię się na wytłumaczeniu `map(&...)`. Niektóre z podanych przykładów mogą być mniej czytelne niż użycie metody `map` z blokiem rozpisanym na kilka linii kodu. Ty jako programistka/programista samodzielnie musisz zdecydować, która wersja kodu jest dla Ciebie i Twojego projektu lepsza.
3. Ze względu na użycie w tym artykule takich elementów Ruby jak proc, lambda czy blok, zachęcam Cię do przeczytania również artykułu o [programowaniu funkcyjnym w Ruby]({{site.baseurl}}/functional-programming-ruby "Programowanie funkcyjne w Ruby"). To pozwoli Ci lepiej zrozumieć omawiany temat.
4. Napisałam ten artykuł dla czystej frajdy i by samej lepiej zrozumieć mechanizmy, jakimi posługuje się język Ruby w przypadku `map(&...)`. Mam nadzieję, że również dla Ciebie będzie to interesująca lektura.

## Co robi `map(&...)`?

Kiedy widzimy

```ruby
[1, 2, 3, 4, 5].map(&:next)
# => [2, 3, 4, 5, 6]
```

możemy początkowo pomyśleć, że jest to skrót od

```ruby
[1, 2, 3, 4, 5].map { |item| item.next }
# => [2, 3, 4, 5, 6]
```

ale tak naprawdę jest to krótsza wersja

```ruby
[1, 2, 3, 4, 5].map(&:next.to_proc)
# => [2, 3, 4, 5, 6]
```

Powyższy przykład może dalej nie być jasny pod względem tego, co się dzieje w metodzie `map(&...)`. Dlatego by dobrze to zrozumieć, przeanalizujmy ten kod krok po kroku. Gdy `[1, 2, 3, 4, 5].map(&:next)` jest wywołana, przekazujemy do metody `map` blokowy argument `&:next`. O tym blokowym argumencie powiem troszkę więcej później. Teraz skupmy się na tym, co dzieje się dalej. Ruby będzie starać się zamienić nasz `&:next` na `Proc`. By to zrobić zostanie wywołane `&:next.to_proc`. Jest to możliwe dlatego, że `:next` to obiekt typu Symbol, który ma zaimplementowaną metodę `Symbol#to_proc`. Dalej nasz `map` wyśle wiadomość `call` do obiektu Proc jakim jest `&:next.to_proc` z argumentem `1`. Czyli zostanie wywołane `:next.to_proc.call(1)`. Ze sposobu w jaki jest zaimplementowana metoda `to_proc` w obiekcie Symbol wiemy, że do obiektu `1` zostanie wysłana metoda `send` z argumentem `:next`, więc wywołany zostanie kod `1.send(:next)`. Ten sam proces będzie wykonany dla pozostałych elementów tablicy `[1, 2, 3, 4, 5]`.

## Blokowy argument dla metody map

Wrócimy na chwilę do tego blokowego argumentu metody `map`. W języku Ruby mamy możliwość przekazania funkcji (bloku) jako argumentu do dowolnych metod (nie tylko metody `map`). Zobaczmy jak to może wyglądać:

```ruby
def check_arguments_method(*args, &block)
  puts "args: #{args.inspect}"
  puts "block: #{block.inspect}"
end
```

Możemy tą metodę wywołać ze zwykłym, nie blokowym, argumentem:

```ruby
check_arguments_method(:next)

# args: [:next]
# block: nil
```

W tym przypadku widzimy, że przekazaliśmy do metody jeden argument, który nie jest blokiem. Co się jednak stanie, gdy użyjemy symbolu `&`?

```ruby
check_arguments_method(&:next)

# args: []
# block: #<Proc:0x00005588aae7b4a8(&:next) (lambda)>
```

Widzimy, że Ruby przekonwertuje nasz symbol `:next` przy użyciu metody `to_proc` na obiekt typu `Proc` i będzie to argument blokowy. Dlaczego twierdzę, że zostanie użyta metoda `to_proc`? Zobaczmy co się stanie, gdy zamiast symbolu użyjemy obiektu typu `String`?

```ruby
check_arguments_method(&'next')

# (irb):13:in `<main>': wrong argument type String (expected Proc) (TypeError)
```

Widzimy, że `String` nie jest obiektem typu `Proc` i nie da się go na taki obiekt przekonwertować, ponieważ `String` nie implementuje metody `#to_proc`. A co się stanie jeżeli na wejście metody `map` podamy obiekt typu `Proc`?

```ruby
my_proc = Proc.new { |item| item.next }

# => #<Proc:0x00005588aa81c468 (irb):14>

check_arguments_method(&my_proc)

# args: []
# block: #<Proc:0x00005588aa81c468 (irb):14>
```

Tym razem nasz obiekt `my_proc` również został przekazany do metody `check_arguments_method` jako argument blokowy. Widzimy też, że wewnątrz metody nasz `Proc` ma to samo _obejct id_. Sprawdźmy jeszcze jedną rzecz. Co się stanie, gdy pominiemy `&` przed obiektem `my_proc`?

```ruby
check_arguments_method(my_proc)

# args: [#<Proc:0x00005588aa81c468 (irb):14>]
# block: nil
```

W tym przypadku, Ruby traktuje nasz obiekt `my_proc` jako zwykły nie blokowy argument. Dlatego gdy chcemy, by coś zostało potraktowane jako argument blokowy, musimy to zaznaczyć używając `&`. To właśnie dlatego używamy `&` w naszym przykładzie `[1, 2, 3, 4, 5].map(&:next)`.

## Jak przekazać dodatkowy argument do blokowego argumentu w metodzie map?

Jak to już pokazałam w poprzednim przykładzie możemy zrobić:

```ruby
[1, 2, 3, 4, 5].map(&:next)
# => [2, 3, 4, 5, 6]
```

Ale co w przypadku, gdy potrzebujemy dodatkowego parametru? Czy możemy zrobić coś w stylu?

```ruby
[1, 2, 3, 4, 5].map(&:+(2))

# /home/agnieszka/.rvm/rubies/ruby-3.0.3/lib/ruby/3.0.0/irb/workspace.rb:116:in `eval': (irb):19: syntax error, unexpected '(', expecting ')' (SyntaxError)
```

Jak widać, ten sposób nie działa. A może jest jakiś inny sposób, by osiągnąć zamierzony efekt? Odpowiedź brzmi - tak.

```ruby
[1, 2, 3, 4, 5].map(&2.method(:+))
# => [3, 4, 5, 6, 7]
```

WOW! Co tu się dzieje? Najpierw wywołujemy `2.method(:+)`. Bierzemy obiekt `2` i tworzymy na nim obiekt typu `Method`. **Method Object** odpowiada na metodę `to_proc`, więc zostaje wywołany kod `2.method(:+).to_proc`. Na powstałym w ten sposób obiekcie `Proc` dla każdego elementu tablicy wywoływana jest metoda `call`. Przykładowo: `2.method(:+).to_proc.call(1)`.

Jest jeszcze jedna rzecz, o której chce tu wspomnieć. Na obiekcie typu `Method` możemy wywołać metodę `call` bezpośrednio, bez wywoływania metody `to_proc`. Nie musimy obiektu `Method` zamieniać na obiekt `Proc`.

```ruby
2.method(:+).call(1)
# => 3
```

### Inne przykłady przekazania dodatkowego argumentu

#### Zamana obiektu Array na obiekt Enumerable

```ruby
[1, 2, 3, 4, 5].to_enum.with_object(2).map(&:+)
# => [3, 4, 5, 6, 7]
```

Zamieniamy `Array` na obiekt `Enumerable`. Dalej wstrzykujemy obiekt `2` do naszego enumeratora i używając metody `map` iterujemy przez wszystkie elementy tablicy.

#### Lambda w metodzie map

```ruby
[1, 2, 3, 4, 5].map(&->(item) { item + 2 })
# => [3, 4, 5, 6, 7]
```

Gdzie kod `->(item) { item + 2 }` to nasza lambda, która zachowuje się bardzo podobnie jak `Proc`

```ruby
[1, 2, 3, 4, 5].map(&(Proc.new { |item| item + 2 }))
# => [3, 4, 5, 6, 7]
```

#### Deklaracja własnej metody

Ten przykład jest bardzo podobny do rozwiązania z `method`, ale tu mamy pełną kontrolę nad tym, co dzieje się w metodzie `double`. Nie zależymy od interfejsu obiektu `2`.

```ruby
def double(x)
  x + 2
end

[1, 2, 3, 4, 5].map(&method(:double))
# => [3, 4, 5, 6, 7]
```

#### Użycie metody curry

```ruby
[1, 2, 3, 4, 5].map(&:+.to_proc.curry(2).call(2))
# => [3, 4, 5, 6, 7]
```

Zatrzymamy się tu na chwile, by lepiej zrozumieć, co się dzieje. Na początku przekazujemy `:+` do metody `map` i konwertujemy go na Proc `&:+.to_proc`. Dalej używając metody `curry` (o niej trochę więcej za chwilę) mówimy językowi Ruby, że ten obiekt typu `Proc` może zostać wykonany tylko, gdy otrzyma dwa argumenty. Za to odpowiada kod `&:+.to_proc.curry(2)`. Następnie przekazujemy pierwszy argument do naszego obiektu `Proc` czyli `2`. Mamy już `:+.to_proc.curry(2).call(2)`. Na koniec wykonana zostaje procedura, którą już znamy z poprzednich przykładów. Wywoływana jest metoda `to_proc`, a później dla każdego elementu tablicy metoda `call`.

## Curring czyli rozwijanie funkcji

To teraz porozmawiajmy chwilę o **rozwijaniu funkcji**. **Curring** jest matematycznym terminem używanym też w programowaniu. To technika pozwalająca na zamianę konkretnej funkcji posiadającej wiele argumentów na sekwencję wielu funkcji, z których każda posiada tylko jeden argument. Pokażmy to na naszym przykładzie. Metoda `:+` potrzebuje 2 argumentów. Zamienimy ją na dwie metody (funkcje) posiadające po jednym argumencie.

```ruby
adding_method = :+.to_proc.curry(2)
# => #<Proc:0x000056401dc42fa8 (lambda)>

first_function = adding_method.call(2)
# => #<Proc:0x000056401e27ad08 (lambda)>

first_function.call(1)
# => 3
```

Na początku tworzymy pierwszą funkcję (Proc) `:+.to_proc.curry(2)`. Wywołujemy ją z jednym argumentem i przypisujemy do zmiennej `first_function = adding_method.call(2)`. Otrzymamy dzięki temu drugą funkcję (Proc) tylko z jednym argumentem. Po wywołaniu tej nowej metody `first_function.call(1)` otrzymujemy wynik dodawania liczb `2 + 1`. Gdyby nie metoda `curry` musielibyśmy podać oba argumenty od razu do metody `:+`.

```ruby
:+.to_proc.call(2, 1)
# => 3
```

W przypadku próby podania tylko jednego argumentu otrzymamy błąd.

```ruby
:+.to_proc.call(2)
# (irb):51:in `+': wrong number of arguments (given 0, expected 1) (ArgumentError)
```

Możemy powiedzieć, że rozwijanie funkcji pozwala nam na odwleczenie wywołania metody z wieloma argumentami w czasie. Ale warto wiedzieć, że dalej istnieje możliwość wywołania tej metody od razu ze wszystkimi argumentami.

```ruby
adding_method.call(2, 1)
# => 3
```

Podsumowując, kiedy używamy metody `curry` dla obiektu typu Proc, otrzymujemy leniwy obiekt Proc. Będzie on zwracał wynik dopiero, gdy wszystkie potrzebne argumenty zostaną podane do metody zgodnie z zadeklarowaną ilością argumentów. W przypadku podania mniejszej ilości argumentów otrzymamy obiekt typu Proc. To zachowanie jest przydatne w naszym przykładzie z metodą `map` i blokowym parametrem.

Metoda `map` w języku Ruby jest z pewnością bardzo interesującą metodą. Podobnie jak inne metody korzystające z bloków. Mam nadzieję, że udało mi się w przystępny sposób wytłumaczyć szczegóły działania metody `map`. Jeśli spodobał Ci się artykuł, to nie zapomnij o 👏, da mi to informację zwrotną.

## Linki

- [Iteratory w języku Ruby]({{site.baseurl}}/ruby-iterators "Przegląd iteratorów w języku Ruby")
- [Block, proc i lambda w języku Ruby]({{site.baseurl}}/functional-programming-ruby "Programowanie funkcyjne w języku Ruby")
- [[EN] Can you supply arguments to the map(&:method) syntax in Ruby?](https://stackoverflow.com/questions/23695653/can-you-supply-arguments-to-the-mapmethod-syntax-in-ruby "Stack Overflow question about map(&:method) arguments")
- [[EN] What does map(&:name) mean in Ruby?](https://stackoverflow.com/questions/1217088/what-does-mapname-mean-in-ruby "Stack Overflow question about map(&:method) meaning")
- [[EN] Currying: A Ruby approach](https://medium.com/@cesargralmeida/currying-a-ruby-approach-b459e32d355c "Medium article about curring basics")
- [[EN] Understanding the arity parameter of the method Proc.curry in Ruby](https://stackoverflow.com/questions/53620881/understanding-the-arity-parameter-of-the-method-proc-curry-in-ruby "Stack Overview question about Proc.curry method")
