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

#import "_pages.typ": title-page
#import "_style.typ": tessa-bib-style, tessa-link-style
#import "_theorems.typ": theorem, lemma, definition, remark, proof, thm-reset

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
  
  show: tessa-link-style
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
    thm-reset()
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
