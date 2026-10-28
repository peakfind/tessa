#import "../../src/lib.typ": *
= Boundary Integral Equations

#definition(note: "Direct BEM for the Dirichlet Problem")[
  Given $u = g$ on $Gamma$, taking $bold(x) -> Gamma$ in the
  representation formula yields an integral equation for the unknown
  flux $q = partial u / partial n$:
  $ 1/2 g(bold(x)) = integral_Gamma G(bold(x), bold(y)) q(bold(y)) dif Gamma_y
    - integral.slash_Gamma g(bold(y)) (partial G)/(partial n)(bold(x), bold(y)) dif Gamma_y. $
]
