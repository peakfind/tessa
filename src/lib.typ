// ============================================================
// tessa — a LaTeX-style template for lecture and study notes
// ============================================================
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
  // `locate` gives access to the current position in the document,
  // needed here to read the section number for "Theorem 2.3" style
  // numbering. In Typst 0.12+ this is written with `context`.
  context {
    // Read the current heading counter, e.g. (2, 1) for section 2.1.
    // (Named `hc`, not `h` — `h` is Typst's horizontal-space function!)
    let hc = counter(heading).get()
    let section = if hc.len() > 0 { str(hc.first()) + "." } else { "" }

    // Advance the shared theorem counter and read its new value.
    thm-counter.step()
    let n = thm-counter.display()

    block(
      width: 100%,
      inset: (top: 0.4em, bottom: 0.4em),
      {
        // Bold header: "Theorem 2.1 (name)". `strong` = bold.
        strong(kind + " " + section + n)
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

// ------------------------------------------------------------
// The main template function.
// Parameters with defaults are optional; the trailing `body`
// receives everything after `#show: tessa.with(...)` (the document).
// ------------------------------------------------------------
#let tessa(
  title: "Untitled Notes",
  author: "Anonymous",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  course: none,        // e.g. "MATH 251" — shown above the title
  body,
) = {
  // ---- Document metadata (used by PDF viewers) ----
  set document(title: title, author: author)

  // ---- Page setup ----
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    // Header/footer use `context` to access per-page info.
    header: context {
      if counter(page).get().first() > 1 {
        set text(9pt)
        emph(title)
        h(1fr)
        counter(page).display("1")
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

  // ---- Headings ----
  // Numbered "1.1.1" like LaTeX sections/subsections.
  set heading(numbering: "1.1.1")
  // A *show rule* restyles matching elements. Here: headings.
  // Level 1 headings get extra space and a slightly larger size.
  show heading.where(level: 1): it => {
    // Reset the theorem counter at each new section so numbers
    // like "Theorem 2.3" mean "3rd theorem in section 2".
    thm-counter.update(0)
    v(1.2em, weak: true)
    text(14pt, strong(it))
    v(0.4em, weak: true)
  }
  show heading.where(level: 2): it => {
    v(1em, weak: true)
    text(12.5pt, strong(it))
    v(0.3em, weak: true)
  }

  // ---- Title block (only on the first page, above the body) ----
  align(center)[
    #if course != none { text(10pt)[#smallcaps(course)]; v(0.5em) }
    #text(17pt, strong(title))
    #v(0.8em)
    #author \
    #text(10pt, date)
  ]
  v(1.5em)

  // ---- The user's document content goes here ----
  body
}
