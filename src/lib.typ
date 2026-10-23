// ============================================================
// tessa — Typst Elegant Structured Study Archive
// A LaTeX-book-style template for lecture and study notes.
// ============================================================
//
// Document structure produced by this template:
//
//   1. Title page        (no header, page number hidden)
//   2. Table of contents (front matter, pages numbered i, ii, ...)
//   3. Main matter       (chapters etc., pages restart at 1, 2, ...)
//   4. Bibliography      (placed by the user with #bibliography(...))
//
// Heading depth, following LaTeX's book-class defaults:
//
//   = Chapter          "Chapter 1", starts a new page, resets theorems
//   == Section         numbered 1.1
//   === Subsection     numbered 1.1.1
//   ==== Subsubsection NOT numbered (like LaTeX's \paragraph)
//
// How a Typst template works:
//   A template is just a *function* that takes the document body
//   and returns it wrapped in styling rules. The user writes:
//
//     #show: tessa.with(title: "Linear Algebra")
//
//   `tessa.with(...)` produces a new function with the arguments
//   filled in; `#show:` applies it to the whole document.

// ------------------------------------------------------------
// Counter shared by all theorem-like environments, so that
// "Theorem 3" and "Definition 4" share one numbering sequence
// (like amsthm's default). Counters in Typst are stateful and
// advance via `counter.step()` or `counter.update(n + 1)`.
// ------------------------------------------------------------
#let thm-counter = counter("thm")

