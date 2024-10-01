#import "defs.typ": *
#import "links.typ": *

= C

Le langage C est un langage de programmation créé en 1972 par Dennis
Ritchie pour le développement du système d'exploitation Unix. Il est
un des langages les plus utilisés dans le monde de l'informatique et
est souvent utilisé pour écrire des systèmes d'exploitation, des
compilateurs, des interpréteurs et des logiciels embarqués.

Le langage a été normalisé par l'ANSI#footnote[_American National
Standard Insitute_, le service de standardisation des États-Unis.] en
1989 #cite(<c89>) puis par l'ISO#footnote[_International Organization for
Standardization_, l'organisation internationale de standardisation.] en
1990 #cite(<c90>). Le standard a été à plusieurs reprises jusqu'à la dernière
version en 2018 #cite(<c18>).

Il existe par ailleurs plusieurs référentiels de
programmation pour garantir une certaine qualité de code. Le plus connu est le
référentiel MISRA-C #cite(<misra>) qui est utilisé dans l'industrie pour
aider à fiabiliser les logiciels embarqués.

== Paradigme

Le langage C est un langage de programmation essentiellement
#paradigme[impératif]. Il est possible, dans une certaine mesure, de programmer
dans un style #paradigme[fonctionnel]. Par exemple, l'exemple du
#ref(<ex_C_length>) peut aussi s'écrire de manière récursive :

```c
int length(struct list *l)
{
  return (NULL == l) ? 0 : 1 + length(l->next);
}
```

mais cela reste limité par rapport aux langages explicitement fonctionnels.
Le style idiomatique est plutôt procédural à la manière de l'exemple
#ref(<ex_C>).

#figure(
  ```c
  int add_value(struct state *s, int v)
  {
    int code = KO;
    if (NULL != s) {
      s->value += v;
      code = OK;
    }
    return code;
  }
  ```,
  caption: [Exemple de code C idiomatique],
) <ex_C>

Dans cet exemple, on déclare une fonction `add_value` qui prend en paramètre
un pointeur vers une structure `struct state` et un entier `v`. Si le pointeur
n'est pas `NULL`, on ajoute la valeur `v` à la valeur de la structure et on
retourne `OK`. Sinon, on retourne `KO`.

Le code est clairement impératif avec la séquence d'instructions, le `if` et
les effets de bord `s->value += v` et `code = OK`.

Sauf pour les fonctions simples et totales comme avec `length`, le code de
retour est généralement utilisé comme un code indiquant si l'appel
a été fructeux ou s'il y a eu une erreur. En pratique, cela donne des appels
en séquence avec un style dit
_défensif_ comme dans le #ref(<defensif_C>).

#figure(
  ```c
  int add_values(struct state *s) {
    int code = KO;
    if (KO == add_value(s, 42)) {
      /* traitement d'erreur 1 ...*/
    }
    if (KO == add_value(s, 24)) {
      /* traitement d'erreur 2 ...*/
    }
    code = OK;
    return code;
  }
  ```,
  caption: [Exemple de code C défensif],
) <defensif_C>


== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

Nous avons comparés plusieurs analyseurs statiques permettant de
détecter des erreurs au _runtime_ pour le langage C. Parmi ceux-ci, nous
en avons les cinq qui ont la propriété d'être _corrects_ et de ne pas donner
de garantir l'absence d'une catégorie de _bug_ : _Astree_, _ECLAIR_, _Frama-C_,
_Polyspace_ et _TIS Analyser_.

Comme indiqué dans la méthodologie, nous avons indiqué les erreurs détectées
d'après les documents publiques. Toutefois, ceux-ci ne sont pas forcément
complets et il est possible que les outils détectent d'autres erreurs non
mentionnées ici. Les cases cochées indiquent que l'outil détecte _au moins_
le type d'erreur correspondant.

