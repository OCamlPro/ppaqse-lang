#import "defs.typ": *
#import "links.typ": *

= Paradigmes

À chaque langage de programmation vient sa manière de decrire les solutions
algorithmiques au problèmes posés. Cette manière d'aborder les problèmes est
ce qu'on appelle le _paradigme_ du langage.

Les paradigmes les plus courants des langages informatiques sont la plupart du
temps les suivants:
- #paradigme[impératif];
- #paradigme[fonctionnel];
- #paradigme[objet].

Il existe d'autres paradigmes moins répandus mais qui concernent
les langages de programmation du rapport:
- #paradigme[déclaratif];
- #paradigme[contrat]
- #paradigme[synchrone].


Notons que les paradigmes ne sont pas exclusifs : un langage peut être
composer plusieurs paradigmes et c'est même le cas général dans les langages
généralistes. Toutefois, même en composant plusieurs paradigmes, il y
en a souvent un qui se dégage plus que les autres à l'usage.

== Impératif

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
    while (nullptr != l) {
      len++;
      l = l->next;
    }
    return len;
  }
  ```,
  caption: [Calcul de la longueur d'une liste chainée en C],
  supplement: none,
) <ex_C_length>

En considérant que `nullptr` représente la liste vide, la fonction `length`
parcourt la liste en incrémentant un compteur `len` à chaque élément de la
liste. Lorsque la liste est vide, la fonction retourne la longueur obtenue.

Le style impératif est le plus répandu dans les langages informatiques. Il est
relativement proche de la machine mais propice aux erreurs de
programmation car il n'est pas toujours évident de suivre l'état d'un système
lorsque plusieurs morceaux de programme le modifient.

== Fonctionnel

Le paradigme fonctionnel consiste à exprimer les calculs sous la forme d'une
composition de fonctions mathématiques. Dans sa forme dite _pure_, les
changements d'état du système sont interdits. En conséquence, il n'y a pas
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

Dans cet exemple, la fonction `length` prend en paramètre une liste et on fait
une analyse de cas sur la structure de la liste. Si la liste est vide (`[]`),
la longueur est 0. Sinon on analyse la tête et la queue (`tl`) de la liste et
on ajoute 1 à la longueur de `tl`.

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

== Objet

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
du point et la méthode `print` permet de les afficher.

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
pour la coordonnée de profondeur. La méthode `print` est redéfinie pour
afficher les trois coordonnées du point.

Le succès des langages objets (C++, Java, Javascript, ...) indique que le
paradigme est très populaire dans les domaines applicatifs et le Web où
la réutilisabilité est un critère de production déterminant.

Généralement, les objets ont un état interne mutable qui peut être modifié par
les méthodes de la classe. De fait, le
paradigme objet va intrinsèquement souffrir des mêmes défauts que le paradigme
impératif sur la difficulté de suivre l'état réel d'un programme.

Par ailleurs, la hiérarchie des classes forme une structure arborescente
qu'il est rapidement difficile de se représenter mentalement. Au delà d'une
certaine profondeur, comprendre le flux de contrôle d'un programme sans
outillage peut être une gageure.

== Déclaratif

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
- soit un modèle de compilation moins optimal (comme pour les langages
  fonctionnels purs comme Haskell) ;
- soit par une perte d'expressivité en restreignant le langage à un
  sous-ensemble plus facilement optimisable (Lustre).

== Contrat

La programmation par contrat est un paradigme secondaire qui complète un
les autres paradigmes. Cela consiste à ajouter dans le programme des propriétés
qui peuvent être vérifiées statiquement par le compilateur (ou un outil tiers)
ou dynamiquement à l'exécution et ajoutant des gardes automatiquement dans le
code.

Ces propriétés prennent la forme d'assertions insérées à des endroits
spécifiques. L'ensemble des assertions associé à un morceau de code est alors q
forme un _contrat_.
Les contrats permettent
de clarifier la sémantique du programme et de réduire le nombre de _bugs_. Ils
jouent ainsi un rôle complémentaire aux types et aux commentaires.

On distingue quatre types d'assertions:
- Les _préconditions_ qui doivent être vérifiées à l'entrée d'une fonction ou
  d'une procédure ;
- Les _postconditions_ qui doivent être vérifiées à la sortie d'une fonction
  ou d'une procédure ;
- Les _invariants_ qui doivent toujours être vrais pour des valeurs d'un
  certain type ou les instances d'une classe ;
- Les _variants_ qui sont des quantités attachées aux boucles ou aux fonctions
  récursives. Elle sont censées croitre ou décroitre de manière bornée à chaque
  itération ou appel récursif. Elles
  permettent de vérifier la terminaison d'un algorithme.

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

Dans cet exemple, les assertions `value_1 > 0` et `value_2 > 0` indiquées dans
la section `require` sont des _précondistions_. L'assertion
`Result = gcd(value_2, value_1)` dans la section `ensure` est une
_postcondition_. Les invariants et les variants sont indiqués dans les sections
idoines.

== Synchrone

La programmation _synchrone_ est utilisée dans le cadre des _systèmes réactifs_,
c'est-à-dire des systèmes qui maintiennent en permanence une interaction avec
un environnement et qui doivent être en mesure d'y réagir de façon synchrone,
sûre et déterministe.

La famille des langages synchrones est elle-même divisée en deux familles:
- les langages _dataflow_ (à _flots de données_);
- les langages _orientés contrôle_.

Les langage de programmation _dataflow_ (Lustre, Scade) sont basés sur
l'idée que les données sont variables au cours du temps et forment des _flôts_
et que les opérations des combinateurs de flôts. Par exemple, le flôt `x` de
type entier est vu d'un point de vue logique comme une suite infinie de valeurs
entières. Si elle est constante (par exemple 1), on peut la représenter par
de la manière suivante:

#align(
   center,
   table(
      columns: (auto, auto, auto, auto, auto, auto, auto, auto),
      [*Temps*], [$t_0$], [$t_1$], [$t_2$], [$t_3$], [$t_4$], [$t_5$], [...],
      [$x$],     [1],     [1],     [1],     [1],     [1],     [1],     [...],
   )
)

Si l'on combine ce flôt avec un autre flôt `y` variable et l'addition, on
obtient un autre flôt `z` qui varie lui aussi au cours du temps en suivant les
valeurs de `x` et `y`:

#align(
   center,
   table(
      columns: (auto, auto, auto, auto, auto, auto, auto, auto),
      [*Temps*],     [$t_0$], [$t_1$], [$t_2$], [$t_3$], [$t_4$], [$t_5$], [...],
      [$x$],         [1],     [1],     [1],     [1],     [1],     [1],     [...],
      [$y$],         [2],     [-1],    [4],     [3],     [-3],    [1],     [...],
      [$z = x + y$], [3],     [0],     [5],     [4],     [-2],    [2],     [...],
   )
)

Un programme revient alors à une description equationnelle des sorties en
fonction des entrées.

Dans les programmes _orientés contrôle_ (Esterel, ReactiveML), la temporalité
s'exprime par les structures de contrôle du langage qui opèrent sur des signaux
équivalent aux flôts précédents mais dont la valeur peu être présente ou
absente. On distingue alors les instructions qui _prennent du temps_ de celles
qui sont considérées comme logiquement instantannées. Voici par exemple un
programme ReactiveML (un surchouche réactive au dessus d'OCaml):

```ocaml
let process produce nat =
   let n = ref 0 in
   loop
      n := !n + 1;
      emit nat !n;
      pause
   end

