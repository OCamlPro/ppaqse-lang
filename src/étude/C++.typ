#import "defs.typ": *
#import "links.typ": *

#language(
  name: "C++",

  introduction: [

Le C++ est une extension du langage C créée par Bjarne Stroustrup en 1979. Il
ajoute au C les concepts de la programmation orientée objet et la
généricité (les _templates_). Pleinement compatible avec le C, le C++ peut
s'utiliser dans les mêmes contextes que le C mais il est plus souvent utilisé
pour écrire des applications complexes nécessitant une certaine abstraction.

Il est standardisé pour la première fois en 1998 #cite(<cpp98>) puis
régulièrement mis-à-jour jusqu'à la dernière version en 2020 #cite(<cpp20>).
Comme pour le C, il existe des référentiels de programmation pour garantir
une certaine qualité de code. Le plus connu est le
référentiel MISRA-C++ #cite(<misra_cpp>).

  ],

  paradigme: [
Le C++ est un langage de programmation #paradigme[objet] et
#paradigme[impératif]. Toutefois, l'un des éléments ayant particulièrement
contribué au succès du C++ est l'introduction des _templates_ qui offrent une
forme de (meta)programmation générique.

],

  runtime: [

Les analyseurs statiques cités pour le C sont indiqués comme
fonctionnant également pour le C++ mais avec un niveau de support obscur.
#astree supporte le standard C++17 tandis que #framac indique clairement un
support balbutiant (via un _plugin_ utilisant #clang pour traduire la partie
C++ en une représentation plus simple).

Les autres outils ne donnent pas explicitement leur niveau de support du C++.
  ],


  wcet: [

Les outils de calcul du WCET cités pour le C fonctionnent également pour le C++.
#otawa fournit notamment un cadre logiciel en C++ qui, intégré au développement,
améliore l'analyse avec des données dynamiques.

  ],

  pile: [

Les outils d'analyse statique de pile cités pour le C fonctionnent également
pour le C++ (tant qu'il existe un compilateur C++ pour l'architecture cible)
puisqu'ils se basent sur une analyse du fichier binaire et non
du code source.
  ],

  numerique: [
Comme pour le C, #astree et #polyspace détectent statiquement
les erreurs à _runtime_. #cadna est aussi utilisable pour des une
analyse dynamique mais #fluctuat et #gappa ne sont pas utilisable directement
sur du C++.

#let mpfrpp = link("http://www.holoborodko.com/pavel/mpfr/", "MPFR++")
#let mpfr_real = link("http://chschneider.eu/programming/mpfr_real/", "MPFR Real")
#let boost_multiprecision = link(
  "https://www.boost.org/doc/libs/1_86_0/libs/multiprecision/doc/html/index.html",
  "Boost"
)

#xsc (eXtended Scientific Computing) est une bibliothèque de calcul
numérique qui réimplémente les calculs sur les flottants avec une précision
arbitraire. Cette implémentation donne des résultats arbitrairement précis (
en fonction de la précision choisie) mais est assez lente.

#mpfr a plusieurs implémentations en C++. Les plus maintenues et à jour
sont #mpfrpp et #boost_multiprecision. #mpfrpp utilise la précision
maximale qu'il trouve dans une expression et arrondi le résultat à précision
de la variable cible. #boost_multiprecision utilise une précision explicite
avec différentes implémentations suivant les classes choisies (pur C++,
basée sur #gmp, basée sur #gmp et #mpfr).

  ],

  formel: [

#let brick = link("https://github.com/bedrocksystems/BRiCk", "BRiCk")
La seule meta formalisation du C++ connue est #brick qui traduit essentiellement
le langage C++ vers #coq pour ensuite bénéficier du cadre logiciel #iris. Le but
est de pouvoir démonter des propriétés sur des programmes C++ concurrents.

  ],

  intrinseque: [
Le C++ offre plus de garanties intrinsèques que le C à travers trois
mécanismes :
- la programmation objet;
- les exceptions;
- les _templates_.

La programmation objet permet de définir des classes et des objets qui
encapsulent des données et des méthodes. En C++, cette encapsulation est
finement contrôlable avec des spécificateurs d'accès (`public`, `protected`,
`private`) qui permettent de limiter la visibilité des membres d'une classe.
Ce mécanisme, cumulé avec le polymorphisme introduit par l'héritage permet
de contractualiser les interfaces. Dans l'exemple suivant :

