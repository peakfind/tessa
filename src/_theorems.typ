// ============================================================
// _theorems.typ — internal: theorem-like environments and proofs.
//
// Every environment is a figure of the SAME custom kind "thm".
// This borrows the figure's built-in machinery: a shared counter
// (same kind = one sequence), per-instance supplement ("Theorem" vs
// "Definition"), and — the point — referenceability: a label attached
// to an environment resolves via @-references, rendered as
// "<supplement> <numbering>", e.g. "Theorem 2.3".
// Numbering is per chapter: reset by thm-reset in the chapter show
// rule; the chapter prefix is captured in the numbering closure.
// ============================================================

// Internal: reset the shared counter at each new chapter. The counter
// itself never leaves this module — only this operation does (called
// by the level-1 heading show rule in _style.typ's tessa-heading-style).
#let thm-reset() = counter(figure.where(kind: "thm")).update(0)

// Numbering for theorem-like environments: "chapter.n". Numbering
// functions are evaluated in context at the ELEMENT's location — so
// the chapter prefix is correct both at the definition and at every
// @-ref, even forward refs in earlier chapters.
#let thm-numfmt(n) = context {
  let hc = counter(heading).get()
  if hc.first() > 0 { str(hc.first()) + "." + str(n) } else { str(n) }
}

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
    // The figure must be returned bare (no `context`, no `show` rule
    // around it): labels attach to the figure element itself.
    // Figures center their body by default — align(left) INSIDE the
    // body counteracts that without wrapping the element.
    figure(
      kind: "thm",
      supplement: identifier,
      numbering: thm-numfmt,
      gap: 0em, // no caption — supplement/numbering surface only in refs
      outlined: false, // environments are not pictures; keep them out of
                       // any `outline(target: figure)` list of figures
    )[
      #align(left, block(
        width: 100%,
        inset: (top: space-above, bottom: space-below), {
          head-fmt(identifier + " " + context counter(figure.where(kind: "thm")).display(thm-numfmt))
          if note != none { head-fmt[ (#note)] }
          head-fmt(delimiter)
          h(0.5em)
          body-fmt(body)
        }
      ))
    ]
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
