#import "@local/engineering-docs-suite:0.1.0": lab-report
#import "utils/preamble.typ": *

#show: codly-init.with()

#codly(
    fill: rgb("#e4e4e4"),
    zebra-fill: rgb("#cfcece"),
    radius: 0.25em,
)

#import "/utils/preamble.typ": *

#set math.equation(numbering: "(1.1)")

#show: project.with(
  title: "Real-Time Flight Instrumentation Cluster System",
  subtitle: "Flight Simulation with Motorized Gauges and Hardware-Software Integration",
  authors: (
    "Kenyi Kubari",
  ),
  school-logo: image("rsc/figures/athabasca_logo.jpg"), // Replace with [] to remove the school logo
  company-logo: image("rsc/figures/university_of_manitoba_logo.jpg", height: 3cm),
  branch: "BSc. Mechanical Engineering (Minor Computer Science)",
  academic-year: "2025-2026",
  footer-text: "COMP 444: Final Project", // Text used in left side of the footer
)


#show figure.where(kind: table): it => {
    v(1em)
    it.caption
    it.body
    v(1em)
}

#show figure.where(kind: image): it => {
    v(1em)
    it.body
    it.caption
    v(1em)
}



// #set par(spacing: 12pt)
#set par(leading: 1.25em, spacing: 2.5em)
#set block(spacing: 1em)

= Introduction <sec:introduction> \
#include "sec/1_introduction.typ" 


= Background <sec:background> \
#include "sec/2_background.typ"

= Methods <sec:methods> \
#include "sec/3_methods.typ"

= Design <sec:design> \
#include "sec/4_design.typ"

= Challenges <sec:5_challenges> \
#include "sec/5_challanges.typ"

= Results and Discussion <sec:results-and-discussion> \
#include "sec/6_results.typ"

= Conclusion <sec:conclusion> \
#include "sec/7_conclusion.typ"



#set page(numbering: "i")
#pagebreak()



// #show heading.where(level: 1): it => {
//     set align(left)
//     set heading(numbering: "A")
//     counter(heading).update(0)
//     set text(size: 16pt, weight: "bold")
//     [APPENDIX] +  + ":" + it.body
// }

#set heading(numbering: "A.1")
#counter(heading).update(0)

#show heading.where(level: 1): it => {
  set align(left)
  set text(size: 16pt, weight: "bold")
//    set heading(supplement: "Appendix")
  [APPENDIX ] + counter(heading).display("A") + [: ] + it.body
}


// #show ref: it => {
//   let el = it.element
//   if el != none and el.func() == heading and el.level == 1 {
//     [Appendix ] + counter(heading).display("A")
//   } else {
//     it
//   }
// }

#include "sec/_appendix.typ"
#pagebreak()

#set heading(numbering: none)
#bibliography("utils/reference.bib")
#pagebreak()