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