#figure(

  table(
    columns: (auto, auto, auto, auto, auto, auto),
    [*Erreur*],                      [*Astrée*], [*ECLAIR*], [*Frama-C*], [*Polyspace*], [*TIS Analyser*],
    [*Division par 0*],              [✓],        [✓],         [✓],          [✓],            [✓],
    [*Débordement de tampon*],       [✓],        [✓],         [✓],          [✓],            [✓],
    [*Déréférencement de NULL*],     [✓],        [✓],         [],           [✓],            [],
    [*Dangling pointer*],            [✓],        [✓],         [✓],          [],             [✓],
    [*Data race*],                   [✓],        [✓],         [],           [],              [],
    [*Interblocage*],                [✓],        [✓],         [✓],          [],             [],
    [*Vulnérabilités de sécurité*],  [✓],        [✓],         [],           [],              [],
    [*Arithmétique entière*],        [✓],        [],          [✓],          [],              [✓],
    [*Arithmétique flottante*],      [✓],        [],          [✓],          [],              [],
    [*Code mort*],                   [✓],        [✓],         [✓],          [✓],            [],
    [*Initialisation*],              [✓],        [✓],         [✓],          [✓],            [✓],
    [*Flot de données*],             [✓],        [✓],         [✓],          [],              [],
    [*Contrôle de flôt*],            [✓],        [],          [✓],          [✓],             [],
    [*Flôt de signaux*],             [✓],        [],          [],           [],              [],
    [*Non-interférence*],            [✓],        [],          [],           [],              [],
    [*Fuites mémoire*],              [],         [✓],         [],           [],              [],
    [*Double `free`*],               [],         [✓],         [],           [],              [],
    [*Coercions avec perte*],        [],         [✓],         [✓],          [],              [✓],
    [*Mémoire superflue*],           [],         [✓],         [],           [],              [],
    [*Arguments variadiques*],       [],         [✓],         [✓],          [],              [],
    [*Chaînes de caractères*],       [],         [✓],         [],           [],              [],
    [*Contrôle d'API*],              [],         [✓],         [],           [✓],             [],
  )
)


==== WCET

La complexité du calcul statique du WCET fait qu'il y a peu d'outil
disponibles. Nous en avons comparés six: #chronos, #bound-T,
#aiT, #sweet, #otawa et #rapidtime. #chronos, #sweet et #otawa sont des outils
académiques tandis que #aiT et #rapidtime sont des outils commerciaux.
#bound-T est à la base un outil commercial mais qui n'est plus maintenu et qui
a été rendu _open source_.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    [*Outil*],     [*WCET statique*], [*WCET dynamique*], [*WCET hybride*], [*Architecture cible*],
    [*Chronos*],   [✓],               [✓],               [],               [
    ],
    [*Bound-T*],   [✓],               [],                [],               text(size: 8pt)[
      - Analog Devices ADSP21020
      - ARMv7 TDMI
      - Atmel AVR (8-bit)
      - Intel 8051 (MCS-51) series
      - Renesas H8/300
      - SPARC v7 / ERC32
    ],
    [*aiT*],       [✓],               [],                [],               text(size: 8pt)[
      - Am486, IntelDX4
      - ARM
      - C16x/ST10
      - C28x
      - C33
      - ERC32
      - HCS12
      - i386DX
      - LEON2, LEON3
      - M68020, ColdFire MCF5307
      - PowerPC
      - TriCore
      - V850E
    ],
    [*SWEET*],     [✓],               [],                [],               [
    ],
    [*Otawa*],     [✓],               [],                [],               text(size: 8pt)[
      - ARM v5,
      - ARM v7,
      - PowerPC (including VLE mode),
      - Sparc,
      - TriCore,
      - Risc-V
    ],
    [*RapidTime*], [],                [],                 [✓],              text(size: 8pt)[
      - ARM (7, 9, 11, Cortex-A, Cortex-R, Cortex-M)
      - Analog Devices
      - Atmel
      - Cobham Gaisler
      - ESA
      - Freescale (NXP)
      - IBM
      - Infineon
      - Texas Instruments
    ],
  )
)

Notons que #chronos et #sweet ne ciblent pas d'architecture particulière mais
se basent sur une
représentation intermédiaire, respectivement un sur-ensemble MIPS et
ALF, pour
effectuer leur analyse. L'avantage est
qu'il est techniquement possible de cibler n'importe quelle architecture dès
lors qu'il y a un traducteur du langage source vers la représentation
intermédiaire. Comme celle-ci ne tient pas compte de toutes les spécificités de
l'architecture ciblée, le WCET calculé est _a priori_ moins précis.

#otawa fonctionne avec des fichiers décrivant l'architecture cible; ce qui
le rend a priori compatible avec toutes les architectures modulo le temps
d'écrire ces descriptions si elles n'existent pas déjà. Les architectures
indiquées sont celles dont les descriptions sont déjà disponibles.


==== Pile

Il existe plusieurs outils pour analyser statiquement la pile utilisée par un
programme. Parmi ceux-ci, nous avons comparé #gcc, #stackanalyser, #t1stack et
#armlink.

