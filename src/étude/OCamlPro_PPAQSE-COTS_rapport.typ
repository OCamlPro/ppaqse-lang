#import "../base.typ": *
#import "defs.typ": *
#import "links.typ": *



#show: report.with(
  title: [Ecosystèmes COTS de développement et de vérification des logiciels critiques et temps réel],
  version: sys.inputs.at("git_version", default: "<unknown>"),
  authors: (
    (
      firstname: "Julien",
      lastname: "Blond",
      email: "julien.blond@ocamlpro.com"
    ),
    (
      firstname: "Arthur",
      lastname: "Carcano",
      email: "arthur.carcano@ocamlpro.com",
    ),
    (
      firstname: "Pierre",
      lastname: "Villemot",
      email: "pierre.villemot@ocamlpro.com",
    )
  ),
  reference: [DLA-SF-0000000-194-QGP],
  abstract: [
    Ce rapport présente une étude des langages #C, #Cpp, #Ada, #Scade, #OCaml
    et #Rust du point de vue de la sûreté. Il suit les clauses techniques
    #cite(<ctcots>) relatives au projet «COTS de qualité : logiciels critiques
    et temps réel» par et pour le #CNES.
  ]
)



#show raw.where(block: true): code => {
  show raw.line: it => {
    let size = calc.ceil(calc.log(it.count))
    let total = measure([#size])
    let num = measure([#it.number])
    let space = total.width - num.width + 0.5em
    h(space)
    text(fill: gray)[#it.number]
    h(0.5em)
    it.body
  }
  code
}


#show heading.where(
  level: 1,
): it => [
  #pagebreak(weak: true)
  #align(center, it)
  #v(1cm)
]

#include "introduction.typ"
#include "C.typ"
#include "C++.typ"
#include "Ada.typ"
#include "Scade.typ"
#include "OCaml.typ"
#include "Rust.typ"

#include "conclusion.typ"

#bibliography("bibliography.yml", title: "Références")

#set heading(numbering: "A.1")
#show heading.where(level: 1): set heading(
  numbering: (..nums) => "Annexe " + numbering("A.1.", ..nums.pos())
)

#counter(heading).update(0)

#include "paradigmes.typ"
#include "analyseurs.typ"
#include "precision.typ"
#include "pointeurs.typ"
#include "mesures.typ"
#include "concurrence.typ"
#include "formalisation.typ"
#include "tests.typ"