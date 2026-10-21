# justfile — task runner for the tessa template.
# Install just with:  brew install just
# List recipes with:  just --list

# Default recipe (runs when you type bare `just`)
default:
    @just --list

# Compile the test document to check the template still works
test:
    typst compile --root . tests/test.typ tests/test.pdf

# Compile the template's example document
example:
    typst compile --root . template/main.typ template/main.pdf

# Watch and recompile the BEM notes on every save
bem:
    typst watch --root . notes/bem.typ notes/bem.pdf

# Compile the BEM notes once
bem-once:
    typst compile --root . notes/bem.typ notes/bem.pdf

# Update the thumbnail from the example's first page
thumbnail:
    typst compile --root . --format png --pages 1 template/main.typ thumbnail.png

# Remove all generated files (PDFs and the thumbnail)
clean:
    rm -f tests/test.pdf template/main.pdf notes/bem.pdf thumbnail.png
