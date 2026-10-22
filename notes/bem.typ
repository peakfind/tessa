// Boundary Element Method notes — written with the tessa template.
// Compile with:  just bem   (or: typst watch notes/bem.typ)
#import "../src/lib.typ": *

#show: tessa.with(
  title: "Boundary Element Methods",
  author: "jyzhang",
  course: "Computational Mechanics",
)

= Introduction

The boundary element method (BEM) reformulates a partial differential
equation as an *integral equation over the boundary* of the domain,
reducing the dimensionality of the discretization problem by one
@Steinbach @Sauter.
It is just a draft version.

= Potential Theory

== Fundamental Solutions

#definition(title: "Fundamental Solution")[
  For the Laplace operator in $RR^3$, the *fundamental solution* is
  $ G(bold(x), bold(y)) = 1 / (4 pi |bold(x) - bold(y)|), $
  which satisfies $-Delta G(bold(x), bold(y)) = delta(bold(x) - bold(y))$
  in the distributional sense.
]

#remark[
  In $RR^2$ the fundamental solution is instead
  $G(bold(x), bold(y)) = -1/(2 pi) log |bold(x) - bold(y)|$.
]

== Green's Identities

#theorem(title: "Green's Second Identity")[
  For sufficiently smooth functions $u, v$ on a domain $Omega subset RR^3$
  with boundary $Gamma = partial Omega$,
  $ integral_Omega (u Delta v - v Delta u) dif Omega
    = integral_Gamma (u (partial v) / (partial n) - v (partial u) / (partial n)) dif Gamma. $
]

#theorem(title: "Representation Formula")[
  If $Delta u = 0$ in $Omega$, then for $bold(x) in Omega$,
  $ u(bold(x)) = integral_Gamma
    [ G(bold(x), bold(y)) (partial u) / (partial n)(bold(y))
      - u(bold(y)) (partial G) / (partial n)(bold(x), bold(y)) ]
    dif Gamma_y. $
]

#proof[
  Apply Green's second identity with $v = G(bold(x), dot)$ on
  $Omega without B_epsilon(bold(x))$ and let $epsilon -> 0$.
  The integral over $partial B_epsilon$ contributes $u(bold(x))$.
]

= Boundary Integral Equations

#example(title: "Direct BEM for the Dirichlet Problem")[
  Given $u = g$ on $Gamma$, taking $bold(x) -> Gamma$ in the
  representation formula yields an integral equation for the unknown
  flux $q = partial u / partial n$:
  $ 1/2 g(bold(x)) = integral_Gamma G(bold(x), bold(y)) q(bold(y)) dif Gamma_y
    - integral.slash_Gamma g(bold(y)) (partial G)/(partial n)(bold(x), bold(y)) dif Gamma_y. $
]

#bibliography("refs.bib")
