#import "@preview/codly:1.3.0": * 
#import "@preview/codly-languages:0.1.1": *

#import "@preview/red-agora:0.2.0": project
#import "@preview/subpar:0.2.2"
#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": qty,numrange,qtyrange, unit
#import "@preview/zero:0.5.0": num, set-round
#import "@preview/equate:0.3.2": equate

#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "1.")
// #set math.equation(numbering: "1.")

#let dhpat(sep, stroke) = tiling(
  size: (10pt, (sep + std.stroke(stroke).thickness) * 10),
  {
    let t = std.stroke(stroke).thickness / 2 + 0.1pt
    let theline = line(length: 10pt, stroke: stroke)
    place(dy: t, theline)
    place(dy: t + sep, theline)
  }
)

#let double-hline = table.hline(stroke: (thickness: 6pt, paint: dhpat(2pt, 0.8pt), cap: "butt"))
#let hline = table.hline()


// IEEE-style heading customization

// Level 1: Section (e.g., I. INTRODUCTION)
#show heading.where(level: 1): it => {
  set align(center)
  set text(size: 16pt, weight: "bold")
  upper(it.body)
}

// Level 2: Subsection (e.g., A. Methodology)
#show heading.where(level: 2): it => {
  set text(size: 14pt, weight: "bold")
  it.body
}

// Level 3: Subsubsection (e.g., 1) Details)
#show heading.where(level: 3): it => {
  set text(size: 12pt, style: "italic")
  it.body
}

// #set par(spacing: 12pt)
#set par(leading: 1.25em)
#set block(spacing: 1em)
#show: codly-init.with()

#codly(
  fill: rgb("#dbdbdb"),
  zebra-fill: rgb("#c7c7c7"),
  radius: 0.25em,
)

