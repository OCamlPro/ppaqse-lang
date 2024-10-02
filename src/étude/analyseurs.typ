#import "defs.typ": *
#import "links.typ": *

= Analyseurs statiques

== Généralités

Pour chaque langage étudié dans le rapport, nous présentons des outils d'analyse
statique permettant de déduire de l'information par une
interprétation abstraite du programme.

Les analyseurs statiques peuvent établir des métriques sur le code ou faire
de la rétro-ingénierie pour en déduire des propriétés (et en vérifier). Ils
peuvent également détecter des erreurs de programmation par heuristique ou
vérifier le respect de normes de codage.

Étant donné le volume d'analyseurs sur le marché, le rapport ne prend en compte
que les analyseurs dits _corrects_.
Un analyseur statique est dit _correct_ s'il ne donne pas de faux-négatif
pour un programme sans _bug_. _A contrario_, il indiquera au moins un _bug_
pour un programme qui en comporte. Cette garantie n'est donnée que par rapport
à la modélisation mathématique qui en est faite et il est donc important que ce
modèle soit raisonnablement proche de la réalité.

Chaque analyseur est étudié par rapport aux ressources publiques disponibles.
Cela comprend le manuel utilisateur, les publications scientifiques, les
brochures commerciales ou le site internet dédié.

Les types d'erreurs détectées dépendent des analyses effectuées par chaque
outils et tous n'utilisent pas toujours la même terminologie pour désigner un
type d'erreur. En conséquence, l'absence d'indication sur la présence d'une
analyse particulière ne signifie pas que l'outil ne la fasse pas mais seulement
que nous n'avons pas trouvé d'information à ce sujet.


== Notes sur les analyseurs statiques

=== Frama-C

Parmi les analyseurs statiques étudiés, #framac#cite(<framac>) a la
particularité de
fonctionner avec des _plugins_ dédiés à un type d'analyse particulier. La
complétion de l'analyse globale considérée dans les comparatifs du document
suppose que les _plugins_ usuels soient utilisés, notamment :
- Eva ;
- Wp ;
- Mthread.

Certaines analyses complémentaires peuvent être proposées par l'outil via des
plugins payants ou réalisés _ad hoc_.

=== Polyspace

Polyspace désigne une gamme de produit de la société MathWorks
#footnote[#link("https://fr.mathworks.com")] qui propose différentes solutions
autour de l'analyse statique.

Dans le cadre de cette étude, nous désignons par Polyspace la solution
_Polyspace Code Prover_.

=== TIS Analyser

_TrustInSoft Analyser_ est un outil d'analyse statique développé par la société
_TrustInSoft_#footnote[#link("https://trust-in-soft.com")]. C'est un _fork_
de Frama-C qui utilise un ancien plugin _value_ basé sur le calcul
d'intervalles. _TrustInSoft_ a amélioré le plugin, la traçabilité des erreurs
et l'expérience utilisateur.