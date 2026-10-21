// Import the template. Once installed as a package this becomes
//   #import "@local/tessa:0.1.0": *
// but inside the repo we import the file directly.
#import "../src/lib.typ": *

#show: tessa.with(
  title: "Real Analysis",
  author: "Ada Lovelace",
  course: "MATH 301",
)

= Limits and Continuity

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

#example[
  $f(x) = x^2$ is continuous everywhere, since
  $|x^2 - a^2| = |x - a| |x + a|$ can be made small by taking $x$
  close to $a$.
]

= Sequences

#definition[
  A sequence $(a_n)$ *converges* to $L$ if for every $epsilon > 0$
  there is $N in NN$ with $|a_n - L| < epsilon$ for all $n >= N$.
]
