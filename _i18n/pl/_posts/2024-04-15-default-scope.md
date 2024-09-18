---
excerpt: >
  Jeśli poszukasz w Internecie frazy "Rails Default Scope",
  znajdziesz ogrom artykułów: dlaczego nie warto używać default scope,
  dlaczego default scope to źródło wielu problemów
  i jak usunąć default scope z projektu.
  Te artykuły często wyrażają silna negatywną opinie na temat default scope.
  Ale czy default scope jest naprawdę tak zły?
  Dyskusja na temat default scope toczy się przynajmniej od 2015 roku,
  prawie dziesięć lat, a ludzie nadal na ten temat rozmawiają.
  Dziś ja dołożę do tego wątku swoją cegiełkę.
layout: post
photo: /images/default-scope/default-scope-header
title: Przegląd default scope w Rails
description: Czego nie wiesz o Default Scope w Railsach?
headline: Premature optimization is the root of all evil.
categories: [programowanie]
tags: [Ruby, Ruby on Rails]
imagefeature: default-scope/og_image.png
lang: pl
---

Jeśli poszukasz w Internecie frazy "Rails Default Scope", znajdziesz ogrom artykułów: dlaczego nie warto używać default scope, dlaczego default scope to źródło wielu problemów i jak usunąć default scope z projektu. Te artykuły często wyrażają silna negatywną opinie na temat default scope. Ale czy default scope jest naprawdę tak zły? Dyskusja na temat default scope toczy się przynajmniej od 2015 roku, prawie dziesięć lat, a ludzie nadal na ten temat rozmawiają. Dziś ja dołożę do tego wątku swoją cegiełkę.

Bądźmy szczerzy: w większości przypadków artykuły te trafnie określają powody, dla których zastosowanie default scope może być ryzykowne. Jednak czy to oznacza, że nie powinniśmy w ogóle stosować default scope? Skoro default scope jest tak problematyczny, to czy po tylu latach dalej byłby częścią Railsów? A może istnieją jakieś scenariusze, gdzie warto użyć default scope? W tym artykule chciałabym dokładnie wyjaśnić specyfikę działania default scope i sprawdzić czy jest miejsce dla default scope w nowoczesnych projektach opartych na Ruby on Rails. Zaczynajmy!

{% include toc.html %}

## Czym jest `default_scope`?

