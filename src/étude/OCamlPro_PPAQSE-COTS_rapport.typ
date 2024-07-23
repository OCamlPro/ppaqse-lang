#import "@local/ocamlpro:0.1.0": *

#show: report.with(
  title: [COTS de qualité : \ logiciels critiques et temps réel],
  version: sys.inputs.at("git_version", default: "<unknown>"),
  authors: (
    (
      firstname: "Julien",
      lastname: "Blond",
      email: "julien.blond@ocamlpro.com"
    ),
  )
)

= Introduction

== Identification

Ce rapport présente une étude des langages C, C++, Ada, Scade, OCaml et Rust
du point de vue de la sûreté. Il suit les clauses techniques #cite(<ctcots>)
relatives au projet
COTS de qualité : logiciels critiques et temps réel du CNES.

== Terminologie

#align(
  center,
  table(
    columns: (auto, auto),
    [*Terme*], [*Définition*],
    [COTS], [_Commercial Off-The-Shelf_ ou produit sur étagère],
  )
)

== Organisation du document

== Méthodologie

=== Paradigme

#let paradigme(p) = text(blue, p)

À chaque langage de programmation vient sa manière de decrire les solutions
algorithmiques au problèmes posés. Cette manière d'aborder les problèmes est
ce qu'on appelle le _paradigme_ du langage.

En réalité, il est rare qu'un langage tienne à un seul paradigme et ils
utilisent généralement plusieurs paradigmes. Néanmoins, il y a généralement
un paradigme général et un ou plusieurs paradigmes secondaires.

Les paradigmes principaux des langages informatiques sont la plupart du temps
- #paradigme[impératif];
- #paradigme[fonctionnel];
- #paradigme[objet];
- #paradigme[déclaratif].

#par[*Le paradigme impératif*]

Le paradigme impératif consiste à exprimer les calculs sous une forme
structurée d'instructions modifiant un état mémoire. Les instructions
emblématiques de ce paradigme sont
- l'affectation;
- le branchement conditionnel (si .. alors .. sinon ..);
- les sauts.

Les sauts ne sont pas toujours disponibles explicitement mais ils sont
utilisés implicitement dans les boucles (`for` ou `while`) que l'on
trouve dans tous les langages impératifs. Par exemple, en C, on peut
calculer la longueur d'une liste chainée de la manière indiquée
dans le #ref(<ex_C_length>) :

#figure(
  ```c
  struct list {
    int value;
    struct list *next;
  };

  int length(struct list *l) {
    int len = 0;
    while (NULL != l) {
      len++;
      l = l->next;
    }
    return len;
  }
  ```,
  caption: [Calcul de la longueur d'une liste chainée en C],
  supplement: [Source],
) <ex_C_length>

En considérant que `NULL` représente la liste vide, la fonction `length`
parcourt la liste en incrémentant un compteur `len` à chaque élément de la
liste. Lorsque la liste est vide, la fonction retourne la longueur obtenue.

Le style impératif est le plus répandu dans les langages informatiques. Il est
relativement proche de la machine mais propice aux erreurs de
programmation car il n'est pas toujours évident de suivre l'état d'un système
lorsque plusieurs morceaux de programme le modifient.

#par[*Le paradigme fonctionnel*]

Le paradigme fonctionnel consiste à exprimer les calculs sous la forme d'une
composition de fonctions mathématiques. Dans sa forme dite _pure_, les
changements de l'état du système sont interdits. En conséquence, il n'y a pas
d'affectations ni de sauts.

Les branchements conditionnels existent mais les boucles sont replacées par la
récursivité, c'est-à-dire la possibilité pour une fonction de s'appeller
elle-même. Par exemple, pour calculer la longueur d'une liste en OCaml, on
procède récursivement :

```ocaml
let rec length (l : 'a list) : int = match l with
  | [] -> 0
  | _ :: tl -> 1 + length tl
```

Dans cet exemple, la fonction `length` prend en paramètre une liste et procède
par cas sur la structure de la liste. Si la liste est vide (`[]`), la longueur
est 0. Sinon on analyse la tête et la queue (`tl`) de la liste et on ajoute 1 à
la longueur de `tl`.

Le style fonctionnel est considéré comme plus sûr que le style impératif.
Chaque fonction est une boite noire qui ne produit pas d'effets de bord, ce qui
la rend plus facile à tester et notamment à paralléliser. En contre-partie,
le style fonctionnel nécessite beaucoup d'allocations dynamiques et donc un
rammasse-miettes pour les gérer automatiquement. Cela peut avoir un impact
négatif sur les performances et les capacités temps réel.

