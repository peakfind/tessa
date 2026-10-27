// ============================================================
// _style.typ — internal: document-wide styling functions.
//
// Each `tessa-*-style` function wraps `body` in set/show rules and is
// applied with `#show:` — either by tessa() (the default composition)
// or à la carte by users who want only some pieces.
// ============================================================
#import "_theorems.typ": thm-reset

/// Generic heading renderer for levels 2–4 (chapters are styled
/// separately — they need a page break and the theorem-counter reset).
///
/// Internal customization hook — intentionally NOT re-exported from
/// lib.typ. Power users can import it directly from this module:
///
///   #import "@preview/tessa:0.1.0/src/_style.typ": render-heading
///   #show heading.where(level: 2): it => render-heading(
///     it, 16pt, head-fmt: it => smallcaps(strong(it)),
///   )
///
/// Parameters:
/// - it: the heading element (positional)
/// - size: font size of the heading (positional, always supplied)
/// - head-fmt: how the heading text is rendered (default: strong)
/// - symbol: optional content prepended to the number, e.g. §
/// - numbered: false renders the body only (subsubsections)
/// - space-above / space-below: vertical rhythm around the heading
#let render-heading(
  it, 
  size, 
  head-fmt: strong, // default: bold
  symbol: none,
  numbered: true, 
  space-above: 0.4em,              
  space-below: 0.4em
) = {
  v(space-above, weak: true)
  text(size, head-fmt({
    if symbol != none { symbol; h(0.3em) }
    if numbered and it.numbering != none { 
      context counter(heading).display(it.numbering) + "."
      h(0.3em)
    }
    it.body
  }))
  v(space-below, weak: true)
}

/// tessa's heading style: numbered chapters / sections / subsections
/// ("1", "1.1", "1.1.1"); subsubsections are unnumbered run-in headings
/// and stay out of the table of contents (which uses depth 3).
/// Chapters start a new page and reset the shared theorem counter.
///
/// Usage: `#show: tessa-heading-style` (included in tessa() by default)
#let tessa-heading-style(
  body
) = {
  // Number chapters, sections, subsections — but not deeper.
  set heading(numbering: "1.1.1")

  // Level 1: chapter -- starts a new page, "Chapter N" above the title,
  // and resets the theorem counter so "Theorem 2.3" means "3rd
  // theorem-like environment in chapter 2".
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    thm-reset()
    v(1cm)
    if it.numbering != none {
      text(14pt)[Chapter #counter(heading).display("1")]
      v(0.6em)
    }
    text(20pt, strong(it.body))
    v(1cm)
  }

  // Level 2: section 
  show heading.where(level: 2): it => render-heading(it, 14pt, symbol: text(font: "Libertinus Serif")[#sym.section], space-above: 2.5em, space-below: 1.5em) 
 
  // Level 3: subsection
  show heading.where(level: 3): it => render-heading(it, 12pt, space-above: 2em, space-below: 1em)

  // Level 4: subsubsection unnumbered
  show heading.where(level: 4): it => render-heading(it, 12pt, numbered: false, space-above: 2em, space-below: 1em)
  
  body
}

/// tessa's link color scheme: navy for internal navigation (citations,
/// cross-references, TOC entries), teal for external URLs. A link's
/// `dest` is a string for URLs and a location for internal jumps.
///
/// Usage: `#show: tessa-link-style` (included in tessa() by default)
#let tessa-link-style(
  body
) = {
 // ---- Color for @cite, @ref, and tocs ----
  show cite: set text(navy)
  show ref: set text(navy)
  show outline.entry: set text(navy)
  
  // ---- External URLs
  show link: it => {
    if type(it.dest) == str {
      text(teal, it) // external
    } else {
      it             // internal
    }
  }
  body
}

/// Customize the style of references.
/// `style: auto` uses tessa's own CSL asset; any other value 
/// (built-in name or .csl path) passes through unchanged.
#let tessa-bib-style(
  title: "References",
  style: auto,
  full: false, // true -> list all entries even uncited
  body
) = {
  set bibliography(
    title: title,
    full: full,
    style: if style == auto {"../assets/tessa.csl"} else { style }
  )
  
  // Layout layer: smaller entries, DOI links in teal.
  // A show rule inside a show rule: the link styling is scoped to the
  // bibliography only — links elsewhere in the document are unaffected.
  show bibliography: it => {
    set text(10pt)
    show regex("DOI:"): set text(font: ("LMMono10", "DejaVu Sans Mono"))
    show link: set text(teal, font: ("LMMono10", "DejaVu Sans Mono"))
    it
  }
  body
}
