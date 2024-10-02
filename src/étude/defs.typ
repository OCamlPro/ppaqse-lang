
#let todo(t) = text(red)[TODO: #t]


#let paradigme(p) = text(blue, p)


#let pageref(label) = context {
  let loc = locate(label)
  let nums = counter(page).at(loc)
  link(loc, numbering(loc.page-numbering(), ..nums))
}

#let crate(name) = link("https://lib.rs/crates/" + name, name)


#let language(
  name:str,
  introduction:content,
  paradigme:content,
  model_intro:content,
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

#model_intro

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
