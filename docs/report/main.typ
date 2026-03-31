#import "/utils/preamble.typ": *

#set math.equation(numbering: "(1.1)")

#show: project.with(
  title: "Injecting a backdoor in the xz library and taking over NASA and SpaceX spaceship tracking servers (for education purposes only)",
  subtitle: "Second year internship report",
  authors: (
    "Kenyi Kubari",
  ),
  school-logo: image("rsc/figures/athabasca_logo.jpg"), // Replace with [] to remove the school logo
  company-logo: image("rsc/figures/university_of_manitoba_logo.jpg", height: 3cm),
  mentors: (
    "Pr. John Smith (Internal)",
    "Jane Doe (External)"
  ),
  jury: (
    "Pr. John Smith",
    "Pr. Jane Doe"
  ),
  branch: "BSc. Mechanical Engineering (Minor Computer Science)",
  academic-year: "2025-2026",
  footer-text: "", // Text used in left side of the footer
)


// #set par(spacing: 12pt)
#set par(leading: 1.25em)
#set block(spacing: 1em)

= Introduction <sec:introduction>
#include "sec/1_introduction.typ"

= Methods <sec:methods>
#include "sec/2_background.typ"

= Results and Discussion <sec:results-and-discussion>
#include "sec/3_results.typ"

= Conclusion <sec:conclusion>
#include "sec/4_conclusion.typ"

#set page(numbering: "i", footer: none)
#counter(page).update(3)

#set heading(numbering: none)
= Appendix <sec:appendix>
#include "sec/_appendix.typ"