#gcc propose une option `-fstack-usage` qui permet de générer un fichier
décrivant l'utilisation de la pile par le programme. Le fichier généré contient
la taille de pile utilisée par fonction et peut
être analysé par un outil tiers pour en extraire des informations sur la
taille maximale de la pile utilisée.

#stackanalyser est un outil commercial développé par #absint qui semble offrir
une vue plus précise (et graphique) de l'utilisation de la pile par le
programme et propose des rapports orienté vers la qualification logicielle.
L'outil supporte une gamme précise de couple compilateur-architecture qui,
pour des raisons de lisibilité, n'est pas indiquée explicitement ici mais
un lien vers page idoine de l'outil est donné. Les architectures communes
(Intel, ARM, PowerPC, RISC-V, ...) sont supportées.


#t1stack est un outil commercial développé par #gliwa qui propose une analyse
statique de la pile pour des architectures spécifiques. L'outil peut utiliser
des annotations pour résoudre les appels utilisant des pointeurs de fonctions
à l'exécution. Ces annotations peuvent être manuelles ou générées
automatiquement par des mesures dynamiques.

Le _linker_ #armlink d'ARM propose une option `--callgraph` qui engendre un
ficher HTML contenant l'arbre d'appels du programme et l'utilisation de la
pile. Comme pour #t1stack, il est possible d'ajouter une analyse dynamique
pour obtenir des informations plus précises en cas d'utilisation de pointeurs
de fonction.

