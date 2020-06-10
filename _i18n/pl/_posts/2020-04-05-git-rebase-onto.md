---
layout: post
photo: git-rebase-onto/git-rebase-onto-header.png
title: Jak używać git rebase --onto?
description: Usuwanie zmian z bieżącej gałęzi lub zmiana gałęzi rodzicielskiej
headline: Premature optimization is the root of all evil.
categories: [narzędzia, git]
tags: [środowisko programistyczne, git, system kontroli wersji]
lang: pl
imagefeature: git-rebase-onto/git-rebase-onto.png
---

W artykule o <a href="{{ site.baseurl }}/replace-parent-branch" title="Jak podmienić gałąź rodzica w git-cie?">podmianie gałęzi rodzica w git-cie</a> pokazałam Ci jedno z zastosowań komendy `git rebase --onto`. Dziś skupimy się na zgłębieniu tematu, bo jest o czym mówić. Im lepiej zrozumiesz to polecenie tym łatwiej będzie Ci go w przyszłości użyć. Zapraszam!

Istnieją dwa przypadki, w których `git rebase --onto` może się przydać:
1. Masz gałąź (branch), na której chciałabyś zmienić gałąź rodzica.
2. Chcesz szybko usunąć zmiany ze swojej gałęzi.

Oczywiście możesz te dwa powody ze sobą połączyć i podmienić gałąź rodzica w tym samym momencie, gdy usuwasz zmiany. Dojdziemy do tego. Najpierw jednak ważne jest zrozumienie różnicy w wywołaniu `git rebase --onto` z dwoma lub trzeba argumentami.

Zacznijmy jednak od małej powtórki. Omówimy sobie pokrótce czym jest `git rebase`. Jeśli będziesz zainteresowana dodatkowymi informacjami o <a href="{{ site.baseurl }}/git-rebase" title="Jak używać git rebase?">git rebase</a>, to odsyłam Cię do osobnego artykułu na ten temat.

## Git rebase

Komenda `git rebase <newparent> <branch>` pozwala nam na dostęp do ostatnich zmian jakie istnieją na gałęzi `<newparent>` i na przesunięcie naszych zmian z gałęzi `<branch>` ponad zmiany z gałęzi `<newparent>`.

Używając komendy:

<pre>
git rebase master next-feature
</pre>

otrzymamy:

<pre>
Before                            After
A---B---C---F---G (HEAD master)   A---B---C---F---G (master)
         \                                         \
          D---E (next-feature)                      D'---E' (HEAD next-feature)
</pre>

Jak widać powyżej po wykonaniu komendy `git rebase` nasz `HEAD` wędruje zawsze na gałąź, która była zdefiniowana jako ostatni argument. W naszym przypadku jest to gałąź `next-feature`. Możemy powiedzieć, że przełączyłyśmy się na gałąź `next-feature`. Po wykonaniu `git rebase` dalej mamy dostęp do wszystkich zmian jakie były na gałęzi `next-feature` przed jej wykonaniem, jednak nie są to dokładnie te same zmiany. Kod, który się tam znajduje jest identyczny. Zmieniły się natomiast identyfikatory zmian wygenerowane przez kryptograficzną funkcję skrótu **SHA-1** (`dce79fd`), które często w skrócie  określamy jako **SHA**. To dlatego na schemacie powyżej zmiany te zostały zaznaczone jako `D'` i `E'`.

Gdy jesteśmy na gałęzi, na której chcemy wykonać `git rebase` możemy pominąć drugi argument komendy, a efekt końcowy będzie taki sam. Komenda:

<pre>
git rebase master
</pre>

daje następujący rezultat:

<pre>
Before                              After
A---B---C---F---G (master)          A---B---C---F---G (master)
         \                                           \
          D---E (HEAD next-feature)                   D'---E' (HEAD next-feature)
</pre>

