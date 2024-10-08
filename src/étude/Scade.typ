#import "defs.typ": *
#import "links.typ": *


#language(
  name: "SCADE",

  introduction: [
    #Scade (_Safety Critical Application Development Environment_) est un
    langage
    de programmation et un environnement de développement dédiés à
    l'embarqué critique. Le langage est né au milieu des années 90 d'une
    collaboration entre le laboratoire de recherche VERIMAG à Grenoble et
    l'éditeur de logiciels VERILOG.
    Depuis 2000, le langage est développé par l'entreprise
    ANSYS/Esterel-Technologies.

    À l'origine le langage #Scade était essentiellement une extension du langage
    Lustre v3 avant d'en diverger à partir de la version 6.

    Grâce à l'expressivité réduite du langage, le compilateur KCG de #Scade est
    capable de vérifier des propriétés plus fortes que le compilateur d'un
    langage généraliste.

  ],

  paradigme: [
    #Scade est un langage _data flow_ #paradigme[déclaratif] et
    #paradigme[synchrone].

    Contrairement à la plus part des langages généralistes dont la brique
    élémentaire de donnée est l'entier, #Scade manipule des _séquences_ (ou
    signaux)
    potentiellement infinies indexées par un temps discret. Ces séquences sont
    une modélisation des entrées analogiques.

    Un programme #Scade est constitué de noeuds (`node` dans le langage)
    et chaque noeud définit un système d'équations entre les entrées et les
    sorties du noeud. Par exemple, considérons le programme suivant en _Lustre_:

    ```lustre
    node mod_count (m : int) returns (out : int);
    let
      out = (0 -> (pre out + 1)) mod m;
    tel
    ```

    où `0 -> (pre out + 1)` indique qu'à l'instant 0, le signal vaut 0 mais
    que pour les instants suivants, le signal vaudra `pre out + 1`. `pre` est un
    opérateur qui récupère la valeur du paramètre à l'instant précédent.

    Par exemple si $m$ est la séquence constante 4, on obtient :

    #align(
      center,
      table(
        columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
        [Temps],                        [$t_0$], [$t_1$], [$t_2$], [$t_3$], [$t_4$], [$t_5$], [$t_6$], [$t_7$],
        [$m$],                          [4],     [4],     [4],     [4],     [4],     [4],     [4],     [4],
        [`pre out`],                    [ ],     [0],     [1],     [2],     [3],     [0],     [1],     [2],
        [`pre out + 1`],                [ ],     [1],     [2],     [3],     [4],     [1],     [2],     [3],
        [`0 -> (pre out + 1)`],         [0],     [1],     [2],     [3],     [4],     [1],     [2],     [3],
        [`(0 -> (pre out + 1)) mod m`], [0],     [1],     [2],     [3],     [0],     [1],     [2],     [3],
        [`out`],                        [0],     [1],     [2],     [3],     [0],     [1],     [2],     [3],
      )
    )

  ],

  runtime: [

    Il ne semble pas y avoir d'analyseur statique autre que ceux présents dans
    la suite #Scade. Celle-ci fait déjà un certain nombre d'analyse permettant
    d'éviter les débordements de tampons ou les boucles causales. Par ailleurs,
    il n'y a pas de manipulation de pointeurs donc les erreurs dessus ne sont
    pas non plus possibles.

    Toutefois, le code généré peut être passé aux analyseurs C & #Ada pour
    éventuellement trouver les erreurs qui seraient passées au travers de
    l'analyse de la suite logicielle.
  ],

  formel: [
    Le langage Lustre a fait l'objet d'une formalisation en
    #coq#cite(<lustrecoq>) mais, à notre connaissance, il
    n'existe pas d'outil de formalisation pour #Scade. Cependant, il est
    possible de formaliser des propriétés sur les programmes #Scade en utilisant
    des noeuds de vérification pour faire du _model checking_. Si ces noeuds
    sont toujours vrais pour toutes
    les entrées possibles, alors le programme est formellement valide
    _a posteriori_.
  ],

  wcet: [
    L'estimation du WCET d'un programme #Scade est cruciale pour s'assurer
    qu'il pourra s'exécuter en temps réel: on doit garantir que chaque pas
    d'exécution avant le _quantum_ de temps autorisé.

    La suite #Scade intègre l'outil #aiT#cite(<aitscade>). Cet outil permet
    l'estimation et l'optimisation du WCET lors de la
    modélisation#cite(<aitwcetscade>).

  ],


  assurances: [
    La suite #Scade offre un très bon niveau de fiabilité du à la simplicité
    du langage _data flow_ sous-jacent et des analyses effectuées par la suite.
    Par ailleurs, le compilateur KCG est certifié pour les normes du
    domaine critique.
  ],

  numerique: [
    Il ne semble pas y avoir d'analyse statique pour les erreurs numériques.
  ],

  pile: [
    La suite #Scade intègre l'outil
    #stackanalyser#cite(<stackanalyzerscade>)#cite(<aitwcetscade>). Il est aussi
    possible d'utiliser les outils travaillant directement sur le binaire
    produit par la compilation du code C ou #Ada engendré par #Scade.

  ],

  intrinseque: [
    #Scade est statiquement et fortement typé; ce qui assure déjà une
    certaine fiabilité. En plus du typage, la suite réalise d'autres analyses
    qui vérifient :
    - que le programme ne contient pas d'accès à un tableau en dehors de ses bornes;
    - qu'il n'y a pas de boucle causale : l'équation  `a = pre a` n'est pas
      possible, il faut introduire un délai (via `->`) ;
    - le programme peut être exécuté avec une quantité de mémoire bornée et
      connue,
    - le programme est déterministe au sens où sa sortie ne dépend pas d'une
  ],

  interfacage: [
    #Scade permet d'importer du code (C ou #Ada) via le mot clé `imported`
    comme par exemple:
    ```scade
    function imported f (i1: int32; i2: bool) returns (o1: bool; o2: int32);
    ```
    mais il faut faire attention à conserver les invariants requis. Dans
    l'exemple précécent, il faut s'assurer que les sorties ne dépendent que des
    entrées sous peine de probablement casser les propriétés de sûreté du
    programme.

    Le code engendré par #Scade peut être utilisé dans un programme C ou #Ada.
  ],

  compilation: [

    #Scade utilise le compilateur KCG qui est techniquement un transpileur,
    c'est-à-dire un traducteur d'un langage de programmation (ici #Scade) vers
    un langage de même niveau (ici le C ou #Ada).

    À notre connaissance, KCG est l'unique compilateur disponible pour
    le langage #Scade. Il est disponible sur Windows en 32 et 64 bits.
    Il est par ailleurs certifié pour les normes suivantes:
    - DO-178B DAL A,
    - DO-178C DAL A,
    - DO-330,
    - IEC 61508 jusqu'à SIL 3,
    - EN 50128 jusqu'à SIL 3/4,
    - ISO 26262 jusqu'à ASIL D.

  ],

  debug: [
    Le débug d'un programme synchrone est un peu particulier car on s'intéresse
    pas ou très peu au contrôle de flôt étant donné que celui-ci est très
    limité dans un langage _data flow_. En revanche, ces derniers sont
    beaucoup plus intéressants et déboguer un programme _data flow_ consiste
    simplement à :
    - afficher les flux (leur valeur aux cours du temps);
    - pouvoir jouer avec les entrées pour voir comment les sorties réagissent;
    - éventuellemnt ajouter des noeuds de contrôle (des _watch dogs_)
      permettant de contrôler des propriétés au cours du temps.
    La suite #Scade permet tout cela en plus de visualiser graphiquement les
    noeuds et leur dépendances.
  ],

  parsers: [
    Le langage n'est pas adapté à l'analyse syntaxique car celle-ci suppose que
    un traitement dynamique avec une consommation mémoire arbitraire; ce qui
    va à l'encontre des limites imposées par le langage. On peut
    tout à fait écrire des parser à mémoire bornée en #Scade pour analyser des
    flux syntaxiques particuliers (comme des flux protocolaires) mais, à notre
    connaissance, il n'existe pas de générateur de parseur pour #Scade.
  ],

  metaprog: [
    Le langage n'offre pas de support pour la métaprogrammation.
  ],

  derivation: [
    Le langage n'offre pas de support pour la dérivation de programme.
  ],

  tests: [
    Les langages _data flow_ se prettent facilement aux tests puisque qu'il
    est facile de créer des noeuds qui testent d'autres noeuds ou de faire
    varier les entrées pour vérifier les sorties. Ce travail est tout aussi
    facilement automatisable à l'aide des indications de type. Aussi, la
    #Scade supporte la génération automatique de tests sur plusieurs
    aspects (unitaires, intégration, couverture) et propose également un cadre
    de gestion des tests et la génération de rapport à l'intention des processus
    de certification/qualification.
  ],

  packages: [
    Aucun gestionnaire de paquet n'est indiquée pour #Scade.
  ],

  communaute: [
    La communauté #Scade semble restreinte aux utilisateurs de la suite,
    notamment les grands comptes de l'avionique,
    et à la communauté de chercheurs en lien avec le langage Lustre.
  ],

  adherence: [
    Un programme #Scade se compile vers du C (ou #Ada) et peut donc fonctionner
    du matériel nu.

  ],

  critique: [
    Du fait des certifications proposées par le compilateur _KCG_, le langage
    #Scade
    est beaucoup utilisé dans l'aviation civile et militaire. On peut citer
    notamment:
    - les commandes de vol des Airbus,
    - le projet openETCS visant à unifier des systèmes de signalisation
      ferroviaires en Europe,
    - dans l'automobile.

  ]
)