// ------------------------------------------------------------
// Helper: one theorem-like environment ("Theorem", "Definition", ...).
// `kind`  — the displayed name, e.g. "Theorem"
// `style` — "plain" (italic body, like amsthm) or "definition" (upright)
// Everything in Typst is *content*; functions return content.
// ------------------------------------------------------------
#let thm-env(kind, style, supplement: none, body) = {
  // `context` gives access to document state at the current position,
  // needed here to read the chapter number for "Theorem 2.3" style
  // numbering.
  context {
    // Read the current heading counter, e.g. (2, 1) for chapter 2,
    // section 1. (Named `hc`, not `h` — `h` is Typst's spacing function!)
    let hc = counter(heading).get()
    let chapter = if hc.len() > 0 { str(hc.first()) + "." } else { "" }

    // Advance the shared theorem counter and read its new value.
    thm-counter.step()
    let n = thm-counter.display()

    block(
      width: 100%,
      inset: (top: 0.4em, bottom: 0.4em),
      {
        // Bold header: "Theorem 2.1 (name)". `strong` = bold.
        strong(kind + " " + chapter + n)
        if supplement != none { strong[ (#supplement)] }
        strong[.]
        h(0.5em) // `h` = horizontal space
        if style == "plain" {
          emph(body) // italic body, amsthm's "plain" style
        } else {
          body
        }
      },
    )
  }
}

// The public environments the user calls in their document.
// Each is a thin wrapper; `title` is the optional parenthesized name.
#let theorem(title: none, body) = thm-env("Theorem", "plain", supplement: title, body)
#let lemma(title: none, body) = thm-env("Lemma", "plain", supplement: title, body)
#let corollary(title: none, body) = thm-env("Corollary", "plain", supplement: title, body)
#let proposition(title: none, body) = thm-env("Proposition", "plain", supplement: title, body)
#let definition(title: none, body) = thm-env("Definition", "definition", supplement: title, body)
#let example(title: none, body) = thm-env("Example", "definition", supplement: title, body)
#let remark(title: none, body) = thm-env("Remark", "definition", supplement: title, body)

// ------------------------------------------------------------
// Proof environment: italic "Proof." followed by the body, ending
// with an open QED square pushed to the right margin — like amsthm.
// ------------------------------------------------------------
#let proof(body) = {
  block(
    width: 100%,
    inset: (top: 0.4em, bottom: 0.4em),
    {
      emph[Proof.]
      h(0.5em)
      body
      // `h(1fr)` is a spring: it expands to fill remaining space,
      // pushing the square to the right edge.
      h(1fr)
      $square.stroked$
    },
  )
}

/// Renders a standalone cover page (no header) with title, author,
/// optional institute, and date. All text parameters accept content.
#let title-page(
  date,
  title: "TBD",
  author: "Anonymous",
  institute: none,
) = {
  { // block scope: page settings revert after the cover
    set page(header: none)
    v(2.5cm)
    align(center)[
      #text(24pt, strong(title))
      #v(2.5em)
      #text(12pt, strong(author)) \
      #if institute != none { text(12pt, institute); linebreak() }
      #v(1em)
      #text(11pt, date)
    ]
  }
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

// ------------------------------------------------------------
// The main template function.
// Parameters with defaults are optional; the trailing `body`
// receives everything after `#show: tessa.with(...)` (the document).
// ------------------------------------------------------------
#let tessa(
  title: "Untitled Notes",
  author: "Anonymous",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  institute: none,       
  toc: true,           // whether to include a table of contents
  body,
) = {
  // ---- Document metadata (used by PDF viewers) ----
  set document(title: title, author: author)

  // ---- Page setup ----
   set page(
     paper: "a4",
     margin: (x: 2.5cm, y: 2.5cm),
     // Header/footer use `context` to access per-page info.
     // counter(page).display() with no argument respects the page's
     // `numbering` setting, so front matter shows i, ii and the main
     // matter shows 1, 2 automatically.
     header: context {
       if counter(page).get().first() > 1 {
         set text(9pt)
         emph(title)
         h(1fr)
         counter(page).display()
         v(-0.6em)
         line(length: 100%, stroke: 0.4pt)
       }
     },
   )

  // ---- Text setup ----
  // New Computer Modern is the open-source Computer Modern —
  // the classic LaTeX font. Falls back to Typst's default if missing.
  set text(font: ("New Computer Modern", "Libertinus Serif"), size: 11pt, lang: "en")
  set par(justify: true, leading: 0.65em)

  // ---- Math ----
  set math.equation(numbering: "(1)")

  // ---- Bibliography ----
  set bibliography(title: "References")

  // ---- Headings ----
  // Number chapters, sections, subsections — but not deeper.
  set heading(numbering: "1.1.1")

  // Chapter (level 1): starts a new page, "Chapter N" above the title,
  // and resets the theorem counter so "Theorem 2.3" means "3rd
  // theorem-like environment in chapter 2".
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    thm-counter.update(0)
    v(1cm)
    if it.numbering != none {
      text(14pt)[Chapter #counter(heading).display("1")]
      v(0.6em)
    }
    text(20pt, strong(it.body))
    v(1cm)
  }

  // Section (level 2) and subsection (level 3): sized like LaTeX.
  // `it` renders the heading with its number automatically.
  show heading.where(level: 2): it => {
    v(1em, weak: true)
    text(14pt, strong(it))
    v(0.4em, weak: true)
  }
  show heading.where(level: 3): it => {
    v(0.8em, weak: true)
    text(12pt, strong(it))
    v(0.3em, weak: true)
  }

  // Subsubsection (level 4): unnumbered bold run-in heading.
  show heading.where(level: 4): it => {
    v(0.6em, weak: true)
    strong(it.body)
    v(0.2em, weak: true)
  }

  // ---- Title page ----
  title-page(date, title: title, author: author, institute: institute)

  // ---- Front matter: table of contents ----
  // Roman page numbers here; arabic numbering restarts at the first
  // chapter below.
  if toc {
    {
      set page(numbering: "i")
      outline(title: [Contents], depth: 3, indent: auto)
    }
  }

  // Start the main matter: new page, page counter back to 1.
  // The chapter show rule's `pagebreak(weak: true)` means we won't get
  // a second, empty page before Chapter 1.
  pagebreak(weak: true)
  counter(page).update(1)

  // ---- The user's document content goes here ----
  body
}
