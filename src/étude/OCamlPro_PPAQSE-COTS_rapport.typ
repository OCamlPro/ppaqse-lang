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

Le document présente tout d'abord la méthodologie utilisée pour l'étude en
détaillant les points abordés pour chaque langage. Ensuite, chaque langage
est étudié individuellement en respectant le plan défini.

= Méthodologie

La méthodologie utilisée pour l'étude des langages reprend les points abordés
dans les clauses techniques #cite(<ctcots>) en les détaillant.

== Paradigme

#let paradigme(p) = text(blue, p)

À chaque langage de programmation vient sa manière de decrire les solutions
algorithmiques au problèmes posés. Cette manière d'aborder les problèmes est
ce qu'on appelle le _paradigme_ du langage.

Les paradigmes les plus courants des langages informatiques sont la plupart du
temps les suivants:
- #paradigme[impératif];
- #paradigme[fonctionnel];
- #paradigme[objet];
- #paradigme[déclaratif];
- #paradigme[contrat]
- #paradigme[synchrone].

Notons que les paradigmes ne sont pas exclusifs : un langage peut être
composer plusieurs paradigmes et c'est même le cas général dans les langages
généralistes récents. Toutefois, même en composant plusieurs paradigmes, il y
en a souvent un qui se dégage plus que les autres à l'usage.