```cpp
class Animal
{
private:
    static uint32_t _count;
    const uint32_t _id;
protected:
    std::string _name;
    static uint32_t fresh(void) { return ++_count; }
    virtual std::string noise(void) const = 0;
    virtual uint32_t id(void) const { return _id; }
public:
    Animal(std::string name) : _id(fresh()), _name(name) {}

    virtual void show(void) const {
        std::cout << _name << std::endl;
    }

    virtual void shout(void) const {
        std::cout << this->noise() << "!" << std::endl;
    }
};

uint32_t Animal::_count = 0;

class Dog : public Animal
{
public:
    Dog(std::string name) : Animal(name) {}
protected:
    std::string noise(void) const override { return "Ouaf"; }
};

class Cat : public Animal
{
public:
    Cat(std::string name) : Animal(name) {}
    void show(void) const override {
        std::cout << _name << "(" << this->id() << ")" << std::endl;
    }
protected:
    std::string noise(void) const override { return "Miaou"; }
};
```

on définit une classe abstraite `Animal` et deux sous classes `Dog` et `Cat`.
À chaque animal est associé un identifiant (le membre `_id`), une
identification (la méthode `show`) et un son
(la méthode `noise`). À l'instanciation d'`Animal`, on peut attribuer un
identifiant à l'objet via la méthode `fresh`. `fresh` est déclarée `private` et
ne peut donc être utilisée que par l'interface `Animal`. La méthode `noise`
est définie par les sous-classes mais elle reste ici `protected` de sorte
qu'elle ne peut pas être appelée de manière externe à l'objet ou les classes
dérivées. La classe `Cat` redéfinit la methode `show` qui permet d'identifier
l'animal en y ajoutant son identifiant auquel il a le droit d'accéder que grâce
à la méthode `id` déclarée `protected` (le champs `_id` est privé).

Cet exemple montre bien qu'à travers un ensemble de mot clés comme les
spécificateurs d'accès ou les `virtual` et `override`, on peut établir des
contrats d'utilisation entre les classes et vis-à-vis du code appelant.
Utilisé correctement, il est facile d'établir des invariants par construction
même si ceux-ci ne sont pas explicitement formalisés.

Les exceptions offrent un moyen de gérer les erreurs qui, en toute théorie, est
plus robuste que les codes de retour et la programmation défensive utilisée
en C. Dans cette dernière, il est facile de rater ou de mal interpréter un
code de retour et obtenir un programme
qui arrive dans état incohérent de manière silencieuse de sorte qu'il est
difficile de déméler la situation. Avec le mécanisme d'exceptions, il est
commun de lancer une exception en cas d'erreur. Celle-ci peut être rattrappée
à n'importe quel moment dans le flôt de contrôle appellant et, en cas de doute,
il est possible d'attrapper toutes les exceptions de sorte qu'aucune erreur
levée ne peut s'échapper et conduire à une erreur à l'exécution.

Enfin, le mécanisme des _templates_ et de spécialisation permet d'expliciter
les contraintes de typage de sorte qu'il est possible de renforcer
arbitrairement le typage du langage pour obtenir un programme fortement typé
de bout en bout. Il est même possible d'encoder des propriétés plus fortes
puisque
le langage de _template_ est Turing complet et que les _templates_ sont
évalués à la compilation.

Tous ces mécanismes permettent, en théorie, de renforcer la qualité et la
fiabilité d'un programme C++. En pratique cependant, la multiplicité des
concepts et la sémantique complexe du langage font que tous
ces mécanismes sont difficiles à bien maîtriser. Or,
mal utilisés, ces mécanismes ont un effet inverse en fragilisant la fiabilité
du code produit. Par ailleurs, même bien utilisés, la multiplication des
abstractions pend les programmes C++ peu lisibles et posent souvent des
problèmes de maintenabilité.

