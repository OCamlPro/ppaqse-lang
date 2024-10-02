#import "defs.typ": *
#import "links.typ": *

= Concurrence

L'utilisation du calcul parallèle au sein d'un même programme se fait
généralement par l'utilisation des _threads_ fournis par le système
d'exploitation sous-jacent. Les threads permettent de lancer plusieurs
fonctions en parallèle en exploitant éventuellement la multiplicité des coeurs
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
comme étant le bon ordonnancement des _threads_. Or, cet ordonnancement n'est
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