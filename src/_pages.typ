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