#figure(
  table(
    columns: (auto, auto, auto),
    [*Outil*],         [*Annotations*],   [*Architectures*],
    [*#gcc*], [], [Toutes celles supportées par GCC],
    [*#stackanalyser*], [], [
      Liste exhaustive sur le site de l'outil :
      https://www.absint.com/stackanalyzer/targets.htm
    ],
    [*#t1stack*], [✓], [
      - Infineon TC1.6.X, TC1.8
      - NXP/STM e200z0-z4, z6, z7
      - ARM (v7-M, v7-R, V8-R)
      - Renesas RH850, G3K/G3KH/G3M/G3MH
      - Intel x86-64
    ],
    [*#armlink*], [], [ARM],
  )
)


==== Qualité numérique

La qualité numérique peut être analysée de deux manières: statiquement et
dynamiquement. Les outils #fluctuat, #astree et #polyspace font partie
des outils d'analyse statique. #polyspace détecte essentiellement des
erreurs à _runtime_ comme la division par 0, les dépassements de capacité et
les débordements de buffer. #astree détecte également les erreurs de
runtime mais réaliste également un calcul d'intervalles permettant d'évaluer
les erreurs d'arrondis. #fluctuat est un outil académique qui est spécifiquement
dédié à l'analyse numérique flottante par interprétation abstraite en utilisant
un domaine basé sur l'arithmétique affine.

L'outil #gappa fonctionne également
par analyse statique mais en utilisant un programme annoté (via #framac) par
les propriétés à vérifier sur les calculs flottants.

Les analyses dynamiques fonctionnent en instrumentant le code avec des
bibliothèques logicielles dédiées. Parmi celles-ci, on trouve #cadna qui
utilise une approche par estimation stochastique des arrondis de calculs.

Une autre approche consiste à utiliser directement des bibliothèques proposant
des calculs flottants plus précis comme la bibliothèque #mpfr qui réalise un
calcul par intervalles ou la bibliothèque #gmp qui permet de réaliser des
calculs avec une précision arbitraire.


=== Meta formalisation

Les outils permettant de formaliser un programme C sont peu nombreux et
fonctionnent tous sur le même principe d'annotations du code source avec
une contractualisation utilisant une logique de séparation. Parmi ceux-ci,
nous avons comparé #framac, #redefinedc et #vercors.

La différence entre ces outils réside principalement dans la syntaxe des
annotations et la manière dont les spécifications sont vérifiées. #framac
utilise une syntaxe E-ACSL qui est un sous-ensemble du langage
_ANSI/ISO C Specificiation Language_ (ACSL). Les spécifications et un modèle
sémantique du C sont ensuite traduites en un problème SMT#footnote[
  _Satisfiability Modulo Theories_
] soumis à plusieurs solveurs (#z3, #cvc5, #altergo) qui déterminent, ou pas, si
les contraintes sont satisfaites. Dans certains
cas, il est également possible de générer des contre-exemples. En cas d'échec
dans la preuve, il est possible de raffiner la spécification pour découper
les preuves en sous-problèmes plus simples.

#redefinedc utilise un langage de spécification déclaratif qui a peu ou prou
la même expressité que E-ACSL. En revanche, la vérification du programme se fait
de manière déductive en utilisant Coq et un modèle sémantique du C écrit en Coq
avec le cadre théorique #iris. L'expressivité du modèle permet d'exprimer des
problématiques arbitrairement complexes (comme par exemple l'_ownership_) tant
que cela reste prouvable. En cas d'échec de la preuve, il est possible
d'écrire directement les preuves en Coq.

#vercors utilise un langage de spécification nommé PVL#footnote[
  _Prototypal Verification Language_
] qui ressemble un peu à celui de #framac. L'outil est en fait basé sur
un autre cadre logiciel appelé #viper qui permet de vérifier des programmes
en utilisant la logique de séparation mais également la logique de
permission, ce qui permet d'exprimer des propriétés d'_ownership_. #viper
utilise le solveur SMT #z3 pour décharger les preuves.


=== Mécanismes intrinsèques de protection

Le C est dispose de très peu de mécanismes de protection. Il existe un système
de type mais qui est très rudimentaire et ne permet pas de garantir la
sécurité mémoire. Les pointeurs peuvent être manipulés de manière très libre
et il est possible de déréférencer un pointeur n'importe où dans la mémoire.

Les mécanismes de protection disponibles pour le C viennent essentiellement des
compilateurs qui ajoutent, ou pas, des analyses complémentaires. La plupart du
temps, il est
recommandé d'activer tous les avertissements du compilateur et de les traiter
comme des erreurs pour assurer un maximum de vérifications.

=== Tests

Nous avons comparés plusieurs outils de tests pour le langage C. Parmi ceux-ci,
se dégagent #cantata, #parasoft, #TPT et #vectorcast qui offent un support de
test étendu pour le C. Ils fournissent également de la génération de test à des
degré divers et une bonne gestion des tests à travers diverses configurations
et la génération de rapports nécessaires aux qualifications/certifications.

#criterion, #libcester, #novaprova et #opmock tiennent plus des usuels cadres
logiciels de tests et offrent une génération de test plus limitée. Cependant,
ils offrent du _mocking_ ou un support pour des interfacages avec des outils
tiers qui peuvent être utiles dans les cas d'intégrations avec des outils tiers.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    [*Outil*],               [*Tests*], [*Generation*], [*Gestion*], [_*mocking*_],
    [*#cantata*],            [UFIRC],   [+++],          [✓],         [],
    [*#criterion*],          [UF],      [+],            [],          [],
    [*#libcester*],          [UF],      [+],            [✓],         [✓],
    [*#novaprova*],          [UF],      [+],            [✓],         [✓],
    [*#opmock*],             [UF],      [++],           [],           [✓],
    [*#parasoft*],           [UFC],    [++],            [✓],         [],
    [*#TPT*],                [UFINC],  [+++],           [✓],         [],
    [*#vectorcast*],         [UFC],    [++],            [✓],         [✓],
  )
)

== Compilateurs & outils

=== Compilation


Il existe beaucoup de compilateurs pour le langage C pour des raisons
à la fois historiques et de compatibilité. Historique car
le langage C est né a une époque où l'_open source_ n'existait pas vraiment et
les seules organisations capables de produire des compilateurs étaient des
entreprises ou des grands laboratoires. Ces entreprises développaient souvent
leur propre compilateur adapté à leur architecture ou au système qu'ils
proposaient par ailleurs, d'où la compatibilité.

Nous ne citerons donc que les principaux compilateurs modernes qui sont les
plus utilisés ou qui ont une caractéristique particulière qui peut les
distinguer dans le contexte de l'embarqué critique.

#figure(
  table(
    columns: (auto, auto, auto),
    [*Compilateur*], [*Architectures*], [*Licence*],
    [*#aocc*], [AMD x86 (32 et 64 bits)], [Gratuit],
    [*#clang*], [AArch64, ARMv7, IA-32, x86-64,  ppc64le], [Apache 2.0],
    [*#compcert*], [x86, x86_64, ARM, PowerPC, SPARC], [Gratuit pour un usage non commercial],
    [*#gcc*], [IA-32, x86_64, ARM, PowerPC, SPARC, ...], [GPLv3+],
    [*#icx (#intel C/C++ Compiler)*], [IA32, x86-64], [Propriétaire, Gratuit],
    [*#msvc*], [IA-32, x86_64, ARM], [Propriétaire],
  )
)

Notons que le compilateur #aocc est basé sur #clang/#llvm mais y ajoute
des optimisations spécifiques aux processeurs AMD. #clang est la partie frontale
de #llvm et les deux forment un compilateur modulaire inité par #apple pour
remplacer #gcc dans les années 2000. Aujourd'hui, ces deux compilateurs offrent
des performances équivalentes.

#gcc est le compilateur de référence pour le langage C depuis les années 1990.
Il est très complet et supporte un grand nombre d'architecture dont seulement
une petite partie est indiquée dans le tableau, une liste plus exhaustive
peut être consultée sur la page https://gcc.gnu.org/install/specific.html.

#icx est le compilateur d'#intel spécifique à aux processeurs et FPGA de la
marque. Depuis 2021, il utilise le _backend_ #llvm. Enfin, #msvc est le
compilateur de #microsoft pour les systèmes Windows.

Le compilateur #compcert est un peu à part car il s'agit d'un compilateur
écrit en grande partie en #coq par l'#inria et qui est formellement prouvé
comme étant correct par rapport à la sémantique du langage C. Il offre des
performances équivalentes à #gcc avec un niveau d'optimisation léger (-O1).
L'utilisation commerciale est pourvue par la société #absint. L'absence
d'optimisations aggressives que l'on peut trouver dans #gcc ou #clang est due
au fait qu'il est difficile de démontrer que ces optimisations sont correctes
d'un point de vue sémantique. Le projet se concentre sur les optimisations
vérifiées afin de produire un code conforme à la spécification du langage C
propre à une utilisation dans les domaines critiques.


=== Déboggeur

Comme pour les compilateurs, il existe une multitude de déboggueurs en fonction
des systèmes d'exploitation et des architectures. Pour simplifier la lecture
de ce document, nous le listons ici que les principaux déboggueurs connus.

#figure(
  table(
    columns: (auto, auto, auto),
    [*Debugueur*], [*Architectures*], [*License*],
    [*#linaro*], [x86-64, ARM, PowerPC, Intel Xeon Phi, CUDA], [Propriétaire],
    [*#gdb*], [x86, x86-64, ARM, PowerPC, SPARC, ...], [GPLv3],
    [*#lldb*], [i386, x86-65, AArch64, ARM], [Apache v2],
    [*#totalview*], [x86-64, ARM64, CUDA], [Propriétaire],
    [*#undo*], [?], [Propriétaire],
    [*#valgrind*], [x86, x86-64, PowerPC, ARMv7], [GPL],
    [*#vsd*], [x86, x86-64], [Propriétaire],
  )
)

#linaro et #totalview sont plutôt dédiés aux systèmes de calculs intensifs
qu'aux systèmes embarqués mais ils supportent les architectures CUDA qui
peuvent être utilisés dans l'embarqués pour du traitement vidéo.

#let ddd = link("https://www.gnu.org/software/ddd/", "DDD")

#gdb est le déboggeur de référence pour le langage C car il va en général de
pair avec l'utilisation de #gcc. Il dispose des fonctionnalités classiques pour
un déboggueur (breakpoints, pas à pas, ...). La version de base ne comporte
qu'un outil en ligne de commande mais des interfaces graphiques existent pour
le compléter, le plus connu étant probablement #ddd.

#lldb est le déboggeur associé à #clang/#llvm comme #gdb l'est à #gcc. Etant
plus jeune, il supporte moins d'architecture mais plus de système
d'exploitation (notamment MacOS et iOS).


#valgrind est un outil d'analyse dynamique qui permet de détecter des erreurs
liées à l'utilisation de la mémoire. Il est particulièrement utile pour détecter
les fuites mémoires sur les langages comme le C. Il fonctionne en compilant le
_bytecode_ à la volée en y ajoutant de l'instrumentation.

#undo est un deboggeur récent compatible avec les commandes de #gdb et proposant
une interface graphique plus moderne que #ddd. Il propose aussi une interface
de navigation dans les historiques d'exécution en séquentiel ou parallèle en
plus d'un déboggue mémoire. En revance, il n'est disponible que sous Linux
et les architectures supportées ne sont pas clairement indiquées. Il est
probable que l'outil fonctionne par compilation à la volée du _bytecode_ et
qu'il soit donc compatible avec toutes les architectures supportées par #gcc.

#vsd est le développeur associé à la suitre de développement #visualstudio
de #microsoft. Il est propriétaire et ne fonctionne que sous Windows mais
offre un support avancé de tous les langages supportés par #visualstudio.

=== Meta programmation

Il n'y a pas, a proprement parler, de support pour la métaprogrammation en C.
Dans la pratique cependant, le preprocesseur du C
(CPP#footnote[C PreProcessor]) est souvent utilisé pour introduire une forme
archaïque de métaprogrammation syntaxique.

CPP utilise un système de macros et d'expansions permettant de générer du code
C par substitution de texte. Un exemple courant est l'utilisation de macros
pour rendre des parties de code conditionnelles :

```c
#include <stdio.h>

#ifdef DEBUG
# define TRACE(...) printf(__VA_ARGS__)
#else
# define TRACE(...)
#endif

int main()
{
  TRACE("Hello, world!\n");
  return 0;
}
```

Dans cet exemple, la macro `TRACE` est définie en fonction de la macro `DEBUG`.
Si `DEBUG` est définie, la macro `TRACE` est expansée en un appel à `printf`
avec les arguments passés. Dans ce cas, la fonction `main` affichera
`Hello, world!`. Si `DEBUG` n'est pas défini, la macro `TRACE` est expansée
en un contenu vide et la fonction `main` n'affichera rien.

L'expansion des macros n'est pas récursive et ne permet donc pas de calculer des
des valeurs arbitrairement complexes. Il est toutefois possible de jouer
subtilement avec l'expansion des macros pour obtenir une récursion bornée
et prégénérer des expressions constantes que le compilateur optimisera en
les calculant à la compilation.

Par exemple, on peut calculer la somme des entiers de 1 à N avec la macro
suivante :

```c
#include <stdio.h>

#define SUM(N) (((N) * ((N) + 1)) / 2)

int main()
{
  printf("%d\n", SUM(10));
  return 0;
}
```

Comme elle sera expansée dans le code, le compilateur y vera une expression
constante et la calculera à la compilation, ce qui donnera le résultat 55
immédiatement à l'exécution. Il est même possible d'obtenir une récursion
finie en exploitant de manière astucieuse les règles d'expansion des macros
mais cela reste une pratique très avancée, peu lisible, peu maintenable et
surtout généralement inutile puisque les fonction déclarées `inline` (et
même parfois celles qui ne le sont pas) sont optimisées de manière similaire
par le compilateur. Ainsi, le resultat constant précédent pourrait être obtenu
plus simplement avec une fonction `inline` :

```c
#include <stdio.h>

inline int sum(int n)
{
  return (n * (n + 1)) / 2;
}

int main()
{
  printf("%d\n", sum(10));
  return 0;
}
```

=== Générateurs de code

==== _Parsing_

On peut distinguer les parseurs en fonction du type de langage considéré
- les langages réguliers
- les langages algébriques
- les grammaires booléennes déterministes
- les langages algébriques avec des grammaires conjonctives ou booléennes

#let flex = link("https://github.com/westes/flex", "Flex")
#let quex = link("https://quex.sourceforge.io/", "Quex")
#let re2c = link("https://re2c.org/", "Re2c")
#let ragel = link("https://www.colm.net/open-source/ragel/", "Ragel")

#figure(
  table(
    columns: (auto, auto),
    [*Nom*], [*Code*], [*Plateforme*], [*License*],
    [*#flex*], [Mixte], [Toutes], [Libre, BSD],
    [*#quex*], [Mixte], [Toutes], [Libre, LGPL],
    [*#re2c*], [Mixte], [Toutes], [Libre, Domaine public],
    [*#ragel*], [Mixte], [Toutes], [Libre, LGPL, MIT],

  ),
  caption: [Parsers de langages réguliers],
)

Les parseurs de langages réguliers sont des outils
utilisés pour parser des expressions régulières dans les langages de
programmation ou pour servir de _lexer_ en découpant un texte en _tokens_ qui
servent ensuite de termes à un parseur plus complexe.

#let lex = link(
  "https://minnie.tuhs.org/cgi-bin/utree.pl?file=4BSD/usr/src/cmd/lex",
  "Lex"
)

#flex est l'outil de référence pour générer des _lexers_ en C.
Les autres lexers sont des alternatives plus modernes qui offrent des
performances un peu meilleures ou des fonctionnalités supplémentaires comme
la gestion de l'unicode.


#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    [*Nom*],         [*Grammaire*],           [*Code*],  [*Plateforme*], [*License*],
    [*#antlr*],      [EBNF],                  [Mixte],   [Java],         [Libre, BSD],
    [*#byacc*],      [Yacc],                  [Mixte],   [Toutes],       [Libre, Domaine public],
    [*#hyacc*],      [Yacc],                  [Mixte],   [Toutes],       [Libre, GPL],
    [*#lemon*],      [Lemon],                 [Mixte],   [Toutes],       [Libre, Domaine public],
    [*#llgen*],      [LLgen],                 [Mixte],   [POSIX],        [Libre, BSD],
    [*#llnextgen*],  [LLnextgen],             [Mixte],   [Toutes],       [Libre, GPL],
    [*#yacc*],       [Yacc],                  [Mixte],   [Toutes],       [Libre, CPL & CDDL],
    [*#treesitter*], [Javascript, DSL, JSON], [Séparé],  [Toutes],       [Libre, MIT],
    [*#styx*],       [Styx],                  [Séparé],  [Toutes],       [Libre, LGPL],
    [*#cocor*],      [Wirth],                 [Mixte],   [Toutes],       [Libre, GPL],
    [*#sablecc*],    [SableCC],               [Séparé],  [Java],         [Libre, GPL],
    [*#bison*],      [Yacc],                  [Mixte],   [Toutes],       [Libre, GPL],
    [*#unicc*],      [EBNF],                  [Mixed],   [POSIX],        [Libre, BSD],
    [*#kmyacc*],     [Yacc],                  [Mixte],   [Toutes],       [Libre, GPL],
    [*#apg*],        [ABNF],                  [Séparé],  [Toutes],       [Libre, BSD],
    [*#gold*],       [EBNF],                  [Séparé],  [Toutes],       [Libre, zlib modifiée],
  ),
  caption: [Parsers de langages algébriques],
)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    [*Nom*],         [*Grammaire*],           [*Code*],  [*Plateforme*], [*License*],
    [*#dparser*],    [EBNF],                  [Mixte],   [POSIX],        [Libre, BSD],
    [*#yaep*],       [EBNF],                  [Mixte],   [Toutes],       [Libre, LGPL],
    [*#bison*],      [Yacc],                  [Mixte],   [Toutes],       [Libre, GPL],
    [*#gdk*],        [Yacc],                  [Mixte],   [POSIX],        [Libre, MIT],
  ),
  caption: [Parsers de grammaires sans contexte, conjonctives ou booléennes],
)

#let dsl = [DSL]

Il existe beaucoup de générateurs de _parser_ pour le langage C. Ils se
différencient essentiellement par le type de langage reconnu :
L'analyse syntaxique fait l'objet de nombreuses recherches depuis les années
1960 et elle continue encore aujourd'hui de sorte qu'il existe de nombreux
outils de _parsing_ académiques qui vont mettre l'accent sur telle ou telle
nouvelle approche ou optimisation.

Nous en avons listé un certain nombre pour information mais il est probable que
qu'utiliser #flex/#bison ou #antlr soit plus que suffisant dans la plupart des
cas.

Notons que #treesitter est un
parseur plutôt dédiés aux éditeurs de textes mais cela peut être intéressant
dans le cadre d'une définition de #dsl ou de protocole pour l'embarqué afin
de faciliter la création d'outils dédiés.

Autrement, la différence entre les _parsers_ de la liste réside essentiellement
dans le type de parser LL, LR, LALR, ... qu'ils implémentent et dans les
fonctionnalités supplémentaires qu'ils offrent.


==== Dérivation

Il n'y a pas réellement de support pour la dérivation en C. Comme pour la
métaprogrammation, le préprocesseur C peut être utilisé pour dériver du code
mais cela reste une pratique peu lisible.

Une technique bien connue est celle des X macros qui permet de générer du code
à partir de la définition déclarative d'une relation. Par exemple, on peut
mettre en relation un identifiant de couleur, un entier qui le représente et
une chaîne de caractères qui la décrit:

```c
#define COULEURS \
  X(ROUGE, 0xFF0000, "rouge") \
  X(VERT, 0x00FF00, "vert") \
  X(BLEU, 0x0000FF, "bleu")
```

La macro `COULEURS` définit la relation en utilisant une macro `X` qui n'a
pas encore de définition. C'est au moment où on utilise cette relation qu'on
donne une définition à la macro `X`. On peut ainsi définir le type couleur :

```c
#define X(label, value, str) label,
typedef enum {
  COULEURS
} couleurs_t;
#undef X
```

ou les convertisseurs adéquats de manière à peu près automatisée :

```c
char* couleur_to_string(couleurs_t couleur)
{
  char* resultat = NULL;
#define X(label, _, str) case label: { resultat = str; break; }
  switch (couleur) {
    COULEURS
    default: { break; }
  }
#undef X
  return resultat;
}

int main()
{
  printf("%s\n", couleur_to_string(ROUGE));
  return 0;
}
```

Il est possible de faire des dérivations plus complexes en jouant sur la
sémantique d'expansion du préprocesseur mais encore une fois, cela reste une
pratique déconseillée dans les développements industriels où la maintenabilité
est une priorité.

== Bibliothèques & COTS

=== Gestionnaire de paquets

Il existe plusieurs gestionnaires de paquet pour le langage C que nous avons
comparés en fonction de leur support des plateformes, le format de configuration
des fonctionalités proposées et du nombre de paquets proposés.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    [*Gestionnaire*],               [*#clib*], [*#conan*], [*#vcpkg*],
    [*Plateformes*],                [Linux],   [Toutes],   [Linux, Windows, MacOS],
    [*Format*],                     [JSON],    [Python],   [JSON],
    [*Résolution des dépendances*], [⨉],       [✓],       [✓],
    [*Cache binaire*],              [⨉],       [✓],       [✓],
    [*Nombre de paquets*],          [~350],    [~1750],    [~2500],
  )
)

#clib propose une gestion de paquet très rudimentaire qui consiste à simplement
intégrer les sources d'un paquet dans les sources du projet. Cela peut être
pratique pour des projets très petits ou pour des projets qui ne veulent pas
dépendre d'un gestionnaire de paquet tiers.

#conan et #vcpkg sont des gestionnaires de paquet plus complets qui proposent
les fonctionnalités d'un gestionnaire de paquet moderne. Ce sont tous deux
des outils matures et maintenus. #conan est plus simple d'utilisation et plus
versatile car les descriptions de paquets (les _recipes_) sont écrites en
Python. #vcpkg est plus classique avec une description JSON mais plus de paquets
disponibles.

=== Communauté

L'histoire du langage C et son rôle central dans l'évolution de l'informatique
font qu'il existe une très grande communauté autour du langage. Cette
communauté est à la fois privée et publique : privée car de nombreuses sociétés
ont et continuent de développer des logiciels ou des produits utilisant le C et
publique à travers toute la communauté _open source_ qui continue de
contribuer aux projets existants (notamment les projets appuyés par la
_FSF_#footnote[_Free Software Foundation_.]) et d'en proposer de nouveaux
puisque le C reste dans les 10 langages les plus utilisés sur
GitHub#footnote[https://www.blogdumoderateur.com/github-top-10-langages-utilises-developpeurs-2023/].

=== Assurances

Aujourd'hui, le niveau d'assurance proposé par le C est très inégal. Le
langage en lui-même est l'un de ceux qui proposent le moins de mécanisme
de protection ou de vérification mais ce manque
a engendré au fil du temps une offre de fiabilisation très large à travers
des outils d'analyse (statique ou dynamique), des outils de tests, des
référentiels de programmation, _etc._. Leur utilisation va, paradoxalement,
permettre d'apporter un niveau d'assurance de qualité élévé pour un langage qui
n'en dispose que très peu.

Toutefois, l'utilisation d'outils tiers à un coût en licences, en formation
et en temps d'utilisation dans un projet. Ainsi, la fiabilité d'un programme C
va essentiellement dépendre des moyens mis en oeuvre pour l'assurer et ne
va dépendre que peu du langage lui même.

== Adhérence au système

Bien qu'un programme C utilise généralement une interface POSIX via la `libc`
dont il existe plusieurs implémentations, il est tout à fait possible de faire
sans et d'utiliser le C sur un système nu. Naturellement, cela nécessite
d'écrire toutes les interfaces systèmes nécessaires mais c'est justement un
langage fait pour ça. Il est donc particulièrement adapté pour des systèmes
embarqués.

== Interfaçage

Le C étant devenu _de facto_ un langage de référence utilisé sur beaucoup de
systèmes et avec un nombre important de bibliothèques, la pluspart des
langages moderne proposent une FFI#footnote[_Foreign Function Interface_,
ou interface de programmation externe.] pour le C. Cela permet généralement
d'utiliser le C dans ces langages mais également au C d'utiliser du code
écrit dans ces langages.

== Utilisation dans le critique

Le C est notoirement utilisé dans tous les domaines critiques soit directement
pour exploiter des systèmes embarqués soit indirectement comme langage cible
pour d'autres langages (Ada, Scade, ...).