Na podstawie [dokumentacji api.rubyonrails.org](https://api.rubyonrails.org/v7.1.3.2/classes/ActiveRecord/Scoping/Default/ClassMethods.html#method-i-default_scope "Dokumentacja Ruby on Rails - default_scope") dla Rails 7.1 `default_scope` to makro w modelu ustawiające domyślny zakres dla wszystkich operacji na modelu. Jest to więc zawężenie wyników wszystkich operacji na modelu do określonego zapytania, warunku lub kolejności elementów.

## Jak stworzyć default scope?

```ruby
class Article < ActiveRecord::Base
  default_scope { where(published: true) }
end
```

Istnieje też inny sposób deklaracji `default_scope`:

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
end
```

Default scope określa ograniczenia na metodę `.all` i w naszym przypadku wyświetla tylko publiczne artykuły.

```ruby
Article.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true
```

Ze względu na poniższą definicję default scope:

```ruby
def default_scope(scope = nil, all_queries: nil, &block)
  scope = block if block_given?

  if scope.is_a?(Relation) || !scope.respond_to?(:call)

  # [...]
end
```

Możemy trochę pobawić się tworzeniem default scope. Na początek, możemy stworzyć [obiekt typu `Proc`]({{site.baseurl}}/functional-programming-ruby#obiekt-proc "Proc obiekt w języku Ruby") i przekazać go jako argument do `default_scope` na dwa różne sposoby:

```ruby
class Article < ActiveRecord::Base
  published_articles = -> { where(published: true) }

  default_scope(all_queries: true, &published_articles)
  default_scope(published_articles, all_queries: true)
end
```

Jest to możliwe ponieważ podając [blok kodu]({{site.baseurl}}/functional-programming-ruby#bloki-w-ruby "Bloki w języku Ruby") w definicji `default_scope` zostanie on przypisany do zmiennej `scope` wewnątrz metody. Drugi trik dotyczy przygotowania odpowiedniej klasy, która posiada metodę instancji `call`. Jest to jedyny warunek jaki musi spełniać podany jako argument obiekt by stworzyć `default_scope`.

```ruby
class PublishedScope
  def initialize(context)
    @context = context
  end

  def call
    context.where(published: true)
  end

  private

  attr_reader :context
end


class Article < ActiveRecord::Base
  default_scope(PublishedScope.new(self), all_queries: true)
end
```

Ta możliwość pozwala nam wyekstrahować logikę naszego zakresu do zewnętrznej klasy/kontekstu.

Na koniec tej części jeszcze jedna uwaga. Jeżeli zastanawiasz się, czy warunek zawierający na przykład odwołanie do bieżącej daty lub godziny będzie odpowiednio wyliczony za każdym razem, gdy wywołany zostanie twój default scope to odpowiedź brzmi tak. Ze względu na to że `Proc` jest blokiem kodu, który jest obliczany każdorazowo przy uruchomieniu nie musimy się martwić _zamrożeniem_ daty lub czasu wewnątrz default scope.

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where('created_at > ?', Time.current) }
end

Article.all
# SELECT "articles".* FROM "articles" WHERE (created_at > '2024-04-29 10:16:38.292367')

Article.all
# SELECT "articles".* FROM "articles" WHERE (created_at > '2024-04-29 10:18:49.980174')
```

## Default scope a tworzenie nowego obiektu

Gdy zaczynamy używać default scope musimy pamiętać, że `default_scope` jest używany również podczas tworzenia obiektu. Jeżeli mamy:

```ruby
class Article < ActiveRecord::Base
  default_scope { where(published: true) }
end
```

Atrybut `published` jest ustawiony na `true` dla każdego zainicjowanego i stworzonego rekordu:

```ruby
Article.new
# => #<Article id: nil, title: nil, published: true, created_at: nil, updated_at: nil>
```

W zależności od twoich potrzeb, może to być oczekiwane lub nie oczekiwane zachowanie. W przypadku tworzenia artykułu raczej na początku chcielibyśmy zapisać artykuł jako szkic, a dopiero po jego doszlifowaniu opublikować go. Więc powyższe zachowanie może być dla nas problematyczne. Z jednej strony używając default scope możemy chcieć się zabezpieczyć przed pokazywaniem nieopublikowanych artykułów, z drugiej z automatu tworzymy publiczny artykuł.

Istotną sprawą jest pamiętanie że **`default_scope` zawsze oddziałuje na inicjalizacje i tworzenie obiektu**. Oczywiście jest możliwość nadpisania domyślnego zachowania, ale jest to dodatkowa rzecz, o której trzeba pamiętać podczas implementacji:

```ruby
Article.new(published: false)
# => #<Article id: nil, title: nil, published: false, created_at: nil, updated_at: nil>
```

## Default scope a aktualizacja obiektu

**Domyślnie `default_scope` nie jest uruchamiany podczas aktualizacji obiektu**.

```ruby
article = Article.last
# => #<Article id: 1, title: 'Default scope overview', published: false, created_at: ..., updated_at: ...>

article.update(title: 'Default scope - user manual')
# => #<Article id: 1, title: 'Default scope - user manual', published: false, created_at: ..., updated_at: ...>
```

Jeżeli chcesz by `default_scope` był wywoływany podczas aktualizacji lub usuwania obiektu dodaj `all_queries: true` to swojej deklaracji `default_scope`:

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }, all_queries: true
end
```

otrzymasz wtedy

```ruby
article = Article.last
# => #<Article id: 1, title: 'Default scope overview', published: false, created_at: ..., updated_at: ...>

