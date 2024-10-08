#import "links.typ": *
#import "defs.typ": *

= Introduction

== Terminologie

#align(
  center,
  table(
    columns: (auto, auto),
    align: (center, left),
    [*Terme*], [*Définition*],
    [COTS <cots>], [_Commercial Off-The-Shelf_ ou produit sur étagère],
    [WCET <wcet>], [
      _Worst Case Execution Time_ ou temps d'exécution du pire cas
      (_i.e._ maximal)
    ],
  )
)

== Organisation du document

Le document présente tout d'abord la méthodologie utilisée pour l'étude en
détaillant les points abordés pour chaque langage. Ensuite, chaque langage
est étudié individuellement en respectant le plan défini.


== Note méthodologique

La méthodologie utilisée pour l'étude des langages reprend les points abordés
dans les clauses techniques #cite(<ctcots>).
De manière générale, l'étude est basée sur le contenu publique disponible sur
internet, les brochures techniques ou commerciales et les connaissances propres
des auteurs. Le volume d'information obtenu étant inégal suivant les outils,
la complétude des informations fournies dans ce rapport n'est pas assurée.
Toutefois, et sous réserve que les informations publiques soient à jour, elles
sont _a priori_ correctes.

Ce rapport étant lui même destiné à être _open source_, nous invitons
le lecteur à participer à son amélioration continue en signalant toute
erreur ou en contribuant via le dépôt https://github.com/OCamlPro/ppaqse-lang.

Pour des questions de lisibilité du document, certains points méthodologiques ou
explications sont renvoyés en annexe.