=== Le paradigme impératif

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

  int length(struct list *l)
  {
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

=== Le paradigme fonctionnel

Le paradigme fonctionnel consiste à exprimer les calculs sous la forme d'une
composition de fonctions mathématiques. Dans sa forme dite _pure_, les
changements de l'état du système sont interdits. En conséquence, il n'y a pas
d'affectations ni de sauts.

Les branchements conditionnels existent mais les boucles sont remplacées par la
récursivité, c'est-à-dire la possibilité pour une fonction de s'appeler
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
la rend plus facile à tester et à paralléliser. En contre-partie,
le style fonctionnel nécessite beaucoup d'allocations dynamiques et donc un
ramasse-miettes pour les gérer automatiquement. Cela peut avoir un impact
négatif sur les performances et les capacités temps réel.

Un langage fonctionnel qui accepte la mutabilité est dit _impur_. Les langages
fonctionnels impurs partagent les avantages et les inconvénients des deux
mondes : ils permettent un gain en performances en évitant potentiellement
beaucoup de copies de données mais héritent
également de la difficulté de gérer un état mutable de manière sûre.

=== Le paradigme objet

Le paradigme objet (ou POO#footnote[Programmation Orientée Objet]) consiste à
traiter les données comme des entités, les
_objets_, ayant leur propre état et des méthodes pour leur passer des messages.
Chaque problème informatique est vu comme l'interaction d'un objet avec un ou
plusieurs autres objets via les appels de méthode.

En POO, on distingue les classes, qui sont des modèles d'objets, et les objets
eux-mêmes, qui sont des _instances_ de classes. Par exemple, on peut représenter
un point d'un espace bidimensionnel en C++ de la manière suivante :

```cpp
class Point2D
{
protected:
    uint32_t pos_x = 0;
    uint32_t pos_y = 0;
public:
    Point2D(uint32_t x, uint32_t y) : pos_x(x), pos_y(y) {}

    uint32_t get_x(void) const { return pos_x; }

    uint32_t get_y(void) const { return pos_y; }

    virtual void print(void) const {
        std::cout << "Point2D(" << pos_x << ", " << pos_y << ")" << std::endl;
    }
};
```

Le mot clé `class`, présent dans pratiquement tous les langages orientés objet,
permet de déclarer un « patron » d'objet. Ici, le patron `Point2D` prend en
paramètre
de construction deux entiers `x` et `y` qui représentent les coordonnées du
point. Ces coordonnées sont enregistrées dans les attributs `pos_x` et
`pos_y` qui représentent l'état interne d'un objet `Point2D`.
Les méthodes `get_x` et `get_y` permettent de récupérer les coordonnées
du point et la méthode `print` permet d'afficher les coordonnées du point.

On peut alors créer une instance de `Point2D` de la manière suivante :

```cpp
Point2D p(1, 2);
```

et afficher les coordonnées du point avec l'appel de la méthode `print` de
l'objet `p` :

```cpp
p.print()
// affiche "Point2D(1, 2)"
```

La POO introduit également la notion d'héritage qui permet de partager du code
de manière concise. Par exemple, on peut étendre la classe `Point2D` pour les
points d'un espace tridimensionnel :

```cpp
class Point3D : protected Point2D
{
protected:
    uint32_t pos_z = 0;
public:
    Point3D(uint32_t x, uint32_t y, uint32_t z) : Point2D(x, y), pos_z(z) {}

    uint32_t get_z(void) const { return pos_z; }

    void print(void) const override {
        std::cout <<
        "Point3D(" << pos_x << ", " << pos_y << ", " << pos_z << ")" <<
        std::endl;
    }
};

int main(void)
{
    Point3D p(1, 2, 3);
    p.print(); // affiche "Point3D(1, 2, 3)"
    return 0;
}
```

Ici, la classe `Point3D` hérite de `Point2D` en en récupérant toutes les
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

Par ailleurs, la hiérarchie des classes forme une structure arborescente
qu'il est rapidement difficile de tracer mentalement. Au delà d'une certaine
profondeur, comprendre le flux de contrôle d'un programme sans outillage peut
être une gageure.

=== Le paradigme déclaratif

Le paradigme déclaratif consiste à décrire le problème à résoudre sans
préciser comment le résoudre. Il s'agit ici de décrire le _quoi_ et non le
_comment_.

Les langages déclaratifs sont généralement orientés vers la description de
données (XML, LaTeX, ...) mais il existe également des langages de
programmation
déclaratifs. Par exemple, Prolog est un langage de programmation qui
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
cela va induire :
- soit une perte de performances : le _comment_ doit être retrouvé
  dynamiquement par le programme (Prolog) ;
- soit un modèle de compilation moins optimal (comme pour les langages fonctionnels
purs comme Haskell)
- soit par une perte d'expressivité
en restreignant le langage à un sous-ensemble plus facilement optimisable
(Lustre).

=== Le paradigme contrat

La programmation par contrat est un paradigme de programmation visant à régir
l'exécution d'un programme par des règles appelées _assertions_ qui sont
généralement vérifiées à l'exécution du programme. L'ensemble des assertions
d'un morceau de code est alors qualifié de _contrat_. Les contrats permettent
de clarifier la sémantique du programme et de réduire le nombre de bugs. Ils
jouent ainsi un rôle complémentaire aux types et aux commentaires. Certains
outils d'analyse statique peuvent utilisé les contrats pour démontrer des
propriétés sur le code.

On distingue quatre types d'assertions:
- Les _préconditions_ qui doivent être vérifiées à l'entrée d'une fonction ou d'une procédure;
- Les _postconditions_ qui doivent être vérifiées à la sortie d'une fonction ou d'une procédure;
- Les _invariants_ qui doivent toujours être vraies pour des valeurs d'un certain type ou les instances d'une classe;
- Les _variants_ qui sont des quantités attachées aux boucles (ou aux fonctions récursives) et qui décroissent à chaque itération (ou appel récursif). Elles permettent de vérifier la terminaison d'un algorithme.

L'exemple ci-dessous est une implémentation de l'algorithme d'Euclide en Eiffel
avec un contrat qui assure que l'on fournit une entrée valide et que
l'algorithme termine:

```eiffel
 gcd (value_1, value_2: INTEGER): INTEGER
    require
       value_1 > 0
       value_2 > 0
    local
       value: INTEGER
    do
       from
          Result := value_1
          value := value_2
       invariant
          Result > 0
          value > 0
          gcd(Result, value) = gcd(value_1, value_2)
       variant
          Result.max(value)
       until
          Result = value
       loop
          if Result > value then
             Result := Result - value
          else
             value := value - Result
          end
       end
    ensure
       Result = gcd(value_2, value_1)
    end
```

=== Le paradigme synchrone

La programmation _synchrone_ est utilisée dans le cadre des _systèmes réactifs_,
c'est-à-dire des systèmes qui maintiennent en permanence une interaction avec
un environnement et qui doivent être en mesure d'y réagir de façon synchrone, sûre et déterministe.

La famille des langages synchrones est elle-même divisée en deux sous-paradigme:
- les langages à _flots de données_ (_LUSTRE_, _SCADE_, _SIGNAL_,...);
- les langages _orientés contrôle_ (_Esterel_, ...).

Ces langages sont fondés sur le modèle du _parallélisme synchrone_ qui introduit une notion de _temps logique_ et permet l'écriture de programmes parallèles et
déterministes. Dans ce modèle les entrées arrivent simultanément puis le programme s'exécute et produit une réponse avant l'arrivée du prochain événement. Le résultat est déterministe au sens où il ne dépend que des entrées.

== Analyse statique

Pour chaque langage étudié dans ce rapport, nous présentons des outils d'analyse
statique permettant de déduire de l'information par une
interprétation abstraite du programme.

Les analyseurs statiques peuvent établir des métriques sur le code ou faire
de la rétro-ingénierie pour en déduire des propriétés (et en vérifier). Ils
peuvent également détecter des erreurs de programmation et, étant donné le
volume d'analyseurs sur le marché, nous nous concentrerons sur cette dernière
catégorie et en particulier sur ceux qui sont _corrects_.

Un analyseur statique est dit _correct_ s'il ne donne pas de faux-positifs
pour un programme sans _bug_. _A contrario_, il indiquera au moins un _bug_
pour un programme qui en comporte.

Chaque analyseur est étudié par rapport aux ressources publiques disponibles.
Cela comprend le manuel utilisateur, les publications scientifiques, les
brochures commerciales ou le site internet dédié.

Les types d'erreurs détectées dépendent des analyses effectuées par chaque
outils et tous n'utilisent pas toujours la même terminologie pour désigner un
type d'erreur. Nous avons donc regroupé les erreurs en catégories générales
et indiqué pour chaque outil s'il couvre au moins une partie des erreurs
d'une catégorie avec un symbole `✓`. Notons que l'absence de symbole ne
signifie pas forcément
que l'outil ne détecte pas l'erreur mais simplement que nous n'avons pas
trouvé d'information explicite à ce sujet sur les ressources publiques.

Les catégories d'erreurs sont les suivantes :

=== Arithmétique entière

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
(ou _dépassement d'entier_).

Ce genre d'erreur peut être assez subtil car
bien qu'il soit détecté par le processeur qui positionne un drapeau
signalant le dépassement, il nécessite que le programmeur vérifie ce drapeau
explicitement pour en tenir compte; ce qu'il ne fait généralement pas.

Il y a aussi des opérations qui peuvent conduire à des comportements indéfinis
par le langage. Les langages dont la sémantique n'est pas complètement
standardisée donnent une certaine liberté aux compilateurs pour interpréter
certaines constructions. C'est ce qu'on appelle les _undefined behavior_.
Cela peut être problématique lorsque le comportement du compilateur n'est pas
celui imaginé par le développeur ou quand le programme est compilé avec un
autre compilateur. Ce genre d'erreur doit également être relevé car il
est susceptible de conduire à des erreurs d'exécution.

Une autre erreur couverte par l'analyse de l'arithmétique entière
est la division par 0. Celle-ci n'est pas plus autorisée en informatique que
dans les mathématiques générales et provoque une erreur fatale à l'exécution.


=== Arithmétique flottante

L'arithmétique flottante est basée sur une représentation binaire des nombres
réels. Les nombres flottants sont représentés par
trois valeurs : le _signe_, la _mantisse_ et l'_exposant_.
La mantisse est la partie
significative du nombre, l'exposant est la puissance de 2 ou de 10 à laquelle
il faut multiplier la mantisse et le signe indique si le nombre est
positif ou négatif.

Comme pour les nombres entiers, il existe plusieurs tailles de flottants et
la norme #cite(<ieee:754-2008>) définit plusieurs formats en fonction
de la base (2 ou 10) et le nombre de bits utilisés (en puissance de 2 de
16 à 128).

Bien que les nombres flottants permettent de représenter des nombres
plus grands que leur équivalent entier, ils n'en sont pas moins sujet à des
dépassement de capacité. Cela étant, le calcul flottant est complet et en cas
de dépassement ou de calcul impossible (comme la division par 0), le résultat
est donné par des nombres spéciaux comme $+infinity$ ou $-infinity$ ou
_NaN_#footnote[_Not A Number_ (pas un nombre), utilisé pour les opérations
invalides].

Le fait que l'arithmétique flottante soit standardisée et complète en font
parfois un choix de prédilection pour les calculs en général. Certains
langages de programmation (comme Lua) ont un seul type numérique qui est,
par défaut, représenté par un flottant.

D'un point de vue mathématique, l'arithmétique flottante a cependant
un soucis d'arrondi inhérent au fait que la décomposition binaire d'un
nombre peut être supérieure à sa capacité. Elle est même d'ailleurs infinie
si le dénominateur du nombre n'est pas une puissance de 2. Par exemple, le
nombre décimal 0.5 a une représentation flottante exacte car c'est
$#text(red)[2]^(-1) = 1/#text(red)[2]$. En revanche 0.1 ($1/#text(red)[10]$)
n'a pas de représentation exacte car sa décomposition
binaire donne $0,0overline(0011)$ (où 0011 se répète à l'infini). Pour pouvoir
représenter ce nombre, il faut l'arrondir à une certaine précision et
généralement 0.1 vaut en 0.10000000000000000555 en flottant.

Ces arrondis donnent lieu à des approximations qui peuvent s'accumuler et
devenir problématiques lorsqu'on enchaîne les opérations. Elles peuvent
également donner lieu à des résultat contre intuitifs. Par exemple, en calcul
flottant, l'égalité $0.1 + 0.2 = 0.3$ est fausse ! Avec les
arrondis, $0.1 + 0.2$ vaut 0.30000000000000004441 tandis que 0.3 vaut
0.29999999999999998890. Dans ce contexte, écrire des algorithmes numériques
fiables peut être très délicat.

Les analyses statiques sur l'arithmétique flottante peuvent détecter
les opérations ambiguës comme la comparaison ci-dessus et vérifier la marge
d'erreur en effectuant un calcul abstrait sur les intervalles possibles.

=== Gestion des pointeurs

Les pointeurs sont des valeurs représentant l'adresse en mémoire d'une autre
valeur. Ils sont couramment utilisés pour passer des valeurs par référence, et
par conséquent, éviter de copier ces valeurs à chaque fois qu'on les utilise
dans le flot de contrôle.

La manipulation des pointeurs est plus ou moins explicite suivant les langages.
En C, les pointeurs sont des valeurs de première classe et peuvent être
manipulés directement. À l'inverse, en OCaml, les pointeurs n'apparaissent
jamais directement dans le code source mais sont utilisés implicitement par
le compilateur.

Lorsque les pointeurs sont explicites, il y a trois type d'erreurs courantes
qui peuvent survenir :
- le débordement;
- le déréférencement de NULL;
- le _dangling pointer_

Le débordement survient lorsqu'on écrit ou lit en mémoire à une adresse
qui n'est pas celle prévue à la base. Typiquement, cela arrive lorsqu'on
adresse un tableau en dehors de ses limites. Par exemple, si on a un tableau
de 10 éléments et qu'on accède à l'élément 11, on accède à une zone pouvant
contenir n'importe quelle donnée et _a priori_ pas celle qui était imaginée.

Le déréférencement de NULL, ou plus généralement le déréférencement invalide,
consiste à utiliser une adresse invalide et à tenter de lire ou écrire à
cette adresse. Quand un programme est lancé par un système d'exploitation,
ce dernier lui octroie une zone mémoire pour son usage exclusif. Si le programme
tente d'accéder à une zone mémoire qui ne lui appartient pas, une erreur
d'accès mémoire est levée et le programme est arrêté.

Le cas le plus courant
est celui du déréférencement de NULL. NULL est une valeur particulière qui est
utilisée pour dénoter des valeurs particulières dans les structures de données
usuelles. Par exemple, une liste chaînée se termine souvent par un pointeur
NULL pour indiquer la fin de la liste. Dans la plupart des systèmes, NULL vaut
techniquement 0 et ce n'est pas une adresse valide.

Le _dangling pointer_ survient lorsqu'on utilise un pointeur sur une
valeur qui n'a jamais été allouée ou été préalablement libérée. Dans les deux
cas, la valeur pointée est indéterminée et l'utilisation de cette valeur
peut conduire à des comportements indéfinis. Par exemple, en C le code suivant
pose problème :

```c
int *p = malloc(sizeof(int)); /* allocation d'un entier dans le tas */
*p = 42;                      /* écriture de 42 à l'adresse pointée */
free(p);                      /* libération de la mémoire */
printf("%d\n", *p);           /* utilisation de la valeur pointée */
```

Après le `free(p)`, l'adresse mémoire pointée par `p` peut être réutilisée
par une autre partie du programme et contenir n'importe quelle valeur. Il n'est
donc pas possible de prédire la valeur affichée par le `printf`.

Notons que le _dangling pointer_ apparaît généralement dans les situations
où l'allocation dynamique se fait manuellement (C, C++, ...) mais il peut très
bien arriver sans allocations dynamiques par l'échappement de portée :

```c
int *p;
{
  int x = 42;
  p = &x;
}
printf("%d\n", *p);
```

ou plus généralement :
```c
int *func(void)
{
    int n = 42;
    /* ... */
    return &n;
}
```

Dans les deux cas, le pointeur (`p` ou `&n`) pointe sur une valeur qui n'est
plus définie lorsque le pointeur est utilisé.

=== Initialisation

Certains langages de programmation autorisent la déclaration de variables
sans initialisation. Une variable non initialisée contient généralement
d'anciennes données écrites par ce programme, voire par un autre programme.

Par exemple, on pourrait écrire par erreur en C:

```c
int n;
printf("%d\n", n);
```
Ce programme contient un _undefined behavior_ et un compilateur respectant
la dernière norme ISO peut produire n'importe quel binaire à partir de ce code
source. En pratique, ce programme affichera le plus souvent un entier dont la valeur peut changer d'une exécution à l'autre.

=== Concurrence

L'utilisation du calcul parallèle au sein d'un même programme se fait
généralement par l'utilisation des _threads_ fournis par le système
d'exploitation sous-jacent. Les threads permettent de lancer plusieurs
fonctions en parallèle en exploitant éventuellement la multiplicité des cœurs
de calcul de la machine. En toute théorie, cela permet d'accélérer le calcul
et de rendre le programme plus réactif.

Pour raisonner avec du calcul parallèle, il est nécessaire de mettre en place
des mécanismes de partage d'information entre les _threads_. Ces mécanismes
sont généralement des variables partagées ou des files de messages. Lorsque
plusieurs _threads_ accèdent à une même variable, il est possible que les
valeurs lues ou écrites soient incohérentes si les _threads_ ne sont pas
synchronisés. Par exemple, si un _thread_ écrit une valeur dans une variable
et que l'autre _thread_ lit cette valeur avant que l'écriture ne soit terminée,
il est possible que le second _thread_ lise une valeur intermédiaire qui n'est
pas celle attendue.

Pour éviter ce genre de problème, il est nécessaire de synchroniser les
_threads_ entre eux. Les mécanismes de synchronisation les plus courants sont
les _mutex_ (verrous) et les _sémaphores_. Toutefois, ces mécanismes se
mettent en place manuellement en fonction de ce que le programmeur imagine
comme étant le bon ordonnancement des _threads_. Or cet ordonnancement n'est
pas toujours celui qui est effectivement réalisé par le système d'exploitation,
ce qui rend les problèmes de concurrence très difficiles à reproduire et à
corriger.

Certaines analyses statiques peuvent détecter des erreurs de concurrence en
simulant les ordonnancements possibles et en vérifiant que les valeurs lues
et écrites sont cohérentes. En fonction de l'analyse effectuée, il est possible
de détecter deux types d'erreurs :
- les _data races_ (courses critique) qui surviennent lorsqu'un _thread_ lit ou
  écrit une valeur partagée sans synchronisation;
- les _deadlocks_ (interblocages) qui surviennent lorsqu'un _thread_ attend une
  ressource qui est détenue par un autre _thread_ qui lui-même attend une
  ressource détenue par le premier.

=== Gestion de la mémoire

Un programme utilise deux zones de mémoire : une zone statique et une zone
dynamique. La zone statique est prédéfinie à la compilation et contient les
données globales (ou explicitement statiques avec le mot clé `static` du C) et
ne peut être modifiée. La zone dynamique est réservée à l'exécution du programme
et contient deux sous-zones : la pile et le tas.

La _pile_ est une zone de mémoire avec une taille maximale définie par le
système et qui se remplit automatiquement en fonction du modèle d'exécution
du langage. En général, elle se remplit à chaque appel de fonction avec les
données locales et l'adresse de retour des fonctions, puis se vide lorsque les
fonctions terminent. Un dépassement de pile (_stack overflow_) peut survenir
lorsque qu'on cumule trop d'appel de fonction; ce qui peut arriver facilement
avec une récursion mal maîtrisée. Un dépassement de pile est une erreur fatale
au programme.

Certaines analyses statiques permettent d'évaluer la taille maximale occupée
par la pile et ainsi garantir l'absence de dépassement de pile.

Le _tas_ est une zone libre de mémoire dans laquelle on peut allouer des
données dynamiquement. L'allocation dynamique est réalisée par l'appel de
fonctions spécifiques qui demandent au système d'exploitation de réserver une
zone de mémoire de taille donnée. Lorsque la mémoire n'est plus utilisée, il
est nécessaire de la libérer pour éviter les _fuites mémoire_. Si trop
de mémoire est allouée sans être libérée, le programme peut consommer toute
la mémoire disponible et être arrêté par le système d'exploitation dans le
meilleur des cas. Dans le pire des cas, le système entier est paralysé car privé
des ressources mémoires nécessaires à son fonctionnement nominal.

Dans la bibliothèque standard du C, la fonction `malloc` peut être utilisée
pour allouer et `free` pour libérer la mémoire. Pour éviter les fuites mémoires,
il faut donc un `free` pour chaque `malloc` réalisé. Cependant, les programmes
non triviaux mettent en œuvre des structures de données complexes dont
certaines parties sont allouées dynamiquement et savoir quand faire le `free`
peut être délicat. Il peut arriver que le programmeur pêche par excès de
prudence et se retrouve à libérer deux fois une même allocation (_double free_).

La double libération a un comportement indéterminé et peut conduire à une
corruption de l'allocateur de mémoire entrainant des allocations incohérentes
et difficiles à diagnostiquer.

Certaines analyses statiques peuvent détecter les fuites mémoires et les
doubles libérations en suivant le flot de contrôle du programme et en
vérifiant que chaque allocation est bien libérée une et une seule fois.

Notons que les langages à gestion automatique de la mémoire ne sont pas exempt
de fuites mémoires. La gestion automatique de la mémoire
est basée sur un ramasse-miettes qui libère la mémoire automatiquement
lorsqu'elle n'est plus utilisée. Toutefois, lorsque le ramasse-miettes ne peut
pas déterminer si une donnée est encore utilisée ou non, il peut décider de
la conserver alors qu'elle n'est plus utilisée. C'est le cas des
ramasse-miettes dits «conservatifs».

=== Analyseurs statiques

==== Frama-C

Parmi les analyseurs statiques étudiés, Frama-C a la particularité de
fonctionner avec des _plugins_ dédiés à un type d'analyse particulier. La
complétion de l'analyse globale considérée dans les comparatifs du document
suppose que les _plugins_ usuels soient utilisés, notamment :
- Eva ;
- Wp ;
- Mthread.

Certaines analyses complémentaires peuvent être proposées par l'outil via des
plugins payants ou réalisés _ad hoc_.

==== Polyspace

Polyspace désigne une gamme de produit de la société MathWorks
#footnote[#link("https://fr.mathworks.com")] qui propose différentes solutions
autour de l'analyse statique.

Dans le cadre de cette étude, nous désignons par Polyspace la solution
_Polyspace Code Prover_.

==== TIS Analyser

_TrustInSoft Analyser_ est un outil d'analyse statique développé par la société
_TrustInSoft_#footnote[#link("https://trust-in-soft.com")]. C'est un _fork_
de Frama-C qui utilise un ancien plugin _value_ basé sur le calcul
d'intervalles. _TrustInSoft_ a amélioré le plugin, la traçabilité des erreurs
et l'expérience utilisateur.

== Compilateurs

Pour chaque langage étudié, nous présentons les compilateurs disponibles et
les plateformes supportées, notamment les architectures les plus courantes:
- x86;
- x86_64;
- ARM.

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

#figure(

  table(
    columns: (auto, auto, auto, auto, auto, auto),
    [*Erreur*],                      [*Astrée*], [*ECLAIR*], [*Frama-C*], [*Polyspace*], [*TISAnalyser*],
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


- _RapiTime_ développé par _Rapita Systems_ permet l'analyse du _WCET_ en C #cite(<rapitime>).
- _aiT WCET Analyzers_ développé par _AbsInt_ supporte l'analyse du _WCET_ en C pour de nombreuses combinaisons compilateur/processeur #cite(<aitwcet>).

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

Le C++ est une extension du langage C créée par Bjarne Stroustrup en 1979. Il
ajoute au C les concepts de la programmation orientée objet et la
généricité (les _templates_). Pleinement compatible avec le C, le C++ peut
s'utiliser dans les mêmes contextes que le C mais il est plus souvent utilisé
pour écrire des applications complexes nécessitant une certaine abstraction.

/* Il est standardisé pour la première fois en 1998 #cite(<cpp98>) puis
régulièrement mis-à-jour jusqu'à la dernière version en 2020 #cite(<cpp20>).
Comme pour le C, il existe des référentiels de programmation pour garantir
une certaine qualité de code. Le plus connu est le
référentiel MISRA-C++ #cite(<misra_cpp>). */


== Paradigme

Le C++ est un langage de programmation #paradigme[objet] et
#paradigme[impératif].

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

- Astree
- ECLAIR
- Polyspace
- TISAnalyser

==== WCET

- _RapiTime_ développé par _Rapita Systems_ permet l'analyse du _WCET_ en C++ #cite(<rapitime>).
- _aiT WCET Analyzers_ développé par _AbsInt_ supporte l'analyse du _WCET_ en C++ pour de nombreuses combinaisons compilateur/processeur #cite(<aitwcet>).

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

Le langage Ada est crée à la fin des années 70 au sein de l'équipe CII-Honeywell Bull
dirigé par Jean Ichbiah pour répondre à un cahier des charges du département de la
Défense des États-Unis. Il est largement utilisé dans des systèmes temps réels
ou embarqués requérant un haut niveau de sûreté.

Le langage est standardisé pour la première fois en 1983 #cite(<ada1983>) sous le
nom d'_Ada83_. La dernière norme ISO _Ada 2022_ a été publiée en 2023 #cite(<ada2023>).
La norme _Ada 2012_ est librement téléchargeable #cite(<ada2012>).

== Paradigme

Ada est un langage de programmation #paradigme[objet] et #paradigme[impératif].
Depuis la norme _Ada 2012_, le paradigme #paradigme[contrat] a été ajouté au
langage.

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

- CodePeer
- Polyspace (MathWorks)
- SPARK Toolset

#figure(

  table(
    columns: (auto, auto, auto, auto),
    [*Erreur*],                      [*CodePeer*], [*Polyspace*], [*SPARK Toolset*],
    [*Division par 0*],              [✓],       [✓],         [],
    [*Débordement de tampon*],       [✓],       [✓],         [],
    [*Déréférencement de NULL*],     [✓],       [?],         [],
    [*Dangling pointer*],            [],        [],         [],
    [*Data race*],                   [✓],       [],         [],
    [*Interblocage*],                [],        [],         [],
    [*Vulnérabilités de sécurité*],  [],        [],         [],
    [*Dépassement d'entier*],        [✓],       [✓],         [],
    [*Arithmétique flottante*],      [],        [],         [],
    [*Code mort*],                   [✓],       [✓],         [],
    [*Initialisation*],              [✓],       [✓],         [],
    [*Flot de données*],             [],        [],         [],
    [*Contrôle de flôt*],            [],        [],         [],
    [*Flôt de signaux*],             [],        [],         [],
    [*Non-interférence*],            [],        [],         [],
    [*Fuites mémoire*],              [],        [],         [],
    [*Double `free`*],               [],        [✓],         [],
    [*Coercions avec perte*],        [],        [],         [],
    [*Mémoire superflue*],           [],        [],         [],
    [*Arguments variadiques*],       [],        [],         [],
    [*Chaînes de caractères*],       [],        [],         [],
    [*Contrôle d'API*],              [],        [],         [],
  )
)

Sources:
- La liste des _Common Weakness Enumeration_ (abrégée CWE) détectés par
  Polyspace: #cite(<polyspacecwe>)

==== WCET

- _RapiTime_ développé par _Rapita Systems_ permet l'analyse du _WCET_ en Ada #cite(<rapitime>).
- _aiT WCET Analyzers_ développé par _AbsInt_ supporte l'analyse du _WCET_ en Ada pour de nombreuses combinaisons compilateur/processeur #cite(<aitwcet>).

==== Pile

Nous considérons ici les logiciels capables via une analyse statique d'estimer
la taille maximale occupée par la pile d'un programme Ada lors de son exécution.

- GNATstack développé par AdaCore #cite(<gnatstack>).
- Le compilateur _GNAT FSF_ propose deux options pour analyser l'usage de la pile:
--`-fstack-usage` qui produit une estimation de la taille maximale de la pile par fonctions.
-- `-Wstack-usage=BYTES` qui produit un message d'avertissement pour les fonctions
qui pourraient nécessitées plus que `BYTES` octets sur la pile.
Il est à noter que ces deux options fournissent

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

==== Typage statique fort

Le langage Ada est _statiquement typé_ et _fortement typé_. Par _statiquement typé_, nous entendons que les types sont vérifiés à la compilation.
Contrairement à des langages comme _C_ ou _C++_, Ada est _fortement typé_,
c'est-à-dire qu'il ne fait pas de conversions implicites entre des types
différents. Par exemple l'expression `2 * 2.0` produira une erreur de compilation car le type de `2` est `Integer` et le type de `2.0` est `Float`.

En plus des habituels types scalaires (entiers, flottants, ...), des enregistrements et des énumérations, le langage dispose de l'abstraction de type et d'un système de sous-typage.

===== Type abstrait
Il est possible de construire un nouveau type à partir d'un autre type via la syntaxe `type New_type is new Old_type`. Par exemple le programme suivant:

```ada
procedure Foo is
   type Kilos is new Float;
   type Joules  is new Float;

   X : Kilos;
   Y : constant Joules := 10.0;
begin
   X := Y;
end Foo;
```
ne compilera pas car bien que `X` et `Y` aient la même représentation mémoire (des flottants), ils ne sont pas du même type.

===== Sous-typage

(TODO)

==== Programmation par contrat

Depuis la norme _Ada 2012_, le paradigme de _programmation par contrat_
a été ajouté au langage. Par exemple la fonction suivante implémente la fonction _racine carrée entière_ qui n'est définie que pour les entiers positifs.

```ada
function Isqrt (X : Integer) return Integer with
 Pre => X >= 0, Post => X = Isqrt'Result * Isqrt'Result
is
  Z, Y : Integer := 0;
begin
  if X = 0 or X = 1 then
    return X;
  else
    Z := X / 2;
    Y := (Z + X / Z) / 2;
    while Y < Z loop
      Z := Y;
      Y := (Z + X / Z) / 2;
    end loop;
    return Z;
  end if;
end Isqrt;
```
Compilé avec l'option `-gnata` du compilateur _GNAT_, on obtiendra une
erreur à l'exécution si on appelle cette fonction avec une valeur négative.

On peut également spécifier des invariants pour des types dans les interfaces
des _packages_. Par exemple, pour une implémentation des intervalles fermés, on peut garantir que l'unique représentant de l'intervalle vide est donné par le couple d'entiers `(0, -1)`.
```ada
package Intervals is
  type Interval is private
    with Type_Invariant => Check (Interval);

  function Make (L : Integer; U : Integer) return Interval;

  function Inter (I : Interval; J : Interval) return Interval;

  function Check (I : Interval) return Boolean;

  private
    type Interval is record
      Lower : Integer;
      Upper : Integer;
    end record;
end Intervals;
```
La fonction `Check`, dont l'implémentation n'est pas exposée dans l'interface,
s'assure que le seul intervalle vide est l'intervalle `[0, -1]`. Une implémentation de cette interface pourrait être:

```ada
package body Intervals is
  function Make (L : Integer; U : Integer) return Interval is
   (if U < L then (0, -1) else (L, U));

  function Min (X : Integer; Y : Integer) return Integer is
   (if X <= Y then X else Y);

  function Max (X : Integer; Y : Integer) return Integer is
   (if X <= Y then Y else X);

  function Inter (I : Interval; J : Interval) return Interval is
   (Max (I.Lower, J.Lower), Min (I.Upper, J.Upper));

  function Check (I : Interval) return Boolean is
   (I.Lower <= I.Upper or (I.Lower = 0 and I.Upper = -1));
end Intervals;
```

Nous avons volontairement laissé un bug dans la fonction `Inter` qui n'appelle pas le _smart constructor_ `Make` pour normaliser un éventuel intervalle vide. Cette erreur pourrait être détectée à l'exécution avec une entrée appropriée ou par un outil d'analyse statique qui utilise les contrats comme des annotations (par exemple _SPARK_).

==== Support multi-tâche

Le langage Ada intègre dans sa norme des bibliothèques pour la programmation concurrentielle. Le concept de _tâche_ permet d'exécuter des applications en
parallèle en faisant abstraction de leur implémentation. Une tâche peut ainsi
être exécutée via un thread système ou un noyau dédié. Il est également possible de donner des prioriétés aux tâches et de les synchroniser.

```ada
with Ada.Text_IO; Use Ada.Text_IO;

procedure Hello_World is
  protected Counter is
    procedure Decr(X : out Integer);
    function Get return Integer;
  private
    Local : Integer := 20;
  end Counter;

  protected body Counter is
    procedure Decr(X : out Integer) is begin
      X := Local;
      Local := Local - 1;
    end Decr;

    function Get return Integer is begin
      return Local;
    end Get;
  end Counter;

  task T1;
  task T2;

  task body T1 is
    X : Integer;
  begin
    loop
      Counter.Decr(X);
      Put_Line ("Task 1: " & Integer'Image (X));
      exit when Counter.Get <= 1;
    end loop;
  end T1;

  task body T2 is
    X : Integer;
  begin
    loop
      Counter.Decr(X);
      Put_Line ("Task 2: " & Integer'Image (X));
      exit when Counter.Get <= 1;
    end loop;
  end T2;
begin
  null;
end Hello_World;
```

==== Traits temps réel

Le profile _Ravenscar_ est un sous-ensemble du langage Ada conçu pour les
systèmes temps réel. Il a fait l'objet d'une standardisation dans _Ada 2005_.
En réduisant les fonctionnalités liées aux multi-tâches, ce profile
facilite en outre la vérification automatique des programmes.

=== Tests

Nous nous bornons ici aux logiciel de génération de tests et aux bibliothèques facilitant la gestion des tests unitaires.

==== Automatisation
- LDRA TBrun
- VectorCAST/Ada
- GNATtest
- AdaTEST 95
- Rational Test RealTime (RTRT)

==== Test unitaire
- Ahven
- AUnit

== Compilateurs & outils

=== Compilation

Il existe de nombreux compilateurs Ada. Nous nous bornons ici à lister quelques compilateurs maintenus et de qualité industrielle.

#figure(

  table(
    columns: (auto, auto, auto, auto, auto),
    [Compilateur], [Compagnie], [OSs], [Licence], [Normes#footnote[Nous ne considérons ici que les trois normes ISO _Ada95_, _Ada 2005_ et _Ada 2012_.]],
    [PTC ObjectAda], [PTC, Inc.], [Windows, Unix-like], [Propriétaire], [95, 2005, 2012],
    [GNAT FSF], [GNU Project], [Windows, Unix-like], [GPLv3+], [95, 2005, 2012],
    [GNAT Pro], [AdaCore], [Windows, Unix-like], [GPLv3+], [95, 2005, 2012],
    [GNAT LLVM], [AdaCore], [Windows, Unix-like], [GPLv3+], [?],
    [GreenHills Ada Optimizing Compiler], [Green Hills Software], [Windows, Unix-like], [Proprietary], [],
    [PTC ApexAda], [PTC, Inc.], [Unix-like], [Propriétaire], [],
    [SCORE Ada], [Symbolics, Inc.], [Symbolics Genera], [Propriétaire], [95],
    [Janus/Ada], [R.R. Software, Inc.], [Windows], [Propriétaire], [95, 2005, 2012],
  )
)

Les compilateurs _GNAT FSF_, _GNAT Pro_ et _Janus/Ada_ proposent également un mode _Ada 83_ mais
ne donnent pas garantie quant au respect de ce standard.

Le langage Ada a une longue tradition de validation des compilateurs. Ce
processus de validation a fait l'objet en 1999 d'une norme ISO #cite(<adaconformity>).
L'_Ada Conformity Assessment Authority_ (abrégée _ACAA_) est actuellement
l'autorité en charge de produire un jeu de tests
(_Ada Conformity Assessment Test Suite_) validant
la conformité d'un compilateur avec les normes Ada. Elle propose la validation
pour les normes Ada83 et Ada95 à travers des laboratoires tiers indépendants.

En plus de cette validation, certains compilateurs ont fait l'objet de certifications pour la sûreté ou la sécurité:
- _GNAT Pro_ dispose des certifications de sûreté suivant:
  - _DO-178C_, _EN-50128_, _ECSS-E-ST-40C_,_ECSS-Q-ST-80C_ et _ISO 26262_
  et des certifications de sécurité:
  - _DO-326A/ED-202A_ et _DO-365A/ED-203A_.


=== Débuggeur

Le débuggeur libre GDB fonctionne avec Ada et est généralement distribué avec GNAT.

=== Meta programmation

=== Générateurs de code

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

ALIRE (_Ada LIbrary REpository_) est un dépôt de bibliothèques Ada près à l'emploi. L'installation se fait via l'outil _alr_ inspiré de _Cargo_ en _Rust_ et _opam_ en _OCaml_.

=== Communauté

- _Ada Europe_ est une organisation internationale promouvant l'utilisation
  d'Ada dans la recherche #cite(<adaeurope>).
- _Ada Resource Association_ (abrégée _ARA_) est une association qui promeut l'utilisation d'Ada dans l'industrie #cite(<adaic>).
- _Ada - France_ est une association loi 1901 regroupant des utilisateurs francophones d'Ada #cite(<adafrance>).
- _The AdaCore blog_ est un blog d'actualité autour du langage Ada maintenu par l'entreprise _AdaCore_ #cite(<adacoreblog>).

=== Assurances

== Adhérence au système

Le langage Ada peut être utilisé dans un contexte de programmation _bare metal_,
c'est-à-dire en l'absence d'un système d'exploitation complexe.

- _GNAT FSF_ permet l'utilisation de _runtime_ personnalisé,
- _GNAT Pro_ est livré avec plusieurs _runtime_:
  - _Standard Run-Time_ pour les OS classiques (Linux, Windows, VxWorks et RTEMS),
  - _Embedded Run-Time_ pour les systèmes _bare metal_ avec le support des tâches,
  - _Light Run-Time_ pour développer des applications certifiables sur des machines ayant peu de ressources;
- _GreenHills Ada Optimizing Compiler_ fournit plusieurs implémentations de
  _runtime_ pour des cîbles différentes #cite(<greenhillscompiler>),
- _PTC_ distribue un _runtime_ pour _PTC ObjectAda_ pour VxWorks et LynxOS sur PowerPC.
- _PTC ApexAda_ propose également un _runtime_ dans un contexte _bare metal_ pour l'architecture Intel X86-64 #cite(<apexada>).

Notons enfin qu'une dès force du langage est qu'en proposant dans sa norme une
API pour la programmation concurrentielle et temps-réel, il permet de cibler
plusieurs plateformes ou runtimes différents sans avoir à modifier le code source.

== Interfaçage

Ada peut être interfacé avec de nombreux langages. Les bibliothèques standards
contiennent des interfaces pour les langages C, C++, COBOL et FORTRAN. L'exemple
ci-dessous est issu du standard d'_Ada 2012_:
```ada
--Calling the C Library Function strcpy
with Interfaces.C;
procedure Test is
   package C renames Interfaces.C;
   use type C.char_array;
   procedure Strcpy (Target : out C.char_array;
                     Source : in  C.char_array)
      with Import => True, Convention => C, External_Name => "strcpy";
This paragraph was deleted.
   Chars1 :  C.char_array(1..20);
   Chars2 :  C.char_array(1..20);
begin
   Chars2(1..6) := "qwert" & C.nul;
   Strcpy(Chars1, Chars2);
-- Now Chars1(1..6) = "qwert" & C.Nul
end Test;
```

Certains compilateurs proposent également d'écrire directement de l'assembleur
dans du code Ada. Pour ce faire, il faut inclure la bibliothèque `System.Machine_Code`
dont le contenu n'est pas normalisé par le standard. Par exemple, le compilateur _GNAT_
propose une interface similaire à celle proposée par _GCC_ en langage C:

```ada
with System.Machine_Code; use System.Machine_Code;

procedure Foo is
begin
  Asm();
end Foo;
```

== Utilisation dans le critique

Ada intégrant des fonctionnalités pertinentes dans un cadre critique, il a été
abondamment utilisé dans de nombreux projets à haute exigence de sûreté. D'abord
présent dans un cadre militaire, Ada est aujourd'hui utilisé par des entreprises
publiques et privées. Nous ne retenons ici que quelques uns de ses nombreux succès:
- Les fusées Ariana 4, 5 et 6.
- Le système de transmission voie-machine (TVM) développé par le groupe CSEE et
utilisé sur les lignes ferroviaires TGV, le tunnel sous la manche, la High Speed
1 au Royaume-Uni ou encore la LGV 1 en Belgique.
- Le pilote automatique pour la ligne 14 du métro parisien dans le cadre du projet
  _METEOR_ (Métro Est Ouest Rapide) #cite(<meteorproject>).
- La majorité des logiciels embarqués du Boeing 777 sont écrits en Ada.

Une liste plus fournis de logiciels critiques utilisant Ada avec quelques
sources: #cite(<adaprojectsummary>).

= SCADE

_SCADE_ (_Safety Critical Application Development Environment_) est un langage
de programmation et un environnement de développement dédiés à l'embarqué critique. Le langage est né au milieu des années 90 d'une collaboration entre le laboratoire de recherche _VERIMAG_ à Grenoble et l'éditeur de logiciels _VERILOG_.
Depuis 2000, le langage est développé par l'entreprise _ANSYS/Esterel-Technologies_.

À l'origine le langage _SCADE_ était essentiellement une extension du langage
_LUSTRE V3_ avant d'en diverger à partir de la version 6.

Grâce à une expressivité réduite du langage, le compilateur _KCG_ de _SCADE_ est
capable de vérifier des propriétés plus forte qu'un compilateur d'un langage de
programmation généraliste.

== Paradigme

_SCADE_ est un langage #paradigme[déclaratif], #paradigme[synchrone] et
#paradigme[par flots].

Contrairement à la plus part des langages généralistes dont la brique élémentaire de donnée est l'entier, _SCADE_ manipule des _séquences_ potentiellement infinies indexées par un temps discret. Ces séquences sont une modélisation des entrées analogiques.

Un programme _SCADE_ est constitué d'une multitude de noeuds (_node_ dans le langage)
et chaque noeud

Le programme lui-même est une liste d'équations entre ces séquences d'entrée. Ces équations peuvent être mutuellement récursives. Par exemple, considérons le programme suivant en _Lustre_:

```lustre
node mod_count (m : int) returns (out : int);
let
  out = (0 -> (pre out + 1)) mod m;
tel
```

Si $m_0, m_1, ...$ désignent les valeurs successives de la séquence d'entrée $m$ et $"out"_0, "out"_1, ...$ celles de la sortie $"out"$. Ce programme produit la sortie:

$0 mod m_0, ((0 mod m_0) + 1) mod m_1, ...$

Par exemple si $m$ est la séquence constante 4, on obtient la suite périodique $0, 1, 2, 3, 0, 1, 2, 3, ...$.

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

Le logiciel _Ansys SCADE suite_ est capable de détecter les erreurs suivantes:
- les débordements de tampons,
- le code mort.

==== WCET

L'estimation du WCET d'un programme _SCADE_ est cruciale pour s'assurer qu'il pourra s'exécuter de façon synchrone: on doit garantir que le programme terminera avant le prochain événement, sans quoi celui-ci pourrait être ignoré.

_Ansys SCADE Suite_ intègre l'outil _timing analyzer_
développé par _aiT_ #cite(<aitscade>). Cet outil permet
l'estimation et l'optimisation du WCET lors de la modélisation, voir le tool paper #cite(<aitwcetscade>).

==== Pile

_Ansys SCADE Suite_ intègre l'outil _StackAnalyzer_ développé par _aiT_ #cite(<stackanalyzerscade>). Son fonctionnement est également décrit dans le tool paper #cite(<aitwcetscade>).

==== Qualité numérique

=== Meta formalisation

=== Mécanismes intrinsèques de protection

Le langage SCADE est statiquement typé et fortement typé. En plus des propriétés
habituellement garanties par un _typechecker_, le compilateur _KCG_ garantie
des propriétés très fortes sur les programmes qu'il produit. Il garantie notamment que:
- le programme ne contient pas d'accès à un tableau en dehors de ses bornes,
- le programme peut être exécuté de façon synchrone,
- le programme peut être exécuté avec une quantité de mémoire bornée et connue,
- le programme est déterministe au sens où sa sortie ne dépend pas d'une valeur indéfinie.

=== Tests



== Compilateurs & outils

=== Compilation

À notre connaissance, _KCG_ est l'unique compilateur disponible pour
le langage _SCADE_. Il est disponible sur _Windows_ en 32 et 64 bits.

Une particularité forte du compilateur _KCG_ est qu'il a fait l'objet de nombreuses
certifications et notamment de certifications permettant de l'utiliser dans l'aéronautique:
- _DO-178B_ au niveau A,
- _DO-178C_ au niveau A,
- _DO-330_,
- _IEC 61508_ jusqu'à _SIL 3_,
- _EN 50128_ jusqu'à _SIL 3/4_,
- _ISO 26262_ jusqu'à _ASIL D_;

=== Débuggeur

=== Meta programmation

=== Générateurs de code

Le compilateur _KCG_ est techniquement un transpileur, c'est-à-dire un traducteur
d'un langage de programmation (ici _SCADE_) vers un langage de même niveau (ici le
langage C ou Ada).

==== _Parsing_

==== Dérivation

== Bibliothèques & COTS

=== Communauté

=== Assurances

== Adhérence au système

Le langage SCADE est généralement compilé vers du C ou de l'Ada.

== Interfaçage

== Utilisation dans le critique

Du fait des certifications proposées par le compilateur _KCG_, le langage _SCADE_
est beaucoup utilisé dans l'aviation civile et militaire. On peut citer notamment:
- les commandes de vol des Airbus,
- le projet openETCS visant à unifier des systèmes de signalisation ferroviaires en Europe,
-

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