article.update(title: 'Default scope - user manual')
# => #<Article id: 1, title: 'Default scope - user manual', published: true, created_at: ..., updated_at: ...>
```

Pamiętaj jednak, że jeżeli użyjesz `all_queries: true`, default scope będzie wywoływany do **wszystkich zapytań**. Oto co dostaniesz w przypadku usuwania obiektu:

```ruby
Article.find(1).destroy
# DELETE FROM "articles" WHERE "articles"."id" = ? AND "articles"."published" = ?  [["id", 1], ["published", true]]
```

Tylko opublikowane rekordy będą usuwane. To zachowanie może cię zaskoczyć, kiedy będziesz chcieć usunąć nieopublikowane artykuły.

Jeszcze jedna ważna rzecz dotycząca tej części. Powiedziałam Ci, że domyślnie `default_scope` nie jest używany podczas aktualizacji obiektu. Jest to prawda tylko w przypadku metody `update`. Natomiast **w przypadku `update_all` default scope będzie użyty**, nawet jeśli nie ustawisz `all_queries: true`. Przykładowo, jeżeli chcesz opublikować wszystkie artykuły za pomocą:

```ruby
Article.all_update(published: true)
# UPDATE "articles" SET "published" = ? WHERE "articles"."published" = ? [["published", true], ["published", true]]
```

nadal będziesz mieć w bazie danych obiekty, które mają atrybut `published: false`, ponieważ `update_all` zawęził twoje zapytanie tylko do artykułów już opublikowanych. Ta sama sytuacja zachodzi w przypadku `destroy_all` - default scope zawęzi zapytanie.

## Wiele deklaracji default scope

W swoim modelu możesz mieć wiele deklaracji default scope. Wszystkie one połączą się w czasie wywołania

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
  default_scope -> { where(archived: true) }
end
```

więc otrzymasz:

```ruby
Article.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true AND "articles"."archived" = true
```

W tym przypadku również podczas inicjalizacji obiektu oba domyślne zakresy będą uwzględnione.

```ruby
Article.new
# => #<Article id: nil, title: nil, published: true, archived: true, created_at: nil, updated_at: nil>
```

Jeżeli chcesz sprawdzić jakie typy default scope zawiera twój model możesz użyć:

```ruby
Article.default_scope

# =>
# [#<ActiveRecord::Scoping::DefaultScope:0x00007fb1157117e0
#   @all_queries=nil,
#   @scope=#<Proc:0x00007fb115711880 .../app/models/article.rb:17>>,
#  #<ActiveRecord::Scoping::DefaultScope:0x00007fb1157115d8
#   @all_queries=nil,
#   @scope=#<Proc:0x00007fb115711600 .../app/models/article.rb:18>>]
```

Dzięki temu zobaczysz w jakich miejscach są zadeklarowane wszystkie twoje domyślne zakresy dla modelu `Article`.

## Default scope a dziedziczenie

W przypadku dziedziczenia i dołączania modułów, gdy w klasie po której dziedziczymy oraz w klasie dziedziczącej są zdefiniowane `default_scope`, to ich funkcjonalność łączy się tak, jak w przypadku wielu deklaracji default scope w jednej klasie.

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
end

class ArchivedArticle < Article
  default_scope -> { where(archived: true) }
end
```

Nasz model `ArchivedArticle` będzie posiadać dwa zakresy: `published` i `archived`:

```ruby
ArchivedArticle.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true AND "articles"."archived" = true
```

Jedna ważna rzecz. Pomysł dodania default scope dla klasy `Article`, jako klasy ogólnej dla wszystkich typów artykułów, nie jest zbyt dobrym pomysłem - po prostu nie spodziewamy się tam żadnego zawężenia zakresu. W przypadku jednak podtypu artykułów, takiego typu jak klasa `ArchivedArticle`, gdzie nazwa mówi sama za siebie, default scope może być całkiem użyteczny.

## Default scope a asocjacje

Załóżmy, że mamy dwa modele: `Article` i `Author`. Każdy artykuł ma jednego autora, a każdy autor może stworzyć wiele artykułów.

```ruby
class Author < ActiveRecord::Base
  has_many :articles, dependent: :destroy
end

class Article < ActiveRecord::Base
  belongs_to :author
  default_scope -> { where(published: true) }