Un langage fonctionnel qui accepte la mutabilité est dit _impur_. Les langages
fonctionnels impurs partagent les avantages et les inconvénients des deux
mondes : ils permettent un gain en performances en évitant potentiellement
beaucoup de copies de données mais héritent
également de la difficulté de gérer un état mutable de manière sûre.

#par[*Le paradigme objet*]

Le paradigme objet (ou POO#footnote[Programmation Orientée Objet]) consiste à
traiter les données comme des entités, les
_objets_, ayant leur propre état et des méthodes pour leur passer des messages.
Chaque problème informatique est vu comme l'interaction d'un objet avec un ou
plusieurs autres objets via les appels de méthode.

En POO, on distingue les classes, qui sont des modèles d'objets, et les objets
eux-mêmes, qui sont des _instances_ de classes. Par exemple, on peut représenter
un point d'un espace bidimensionnel en OCaml de la manière suivante :

```ocaml
class point2d (x : int) (y : int) =
object
  val pos_x : int = x
  val pos_y : int = y

  method get_x : int = pos_x
  method get_y : int = pos_y
  method print : unit -> unit = fun () ->
    Printf.printf "(%d, %d)" pos_x pos_y
end
```

Le mot clé `class`, présent dans pratiquement tous les langages orientés objet,
permet de déclarer un « patron » d'objet. Ici, le patron `point2d` prend en
paramètre
de construction deux entiers `x` et `y` qui représentent les coordonnées du
point. Ces coordonnées sont enregistrées dans les attributs `pos_x` et
`pos_y` qui représentent l'état interne d'un objet `point2d`.
Les méthodes `get_x` et `get_y` permettent de récupérer les coordonnées
du point et la méthode `print` permet d'afficher les coordonnées du point.

On peut alors créer une instance de `point2d` de la manière suivante :

```ocaml
let p = new point2d 1 2
```

et afficher les coordonnées du point avec l'appel de la méthode `print` de
l'objet `p` :

```ocaml
p#print ()
(* affiche "(1, 2)" *)
```

La POO introduit également la notion d'héritage qui permet de partager du code
de manière concise. Par exemple, on peut étendre la classe `point2d` pour les
points d'un espace tridimensionnel :

```ocaml
class point3d (x : int) (y : int) (z : int) =
object
  inherit point2d x y
  val pos_z : int = z

  method get_z : int = pos_z
  method! print : unit -> unit = fun () ->
    Printf.printf "(%d, %d, %d)" pos_x pos_y pos_z
end

let p' = new point3d 1 2 3;;

p'#get_x;;    (* retourne 1 *)

p'#print ();; (* affiche "(1, 2, 3)" *)
```

Ici, la classe `point3d` hérite de `point2d` en en récupérant toutes les
méthodes et ajoute un attribut `pos_z`
pour la coordonnée en profondeur. La méthode `print` est redéfinie pour
afficher les trois coordonnées du point.

Le succès des langages objets (C++, Java, Javascript, ...) indique que le
paradigme est très populaire dans les domaines applicatifs et le Web où
la réutilisabilité est un critère de production déterminant.

Généralement, les objets ont un état interne mutable caractérisé par des
méthodes _setter_ ou d'autres méthodes modifiant leur état interne. De fait, le
paradigme objet va intrinsèquement souffrir des mêmes défauts que le paradigme
impératif sur la difficulté de suivre l'état réel d'un programme.

Par ailleurs, la hierarchie des classes forme une structure arborescente
qu'il est difficile de tracer mentalement. Au delà d'une certaine profondeur,
comprendre le flux de contrôle d'un programme sans outillage peut être une
gageure.

#par[*Le paradigme déclaratif*]

Le paradigme déclaratif consiste à décrire le problème à résoudre sans
préciser comment le résoudre. Il s'agit ici de décrire le _quoi_ et non le
_comment_.

Les langages déclaratifs sont généralement orientés vers la description de
données (XML, LaTeX, ...) mais il existe également des langages de
programmation
déclaratifs. Par exemple, Prolog est un langage de programmation logique qui
permet de décrire un problème de manière logique et de laisser le moteur
d'inférence résoudre le problème. Par exemple, on peut décrire un ensemble de
faits:

```prolog
animal(chat).
animal(chien).
```

et demander à Prolog quels sont les animaux possibles :

```prolog
?- animal(X).
X = chat ;
X = chien.
```

Cette abstraction permet généralement une programmation plus concise mais
cela va induire soit par une perte de
performances à travers un moteur d'inférence intrinsèquement lent (Prolog) ou
un modèle de compilation moins optimal (comme pour les langages fonctionnels
purs), soit par une perte d'expressivité
en restraignant le langage à un sous-ensemble plus facilement optimisable
(Lustre).

=== Analyse statique

Pour chaque langage étudié dans ce rapport, nous présentons des outils d'analyse
statique permettant de déduire de l'information par une
interprétation abstraite du programme.

Les analyseurs statiques peuvent établir des métriques sur le code ou faire
de la rétro-ingénierie pour en déduire des propriétés. Ils peuvent également
détecter des erreurs de programmation. Étant donné le volume d'analyseurs
sur le marché, nous nous concentrerons sur cette dernière catégorie et en
particulier sur ceux qui sont _corrects_.

Un analyseur statique est dit _correct_ s'il ne donne pas de faux-positifs
pour un programme sans _bug_. _A contrario_, il indiquera au moins un _bug_
pour un programme qui en comporte.

Chaque analyseur est étudié par rapport aux ressources publiques disponibles.
Cela comprend le manuel utilisateur, les publications scientifiques, les
brochures commerciales ou le site internet dédié.

Les types d'erreurs détectées dépendent des analyses effectuées par chaque
outils et tous n'utilisent pas toujours la même terminologie pour désigner un
type d'erreur. Nous avons donc regroupé les erreurs en catégories générales
et indiqué pour chaque outil s'il détecte ou non cette catégorie d'erreur
avec un symbole `✓`. Notons que l'absence de symbole ne signifie pas forcément
que l'outil ne détecte pas l'erreur mais simplement que nous n'avons pas
trouvé d'information explicite à ce sujet.

Les catégories d'erreurs sont les suivantes :

#par[*Arithmétique entière*]

Les erreurs d'arithmétique entière sont des erreurs qui surviennent lors de
calculs sur des entiers machine. Il s'agit là des entiers que l'on trouve dans
la plupart des langages de programmation et souvent désignés par le mot clé
`int`.

La taille des entiers manipulables dépend de l'architecture du processeur
utilisé. Sur la plupart des architectures, elle correspond aux puissances de 2
entre 8 et 64. Par exemple, un entier (machine) de 8 bits non signé (uniquement
positif) peut représenter un entier (mathématique) de 0 à 255. Les formes
signées utilisent un bit pour indiquer si l'entier est positif ou négatif; ce
qui permet de représenter les entiers mathématiques de -128 à +127.

Dès lors que les entiers machines ont une taille finie, il est possible de
réaliser des opérations qui dépassent cette taille. Par exemple, calculer
$200 + 100$ sur un entier non signé de 8 bits donnera 44 (300 modulo 256). Ce
résultat est correct dans une arithmétique modulo 256 mais il est rare
que le programmeur pense dans cette arithmétique et il est plus probable qu'il
s'agisse d'une erreur involontaire. Ce type d'erreur est appelé _overflow_
(ou dépassement de capacité). Cette erreur peut être assez subtile car
bien qu'elle soit détectée par le processeur qui positionne un drapeau
signalant le dépassement, elle nécessite que le programmeur vérifie ce drapeau
explicitement pour en tenir compte; ce qu'il ne fait généralement pas.

Une autre erreur couverte par l'analyse de l'arithmétique entière
est la division par 0. Celle-ci n'est pas plus autorisée en informatique que
dans les mathématiques générales et provoque une erreur fatale à l'exécution.

// D'autres erreurs liés à des comportements indéfinis par le langage peuvent être
// détectées par les analyseurs. Par exemple, le fait de décaller un entier de 8
// bits de 9 bits n'a pas de sens défini en C et peut donner des résultats

#par[*Arithmétique flottante*]

- précision
- arrondi
- NaN

#par[*Gestion des pointeurs*]

- Débordement
- Déréférencement de NULL
- Dangling pointer



- flot de données/controle ref eva ?

= C

TODO: historique avec pointeur sur les standards.

== Paradigme

Le langage C est un langage de programmation essentiellement
#paradigme[impératif]. Il est possible, dans une certaine mesure, de programmer
dans un style #paradigme[fonctionnel]. Par exemple, l'exemple du
#ref(<ex_C_length>) peut aussi s'écrire de manière récursive :

```c
int length(struct list *l) {
  return (NULL == l) ? 0 : 1 + length(l->next);
}
```

mais cela reste limité par rapport aux langages explicitement fonctionnels.
Le style idiomatique est plutôt procédural à la manière de l'exemple
#ref(<ex_C>).

#figure(
  ```c
  int add_value(struct state *s, int v) {
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

#figure(

  table(
    columns: (auto, auto, auto, auto, auto, auto),
    [*Erreur*],                      [*Astrée*], [*ECLAIR*], [*Frama-C*], [*Polyspace*], [*TISAnalyser*],
    [*Division par 0*],              [✓],        [✓],         [✓],          [],            [],
    [*Débordement de tampon*],       [✓],        [✓],         [✓],          [],            [],
    [*Déréférencement de NULL*],     [✓],        [✓],         [],          [],            [],
    [*Dangling pointer*],            [✓],        [✓],         [✓],          [],            [],
    [*Data race*],                   [✓],        [✓],         [],          [],            [],
    [*Interblocage*],                [✓],        [✓],         [✓],          [],            [],
    [*Vulnérabilités de sécurité*],  [✓],        [✓],         [],          [],            [],
    [*Arithmétique entière*],        [✓],        [],         [✓],          [],            [],
    [*Arithmétique flottante*],      [✓],        [],         [✓],          [],            [],
    [*Code mort*],                   [✓],        [✓],         [✓],          [],            [],
    [*Initialisation*],              [✓],        [✓],         [✓],          [],            [],
    [*Flot de données*],             [✓],        [✓],         [✓],          [],            [],
    [*Contrôle de flôt*],            [✓],        [],         [✓],          [],            [],
    [*Flôt de signaux*],             [✓],        [],         [],          [],            [],
    [*Non-interférence*],            [✓],        [],         [],          [],            [],
    [*Fuites mémoire*],              [],         [✓],         [],          [],            [],
    [*Double `free`*],               [],         [✓],         [],          [],            [],
    [*Coercions avec perte*],        [],         [✓],         [✓],          [],            [],
    [*Mémoire superflue*],           [],         [✓],         [],          [],            [],
    [*Arguments variadiques*],       [],         [✓],         [✓],          [],            [],
    [*Chaînes de caractères*],       [],         [✓],         [],          [],            [],
    [*Contrôle d'API*],              [],         [✓],         [],          [],            [],
  )
)


==== WCET

==== Pile


==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

=== Tests

== Compilateurs & outils

=== Compilation

=== Débuggeur

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

=== Communauté

=== Assurances

== Adhérence au système

== Interfaçage

== Utilisation dans le critique






= C++

== Paradigme

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

- Astree
- ECLAIR
- Polyspace
- TISAnalyser

==== WCET

==== Pile

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

=== Tests

== Compilateurs & outils

=== Compilation

=== Débuggeur

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

=== Communauté

=== Assurances

== Adhérence au système

== Interfaçage

== Utilisation dans le critique


= Ada

== Paradigme

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

- CodePeer
- Polyspace (MathWorks)
- SPARK Toolset

==== WCET

==== Pile

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

=== Tests

== Compilateurs & outils

=== Compilation

=== Débuggeur

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

=== Communauté

=== Assurances

== Adhérence au système

== Interfaçage

== Utilisation dans le critique


= Scade

== Paradigme

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

- KCG

==== WCET

==== Pile

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

=== Tests

== Compilateurs & outils

=== Compilation

=== Débuggeur

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

=== Communauté

=== Assurances

== Adhérence au système

== Interfaçage

== Utilisation dans le critique


= OCaml

== Paradigme

OCaml est un langage de programmation multiparadigme. Il est conçu comme étant
avant tout un langage #paradigme[fonctionnel] mais il est dit _impur_ dans le
sens où la mutabilité est autorisée. L'intégration des boucles (`while`, `for`)
en font tout aussi bien un langage #paradigme[impératif] dans lequel on peut
très bien programmer de manière
procédurale. Le O de OCaml signifie _Objective_ et fait référence au
fait que le langage est également #paradigme[objet]. Ce trait est toutefois
relativement peu usité en pratique.




== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

Initiative gospell ?

==== WCET

Néant.

==== Pile

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

=== Tests

== Compilateurs & outils

=== Compilation

=== Débuggeur

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

=== Communauté

=== Assurances

== Adhérence au système

== Interfaçage

== Utilisation dans le critique


= Rust

== Paradigme

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

==== WCET

==== Pile

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

=== Tests

== Compilateurs & outils

=== Compilation

=== Débuggeur

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

=== Communauté

=== Assurances

== Adhérence au système

== Interfaçage

== Utilisation dans le critique

= Conclusions

= Références

#bibliography("bibliography.yml")

