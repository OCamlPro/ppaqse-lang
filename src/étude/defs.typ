
#let todo(t) = par(text(red)[TODO: #t])


#let paradigme(p) = text(blue, p)

#let language(
  name:content,
  introduction:content,
  paradigme:content,
  runtime:content,
  wcet:content,
  pile:content,
  numerique:content,
  formel:content,
  intrinseque:content,
  tests:content,
  compilation:content,
  debug:content,
  metaprog:content,
  parsers:content,
  derivation:content,
  packages:content,
  communaute:content,
  assurances:content,
  adherence:content,
  interfacage:content,
  critique:content,
) = [
= #name

#introduction

== Paradigme

#paradigme

== Modélisation & vérification

=== Analyse statique

==== _Runtime Errors_

#runtime

==== WCET

#wcet

==== Pile

#pile

==== Qualité numérique

#numerique

=== Meta formalisation

#formel

=== Mécanismes intrinsèques de protection

#intrinseque

=== Tests

#tests

== Compilateurs & outils

=== Compilation

#compilation

=== Débuggeur

#debug

=== Meta programmation

#metaprog

=== Générateurs de code

==== _Parsing_

#parsers

==== Dérivation

#derivation

== Bibliothèques & COTS

=== Gestionnaire de paquets

#packages

=== Communauté

#communaute

=== Assurances

#assurances

== Adhérence au système

#adherence

== Interfaçage

#interfacage

== Utilisation dans le critique

#critique

]
