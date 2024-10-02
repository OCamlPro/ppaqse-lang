#import "defs.typ": *
#import "links.typ": *

= Mesures statiques

== WCET

Le calcul du WCET est important sur les systèmes temps réel pour garantir
que les tâches critiques se terminent dans un temps donné. Le WCET est le
temps maximal que peut prendre une tâche pour se terminer. Il est calculé
en fonction des temps d'exécution des instructions, des branchements et des
accès mémoire.

Il existe deux méthodes pour calculer le WCET : la méthode _dynamique_ et
la méthode _statique_. La méthode dynamique consiste à exécuter le programme
dans l'environnement cible et à mesurer le temps d'exécution un nombre de fois
jugé suffisant pour établir un WCET statistique. Cette
méthode est fiable mais coûteuse en temps et en ressources.

La méthode statique consiste à analyser le programme sans l'exécuter et à
déduire le WCET à partir de cette analyse. Le problème de cette méthode est
qu'il est difficile de calculer un WCET précis du fait des optimisations
réalisées par le compilateur et de la complexité des architectures modernes.
La prédiction de branchement ou l'utilisation des caches peut faire varier le
le temps d'exécution de manière importante et rendre le WCET difficile à
calculer sans le majorer excessivement.

== Analyse de la pile

L'analyse de la pile consiste à calculer la taille maximale de la pile
utilisée par un programme. La plupart du temps, cette analyse se fait
directement sur le binaire car le langage source ne contient pas forcémement
les informations adéquates pour réaliser cette analyse puisqu'elles sont
ajoutées durant la compilation.

Connaître la taille maximale de la pile utilisée est important pour dimensionner
et optimiser les systèmes embarqués qui peuvent être très contraints en mémoire.
Cela permet d'éviter les dépassements de pile (_stack overflow_) qui sont des
erreurs fatales.

L'analyse de la pile peut n'est pas décidable lorsque le programme utilise
des pointeurs de fonctions car il n'est pas forcément possible de déterminer
la suite d'appels de fonctions à l'avance. Dans ce cas, l'analyse de la pile
peut demander à annoter le code source pour avoir plus d'informations.