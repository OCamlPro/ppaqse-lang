#import "defs.typ": *
#import "links.typ": *

#language(
  name: [OCaml],
  introduction: [
    Le langage #ocaml est issu de la famille des langage ML via différentes
    implémentations (Caml, Caml light) et première version officielle en 1996.
    Le langage connait une popularité croissante dans les milieux académiques
    car il est particulièrement adapté à l'enseignement de l'algorithmique et
    de la compilation.

    Le langage se prette tellement bien à l'exercice qu'il est souvent utilisé,
    y compris dans les sociétés privées, pour développer des outils d'analyse
    ou des compilateurs pour d'autres langages. Pour des applications en
    production, le langage reste toutefois peu utilisé et son utilisation la plus
    notoire à l'heure actuelle est celle de #janestreet pour réaliser du
    _trading_ haute fréquence.

    Comme les garanties du langage suffisent généralement à son usage, il n'y a
    pas eu de développements majeurs sur des outils d'analyse statique dessus :
    le langage étant principalement utilisé pour écrire ces analyseurs pour
    d'autres langages.

  ],
  paradigme: [
    OCaml est un langage de programmation multiparadigme. Il est conçu comme
    étant avant tout un langage #paradigme[fonctionnel] mais il est dit _impur_
    dans le sens où la mutabilité est autorisée. Cette dernière et les
    boucles (`while`, `for`) en font tout aussi bien un langage
    #paradigme[impératif] dans lequel on peut
    très bien programmer de manière
    procédurale.

    Le O de OCaml signifie _Objective_ et fait référence au
    fait que le langage est également #paradigme[objet]. Ce trait est toutefois
    relativement peu usité en pratique.

  ],
  runtime: [
    Il n'y a pas d'outils tiers pour analyser statiquement le code OCaml et
    se prémunir contre les erreurs à _runtime_. Cela s'explique par le fait que
    le langage est justement conçu pour les éviter dans une large mesure au
    travers un système de typage très puissant et un ramasse-miettes à l'état
    de l'art.

    Le langage n'expose à l'utilisateur qu'une notion de _valeur_ qui
    n'autorise pas la manipulation manuelle des pointeurs. Ceux-ci sont gérés
    automatiquement à la compilation et par le ramasse miettes. Cela permet
    de se prémunir contre toutes les erreurs de gestion de la mémoire.

    Les valeurs sont alignées systématiquement sur la taille d'un mot mémoire
    et les valeurs numériques sont encodées sur 31 ou 63 bits suivant les
    architectures (respectivement 32 ou 64 bits). Le bit manquant sert au
    ramasse miettes. Cette représentation uniforme diminue les occurences
    de dépassement de capacité puisqu'on ne peut pas manipuler des entiers
    plus petits qui seraient mal dimensionnés mais l'erreur est toujours
    possible.

    Il y a eu des initiatives pour ajouter plus d'analyse statique, notamment
    sur les exceptions, mais aucune n'a donné d'outil mature indépendant ou
    intégré au
    compilateur.
  ],

  wcet: [
    Il n'y a pas d'analyseur statique de WCET ciblant spécifiquement #OCaml.
    Les outils utilisés pour le C peuvent probablement être utilisés
    sur les programmes #OCaml compilé nativement mais il n'est pas garanti que
    les résultats soient pertinents.

    Il est aussi possible de ne pas utiliser le code natif et de faire
    l'analyse sur le _byte code_ #OCaml#cite(<ocaml-wcet>) en simplifiant le
    langage pour le ramener à du Lustre à la manière de #Scade.
  ],

  pile:[
    Il n'y a pas d'analyseur statique de pile ciblant spécifiquement #OCaml.
    Les outils utilisés pour le C peuvent cependant être utilisés sur les
    programmes #OCaml compilés nativement.
  ],

  numerique: [
    Il n'y a pas d'analyseur statique pour les calculs numériques des
    programmes OCaml. Toutefois, les bilbiothèques #mpfr et #gmp ont été
    portées en #ocaml.
  ],
  formel: [

    Le moyen le plus simple de faire de la programmation formelle avec #ocaml
    est d'utiliser #coq. Ce dernier, implémenté en #ocaml, permet d'implémenter
    et prouver des programmes qui peuvent être ensuite extraits vers #ocaml.
    C'est la stratégie utilisée pour implémenter le compilateur #compcert.

    Notons qu'il existe une initiative pour permettre de prouver des
    programmes #ocaml dans le texte en utilisant la même stratégie que
    #framac: #cameleer. Cependant, le projet est encore en cours de
    développement et
    n'a pas encore atteint un niveau de maturité suffisant pour être utilisé
    en production.
  ],
  intrinseque:[
    Les deux principaux atouts d'OCaml est son système de type riche avec
    inférence et son ramasse-miettes. Les deux permettent de se prémunir
    contre un large éventail d'erreurs de programmation sans perdre en
    expressivité.

    Son système de type permet notamment de définir des types algébriques
    (ou variants) qui permettent de définir un type par une somme de valeurs
    possibles, elles-mêmes pouvant être valuées. Cela permet d'encoder
    le _pattern_ des unions à discriminant du C de manière synthétique mais
    également avec des vérifications beaucoup plus poussées par le compilateur.

    Typiquement, l'exemple suivant:
    ```ocaml
    type state = A | B of int | C of string list

    let f s =
      match s with
      | A -> 0
      | B i -> i
      | C (h :: t) -> String.length h + List.length t
    ```
    ne sera pas accepté par le compilateur qui signalera une erreur
    de _pattern matching_ incomplet. En effet, le cas où la liste donnée en
    argument au constructeur `C` est vide n'est pas traité.

    Cette programmation par cas est extrèmement courante dans la programmation
    en général et pouvoir identifier les cas non traités facilement à la
    compilation est une des forces du langage. Ce mécanisme est hérité de la
    famille des langages ML et a été reprit dans les langages plus récents
    (Swift, #Rust, ...) pour les mêmes raisons.

    Le ramasse-miettes, quant à lui, permet de se prémunir contre les fuites
    mémoires et les erreurs de gestion de la mémoire. Il est particulièrement
    efficace pour les programmes #ocaml car il utilise un système a double
    tas : un mineur et un majeur. Les valeurs sont allouées dans le tas mineur
    et sont déplacées dans le tas majeur si leur durée de vie dépasse un certain
    seuil. Comme la plupart des valeurs allouées ont une durée de vie très
    faible, elles ne vont généralement pas plus loin et comme
    les allocations dans le tas mineur sont très efficaces (cela revient à
    globalement incrémenter un compteur), celui-ci se comporte à peu près comme
    la pile et bénéficie des effets de cache.
  ],
  tests: [

    Il existe globalement trois façons de tester un programme OCaml : par des
    cadres logiciels de test à la manière de ce qui existe en C/C++, par
    des préprocesseurs et par l'outil `dune`.

    Les cadres logiciels indiqués dans la #ref(<ocaml-test-framework>) se
    présentent comme des bibliothèques à utiliser pour définir un programme de
    test. #alcotest fut l'un des premiers à être populaire; il offre une sortie lisible mais non standard et convient pour des petits
    projets. #ounit est une adapation pour #ocaml de JUnit initialement développé pour Java et qui a été adapté pour plusieurs autres langages.
    L'avantage de cette bibliothèque est qu'elle engendre des sorties au format JUnit permettant à des outils tiers de travailler sur les résultats de test.

    #qcheck donne également des primitives de test à la manière des
    bibliothèques précédentes mais incorpore également un générateur de
    valeur pour les types de données utilisés, ce qui permet de faire du
    test automatisé par _fuzzing_. Par ailleurs, #qcheck est compatible
    avec #ounit pour éventuellement obtenir des rapports au format JUnit.
    #crowbar utilise également le _fuzzing_ via l'outil `afl-fuzz`.

    #figure(
      table(
        columns: (auto, auto, auto, auto, auto),
        [*Outil*],     [*Tests*], [*Generation*], [*Gestion*], [_*mocking*_],
        [*#alcotest*], [U],       [+],            [],          [],
        [*#ounit*],    [U],       [+],            [+],         [],
        [*#qcheck*],   [U],       [+++],          [],          [],
        [*#crowbar*],  [U],       [+++],          [],          [],
      ),
      caption: [Cadres de test #ocaml],
    ) <ocaml-test-framework>

    #ocaml fait partie des langages ayant une phase de _preprocessing_
    éditable via des PPX. Ces PPX permettent de transformer l'AST du programme
    source pour y ajouter automatiquement des bouts de programmes supplémentaires _a priori_ déduits de l'AST précédent. Il existe notamment
    deux PPX qui sont souvent utilisés : #ppx_inline_test et #ppx_expect.
    Le premier permet de créer des tests à la volée et le second permet de comparer des sorties :

    ```ocaml
    let#test _ = 3 <> 4

    let#expect "addition" =
      Printf.printf "%d" (1 + 2);
      [%expect {| 3 |}]
    ```

    Dans le premier cas, le test se fait directement alors que dans le second,
    le test effectue un calcul et l'affiche sur la sortie standard qui est
    capturée et comparée avec le contenu de l'extension `[%expect ...]`.

    Enfin, les Cram tests de Python sont également disponibles dans `OCaml`
    via l'outil `dune` qui peut interpréter directement un fichier au format
    Cram pour effectuer les tests:

    ```cram
    Ceci est un test
      $ echo "Hello world!"
      Hello world!
    ```

    Ce format est plus adaptés aux tests de plus haut niveau (fonctionnels,
    validation) où l'on va tester le comportement du binaire produit
    par rapport à une sortie attendue (les lignes
    indentées sans `$`).

  ],

  compilation: [
    Le compilateur fourni par l'INRIA est le seul compilateur officiel du
    langage #ocaml.

    Il existe des _forks_ maintenus en interne par certains industriels mais ils
    ne font pas référence.

  ],

  debug: [
    #ocaml est fourni avec un debuggeur par défaut : `ocamldebug` qui se
    comporte peu ou prou comme #gdb pour un programme #ocaml.
  ],

  metaprog: [
    La métaprogrammation en #ocaml passe essentiellement par le système des PPX
    qui permettent d'engendrer du code spécifique à l'aide des extensions
    (`[%... ...]`). Les PPX peuvent offrir des fonctionnalités très utiles en
    production comme de
    outils d'inspection pour la plupart des types de données, la possibilité
    d'écrire du SQL (typé) dans le code #ocaml ou encore d'extraire des
    métadonnées pour la documentation.

    Le typage #ocaml est également suffisamment expressif pour décrire des
    propriétés statiques sur le code permettant une forme limitée de
    programmation par spécialisation. Ainsi, il est possible d'encoder
    les entiers naturels dans le système de type et donc de faire du code
    spécificique pour des listes de longueur 4.
  ],

  parsers: [

    #ocaml étant historiquement utilisé pour écrire des compilateurs, il dispose
    d'outils d'analyse lexicale et syntaxique complets. Un générateur de _lexer_ (`ocamllex`) et un générateur de _parser_ (`ocamlyacc`) sont même
    fournis par défaut avec #ocaml. Ceux-ci fonctionnent très bien mais sont
    un peu limités et d'autres outils plus complets sont venus compléter l'offre.

    Au niveau des _lexers_, on citera #sedlex et #ulex qui permettent l'analyse
    de l'unicode. Par ailleurs, #sedlex s'intègre facilement avec les
    _parsers_ existant.


    #figure(
      table(
        columns: (auto, auto, auto, auto),
        [*Nom*],      [*Code*], [*Plateforme*], [*License*],
        [*ocamllex*], [Lex],    [POSIX],       [Libre, LGPL],
        [*#dypgen*],  [EBNF],   [POSIX],       [Libre, CeCILL-B],
        [*#sedlex*],  [OCaml],  [POSIX],       [Libre, MIT],
        [*#ulex*],    [OCaml],  [POSIX],       [Libre, MIT],
      ),
      caption: [_Lexers_ #ocaml],
    )

    #let angstrom = link(
      "https://github.com/inhabitedtype/angstrom",
      "angstrom"
    )
    #let mparser = link("https://github.com/murmour/mparser", "mparser")

    Au niveau des _parsers_, en plus d'`ocamlyacc`, il y a des
    bibliothèques de combinateurs de _parser_ avec #angstrom et #mparser qui
    sont utiles dans le _parsing_ dynamique de petites grammaires. Pour les
    grammaires plus conséquentes, #dypgen ou #menhir sont des outils plus adaptés. #menhir est probablement le générateur de _parser_ le plus abouti
    et est la référence actuelle dans le monde #ocaml. Celui-ci permet en plus
    d'engendrer la preuve de correction (en Coq) du _parser_ engendré.

    #figure(
      table(
        columns: (auto, auto, auto, auto),
        [*Nom*],       [*Code*], [*Plateforme*], [*License*],
        [*ocamlyacc*], [Yacc],   [POSIX],        [Libre, LGPL],
        [*#angstrom*], [OCaml],  [POSIX],        [Libre, BSD],
        [*#dypgen*],   [EBNF],   [POSIX],        [Libre, CeCILL-B],
        [*#menhir*],   [Yacc],   [POSIX],        [Libre, GPL],
        [*#mparser*],  [OCaml],  [POSIX],        [Libre, LGPL],
      ),
      caption: [_Parsers_ #ocaml],
    )

    Il existe également un autre outil historiquement utilisé pour préprocesser
    #ocaml mais qui peut servir à définir des langages à part entière : #camlp5.

  ],

  derivation: [
    Comme pour la métaprogrammation, la dérivation se fait en utilisant les PPX
    et les annotations. L'usage classique (mais non limité à cela) consiste à
    annoter une définition de type pour indiquer au PPX une dérivation à
    effectuer. Typiquement :

    ```ocaml
    type foo = {
      bar : int;
      baz : string list;
    }[@@deriving yojson]
    ```

    engendrera automatiquement les fonctions de conversion `foo_to_yojson` et
    `foo_of_yojson` pour traduire une valeur de type `foo` en une valeur JSON
    et reciproquement.


  ],

  packages: [
    Plusieurs tentatives de gestionnaires de paquet ont vu le jour mais celle
    qui s'est imposé de fait et qui est devenu la référence non seulement pour
    #ocaml mais aussi pour #coq est #opam.
    Celui-ci est stable et contient environ 4800 paquets logiciels. Il permet
    de créer des environnements de _build_ propres (des _switchs_) et de
    contrôler (ou pas) les versions de manière assez fine pour de la production
    industrielle.
  ],

  communaute: [
    #let tarides = link("https://tarides.com/", "Tarides")
    #let ocamlpro = link("https://ocamlpro.com/", "OCamlPro")
    #let lexifi = link("https://www.lexifi.com/#", "Lexifi")
    #let meta = link("https://www.meta.com", "Meta")

    La taille de la communauté #ocaml n'est pas connue. Elle est manifestement
    plus petite que la plupart des langages _mainstream_ mais la diffusion
    académique semble avoir engendré une diaspora solide de pratiquants et un
    noyau dur d'entreprises utilisant #ocaml. Parmi celles-ci on distingue les
    entreprises dont #ocaml est le coeur technologique (#janestreet, #ocamlpro,
    #tarides, #lexifi, ...) et celles qui l'utilisent dans leur équipes de R&D
    pour construire de l'outillage (#microsoft, #meta, #intel, ...).
  ],

  assurances: [
    L'utilisation d'#ocaml permet de se prémunir naturellement contre un
    certains nombre d'erreurs à _runtime_ : tous ce qui découle des erreurs
    de typage et de la gestion des pointeurs. Dans un développement standard,
    ces erreurs étant les plus coûteuses, un développement #ocaml assure un
    gain en fiabilité et en coût par son usage même.

    La possibilité d'utiliser #coq au dessus #ocaml permet de gagner encore plus
    en fiabilité et d'adresser des normes très exigentes comme les Critères
    Communs aux niveaux d'assurance les plus élevés (EAL6+).

    Pour des niveaux d'assurances élevés en sûreté, il manque quelques analyses:
    - le WCET statique, quitte à restreindre le langage;
    - l'échappement des exceptions;
    - les allocations bornées pour majorer le temps utilisé par le
      ramasse miettes;
    - récursion bornée.
    Ces analyses, couplées avec un outil comme #cameleer permettraient de
    circonvenir aux besoins d'une utilisation dans le domaine critique.
  ],

  adherence: [
    #ocaml a besoin d'un système POSIX pour fonctionner en natif mais en
    _bytecode_, il suffit de porter la machine virtuelle #ocaml (écrite en C)
    pour qu'il fonctionne sur n'importe quelle plateforme.
  ],

  interfacage: [
    #ocaml a plusieurs moyens de s'interfacer avec le C (et donc avec tous les
    langages compatibles avec le C):
    - la FFI pour le _link_ statique;
    - `Ctypes` pour le _link_ dynamique.

    #let camlidl = link("https://github.com/xavierleroy/camlidl", "camlidl")

    La FFI d'#ocaml est bien documentée et, modulo quelques subtilités sur
    la bonne entente avec le ramasse-miettes et les _threads_, s'utilise
    raisonnablement facilement pour intégrer du code C dans #ocaml et
    l'export d'une fonction #ocaml vers C se fait sur une simple déclaration.
    Il existe par ailleurs un outil #camlidl pour engendrer le code de
    conversion automatiquement à partir de fichiers `.h` annotés.

    `Ctypes` est une biblothèque #ocaml qui permet d'encoder les types C dans
    #ocaml et d'engendrer automatiquement les bons appels à partir des types
    déclarés. Bien qu'utiliser `Ctypes` ne soit pas compliqué, il existe
    des outils pour dériver automatiquement les déclarations soit par PPX
    soit intégré dans le système de _build_ `dune`.

  ],

  critique: [
    L'utilisation de MirageOS, un unikernel écrit en #ocaml est pressenti comme
    étant une technologie utilisable dans le spatial mais aucune utilisation
    avérée n'a été recensée jusqu'à présent.
  ]



)


