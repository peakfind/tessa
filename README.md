# tessa

**T**ypst **E**legant **S**tructured **S**tudy **A**rchive — a LaTeX-style
Typst template for lecture and study notes.

## Provided environments

| Function      | Style                          |
|---------------|--------------------------------|
| `#theorem`    | italic body, shared numbering  |
| `#lemma`      | italic body, shared numbering  |
| `#proposition`| italic body, shared numbering  |
| `#corollary`  | italic body, shared numbering  |
| `#definition` | upright body, shared numbering |
| `#example`    | upright body, shared numbering |
| `#remark`     | upright body, shared numbering |
| `#proof`      | "Proof." … □                   |

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