W obu przypadkach na gałęzi `master` były dwie dodatkowe zmiany `F` i `G`, które nie były dostępne z poziomu gałęzi `next-feature`. Wykonując polecenie `git rebase` bierzemy zmianę `D`, która jest pierwszą zmianą na gałęzi `next-feature` wraz z resztą zmian na tej gałęzi i przenosimy/przesuwamy je ponad/powyżej ostatnią zmianę na gałęzi `master`, czyli ponad zmianę `G`. W przypadku schematów pokazywanych w tym artykule lepiej będzie użyć sformułowania _przesuwamy zmiany na koniec gałęzi `master`_. Warto jednak pamiętać, że korzystając z narzędzi takich jak `git log` nasze zmiany będziemy widzieć nad zmianami z gałęzi `master`. Mówiąc jeszcze inaczej zmieniamy rodzica naszej gałęzi `next-feature` ze zmiany `C` na zmianę `G`.

## Git rebase --onto

### Bardziej precyzyjne podmienianie gałęzi rodzicielskiej

W przypadku polecenia `git rebase --onto` możemy przesunąć się w dowolne miejsce gałęzi rodzicielskiej, nie tylko na jej koniec. Dokładniej mówiąc możemy przesunąć punkt rozgałęzienia miedzy naszą gałęzią a gałęzią rodzicielską w dowolne miejsce drzewa zmian, czyli punkt rozgałęzienia może znaleźć się na dowolnej istniejącej zmianie. Dodatkowo możemy również wybrać zmianę, która będzie ostatnią zmianą widoczną na naszej gałęzi. Możemy powiedzieć, że `git rebase --onto` jest bardzo precyzyjny i elastyczny. Daje nam dostęp do tego gdzie chcemy zacząć, a gdzie skończyć.

Przykładowo, chciałabyś przesunąć rozpoczęcie swojej gałęzi `my-branch` z `C` na `F` i usunąć zmianę `D`. By móc tego dokonać potrzebujesz:

<pre>
git rebase --onto F D
</pre>

A tak wygląda to na schemacie:

<pre>
Before                                    After
A---B---C---F---G (branch)                A---B---C---F---G (branch)
         \                                             \
          D---E---H---I (HEAD my-branch)                E'---H'---I' (HEAD my-branch)
</pre>

Przesuwamy zmiany dostępne z poziomu `HEAD`, czyli naszego `my-branch`, gdzie starą zmianą rodzicielską było `D`, na nową zmianę rodzicielską `F`.  Możemy też powiedzieć, że zmieniamy rodzica zmiany `E` z `D` na `F`.

Taki sam efekt uzyskamy korzystając z polecenia:

<pre>
git rebase --onto F D my-branch
</pre>

Sytuacja wygląda inaczej, gdy zamiast `HEAD`, jako trzeci argument, podamy ostatnią zmianę. W naszym przypadku `I`. Wywołanie będzie wyglądać następująco:

<pre>
git rebase --onto F D I
</pre>

A efekt jaki otrzymamy widoczny jest na schemacie:

<pre>
Before                                    After
A---B---C---F---G (branch)                A---B---C---F---G (branch)
         \                                        |    \
          D---E---H---I (HEAD my-branch)          |     E'---H'---I' (HEAD)
                                                   \
                                                    D---E---H---I (my-branch)
</pre>

Podobnie jak w przypadku `git rebase` bez dodatkowych parametrów, tu też przełączamy `HEAD` na ostatni argument wywołania komendy `git rebase --onto`. Widzimy, że nasza gałąź `my-branch` pozostała nienaruszona, natomiast `HEAD` znajduje się na nowej wersji zmiany `I`. Nie jest to jeszcze nazwana gałąź, ale jeżeli chcemy możemy ją nazwać. Zastanówmy się teraz, co tu się stało. Nasze polecenie `git rebase --onto F D I` sprawia, że zmieniamy rodzica zmiany `E`. Można tu się zastanowić dlaczego właściwie zmiany `E`? Przecież zmiana ta nie występuje nigdzie w poleceniu. Jest to pewnego rodzaju podmiot domyślny. Skoro bieżącym rodzicem jest zmiana `D`, to jest ona rodzicem dla zmiany `E`. W skrócie możemy powiedzieć, że `git rebase --onto F D I` zmieni rodzica zmiany `E` ze zmiany `D` na `F`. Dodatkowo przełączy nasz `HEAD` na zmianę `I`.

Taki sam efekt uzyskamy korzystając z polecenia:

