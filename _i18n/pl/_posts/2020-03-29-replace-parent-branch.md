---
layout: post
title: Jak podmienić gałąź rodzica w git-cie?
description: Ustawienie nowej gałęzi rodzica przy pomocy git rebase --onto.
headline: Premature optimization is the root of all evil.
categories: [narzędzia, git]
tags: [środowisko programistyczne, git, system kontroli wersji]
lang: pl
imagefeature: git-rebase/git.png
---

Kilka dni temu stworzyłam nową gałąź (branch). Na tej gałęzi zatwierdziłam już kilka zmian (czyli dodawałam kilka commit-ów), ale po jakimś czasie zorientowałam się, że gałąź od jakiej wyszłam to nie master tylko zupełnie inna gałąź. No cóż moje przeoczenie, tylko jak teraz poradzić sobie z tym problemem? W tym momencie potrzebowałam scalić (merge) moje bieżące zmiany z gałęzią master. Jednak to nie był dobry czas na dodanie również zmian z tej drugiej gałęzi. Jak to zrobić? W takiej sytuacji z pomocą przychodzi nam git.

Problem, który opisałam powyżej można rozwiązać na wiele sposobów. Ja omówię dwa. Pierwszy jest łatwy w zrozumieniu, ale trochę czasochłonny. Możemy stworzyć nową gałąź. Taką, która będzie wywodzić się od gałęzi master i użyć komendy `git cherry-pick`. Tak by przenieść wszystkie zmiany z jednej gałęzi na drugą. To rozwiązanie jest OK, ale tylko wtedy, gdy nie ma się tych zmian za dużo. Wyobraź sobie, że masz 10 zatwierdzonych zmian (commit-ów). Teraz do każdej takiej zmiany musisz zastosować komendę `git cherry-pick`. Jest to całkiem sporo pracy. Drugi powód jest równie ważny. W wielu firmach programistycznych istnieje zdefiniowany proces dostarczania nowych funkcjonalności. Często częścią tego procesu jest pokazanie swojego kodu innym członkom zespołu zanim zostanie on dołączony do głównej gałęzi. Jest to tak zwane **review kodu**. Przeprowadza się je na zdalnym repozytorium używając do tego pull/merge request-ów. Dodatkowo założenie takiego przeglądu kodu jest proste: co najmniej jedna osoba musi takie zmiany zatwierdzić. Jeżeli stworzymy nową gałąź to proces przeglądu kodu prawdopodobnie będzie musiał zostać powtórzony. Co powoduje przeznaczenie dodatkowego czasu na przejrzenie lub przynajmniej zatwierdzenie zmian.

Jest jednak inne rozwiązanie. Możemy użyć komendy `git rebase --onto`. Pozwoli nam ona zrobić dokładnie to czego oczekujemy, czyli pozwoli nam zamienić gałąź rodzicielską od której wyszła nasza bieżąca gałąź. Na schemacie poniżej możesz zobaczyć ułożenie naszych gałęzi przed wywołaniem komendy `git rebase --onto`:

```
A---B---C---D  master
            \
              E---F---G  feature-branch
                      \
                        H---I---J current-feature-branch (HEAD)
```

oraz po jej wywołaniu:

```
A---B---C---D  master
            |\
            | E---F---G  feature-branch
            |
             \
              H'---I'---J' current-feature-branch (HEAD)
```

By zamienić gałąź rodzicielską na gałąź `master` musimy się przełączyć na gałąź `current-feature-branch` (to jest właśnie nasza problematyczna gałąź) i wywołać następującą komendę:

```bash
git rebase --onto master feature-branch
```

I to wszystko. Nasza gałąź `current-feature-branch` wywodzi się teraz od gałęzi `master`, właśnie o to nam chodziło.

Na koniec chciałabym jeszcze powiedzieć dwie rzeczy. Po pierwsze: Jeżeli chcesz dostosować polecenie `git rebase --onto` do swoich potrzeb, to tak wygląda jego ogólne wytłumaczenie dla pokazanego problemu:

```bash
git rebase --onto new-parent old-parent
```

Po drugie, jak pewnie zauważyłaś na schemacie po wykonaniu polecenia `git rebase --onto` nie mamy dostępu do dokładnie tych samych zmian co przedtem. Kod w naszych zatwierdzonych zmianach pozostaje taki sam, jednak zmienia się unikalny identyfikator każdej zmiany, czyli jego **SHA** (np. `2d4698b`). Wszystko będzie dobrze jeżeli sama pracujesz na problematycznej gałęzi. Tak było w moim przypadku. Sprawa zaczyna się komplikować, gdy na gałęzi pracują też inne osoby w zespole. Może to powodować problemy. Identyfikatory zmian u Ciebie lokalnie, a także na zdalnym repozytorium, będą inne niż u reszty Twojego zespołu. Pamiętaj o tym, zanim użyjesz polecenia `git rebase --onto`, ponieważ przykładowo może to doprowadzić do zniknięcia części zmian z repozytorium.
