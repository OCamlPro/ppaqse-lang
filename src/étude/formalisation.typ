#import "defs.typ": *
#import "links.typ": *

= Meta formalisation

Pour certains langages, il est possible d'utiliser des outils de formalisation
pour spécifier des programmes et prouver que des propriétés.
Il existe globalement trois stratégies pour développement formel pour les
langages cibles:
- l'extraction de code;
- la génération de code;
- la vérification de code.

L'extraction de code consiste à écrire un programme dans un langage de
spécification (comme #coq ou #isabelle par exemple) et à extraire un programme
exécutable dans un langage cible. Ce dernier peut être soit le langage voulu
soit un langage compatible avec le langage voulu. Par exemple, on peut
extraire un programme #ocaml de #coq et compiler ce programme en un fichier
objet pouvant être lié à un programme C. C'est l'approche la plus simple pour
faire des développements formels intégrables dans des systèmes existants mais
elle a plusieurs inconvénients :
- elle suppose que l'extraction de programme est correcte;
- le langage cible n'est pas forcément agréé pour le développement critique.

La génération de code consiste à injecter le langage cible dans le langage
formel (qui devient un langage hôte). Cette injection se fait en
1. décrivant le langage cible dans le langage hôte ;
2. programmant dans le langage hôte le programme du langage cible ;
3. imprimer le programme cible dans un fichier ou plusieurs fichiers.

Les fichiers obtenus reprensent alors un programme valide du langage cible mais
qui a été formalisé dans le langage hôte.
Au final, cette approche permet
de décrire des programmes idiomatique au langage cible dans une syntaxe
plus ou moins proche de celui-ci suivant les capacités du langage hôte et de
démontrer des propriétés sur ces programmes. L'inconvénient
réside essentiellement dans le travail nécessaire pour décrire une injection
complète du langage cible dans le langage hôte qui peut se compter en années de
travail.

La vérification de code consiste partir du programme à vérifier dans le
langage cible et à décrire
des propriétés sur ce programme par le biais d'annotations (la plupart du
temps dans les commentaires). Ces  propriétés sont ensuite vérifiées par un
outil de vérification tiers. Cette approche est la plus pratique d'un point de
vue opérationnel car elle ne nécessite pas de manipuler des langages formels
directement. Les équipes de développement peuvent continuer à travailler
dans leur langage habituel et l'ajout des annotations peut se faire par d'autres
personnes. Toutefois, cette approche est limitée par les capacités de l'outil
de vérification et les annotations
doivent être suffisamment précises pour être utiles. Cela demande souvent une
connaissance assez fine de l'outil de vérification pour être efficace. Par
ailleurs, et comme pour la solution précédente, l'outil doit avoir un modèle
sémantique du langage cible qui nécessite beaucoup de travail. C'est
l'approche des outils de vérification de code comme #framac avec par exemple
let code annoté suivant:

```c
/*@
  requires \valid(a) && \valid(b);
  assigns *a, *b;
  ensures *a == \old(*b);
  ensures *b == \old(*a);
*/
void swap(int* a, int* b){
  int tmp = *a;
  *a = *b;
  *b = tmp;
}

int main(){
  int a = 42;
  int b = 37;
  swap(&a, &b);
  //@ assert a == 37 && b == 42;
  return 0;
}
```
où l'assertion sera vérfiée par l'outil et les solveurs sous-jacents à l'aide
des propriétés spécifiées dans le commentaire de la fonction `swap`.
