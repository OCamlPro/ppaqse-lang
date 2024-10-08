#import "defs.typ": *
#import "links.typ": *

= Test <A-tests>

Il y a plusieurs type d'outils pour tester un programme que l'on peut diviser
en trois catégories qui ne sont pas forcément exclusives:
- les outils d'écriture de tests;
- les outils de génération de tests;
- les outils de gestion des tests.

Les outils d'écriture de tests permettent de décrire les tests à réaliser. Ils
sont souvent fournis sous la forme de bibliothèques logicielles qui fournissent
des fonctions, des macros ou des annotations pour décrire les tests à
l'intérieur du programme lui même ou d'un programme à part.

L'écriture des tests étant souvent laborieuse, il existe des
générateurs de tests qui offrent la possibilité de réaliser une bonne partie des
tests unitaires et parfois fonctionnels de manière automatique.
Ces générateurs peuvent
être basés sur des techniques de génération aléatoire (_fuzzing_) qui peut être
guidée,
de génération de modèle (_model checking_) ou de génération de cas de test aux
limites.

Les outils de gestion des tests engloblent les outils qui vont ajouter de
l'intelligence dans l'éxécution des tests et factoriser le plus possible
les exécutions qui peuvent être coûteuses en temps et en ressources.

Notons que certains outils proposent également la générations de méta données
utiles pour la certification ou qualification de logiciels. Certains peuvent
engendrer des matrices de tracabilité ou des rapports préformatés pour les
processus idoines.

Étant donné qu'il existe pléthore de cadres logiciels pour uniquement écrire
des tests et que la plus-value de ces cadres dans le processus d'édition
de logiciel critique est limitée, nous nous concentrerons essentiellement sur
les outils qui offrent un minimum de génération ou de gestion de tests
offrant le plus de valeur ajoutée pour les logiciels critiques.

Par ailleurs, il faut aussi distinguer quels types de test l'outil peut gérer.
Dans le rapport, nous distinguerons le type de test avec une
lettre majuscule selon le tableau suivant :

#figure(
  table(
    columns: (auto, auto, auto),
    [*Type*], [*Description*], [*Identifiant*],
    [*Unitaire*], [
      Teste une unité de code (fonction, module, classe, ...)
    ], [U],
    [*Intégration*], [
      Teste l'intégration de plusieurs unités de code
    ], [I],
    [*Fonctionnel*], [
      Teste une fonctionnalité du programme
      ], [F],
    [*Non régression*], [
      Teste que les modifications n'ont pas introduit de régression
    ], [N],
    [*Robustesse*], [
      Teste une unité de code ou une fonctionnalité avec des valeurs aux
      limites, voir hors limites
    ], [R],
    [*Couverture*], [
      Teste la couverture du code par les tests
    ], [C],
  )
)

Les critères d'analyse utilisés sont la capacité de
- générer des tests automatiquement
- de gérer efficacement les tests (factorisation, parallélisation,
  rapports, ...)
- faire du _mocking_, c'est-à-dire de la simulation de dépendances.
