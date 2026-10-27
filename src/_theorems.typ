// ============================================================
// _theorems.typ — internal: theorem-like environments and proofs.
//
// All environments share one counter (amsthm-style) numbered per
// chapter: "Theorem 2.3" = 3rd theorem-like environment in chapter 2.
// The reset half of the chapter link lives here (thm-reset); the
// chapter-number prefix is read live from the heading counter at
// render time inside render-thm-env.
// ============================================================

// ------------------------------------------------------------
// Counter shared by all theorem-like environments. Counters in Typst
// are document state keyed by name; updates are directives placed in
// the content flow, reads require `context`.
// ------------------------------------------------------------
#let thm-counter = counter("thm")

// Internal: reset the shared counter at each new chapter. The counter
// itself never leaves this module — only this operation does (called
// by the level-1 heading show rule in _style.typ's tessa-heading-style).
#let thm-reset() = thm-counter.update(0)

/// Generic renderer for theorem-like environments. The environments
/// below are thin .with() presets of this function.
///
/// Internal customization hook — intentionally NOT re-exported from
/// lib.typ. Power users can define their own environments:
///
///   #import "@preview/tessa:0.1.0/src/_theorems.typ": render-thm-env
///   #let axiom = render-thm-env.with("Axiom", body-fmt: emph)
///
/// Parameters:
/// - identifier: the rendered name, e.g. "Theorem" (positional)
/// - body: the content (positional)
/// - note: optional parenthesized note after the number, "(name)"
/// - body-fmt: emph = amsthm "plain" (italic body); identity = upright
/// - head-fmt: how "Theorem 1.1 (note)." renders (default: strong)
/// - delimiter: head punctuation (default: ".")
/// - space-above / space-below: vertical padding around the environment
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
  
  // The public environments — amsthm's "plain" style (italic body) for
  // theorem/lemma, "definition" style (upright body) for definition/remark.
  #let theorem = render-thm-env.with("Theorem", body-fmt: emph)
  #let lemma = render-thm-env.with("Lemma", body-fmt: emph)
  #let definition = render-thm-env.with("Definition")
  #let remark = render-thm-env.with("Remark")
  
/// Proof environment: bold "Proof." followed by the body, ending with
/// a QED symbol pushed to the right margin — like amsthm.
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
