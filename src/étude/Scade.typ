#import "defs.typ": *
#import "links.typ": *


#language(
  name: "SCADE",

  introduction: [
_SCADE_ (_Safety Critical Application Development Environment_) est un langage
de programmation et un environnement de développement dédiés à l'embarqué critique. Le langage est né au milieu des années 90 d'une collaboration entre le laboratoire de recherche _VERIMAG_ à Grenoble et l'éditeur de logiciels _VERILOG_.
Depuis 2000, le langage est développé par l'entreprise _ANSYS/Esterel-Technologies_.

À l'origine le langage _SCADE_ était essentiellement une extension du langage
_LUSTRE V3_ avant d'en diverger à partir de la version 6.

Grâce à une expressivité réduite du langage, le compilateur _KCG_ de _SCADE_ est
capable de vérifier des propriétés plus forte qu'un compilateur d'un langage de
programmation généraliste.

  ],

  paradigme: [
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

  ],

  runtime: [

Le logiciel _Ansys SCADE suite_ est capable de détecter les erreurs suivantes:
- les débordements de tampons,
- le code mort.

  ],

  wcet: [
L'estimation du WCET d'un programme _SCADE_ est cruciale pour s'assurer qu'il pourra s'exécuter de façon synchrone: on doit garantir que le programme terminera avant le prochain événement, sans quoi celui-ci pourrait être ignoré.

_Ansys SCADE Suite_ intègre l'outil _timing analyzer_
développé par _aiT_ #cite(<aitscade>). Cet outil permet
l'estimation et l'optimisation du WCET lors de la modélisation, voir le tool paper #cite(<aitwcetscade>).

  ],

  pile: [
_Ansys SCADE Suite_ intègre l'outil _StackAnalyzer_ développé par _aiT_ #cite(<stackanalyzerscade>). Son fonctionnement est également décrit dans le tool paper #cite(<aitwcetscade>).

  ],

  intrinseque: [
Le langage SCADE est statiquement typé et fortement typé. En plus des propriétés
habituellement garanties par un _typechecker_, le compilateur _KCG_ garantie
des propriétés très fortes sur les programmes qu'il produit. Il garantie notamment que:
- le programme ne contient pas d'accès à un tableau en dehors de ses bornes,
- le programme peut être exécuté de façon synchrone,
- le programme peut être exécuté avec une quantité de mémoire bornée et connue,
- le programme est déterministe au sens où sa sortie ne dépend pas d'une valeur indéfinie.

  ],

  compilation: [

Le compilateur _KCG_ est techniquement un transpileur, c'est-à-dire un traducteur
d'un langage de programmation (ici _SCADE_) vers un langage de même niveau (ici le
langage C ou Ada).


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

  ],

  adherence: [
Le langage SCADE est généralement compilé vers du C ou de l'Ada.

  ],

  critique: [
Du fait des certifications proposées par le compilateur _KCG_, le langage _SCADE_
est beaucoup utilisé dans l'aviation civile et militaire. On peut citer notamment:
- les commandes de vol des Airbus,
- le projet openETCS visant à unifier des systèmes de signalisation ferroviaires en Europe,
-

  ]
)