end
```

Jeżeli zechcemy wybrać wszystkie artykuły danego autora default scope spowoduje, że zobaczymy tylko te publiczne artykuły. Na tej podstawie widzimy, że **`default_scope` zostanie użyty przy korzystaniu z asocjacji w modelu**.

```ruby
author.articles
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = ? AND "articles"."author_id" = ? [["published", true], ["author_id", 1]]
```

Załóżmy teraz, że chcemy usunąć autora wraz z wszystkimi jego artykułami. W przypadku braku domyślnego zakresu w modelu moglibyśmy po prostu wywołać `author.destroy`, ale gdy artykuł ma default scope oczekiwane zachowanie będzie inne niż to co naprawdę zostanie wykonane. Wywołując `author.destroy` zaczniemy usuwanie tylko artykułów, które są `published`, ale artykuły nieopublikowane nie zostaną usunięte. To spowoduje wyjątek po stronie bazy danych dotyczący naruszenia klucza obcego. W przeciwnym wypadku w bazie danych zostałyby rekordy odwołujące się do nieistniejącego autora.

## Default scope a nadpisanie domyślnej wartości zakresu

Powiedzmy, że masz default scope na modelu `Article`, który zwraca rekordy w odpowiedniej kolejności:

```ruby
class Article < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
end
```

i chcesz zmienić kolejność elementów z sortowania po `created_at` na `updated_at`. W takiej sytuacji `Article.order(updated_at: :desc)` nie zrobi tego, co oczekujesz. Zamiast kolejności względem pola `updated_at` otrzymasz podobnie jak w przypadku dziedziczenia połączenie warunków.

```ruby
Arcicle.order(updated_at: :desc).limit(10)
# SELECT "articles".* FROM "articles" ORDER BY "articles"."created_at" DESC, "articles"."updated_at" DESC LIMIT 10
```

Artykuły zostaną posortowane względem obu pól: `created_at` i `updated_at`. Default scope nie zostanie nadpisany. Musisz użyć metody `unscoped`, by pozbyć się niechcianego default scope.

```ruby
Article.unscoped.order(updated_at: :desc).limit(10)
# SELECT "articles".* FROM "articles" ORDER BY "articles"."updated_at" DESC LIMIT 10
```

Pamiętaj jednak, że `unscoped` może być zdradliwy. Spójrz poniżej.

**Mała uwaga**. Jeżeli interesuje Cię kolejność rekordów Twojego modelu, to zerknij na metodę `implicit_order_column` w Railsach.

## Default scope a `unscoped`

`Unscope` pozwala nam usunąć niechciane zakresy, które są już zdefiniowane w modelu. To znaczy, że możemy usunąć wybrany scope, ale też możemy usunąć wszystkie zakresy.

```ruby
class Article < ActiveRecord::Base
  default_scope -> { where(published: true) }
  default_scope -> { where(archived: true) }
end
```

Jeżeli użyjesz metody `unscoped` usuniesz wszystkie zakresy.

```ruby
Articles.all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true AND "articles"."archived" = true

Articles.unscoped.all
# SELECT "articles".* FROM "articles"
```

Jeżeli chcesz usunąć tylko jeden z nich, to możesz zrobić to za pomocą metody `unscope` podając dodatkowo wybrany warunek.

```ruby
Article.unscope(where: :archived).all
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = true

Article.unscope(where: :published).all
# SELECT "articles".* FROM "articles" WHERE "articles"."archived" = true
```

Trzeba także pamiętać, że kolejność wywołania metod ma znaczenie. Jeżeli najpierw użyjemy metody `unscoped` a później dodamy nowy warunek, to default scope zostanie usunięty, ale nowy warunek będzie uwzględniony w zapytaniu:

```ruby
Article.uncoped.where(title: 'Default scope overview')
# SELECT "articles".* FROM "articles" WHERE "articles"."title" = 'Default scope overview'
```

Natomiast, gdy zmienimy kolejność tych metod, to usuniemy wszystkie warunki i default scope i nowy warunek `where`:

```ruby
Article.where(title: 'Default scope overview').uncoped
# SELECT "articles".* FROM "articles"
```

Interesujący przypadek z `unscoped` dostaniemy dla asocjacji.

```ruby
class Author < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :author
  default_scope -> { where(published: true) }
