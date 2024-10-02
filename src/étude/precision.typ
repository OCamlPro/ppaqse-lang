#import "defs.typ": *
#import "links.typ": *

= Analyse numérique

== Entière

Les erreurs d'arithmétique entière sont des erreurs qui surviennent lors de
calculs sur des entiers machine. Il s'agit là des entiers que l'on trouve dans
la plupart des langages de programmation et souvent désignés par le mot clé
`int` ou dérivés.

La taille des entiers manipulables dépend de l'architecture du processeur
utilisé. Sur la plupart des architectures, elle correspond aux puissances de 2
entre 8 et 64. Par exemple, un entier de 8 bits non signé (uniquement
positif) peut représenter un entier mathématique de 0 à 255. Les formes
signées utilisent un bit pour indiquer si l'entier est positif ou négatif; ce
qui permet de représenter les entiers mathématiques de -128 à +127.

Dès lors que les entiers machines ont une taille finie, il est possible de
réaliser des opérations qui dépassent cette taille. Par exemple, calculer
$200 + 100$ sur un entier non signé de 8 bits donnera 44 (300 modulo 256). Ce
résultat est correct dans une arithmétique modulo 256 mais il est rare
que le programmeur pense dans cette arithmétique et il est plus probable qu'il
s'agisse d'une erreur involontaire. Ce type d'erreur est appelé _overflow_
(ou dépassement de capacité).

Ce genre d'erreur peut être assez subtil car
bien qu'il soit détecté par le processeur qui positionne un drapeau
signalant le dépassement, il nécessite que le programmeur vérifie ce drapeau
explicitement pour en tenir compte; ce qu'il ne fait généralement pas.

Il y a aussi des opérations qui peuvent conduire à des comportements indéfinis
par le langage. Les langages dont la sémantique n'est pas complètement
standardisée donnent une liberté aux compilateurs pour interpréter
certaines constructions. C'est ce qu'on appelle les _undefined behavior_.
Cela est problématique lorsque le comportement du compilateur n'est pas
celui imaginé par le développeur ou quand le programme est compilé avec un
autre compilateur. Ce genre d'erreur doit également être relevé car il
est susceptible de conduire à des erreurs d'exécution.

Une autre erreur couverte par l'analyse de l'arithmétique entière
est la division par 0. Celle-ci n'est pas plus autorisée en informatique que
dans les mathématiques générales et provoque une erreur fatale à l'exécution.


=== Flottante

L'arithmétique flottante est basée sur une représentation binaire des nombres
réels. Les nombres flottants sont représentés par
trois valeurs : le _signe_, la _mantisse_ et l'_exposant_.
La mantisse est la partie
significative du nombre, l'exposant est la puissance de 2 ou de 10 à laquelle
il faut multiplier la mantisse et le signe indique si le nombre est
positif ou négatif.

Comme pour les nombres entiers, il existe plusieurs tailles de flottants et
la norme #cite(<ieee:754-2008>) définit plusieurs formats en fonction
de la base (2 ou 10) et le nombre de bits utilisés (en puissance de 2 de
16 à 128).

Bien que les nombres flottants permettent de représenter des nombres
plus grands que leur équivalent entier, ils n'en sont pas moins sujet à des
dépassement de capacité. Cela étant, le calcul flottant est complet et en cas
de dépassement ou de calcul impossible (comme la division par 0), le résultat
est donné par des nombres spéciaux comme $+infinity$ ou $-infinity$ ou
_NaN_#footnote[_Not A Number_ (pas un nombre), utilisé pour les opérations
invalides].

Le fait que l'arithmétique flottante soit standardisée et complète en font
parfois un choix de prédilection pour les calculs en général. Certains
langages de programmation (comme Lua) ont un seul type numérique qui est,
par défaut, représenté par un flottant.

D'un point de vue mathématique, l'arithmétique flottante a cependant
un soucis d'arrondi inhérent au fait que la décomposition binaire d'un
nombre peut être supérieure à sa capacité. Elle est même d'ailleurs infinie
si le dénominateur du nombre n'est pas une puissance de 2. Par exemple, le
nombre décimal 0.5 a une représentation flottante exacte car c'est
$#text(red)[2]^(-1) = 1/#text(red)[2]$. En revanche 0.1 ($1/#text(red)[10]$)
n'a pas de représentation exacte car sa décomposition
binaire donne $0,0overline(0011)$ (où 0011 se répète à l'infini). Pour pouvoir
représenter ce nombre, il faut l'arrondir à une certaine précision et
généralement 0.1 vaut en 0.10000000000000000555 en flottant.

Ces arrondis donnent lieu à des approximations qui peuvent s'accumuler et
devenir problématiques lorsqu'on enchaîne les opérations. Elles peuvent
également donner lieu à des résultats contre intuitifs. Par exemple, en calcul
flottant, l'égalité $0.1 + 0.2 = 0.3$ est fausse ! Avec les
arrondis, $0.1 + 0.2$ vaut 0.30000000000000004441 tandis que 0.3 vaut
0.29999999999999998890. Dans ce contexte, écrire des algorithmes numériques
fiables peut être très délicat.

Les analyses statiques sur l'arithmétique flottante peuvent détecter
les opérations ambiguës comme la comparaison ci-dessus et vérifier la marge
d'erreur en effectuant un calcul abstrait sur les intervalles possibles ou en
évaluant le delta de précision qui est, de manière qui peut paraître
paradoxale, calculable de manière exacte. Il existe également des bibliothèques
de calcul pour réaliser à _runtime_ les opérations en utilisant ces deux
techniques.
