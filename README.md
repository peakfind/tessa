# tessa

**T**ypst **E**legant **S**tructured **S**tudy **A**rchive — a LaTeX-style
Typst template for lecture and study notes.

## Provided environments

| Function      | Style                          |
|---------------|--------------------------------|
| `#theorem`    | italic body, shared numbering  |
| `#lemma`      | italic body, shared numbering  |
| `#definition` | upright body, shared numbering |
| `#remark`     | upright body, shared numbering |
| `#proof`      | "Proof."                       |

All theorem-like environments share one counter, numbered per chapter
("Theorem 2.3" = 3rd theorem-like environment in chapter 2).

## Document structure

`tessa` produces a LaTeX-book-style document: title page, table of
contents (roman page numbers), then main matter with arabic numbering.

- `= Chapter` — starts a new page, resets theorem numbering
- `== Section`, `=== Subsection` — numbered `1.1`, `1.1.1`
- `==== Subsubsection` — unnumbered run-in heading
- `#heading(level: 1, numbering: none)[Preface]` — unnumbered chapter
  that still appears in the table of contents

## References

Keep a BibTeX file next to your document, cite with `@key`, and place
the bibliography at the end:

```typst
The presentation follows @rudin1976.

#bibliography("refs.bib")   // prints an unnumbered "References" chapter
```

## Fonts

| Role | Font | Why | Availability |
|------|------|-----|--------------|
| Body text | New Computer Modern | Unicode port of Computer Modern — the LaTeX look | bundled with Typst |
| Body fallback | Libertinus Serif | Typst's default serif | bundled with Typst |
| Math | New Computer Modern Math | Typst's default math font; matches the body | bundled with Typst |
| DOI in references | LMMono10 (Latin Modern Mono) | descendant of cmtt10 — LaTeX's `\texttt` | **system font — not bundled** |
| Code (`` `raw` ``) | DejaVu Sans Mono | Typst's built-in monospace | bundled with Typst |

Note: "bundled" means the font is embedded in the Typst binary and works
everywhere. LMMono10 comes from the operating system (e.g. macOS ships
Latin Modern), so on machines without it the DOI falls back to DejaVu
Sans Mono via the font fallback chain in `tessa-bib-style`.

## Development

```sh
just test      # compile the test document
just example   # compile template/main.typ
just bem       # live-preview notes/bem.typ
```

## Repository layout

```
src/lib.typ     the template itself
typst.toml      package manifest (entrypoint points into src/)
template/       starter document (used by `typst init`)
tests/          compile checks
notes/          real-world notes written with the template
```