En conséquence, les normes C++ en matière de logiciel critique
(comme le MISRAC++#cite(<misra_cpp>))
sont très strictes et demandent de bien vérifier que l'usage des
fonctionnalités du C++ sont utilisées de manière à laisser le moins de doutes
possibles. En conséquence et comme pour le C, la fiabilité des programmes C++
va en partie dépendre de l'utilisation d'outils tiers.
  ],

  tests: [

#let boost_test = link(
  "https://www.boost.org/doc/libs/1_85_0/libs/test/doc/html/index.html",
  [Boost Test Library]
)
#let catch2 = link("https://github.com/catchorg/Catch2", "Catch2")

Certains des outils cités pour le C fonctionnent également pour le C++. C'est
le cas pour #cantata ou #parasoft par exemple. D'autres outils ou bibliothèques
ont été conçus spécifiquement pour le C++. La plus connue des bibliothèques C++,
#boost, propose également une bibliothèque facilitant l'écriture de tests. De base,
elle définit sensiblement les mêmes macros que beaucoup de bibilothèques
similaires mais avec quelques options de générations intéressantes sur
les rapports de test ou les possibilités de _fuzzing_. Le _mocking_ est
également disponible via une extension. #catch2 propose sensiblement la même
chose que #boost_test.

#let gtest = link("https://github.com/google/googletest", "Google Test")
#let google = link("https://about.google", "Google")

#let safetynet = link(
  "https://bitbucket.org/rajinder_yadav/safetynet/src/master/",
  "Safetynet"
)

#gtest est un cadre logiciel proposé par #google pour le test unitaire. Il est
très complet et utilisé pour de gros projets. Il permet de découvrir les
tests automatiquement, de les exécuter et de générer des rapports de tests
détaillés dans des formats personnalisables. Il est aussi extensible au fil
des besoins de l'utilisateur. #safetynet permet également de générer les tests
automatiquement à partir de classes décrivant les tests et à l'aide d'un
script
Ruby. L'outil semble cependant moins mature et complet que #gtest.

#let mockpp = link("https://mockpp.sourceforge.net/index-en.html", "Mockpp")

#mockpp est une bibliothèque de _mocking_ pour le C++. Elle s'utilise plutôt
conjointement avec d'autres outils de tests unitaires pour simuler des
comportements de fonctions ou de classes à la manière de #opmock.

#let testwell_ctc = link(
  "https://www.verifysoft.com/fr_ctcpp.html",
  "Testwell CTC++"
)

