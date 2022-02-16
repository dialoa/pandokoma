# Pandokoma - versatile KOMA-script template for Pandoc

v0.9. Copyright: © 2022 Julien Dutant <julien.dutant@kcl.ac.uk>
License:  MIT - see LICENSE file for details.

Pandokoma is a versatile KOMA-script template for Pandoc. It aims at 
providing control of most of KOMA-script advanced typesetting options:

- setting KOMA class options,
- full control of title pages, either via KOMA's commands 
  (`\frontispiece`, `\extratitle`, ...) or by directly providing 
  title code,
- predefined templates for title pages, with the possibility of 
  defining your own,
- setting and defining new koma font styles,
- advanced control of page headers and footers,
- advanced control of division headings style and spacing,
- redefining footnote style,
- and more.

These are controlled by YAML metadata fields. For instance, a new
font style `headerauthor` can be defined with:

```yaml
newkomafont:
- element: headerauthor
  font: 'Libertinus Serif'
  fontoptions: 'Numbers=OldStyle'
  command: \scshape
```

Left-page headers can then be set to display 'Jane Doe' in that font with:

```yaml
lehead: \usekomafont{headauthor}Jane Doe
```

This repository provides the template and various examples of its use
to produce articles, theses, books, multi-author books and academic
journals.

The repository is under MIT License: you can copy, use and modify it 
as you wish, provided you mention its copyright and license. 
See LICENSE for details. 

Contributions and bug reports are welcome. Contributions can be 
further options controls in the template, new title page templates
and more examples. 

## Description

[KOMA-script](https://www.ctan.org/pkg/koma-script?lang=en) is a bundle 
of classes and packages developed by Markus Kohm for good typography 
and versatile typesetting. They are included in standard LaTeX 
distributions and [extensively documented](http://mirrors.ctan.org/macros/latex/contrib/koma-script/doc/scrguien.pdf)
([in German](http://mirrors.ctan.org/macros/latex/contrib/koma-script/doc/scrguide.pdf) too).

[Pandoc](https://pandoc.org/MANUAL.html) is a universal document 
converter that allows you (inter alia) to write documents in markdown 
and convert them to various output formats, including PDF via LaTeX.
KOMA-script classes can be used with Pandoc by setting your document's
metadata variable `documentclass` to one of the KOMA classes. From the
command line:

```bash
pandoc --standalone source.md --M documentclass=scrbook --output output.pdf
```

Or within [your markdown's document YAML metadata block](https://pandoc.org/MANUAL.html#metadata-blocks):

```yaml
---
documentclass: scrbook
---
```

Pandoc uses a template to convert your source document to LaTeX output. 
If your source is in markdown, it can include a metadata block; if not,
metadata can still be provided in a [separate YAML file](https://pandoc.org/MANUAL.html#option--metadata-file). Pandoc's default template uses
[some metadata fields to control LaTeX output](https://pandoc.org/MANUAL.html#variables-for-latex), e.g. `fontsize`, `lang`, `mainfont`
`mathfont`, `papersize`, etc. 

Pandokoma greatly extends Pandoc's default template to provide control
of most of the KOMA-script options. For novice users it provides
default templates with simple fields suited for a thesis, report or
simple book. For advanced users it provides the ability to control
most of the document's typesetting, from title pages and table of
contents to page headers and footers, chapter titles, section 
headings and custom font styles. 

## Usage



# Advice

Sometimes you want to set a field, but give it an empty value.
For instance, you may want to redefine the LaTeX command
`\sectionmarkformat` to be empty, in order to remove section 
numbers in page headers marks. We do this by setting the 
`sectionmarkformat` metadata key. The following won't work,
however, because they are equivalent to *not* setting any
value for that key: 

```yaml
sectionmarkformat:
sectionmarkformat: false
sectionmarkformat: ''
sectionmarkformat: ' ' 
```

Instead, you should set the key to the LaTeX `\relax` command
that does nothing:

```yaml
sectionmarkformat: \relax
```

The template converts this to the LaTeX code:

```latex
\renewcommand{\sectionmarkformat}{\relax}
```

Which gives the desired result. (Note, a baacklashed escaped
space `\ ` won't work: if alone in a yaml metadata field the last
space seems to be ignored and it's interpreted as a backslash,
 `\textbackslash{}` in LaTeX.)

 ## Credits

 Pandokoma is based on:

* pandoc's default latex template by John MacFarlane <https://pandoc.org/>
* arabica by Martin Maga <https://github.com/periodicpoint/arabica>
* pandoc-latex-template by Pascal Wagler <https://github.com/Wandmalfarbe/pandoc-latex-template>
* pandoc KOMA template by Karl Voigt <https://github.com/novoid/LaTeX-KOMA-template>