end
```

Tak jak już wspominałam wcześniej, gdy pytamy o artykuły konkretnego autora, wyniki zostaną ograniczone do tych spełniających default scope:

```ruby
Author.first.articles
# SELECT "articles".* FROM "articles" WHERE "articles"."published" = ? AND "articles"."author_id" = ? [["published", true], ["author_id", 1]]
```

ale gdy użyjemy `unscoped`, nawet warunek dotyczący autora zostanie usunięty.

```ruby
Autor.first.articles.unscoped
# SELECT "articles".* FROM articles
```

Warto zapamiętać, że **`unscoped` usuwa WSZYSTKIE zakresy nawet te związane z asocjacjami**.

By pozbyć się niechcianego default scope musimy użyć metody `unscope` i wybrać tylko zakres `published`:

```ruby
Author.first.articles.unscope(where: :published)
# SELECT "articles".* FROM "articles" WHERE "articles"."author_id" = ? [["author_id", 1]]
```

## Sposoby na nadpisanie default scope

Zdefiniujmy jeszcze raz naszą klasę:

```ruby
  class Article < ActiveRecord::Base
    default_scope -> { where(status: :published) }
    scope :archvied, -> { where(status: :archived)}
  end
```

Istnieje kilka możliwości by dostać tylko artykuły zarchiwizowane niezależnie od tego czy były publiczne czy nie.

Możemy użyć `unscoped` a później metodę `archived`:

```ruby
Article.unscoped.archvied
# SELECT "articles".* FROM articles WHERE "articles"."status" = 'archived'
```

Możemy użyć metody `unscope` i wybrać konkretny zakres, który chcemy pominąć:

```ruby
Article.unscope(where: :state).archvied
# SELECT "articles".* FROM articles WHERE "articles"."status" = 'archived'
```

Dostępna jest też metoda `rewhere`:

```ruby
Article.rewhere(state: :archived)
# SELECT "articles".* FROM articles WHERE "articles"."status" = 'archived'
```

W przypadku default scope opartego na sortowaniu możemy użyć metody `reorder`.

## Podsumowanie

- Jeśli nie rozumiesz, jak default scope działa, może Ci to przysporzyć wiele problemów: długi czas debugowania, dziwne lub niespodziewane zachowanie aplikacji, czy też nieczytelny kod
- Default scope może stać się dość skomplikowany zwłaszcza w przypadku dziedziczenia czy relacji.
- `default_scope` zachowuje się podobnie do [gemu ActsAsParanoid](https://github.com/ActsAsParanoid/acts_as_paranoid "Gem ActsAsParanoid"), w obu przypadkach warto zachować ostrożność i pomyśleć dwa razy przed podjęciem decyzji o użyciu tych rozwiązań.
- Możemy myśleć o `defaul_scope` jako o czymś podobnym do globalnego stanu lub wzorca projektowego singleton. Musimy wiedzieć, co robimy, te narzędzia mogą być zarówno użyteczne jak i niebezpieczne ;)
- Moim zdaniem `default_scope` jest narzędziem, które warto używać w bardzo określonych przypadkach, jednak nie mogę się zgodzić, że to źródło wszelkiego zła ;)
- Największym problemem z `default_scope` jest użycie go niejawnie - ukrywając go gdzieś w kodzie. W takim przypadku będziemy mieć problemy z zrozumieniem logiki, debugowaniem i dziwnym zachowaniem. Są to jednak problemy z komunikacją (programista - kod - programista). Dlatego warto używać `default_scope` jawnie, jak w przypadku klasy `ArchivedArticle`.

## Źródła

- [Why is using the rails default_scope often recommend against? - EN](https://stackoverflow.com/questions/25087336/why-is-using-the-rails-default-scope-often-recommend-against "Stack Overflow wątek na temat default_scope")
- [Using Default Scope and Unscoped in Rails - EN](https://blog.jasonmeridth.com/posts/using-default-scope-and-unscoped-in-rails/ "Artykuł na temat default_scope i unscoped")
- [How to Carefully Remove a Default Scope in Rails - EN](https://singlebrook.com/2015/12/18/how-to-carefully-remove-a-default-scope-in-rails/ "Artykuł na temat usuwania default_scope")
- [Beware of using default scope - EN](https://coderwall.com/p/khht6a/beware-of-using-default-scope "Ciekawostki na temat default_scope")
- [default_scope - Ruby on Rails documentation - EN](https://api.rubyonrails.org/classes/ActiveRecord/Scoping/Default/ClassMethods.html#method-i-default_scope "Dokumentacja Ruby on Rails odnosnie default_scope")