let process print nat =
   loop
      await nat(n) in
      print_int n;
   end

let process main =
   signal nat in
   run (produce nat) || run (print nat)

let () = run main
```

Dans ce programme, on crée un processus `produce` qui prend un signal `nat` et
boucle indéfiniment en incrémentant le compteur `n` et en émétant la valeur de
`n` dans le signal `nat`. Comme toutes ces oprations sont instantannées, on
insère une instruction `pause` qui prend du temps (logique) et évite à la
boucle `loop` de tourner indéfiniment dans le même pas de temps.
Le processus `print` boucle indéfiniment en attendant la valeur de `nat` et
l'affiche. Comme attendre un signal prend du temps, la boucle `loop` n'est
pas instantannée et n'a pas besoin de pause.
Le processus `main` crée un signal `nat` et lance les processus `produce` et
`print` en parallèle. Lorsqu'on exécute le programme, on obtient l'affichage
1, 2, 3, 4, 5, ... qui montre bien que les deux processus tournent en parallèle
de manière synchrone.

Ce genre de programmation est particulièrement adapté aux systèmes interactifs
car il permet de décrire de manière intuitive et concise les interactions en
obtenant un résultat déterministe. Obtenir le même résultat avec un langage
utilisant des _threads_ est généralement plus complexe et moins sûr.

Dans les deux cas, les langages synchrones utilisent un modèle temporel logique
pour ordonnancer les évènements et les réactions à ces évènements. Ce modèle
de temps logique peut être callé sur le temps réel en choissisant une borne
maximale entre deux instants logiques du système. Dans les langages comme Lustre
ou l'ordonancement est statique et que le code engendré pour un pas de temps
est déterministe, on peut calculer le WCET maximal d'un pas de temps et donc
garantir l'adéquation avec le temps réel.

