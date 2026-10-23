// Compile check for the tessa template.
// Run with:  just test
// This file intentionally exercises edge cases — unlike template/main.typ,
// which is meant to be a pretty example.
#import "../src/lib.typ": *

#show: tessa.with(
  title: "Template Test",
  author: "Test Author",
  institute: "CityU HK",
)

// Unnumbered front-matter chapter: no "Chapter" label, but in the TOC.
#heading(level: 1, numbering: none)[Preface]

A preface paragraph.

// Theorems *before* any numbered chapter: chapter prefix omitted.
#theorem[Numbering before the first chapter should have no chapter prefix.]

= First Chapter
@rudin1976
#theorem[First theorem in chapter 1 — should be "Theorem 1.1".]
#definition[First definition — shares the counter, so "Definition 1.2".]
#lemma[A lemma — "Lemma 1.3".]
#proof[A proof with a QED square at the right margin.]
#corollary[Corollary.]
#proposition[Proposition.]

== A Section

#example(title: "Named")[An example with a title.]
#remark[A remark.]

=== A Subsection

Numbered 1.1.1 and included in the table of contents.

==== A Subsubsection

Must be UNNUMBERED and absent from the table of contents.

= Second Chapter

// Counter must reset: this should be "Theorem 2.1", not "Theorem 2.6".
#theorem[Counter reset check — must read "Theorem 2.1".]

== Math

A numbered equation:
$ integral_a^b f(x) dif x = F(b) - F(a) $

// Bibliography heading renders unnumbered as "References".
#bibliography("refs.bib")