#testwell_ctc est un outil commercial qui, comme #cantata, #parasoft ou
#vectorcast que nous
avons déjà présenté dans la partie C, couvre différents types de tests
(unitaires, couverture) et est adapté aux usages de l'embarqué critique.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    [*Outil*],               [*Tests*], [*Generation*], [*Gestion*], [_*mocking*_],
    [*#boost_test*],         [U],       [+],            [✓],          [],
    [*#catch2*],             [U],       [+],            [✓],          [],
    [*#cantata*],            [UIRC],    [+++],          [✓],         [],
    [*#criterion*],          [U],       [+],            [],           [],
    [*#libcester*],          [U],       [+],            [✓],         [✓],
    [*#gtest*],              [U],       [++],           [✓],         [✓],
    [*#mockpp*],             [U],       [+],            [],          [✓],
    [*#opmock*],             [U],       [++],           [],           [✓],
    [*#parasoft*],           [UC],      [++],           [✓],         [],
    [*#safetynet*],          [U],       [++],           [✓],         [],
    [*#testwell_ctc*],       [UIC],     [++],           [✓],         [],
    [*#TPT*],                [UINC],   [+++],           [✓],         [],
    [*#vectorcast*],         [UC],      [++],           [✓],         [✓],
  ),
  caption: "Outils de tests pour le C++"
)
  ],

  compilation: [
#let cppbuilder = link(
  "https://www.embarcadero.com/products/cbuilder",
  "C++ Builder"
)

#let nvidia_hpc_sdk = link(
  "https://developer.nvidia.com/hpc-sdk",
  "NVIDIA HPC SDK"
)

#let oracle_cpp = link(
  "https://docs.oracle.com/cd/E37069_01/html/E37073/gkobs.html",
  "Oracle C++ Compiler"
)

#let ibm_xl = link(
  "https://www.ibm.com/products/c-and-c-plus-plus-compiler-family",
  "IBM XL C/C++"
)

#figure(
  table(
    columns: (auto, auto, auto),
    [*Compilateur*],                  [*Architectures*],                         [*Licence*],
    [*#aocc*],                        [AMD x86 (32 et 64 bits)],                 [Propriétaire, Gratuit],
    [*#cppbuilder*],                  [x86 (32 et 64 bits)],                     [Commercial],
    [*#clang*],                       [AArch64, ARMv7, IA-32, x86-64,  ppc64le], [Apache 2.0],
    [*#gcc*],                         [IA-32, x86_64, ARM, PowerPC, SPARC, ...], [GPLv3+],
    [*#icx (#intel C/C++ Compiler)*], [IA32, x86-64],                            [Propriétaire, Gratuit],
    [*#msvc*],                        [IA-32, x86_64, ARM],                      [Propriétaire],
    [*#nvidia_hpc_sdk*],              [x86-64, ARM],                             [Propriétaire],
    [*#oracle_cpp*],                  [SPARC, x86 (32 et 64 bits)],              [Propriétaire, Gratuit],
    // [*#ibm_xl*],                      [POWER & z, AIX, BlueGene/Q, z/OS, z/VM],  [Propriétaire],

  )
)

#let edgcpp = link("https://www.edg.com/c/features", "EDG C++ Front End")
#let open64 = link("https://sourceforge.net/projects/open64/", "Open64")

Le tableau ci-dessus présente les principaux compilateurs C++ de bout en bout
disponibles. Nous précisons de bout en bout car il existe des _front ends_ qui
ne s'occupent que de traduire le C++ en C (comme #edgcpp). Tous les compilateurs
ne sont pas listés ici car beaucoup d'entre eux ne sont plus maintenus ou sont
_a priori_ moins pertinents pour des projets critiques.

  ],

  debug: [
Les mêmes débuggeurs que pour le C sont utilisables pour le C++.
  ],

  metaprog: [
La méta programmation est un des aspects mis en avant dans le C++ à travers
l'utilisation des _templates_ et de la spécialisation qui peuvent être vus
comme un langage de macro de haut niveau. Celui-ci est suffisamment expressif
pour être Turing-complet
et permet de calculer virtuellement n'importe quoi qui ne dépende pas d'une
entrée dynamique. Cette façon de programmer est souvent utilisée pour
précalculer des données numériques (comme des tables trigonométriques) qui
pourront être utilisées
instantanément à l'exécution. Le cas d'école est celui de la factorielle :

```cpp
template<unsigned int N>
struct Fact
{
    enum {Value = N * Fact<N - 1>::Value};
};

template<>
struct Fact<0>
{
    enum {Value = 1};
};

unsigned int x = Fact<4>::Value;
```

Dans cet exemple, on définit un _template_ de structure `Fact` paramétré par un
entier `N`. Dans cette structure, on définit un type énuméré n'ayant qu'une
seule valeur `Value` à laquelle on attribue la valeur correspondant à
l'expression `N * Fact<N - 1>::Value`. Le compilateur en prend note mais ne
calcule rien car les _templates_ sont instanciés à l'usage. On définit également
une spécialisation _template_ `Fact` pour le cas où `N` vaut 0. Dans ce cas,
la valeur de `Value` est 1. Lorsque vient le moment d'instancier ce
_template_ avec la définition de la valeur `x` associée à `Fact<4>::Value`, le
compileur va dérouler la définition en utilisant le _template_ paramétré par
`N` avec `N = 4`, c'est à dire `4 * Fact<3>::Value` puis il va continuer à
dérouler `4 * (3 * Fact<2>::Value)` puis `4 * (3 * (2 * Fact<1>::Value))` puis
`4 * (3 * (2 * (1 * Fact<0>::Value)))`. À ce moment là, comme `N = 0`, c'est
la spécialisation `Fact<0>` qui est utilisée et donc `Fact<0>::Value = 1`. Cela
donne au final l'expression `4 * (3 * (2 * 1))`. Le compilateur sait simplifier
ce type d'expression statiquement et va la remplacer de lui même par 24 à la
compilation de sorte qu'à l'exécution aucun calcul ne sera nécessaire pour
calculer
la valeur de `x`.

Cette technique est un peu utilisée dans la bibliothèque standard mais est
très utilisée dans la bibliothèque #boost. Bien que la technique soit très
séduisante pour gagner un maximum de performance à l'éxécution, elle présente
plusieurs inconvénients :
- plus on l'utilise plus la compilation est longue puisqu'on demande au
  compilateur de calculer des choses qu'on aurait normalement calculé à
  l'exécution. Précalculer des tables trigonométriques peut prendre des
  heures, voire des jours...
- La moindre erreur dans le flôt d'instanciation déroule tout le flôt
  d'instanciation et les messages d'erreurs sont souvent incompréhensibles pour
  la plupart des développeurs.

La métaprogrammation en C++ s'accompagne donc un surcoût en temps
ou en puissance de calcul avec un risque significatif d'augmentation de la
dette technique.
  ],

  parsers: [

Les outils de _parsing_ cités pour le C fonctionnent également pour le C++
mais il en existe d'autres ciblant ce dernier.
Si l'on passe les outils non maintenus, insuffisamment documentés ou trop jeunes
pour être utilisés en production, on peut citer au titre des _lexers_ les
outils de la @cpp-lexers.

// lexers
#let astir = link("https://lexected.github.io/astir/#/?id=about", "Astir")

// lib
#let lexertl = link("http://www.benhanson.net/lexertl.html", "Lexertl")

#let reflex = link("https://github.com/Genivia/RE-flex", "RE/flex")

#figure(
  table(
    columns: (auto, auto, auto, auto),
    [*Nom*],      [*Code*], [*Plateforme*], [*License*],
    [*#astir*],   [Astir],  [Toutes],       [Libre, MIT],
    [*#reflex*],  [Flex],   [Lexer],        [Libre, BSD],
  ),
  caption: "Lexers pour le C++"
) <cpp-lexers>


// bof
#let btyacc = link("https://github.com/ChrisDodd/btyacc", "btyacc")
#let msta = link("https://github.com/cocom-org/msta", "MSTA")
#let styx = link("http://speculate.de/", "Styx")
#let lapg = link("https://lapg.sourceforge.net/", "Lapg")
#let kelbt = link("https://github.com/Distrotech/kelbt", "Kelbt")
#let tgs = link(
  "https://www.experasoft.com/en/products/tgs/",
  "Tunnel Grammar Studio"
)
#let myparser = link("https://github.com/hczhcz/myparser", "MyParser")
#let elkhound = link("https://github.com/WeiDUorg/elkhound", "Elkhound")

// ok
#let syntax = link("https://github.com/DmitrySoshnikov/syntax", "Syntax")
#let kdevelop_pg_qt = link(
  "https://github.com/KDE/kdevelop-pg-qt",
  "KDevelop PG-Qt"
)
#let spirit = link(
  "https://boost-spirit.com/home/",
  "Boost Spirit"
)
#let pegtl = link("https://github.com/taocpp/PEGTL", "PEGTL")
#let lug = link("https://github.com/jwtowner/lug", "Lug")

Au niveaux des _parsers_ plus généraux, beaucoup sont dynamiques : ils se
présentent sous la forme de bibliothèques dont l'API permet de décrire un
langage (et la manière de le parser) à l'exécution. Cette dynamicité peut être
un atout pour définir des grammaires évolutives mais dans la
pratiques, les _parsers_ à émission de code sont plus adaptés. Il y a toutefois
des exceptions avec les bibliothèques utilisant la méta-programmation (comme
#spirit ou #pegtl) pour engendrer le gros du _parsing_ à la compilation.

Les _parsers_ cités pour le C fonctionnent pour le C++
et les classiques #bison et #antlr sont bien suffisants dans la plupart des
cas.
  ],

  derivation: [

La dérivation de code en C++ repose sur la méta-programmation autorisée par
les _templates_ et la spécialisation. Cependant, comme le langage n'est pas
réflexif, on ne peut pas dériver directement du code à partir des définitions.
Toutefois, le système des _traits_ (des _templates_ dirigés sur les propriétés
sur les types) permet de construire des dérivations par spécialisation.
  ],

  packages: [
En plus des gestionnaires de paquets #conan et #vcpkg qui supportent les
paquets écrits en C++, il y a également #buckaroo qui est dédié au C++.

#figure(
  table(
   columns: (auto, auto, auto, auto),
    [*Gestionnaire*],               [*#buckaroo*],           [*#conan*], [*#vcpkg*],
    [*Plateformes*],                [Linux, Windows, MacOS], [Toutes],   [Linux, Windows, MacOS],
    [*Format*],                     [ToML],                  [Python],   [JSON],
    [*Résolution des dépendances*], [✓],                     [✓],       [✓],
    [*Cache binaire*],              [✓],                     [✓],       [✓],
    [*Nombre de paquets*],          [~350],                  [~1750],    [~2500],
  )
)

  ],

  communaute: [

Le C++ est un des langages les plus populaires et les plus utilisés depuis plus
de 20 ans et ce, dans tous les domaines de l'informatique. Toutefois, le
langage est maintenant en concurrence directe avec Rust qui intègre la plupart
de ses
qualités intrinsèques ou méthodologiques. Il est donc probable qu'une partie
de la communauté C++ se déplace vers la communauté Rust avec le temps.
  ],

  assurances: [

Comme pour le C, le cas du C++ est paradoxal. En effet, le langage porte en
lui-même des éléments permettant d'assurer des contraintes très fortes de
typage ou certains invariants à l'aide des _templates_ et les spécificateurs
d'accès. Toutefois, l'ensemble est si complexe à maîtriser qu'il peut induire
des surcoûts dans toutes les étapes du cycle de vie du logiciel :
- au développement : une équipe hétérogène d'ingénieur peut mettre plus de temps
  à concevoir et débugger le logiciel tandis qu'une équipe de spécialistes
  diminuera le temps de développement mais coutera plus cher.
- à la vérification : la vérification du C++ est plus complexe que celle du C et
  toutes les constructions C++ ne sont pas supportées par les outils de
  vérification.
- à la maintenance : le code étant plus complexe, il est plus difficile à
  maintenir et à faire évoluer.

En conséquence, lorsque le C++ est utilisé dans des domaines ou l'un de ces
critèques est déterminant, il est nécessaire d'utiliser conjointement un outil
de vérification de règles de codage pour s'assurer des bonnes pratiques (en plus
d'une batterie de test importante).
  ],

  adherence: [
Comme pour le C, le C++ peut fonctionner sur un système nu et sans bibliothèque
standard.

  ],

  interfacage: [
Le C++ peut utiliser du C nativement. Pour utiliser du C++ en C, il suffit
d'indiquer que les fonctions à exporter sont `extern "C"` de sorte que le
compilateur en donne une version compatible avec le C.

Dès lors que l'interopérabilité avec le C est complète, celle-ci, par
transitivité, l'est aussi avec tout langage s'interfaçant avec le C,
c'est-à-dire la plupart des langages.
  ],

  critique: [
Comme le C, le C++ est utilisé dans tous les domaines critiques.
  ]
)