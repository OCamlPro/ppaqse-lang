
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
  model_intro:[],
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

== Description

#introduction

=== Paradigme

#paradigme

=== Mécanismes intrinsèques de protection

#intrinseque

=== Compilateurs

#compilation

=== Interfaçage

#interfacage


=== Adhérence au système

#adherence


=== Gestionnaire de paquets

#packages

=== Communauté

#communaute



== Outillage

=== Débugueurs

#debug

=== Tests

#tests

=== Parsing

#parsers

=== Meta programmation

#metaprog

=== Dérivation

#derivation

== Analyse & fiabilité

#model_intro

=== Analyse statique

#runtime

=== Meta formalisation

#formel

=== WCET

#wcet

=== Pile

#pile

=== Qualité numérique

#numerique

=== Assurances

#assurances

=== Utilisation dans le critique

#critique

]