<pre>
git rebase --onto F D HEAD
</pre>

Podobna sytuacja ma miejsce, gdy chcemy na przykład przełączyć `HEAD` na zmianę `H`. Tak będzie wtedy wyglądać komenda:

<pre>
git rebase --onto F D H
</pre>

Natomiast nasze drzewo gałęzi będzie wyglądać następująco:

<pre>
Before                                    After
A---B---C---F---G (branch)                A---B---C---F---G (branch)
         \                                        |    \
          D---E---H---I (HEAD my-branch)          |     E'---H' (HEAD)
                                                   \
                                                    D---E---H---I (my-branch)
</pre>

Jedyna rzecz jaka zmieniła się od ostatniego przykładu, to że `HEAD` nie znajduje się teraz na `I` ale na zmianie `H`. Wcześniej, przed wykonaniem komendy `git rebase --onto`, `HEAD` znajdował się na gałęzi `my-branch`. Po wywołaniu polecenia `git rebase --onto F D H` przenosimy `HEAD` na zmianę `H` ignorując przy tym całkowicie zmianę `I`. Analogiczne zachowanie zaobserwujemy w naszym drzewie po wykonaniu jednego z poniższych poleceń:

<pre>
git rebase --onto F D H
git rebase --onto F D HEAD^
git rebase --onto F D HEAD~
git rebase --onto F D HEAD~1
</pre>

## Usuwanie zmian z bieżącej gałęzi

To szybkie rozwiązanie, które pozwala nam usunąć niektóre zmiany z naszej gałęzi bez konieczności używania interaktywnego polecenia rebase. Jeżeli mamy gałąź, na której chcemy usunąć zmiany `C` i `D`, możemy to zrobić za pomocą polecenia:

<pre>
git rebase --onto B D
</pre>

Co daje nam:

<pre>
Before                                 After
A---B---C---D---E---F (HEAD branch)    A---B---E'---F' (HEAD branch)
</pre>

W tym przypadku mówimy _przenieś `HEAD` nad zmianę `B`, gdzie starą zmianą rodzicielską była zmiana `D`_. Taki sam efekt uzyskamy za pomocą:

<pre>
git rebase --onto B D my-branch
</pre>

W przypadku gdy użyjemy `git rebase --onto` z trzema argumentami, gdzie ostatnim argumentem będzie identyfikator zmiany, sytuacja będzie wyglądać trochę inaczej. Powiemy wtedy: _przenieś `HEAD` nad zmianę `B`, gdzie starą zmianą rodzicielską była zmiana `D`, ale tylko do zmiany `E`_. By to osiągnąć użyjemy następującego polecenia:

<pre>
git rebase --onto B D E
</pre>

Dostaniemy wtedy _nową gałąź_ tylko ze zmianą `E` wychodzącą od zmiany `B`:

<pre>
Before                                 After
A---B---C---D---E---F (HEAD branch)    A---B---C---D---E---F (branch)
                                            \
                                             E' (HEAD)
</pre>

## Podsumowanie git rebase --onto

Podsumujmy teraz jak działa `git rebase --onto`. Polecenia tego możemy używać z dwoma lub trzema argumentami. Gdy używamy `git rebase --onto` z dwoma argumentami to tak wygląda składnia tego polecenia:

<pre>
git rebase --onto &lt;newparent&gt; &lt;oldparent&gt;
</pre>

To pozwala nam zmienić bieżącą gałąź rodzicielską `<oldparent>` na nową `<newparent>`. Ze względu na to, że nie określamy tutaj trzeciego argumentu zostajemy na bieżącej gałęzi. W przypadku `git rebase --onto` z trzema argumentami składnia polecenia wygląda następująco:

<pre>
git rebase --onto &lt;newparent&gt; &lt;oldparent> &lt;until&gt;
</pre>

W tym przypadku nie tylko możemy zmienić gałąź rodzicielską `<oldparent>` na nową `<newparent>`, ale możemy też określić do jakiej zmiany chcemy to zrobić `<until>` (na jakiej zmianie chcemy zakończyć). Watro tu pamiętać, że `<until>` stanie się naszym nowym `HEAD` po zakończeniu `git rebase --onto`.
