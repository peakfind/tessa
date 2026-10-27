// ------------------------------------------------------------
// Counter shared by all theorem-like environments, so that
// "Theorem 3" and "Definition 4" share one numbering sequence
// (like amsthm's default). Counters in Typst are stateful and
// advance via `counter.step()` or `counter.update(n + 1)`.
// ------------------------------------------------------------
#let thm-counter = counter("thm")

// Internal: reset the shared counter at each new chapter. The counter
// itself never leaves this module — only this operation does (called
// by the level-1 heading show rule in lib.typ).
#let thm-reset() = thm-counter.update(0)

#let render-thm-env(
    identifier,                      // "Theorem" — the rendered name
    body,                            // the content (positional, per the pattern)
    note: none,                      // optional "(name)" after the number
    body-fmt: it => it,              // emph = plain/italic style; identity = upright
    head-fmt: strong,                // how "Theorem 1.1 (note)." renders
    delimiter: ".",                  // delimiter
    space-above: 0.4em,              
    space-below: 0.4em,
  ) = {
    thm-counter.step()
    context {
      // -- counter
      let hc = counter(heading).get()
      let chapter = if hc.first() > 0 { str(hc.first()) + "." } else { "" }
      let n = thm-counter.display()
      // --
      block(
        width: 100%,
        inset: (top: space-above, bottom: space-below), {
          head-fmt(identifier + " " + chapter + n) 
          if note != none { head-fmt[ (#note)] }
          head-fmt(delimiter)
          h(0.5em)
          body-fmt(body)
        }
      )
    }
  }
  
  #let theorem = render-thm-env.with("Theorem", body-fmt: emph)
  #let lemma = render-thm-env.with("Lemma", body-fmt: emph)
  #let definition = render-thm-env.with("Definition")
  #let remark = render-thm-env.with("Remark")
  
// ------------------------------------------------------------
// Proof environment: italic "Proof." followed by the body, ending
// with an open QED square pushed to the right margin — like amsthm.
// ------------------------------------------------------------
#let proof(body) = {
  block(
    width: 100%,
    inset: (top: 0.4em, bottom: 0.4em),
    {
      strong[Proof.]
      h(0.5em)
      body
      // `h(1fr)` is a spring: it expands to fill remaining space,
      // pushing the square to the right edge.
      h(1fr)
      $qed$
    },
  )
}
