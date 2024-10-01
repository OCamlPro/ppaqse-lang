#import "@local/ocamlpro:0.1.0": *

#show: report.with(
  title: [COTS de qualité : \ logiciels critiques et temps réel],
  version: sys.inputs.at("git_version", default: "<unknown>"),
  authors: (
    (
      firstname: "Julien",
      lastname: "Blond",
      email: "julien.blond@ocamlpro.com"
    ),
  )
)



#import "defs.typ": *
#import "links.typ": *

#include "introduction.typ"
#include "C.typ"
#include "C++.typ"
#include "Ada.typ"
#include "Scade.typ"
#include "OCaml.typ"
#include "Rust.typ"

= Conclusions

= Références

#bibliography("bibliography.yml")

