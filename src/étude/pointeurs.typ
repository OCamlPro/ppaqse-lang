#import "defs.typ": *
#import "links.typ": *

= Pointeurs & Mémoire

== Gestion des pointeurs

Les pointeurs sont des valeurs représentant l'adresse en mémoire d'une autre
valeur. Ils sont couramment utilisés pour passer des valeurs par référence, et
par conséquent, éviter de copier ces valeurs à chaque fois qu'on les utilise
dans le flôt de contrôle.

La manipulation des pointeurs est plus ou moins explicite suivant les langages.
En C, les pointeurs sont des valeurs de première classe et peuvent être
manipulés directement. À l'inverse, en OCaml, les pointeurs n'apparaissent
jamais directement dans le code source mais sont utilisés implicitement par
le compilateur.

Lorsque les pointeurs sont explicites, il y a trois type d'erreurs courantes
qui peuvent survenir :
- le débordement;
- le déréférencement de `NULL`;
- le _dangling pointer_

Le débordement survient lorsqu'on écrit ou lit en mémoire à une adresse
qui n'est pas dans une plage de valeurs attendues. Typiquement, cela arrive
lorsqu'on
adresse un tableau en dehors de ses limites. Si on a un tableau
de 10 éléments et qu'on accède au 11ème élément, on accède à une zone pouvant
contenir n'importe quelle donnée et très probablement pas celle qui était
imaginée par le programmeur.

Le déréférencement de `NULL`, ou plus généralement le déréférencement invalide,
consiste à utiliser une adresse invalide et à tenter de lire ou écrire à
cette adresse. Quand un programme est lancé par un système d'exploitation,
ce dernier lui octroit une zone mémoire pour son usage exclusif. Si le programme
tente d'accéder à une zone mémoire qui ne lui appartient pas, une erreur
d'accès mémoire est levée et le programme est arrêté.
Le cas le plus courant
est celui du déréférencement de `NULL`. `NULL` est une valeur spéciale
utilisée pour dénoter des valeurs particulières, en parucilier l'absence de
valeur. Par exemple, une liste chaînée se termine souvent par un pointeur
`NULL` pour indiquer la fin de la liste. Dans la plupart des systèmes, `NULL`
vaut techniquement 0 et ce n'est pas une adresse valide.

Le _dangling pointer_ survient lorsqu'on utilise un pointeur sur une
valeur qui n'a jamais été allouée ou été libérée. Dans les deux
cas, la valeur pointée est indéterminée et l'utilisation de cette valeur
peut conduire à des comportements indéfinis. Par exemple, en C le code suivant
pose problème :

```c
int *p = calloc(1, sizeof(int)); /* allocation d'un entier dans le tas */
*p = 42;                         /* écriture de 42 à l'adresse pointée */
free(p);                         /* libération de la mémoire */
printf("%d\n", *p);              /* utilisation de la valeur pointée */
```

Après le `free(p)`, l'adresse mémoire pointée par `p` peut être réutilisée
par une autre partie du programme et contenir n'importe quelle valeur. Il n'est
donc pas possible de prédire la valeur affichée par le `printf`.

Notons que le _dangling pointer_ apparaît généralement dans les situations
où l'allocation dynamique se fait manuellement (C, C++, ...) mais il peut très
bien arriver sans allocations dynamiques par échappement de portée :

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

Dans les deux cas, le pointeur (`p` ou `&n`) pointe sur une valeur qui a été
allouée dans la pile mais qui n'est plus valide à la sortie du bloc représenté
par les accolades.


== Gestion de la mémoire

Un programme utilise deux zones de mémoire : une zone statique et une zone
dynamique. La zone statique est prédéfinie à la compilation et contient les
données globales (ou explicitement statiques avec le mot clé `static` du C) et
ne peut être modifiée. La zone dynamique est réservée à l'éxécution du programme
et contient deux sous-zones : la pile et le tas.

La _pile_ est une zone de mémoire avec une taille maximale définie par le
système et qui se remplit automatiquement en fonction du modèle d'execution
du langage. En général, elle se remplit à chaque appel de fonction avec les
données locales et l'adresse de retour des fonctions, puis se vide lorsque les
fonctions terminent. Un dépassement de pile (_stack overflow_) peut survenir
lorsque qu'on cumule trop d'appel de fonction. Cela peut arriver facilement
avec une récursion mal maîtrisée. Un dépassement de pile est une erreur fatale
au programme.

Le _tas_ est une zone libre de mémoire dans laquelle on peut allouer des
données dynamiquement. L'allocation dynamique est réalisée par l'appel de
fonctions spécifiques qui demandent au système d'exploitation de réserver une
zone de mémoire de taille donnée. Lorsque la mémoire n'est plus utilisée, il
est nécessaire de la libérer pour éviter les _fuites mémoire_. Si trop
de mémoire est allouée sans être libérée, le programme peut consommer toute
la mémoire disponible et être arrêté par le système d'exploitation dans le
meilleur des cas. Dans le pire des cas, le système entier est paralysé car privé
des ressources mémoires nécessaires à son fonctionnement nominal.

Dans la bibliothèque standard du C, la fonction `malloc` et ses dérivées
peuvent être utilisées
pour allouer et `free` pour libérer la mémoire. Pour éviter les fuites mémoires,
il faut donc un `free` pour chaque allocation réalisée. Cependant, les
programmes
non triviaux mettent en oeuvre des structures de données complexes dont
certaines parties sont allouées dynamiquement et savoir quand faire le `free`
peut être délicat. Il peut arriver que le programmeur pêche par exces de
prudence et se retrouve à libérer deux fois une même allocation (_double free_).

La double libération a un comportement indéterminé et peut conduire à une
corruption de l'allocateur de mémoire entrainant des allocations incohérentes
et difficiles à diagnosiquer.

Certaines analyses statiques peuvent détecter les fuites mémoires et les
doubles libérations en suivant le flôt de contrôle du programme et en
vérifiant que chaque allocation est bien libérée une et une seule fois.

Notons que les langages à gestion automatique de la mémoire ne sont pas exempt
de fuites mémoires. La gestion automatique de la mémoire
est basée sur un ramasse-miettes qui libère la mémoire automatiquement
lorsqu'elle n'est plus utilisée. Toutefois, lorsque le ramasse-miettes ne peut
pas déterminer si une donnée est encore utilisée ou non, il peut décider de
la conserver alors qu'elle n'est plus utilisée. C'est le cas des
ramasse-miettes dits «conservatifs».
