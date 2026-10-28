// Boundary Element Method notes — written with the tessa template.
// Compile with:  just bem   (or: typst watch notes/bem.typ)
#import "../src/lib.typ": *

#show: tessa.with(
  title: "Boundary Element Methods",
  author: "ZHANG JIAYI",
  institute: "CityU HK",
)

#include "chapters/ch1-introduction.typ"
#include "chapters/ch2-potential.typ"
#include "chapters/ch3-boundary-integral.typ"

#tessa-bib-style[#bibliography("refs.bib")]
