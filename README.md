# tessa

A LaTeX-style Typst template for lecture and study notes.

## Usage

```typst
#import "@local/tessa:0.1.0": *

#show: tessa.with(
  title: "My Course Notes",
  author: "Your Name",
  course: "MATH 301",   // optional
)

= First Section

#theorem(title: "Optional Name")[
  Statement of the theorem.
]

#proof[
  Proof goes here; a QED square is added automatically.
]
```

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

All theorem-like environments share one counter, numbered per section
("Theorem 2.3" = 3rd theorem-like environment in section 2).

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
