#import "defs.typ": *
#import "links.typ": *

= Conclusion

Ce rapport fourni un aperçu des langages de programmation C, C++, #Ada,
#Scade, #OCaml, #Rust et de leur écosystème du point de vue de la sûreté
logicielle.

Comme à chaque fois qu'on étudie plusieurs langages, il est difficile d'échapper
à la question toute naturelle : _in fine_, quel est le langage le plus sûr ?
La réponse sous-tend qu'on compare les langages et leur écosystème entre eux
et, comme nous l'avons vu, tous ces langages ne sont pas vraiment comparables
car il vont toucher des usages particuliers avec des techniques particulières.
Comme un bon bricoleur choisi bien son outil en fonction de la tâche à réaliser,
un bon développeur doit choisir le langage le plus adapté à son besoin.

Le besoin en sureté est celui de la confiance dans le logiciel. Celle-ci repose
sur deux piliers:
- les vérifications statiques, que ce soit par le compilateur lui-même ou des
  outils tiers;
- les tests.

Ni l'un ni l'autre ne suffisent, seuls, à garantir la sûreté d'un logiciel :
les analyses peuvent être mal implémentées ou reposer sur des hypothèses fausses
et les tests peuvent ne pas couvrir toutes les combinaisons possibles pour
des raisons combinatoires ou techniques.

Or, nous l'avons vu, tous les langages présentés disposent
d'environnements de test plus ou moins automatisés mais suffisants pour
réaliser des bancs de tests complets. En revanche, #OCaml et #Rust, malgré leur
très bon degré de vérification intrinsèque, manquent d'analyses complémentaires
qui ne sont, pour l'heure, qu'à l'état de projets de recherche.

Aussi, pour des projets très critiques, les langages #Ada et #Scade semblent
être les plus adaptés car ils offrent des garanties de vérification
à la fois intrinsèques et externes très fortes.

Pour les projets un peu moins critiques, #OCaml et #Rust ont probablement
une place à prendre en fonction des objectifs recherchés :
- #Rust pour les mêmes raisons que le C/C++ mais avec des garanties
  supplémentaires;
- #OCaml pour son efficacité productive.

Lorsque plusieurs langages sont utilisables, la gestion du _coût_ intervient
afin d'être compétitif. Ce coût provient :
- du temps de développement;
- du temps de débogue;
- des licences d'outils tiers;
- de la formation du personnel (pour le langage et les outils);
- de la dette technique.

La dette technique est un point important car elle est souvent sous-estimée
et engendre un coût caché de production qui augmente, parfois de manière
dramatique, avec le temps. La dette technique est évaluée par rapport à :
1. la complexité et maintenabilité de la base de code au fil du temps. Par
  exemple, les programmes C++ ont une tendance naturelle à devenir
  difficile à suivre;
2. la disponibilité des ressources : les ressources qui savent faire de
  l'#Ada ou du #Scade sont plus rares que celles qui savent faire du C et
  coûtent naturellement plus cher sur le marché du travail.

Comme il n'existe pas à notre connaissance de métriques sur des développements
comparables, il est difficile de donner une vue complètement objective
de la comparaison entre les langages selon les critères ci-dessus. A titre
informatif, nous pouvons cependant donner le résultat d'une étude informelle
réalisée
dans le cadre du développements de systèmes embarqués (mais lourds) a haut
niveau de confiance avec du temps réel avec des garanties de
sécurité#footnote[Le système d'exploitation PolyXene (https://cyber.gouv.fr/produits-certifies/polyxene-version-11) et ses variantes.].
Ces systèmes n'étaient pas soumis au normes de sûreté mais l'expérience est
toutefois pertinente puisque le hasard a voulu que les langages étudiés dans
ce rapport y soient utilisés (ou dans une forme équivalente). Ces
développements ont été fait avec une équipe
d'ingénieurs représentative de l'ingénieur moyen et le résultat est résumé dans
la @bilan. Les coûts sont donnés en pire cas (avec des € croissants) : par exemple,
si l'équipe d'ingénieur est déjà versée dans l'art de faire du bon C++, son coût
de formation sera moindre ou nul.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    [],                          [*C*],     [*C++*],  [*#Ada*], [*#Scade*], [*#OCaml*],        [*#Rust*],
    [*Temps Réel dur*],          [Oui],     [Oui],    [Oui],    [Oui],      [Non],             [Oui],
    [*Temps Réel mou*],          [Oui],     [Oui],    [Oui],    [Oui],      [Oui],             [Oui],
    [*Environnement contraint*], [Oui],     [Oui],    [Oui],    [Oui],      [Pas directement], [Oui],
    [*Temps de développement*],  [Long],    [Moyen],  [Moyen],  [Long],     [Court],           [Moyen],
    [*Temps de débogage*],       [Long],    [Long],   [Court],  [Court],    [Court],           [Court],
    [*Licences*],                [€€€],     [€€€],    [€€€],    [€€€],      [?],               [?],
    [*Formation*],               [€],       [€€€],    [€€€],    [€€],       [€],               [€€€],
    [*Dette technique*],         [€],       [€€],     [€],      [?],        [€],               [€€],
  ),
  caption: [Bilan comparatif des langages]
) <bilan>

Nous n'avons pas assez de recul pour évaluer la dette technique liée à #Scade
ni le prix des licences sur l'éventuelle commercialisation des outils
actuellement à l'état de projet de recherche pour #OCaml et #Rust. Toutefois,
nous pensons que ce bilan et le rapport dans sa globalité donneront une idée
générale assez fidèle à l'état actuel des langages étudiés.