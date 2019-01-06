---
layout: post
title: Git Rebase
description: Jak używać git rebase?
headline: My code is getting worse, please send more chocolate
categories: [narzędzia]
tags: [środowisko programistyczne, git, system kontroli wersji]
comments: true
---


Poprzednie dwa artykuły wprowadzały do tego [co to jest git]({{ site.baseurl }}/what-is-git) i jak go [używać]({{ site.baseurl }}/git-usage). Możecie tam znaleźć podstawowe informacje na temat gita. Dzisiaj chciałabym skupić się na trochę bardziej zaawansowanych rzeczach związanych z gitem. W zeszłym tygodniu robiłam krótką prezentację dotyczącą funkcji `git rebase`, pomyślałam więc że to dobry pomysł by zrobić z tego krótką notatkę tutaj. Oto ona.

Kiedy używamy gita mamy dwie możliwości dociągnięcia nowych zmian ze zdalnego repozytorium. **Merge** i **rebase**. Jeżeli używamy funkcji **merge** (jest to opcja domyślna) git stara się rozwiązać wszystkie konflikty i umieszcza nasze zmiany między zmianami innych członków zespołu, porządkując je względem linii czasu. Natomiast gdy używamy opcji **rebase** git przenosi nasze lokalne zmiany do takiego tymczasowego miejsca i dociąga to co się zmieniło z zdalnego repozytoriom. Po czym każdą naszą lokalną zmianę umieszcza z powrotem na branch na samej górze wszystkich dociągniętych zmian. Mówimy wtedy, że jesteśmy na samej górze **HEAD**. Można powiedzieć, że HEAD jest czymś w rodzaju takiego znacznika, która wersja jest aktualna. Kiedy na zdalnym repozytorium są zmiany, których jeszcze nie mamy u siebie na komputerze, mówimy że jesteśmy **za HEAD** (czyli za tym głównym znacznikiem), jak tylko dociągniemy zmiany to będziemy **na bieżącym HEAD**.

<figure>
  <a href="{{ site.baseurl_root }}/images/git-rebase/rebase-diagram.png"><img src="{{ site.baseurl_root }}/images/git-rebase/rebase-diagram.png"></a>
</figure>

A teraz zobaczmy jak wizualnie wyglądają różnice między tymi dwoma metodami.

## Merge

<figure>
  <a href="{{ site.baseurl_root }}/images/git-rebase/merge.png"><img src="{{ site.baseurl_root }}/images/git-rebase/merge.png"></a>
</figure>

Widać że zmiany, które tworzą logiczną całość po dołączeniu do gałęzi (branch) develop zostają przeplecione innymi zmianami. Wszystko powoduje wrażenie bałaganu i nieładu. Dodatkowo da się zauważyć zmiany (commit), których sami nie zrobiłyśmy. Są to właściwie informacje o tym jak zostały połączone pliki modyfikowane przez kilka osób.

## Rebase

<figure>
  <a href="{{ site.baseurl_root }}/images/git-rebase/rebase.png"><img src="{{ site.baseurl_root }}/images/git-rebase/rebase.png"></a>
</figure>

Tutaj wszystko ma swoje miejsce. Zmiany są pogrupowane w jakieś logiczne całości. Dodatkowo widzimy historię naszych gałęzi (branches).

## W takim razie jak możemy to zrobić, gdy nasz kod był tylko zapisany lokalnie?

1. Przechodzimy na gałąź (branch) develop

    ```bash
    git checkout develop
    ```

2. Dociągamy najnowsze zmiany

    ```bash
    git pull
    ```

3. Przełączmy się na naszą gałąź (branch) gdzie wcześniej pracowałyśmy

    ```bash
    git checkout my-branch
    ```

4. Robimy rebase

    ```bash
    git rebase develop
    ```

5. Możemy wrzucić zmiany na zdalne repozytorium

    ```bash
    git push
    ```

Czasami gdy będziemy robić `git rebase`, git może nie dać sobie rady sam z rozwiązywaniem konfliktów (czyli łączeniem plików modyfikowanych przez kilka osób). Wtedy do akcji wkraczamy my. Poprawnie rozwiązujemy konflikty i dodajemy nasze zmiany, tak by git je widział. Następnie możemy dalej kontynłować rebase.

```bash
git rebase develop
# rozwiązanie konfliktów
git add -u # dodanie wszystkich zmian do śledzenia
git rebase --continue
```

Musimy porozmawiać jeszcze o jedne rzeczy. Czasami nasze zmiany są już na zdalnym repozytorium a my musimy/chcemy zrobić rebase. Po zakończeniu całej operacji chcemy umieści zmiany z powrotem na zdalnym repozytorium. Jednak tym razem `git push` nam nie zadziała. W takie sytuacji możemy zrobić tak:

```bash
git push -f origin my-branch
```

Uwaga! Z tym poleceniem trzeba być bardzo uważnym. Polecenie to nadpisze wszystkie zmiany na wybranej przez nas gałęzi (branch) zmianami, które miałyśmy lokalnie. Jeżeli tylko my pracujemy na tej gałęzi nic się nie stanie. Jeżeli współdzielimy tą gałąź z kimś innym, trzeba myśleć o tym, że możemy usunąć czyjeś zmiany. Musimy wiedzieć co robimy i zdawać sobie sprawę z konsekwencji.

Gdybyśmy chcieli zrezygnować z rebase, możemy do tego celu użyć polecenia:

```bash
git rebase --abort
```

To wszystko na dzisiaj. Pokazałam Wam jak można używać `git rebase`. Mam nadzięję, że było to dla Was pomocne. Jeżeli miacie jakieś pytania lub sugestie zapraszam do komentowania. Do zobaczenia następnym razem!
