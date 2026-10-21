// Compile check for the tessa template.
// Run with:  typst compile tests/test.typ
// This file intentionally exercises edge cases — unlike template/main.typ,
// which is meant to be a pretty example.
#import "../src/lib.typ": *

#show: tessa.with(
  title: "Template Test",
  author: "Test Author",
  course: "TEST 000",
)

// Theorems *before* any heading: section prefix should be omitted.
#theorem[Numbering before the first heading should have no section prefix.]

= First Section

#theorem[First theorem in section 1 — should be "Theorem 1.1".]
#definition[First definition — shares the counter, so "Definition 1.2".]
#lemma[A lemma — "Lemma 1.3".]
#proof[A proof with a QED square at the right margin.]
#corollary[Corollary.]
#proposition[Proposition.]

== Subsection

#example(title: "Named")[An example with a title.]
#remark[A remark.]

= Second Section

// Counter must reset: this should be "Theorem 2.1", not "Theorem 2.6".
#theorem[Counter reset check — must read "Theorem 2.1".]

== Math

A numbered equation:
$ integral_a^b f(x) dif x = F(b) - F(a) $
