// Import the template. Once installed as a package this becomes
//   #import "@local/tessa:0.1.0": *
// but inside the repo we import the file directly.
#import "../src/lib.typ": *

#show: tessa.with(
  title: "Real Analysis",
  author: "Ada Lovelace",
  institute: "CityU HK",
)

// ---- Preface (optional) ----
// An unnumbered front-matter chapter: it appears in the table of
// contents but gets no chapter number. Use it for prefaces,
// acknowledgments, "how to read these notes", etc.
#heading(level: 1, numbering: none)[Preface]

These notes were typeset with tessa.

= Limits and Continuity

== The Limit of a Function

// Cite a bibliography entry with @key — the key comes from refs.bib.
The presentation here follows @rudin1976.

#definition(title: "Limit")[
  Let $f : RR -> RR$ and $a in RR$. We say $lim_(x -> a) f(x) = L$ if
  for every $epsilon > 0$ there exists $delta > 0$ such that
  $ 0 < |x - a| < delta quad ==> quad |f(x) - L| < epsilon. $
]

#theorem(title: "Squeeze Theorem")[
  If $g(x) <= f(x) <= h(x)$ near $a$ and
  $lim_(x -> a) g(x) = lim_(x -> a) h(x) = L$,
  then $lim_(x -> a) f(x) = L$.
]

#proof[
  Given $epsilon > 0$, choose $delta$ small enough that both $g$ and $h$
  lie within $epsilon$ of $L$ on the punctured neighborhood. Then
  $L - epsilon < g(x) <= f(x) <= h(x) < L + epsilon$,
  so $|f(x) - L| < epsilon$.
]

== Continuity

#remark[
  Every function continuous at $a$ has a limit there: continuity is
  exactly the statement $lim_(x -> a) f(x) = f(a)$.
]

=== A worked case

#example[
  $f(x) = x^2$ is continuous everywhere, since
  $|x^2 - a^2| = |x - a| |x + a|$ can be made small by taking $x$
  close to $a$.
]

==== Why no number here?

A level-4 heading is an unnumbered run-in heading, like LaTeX's
`paragraph` — handy for small asides that don't belong in the TOC.

= Sequences

#definition[
  A sequence $(a_n)$ *converges* to $L$ if for every $epsilon > 0$
  there is $N in NN$ with $|a_n - L| < epsilon$ for all $n >= N$.
]

// ---- References ----
// Prints an unnumbered "References" chapter listing every cited entry.
#bibliography("refs.bib")
