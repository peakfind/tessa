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