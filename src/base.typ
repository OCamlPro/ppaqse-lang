// polylux gives slides stuff
#import "@preview/polylux:0.3.1": *

// import graphical stuff
#import "@preview/cetz:0.2.0" as cetz: *
#import "@preview/fletcher:0.4.1" as fletcher: node, edge

// import formatting stuff
#import "@preview/oxifmt:0.2.1": strfmt



// logo
#let logo = table(
  stroke: none,
  columns: (auto, auto),
  image(width: 3cm, "imgs/ocp.png"),
  image("imgs/Logo carré bleu - fond transparent.png"),
)


#let common(doc) = [

  #show raw.where(block: true): it => rect(width: 100%, radius: 4pt, it)

  #set text(
    font: ("Marianne"),
    //fallback: false,
  )

  #show figure.where(kind: raw): it => {
    show raw: set align(left)
    it
  }

  #set par(justify: true)




  #doc

]


#let presentation(body) = {
  show: common

  // slides need bigger font
  set text(size: 22pt)

  set page(
    paper: "presentation-16-9",
    margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 3cm),
    header: [
      #align(center, [
        #stack(dir: ttb, spacing: 2pt,
          logo,
          line(length: 100%)
        )
      ])
    ],
    numbering: "1 / 1",
    footer: [
      #stack(
        dir: ttb,
        spacing: 2pt,
        line(length: 100%),
        align(
          center + horizon,
          [
            #set text(size: 14pt)
            #counter(page).display("1 / 1", both: true)
          ]
        )
      )
    ]
  )



  body
}

#let title-slide(title: "", subtitle: "", authors: [], body: []) = {
  polylux-slide[
    #align(center + horizon,
      stack(dir: ttb, spacing: 1cm,
        text(size: 40pt, [*#title*]),
        text(size: 30pt, [*#subtitle*]),
        authors,
        body
      )
    )
  ]
}

#let slide(body) = {
  show heading: it => [#it #v(1cm)]
  polylux-slide[
    #body
  ]
}

#let abstract(body) = {
}

#let report(
  title: [],
  version: [],
  version_title: "Version",
  authors: array,
  right_to_know: none,
  need_to_knows: (),
  paraphes: false,
  reference: [],
  abstract: [],
  doc
) = {



  /* Using common stuff */
  show: common

  let authors_array = authors.map(author =>
    author.firstname + " " + author.lastname
    + " (" + author.email + ")"
  )

  /* Setting metadatas */
  set document(
    title: title,
    author: authors_array
  )

  set heading(numbering: "1.")

  // labeling stuff. It's fragile for now : only "confidential"
  // RTK is supported and we don't check NTKS size...
  let labelling(rtk, ntks) = {
    if rtk != none {
      show "confidential": w => text(red, upper(w))
      table(
        columns: (auto, auto),
        [#text(size: 16pt, [#rtk])],
        [#text(size: 16pt, blue, [#ntks.join(", ")])]
      )
    }
  }

  let topsize = if right_to_know != none {3cm} else {2cm}

  set page(
    paper: "a4",
    margin: (top: topsize, bottom: 2cm, left: 3cm, right: 3cm),
    header: [
      #align(center, [
        #stack(dir: ttb, spacing: 2pt,
          logo,
          line(length: 100%),
          v(2pt),
          labelling(right_to_know, need_to_knows)
        )
      ])
    ],
    numbering: "1 / 1",
    footer: [
      #stack(
        dir: ttb,
        spacing: 5pt,
        line(length: 100%),

        align(
          center + horizon,
          stack(dir: ttb, spacing: 2pt,
            grid(
              columns: (40%, 20%, 40%),
              rows: (auto),
              [],
              [
                #set text(size: 10pt)
                #counter(page).display("1 / 1", both: true)
              ],
              {
                if paraphes {
                  rect(
                    stroke: gray.darken(40%),
                    width: 6cm,
                    height: 1cm,
                    radius: 2pt,
                    align(left, text(gray.darken(40%), [Paraphes:])))
                }
              },
            )
          )
        )
      )
    ]
  )

  align(
    center,
    stack(
      dir: ttb,
      spacing: 1cm,
      v(10%),
      text(size: 20pt, [
        #set par(justify: false)
        *#title*
      ]),
      text(
        size: 14pt,
        table(
          columns: (auto, auto),
          align: (right, left),
          stroke: none,
          [ *#version_title:*], version,
          ..if reference != [] {
            ([*Référence:*], reference)
          }
        )
      ),
      stack(
        spacing: 5pt,
        stack(
          spacing:8pt,
          text(size: 12pt)[#if authors.len() > 1 [*Auteurs:*] else [*Auteur:*]],
          ..authors_array,
        ),
        ..if abstract != [] {
          (
            v(10%),
            stack(
              dir: ttb,
              spacing: 10pt,
              text(size: 12pt)[*Résumé*],
              abstract,
            )
          )
        }
      ),
      v(10%),


    )
  )



  /* content */
  doc

}

