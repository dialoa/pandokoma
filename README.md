# Pandokoma - versatile KOMA-script template for Pandoc

Pandokoma is a powerful and versatile KOMA-script template for Pandoc. 

Version 0.9.5. Compatible with Pandoc 3.5. 

Copyright 2022-24 Philosophie.ch. License:  MIT - see LICENSE file for details.

Written by Julien Dutant <https://github.com/jdutant>

## Introduction

Pandokoma provides control for a large subset of the KOMA-script
classes features directly from a source document's metadata, such
as:

- setting and defining KOMA font styles
- typesetting division headings 
- typesetting page headers and footers
- typesetting table of content entries
- redefining footnote styles
- defining custom colours
- typesetting title pages - either via KOMA's commands 
  (`\frontispiece`, `\extratitle`, ...) or by directly providing 
  LaTeX code for title pages,
- loading LaTeX packages
- and more.

These are controlled by YAML metadata fields. For instance, the following
defines a new `headerauthor` font style and specifies verso (left-side)
page headers to display the name "Jane Doe" in that style:

```yaml
newkomafont:
- element: headerauthor
  font: 'Libertinus Serif'
  fontoptions: 'Numbers=OldStyle'
  command: \scshape

lehead: \usekomafont{headauthor}Jane Doe
```

See below for more examples or look at the 
[pandokoma-options.yaml](pandokoma-options.yaml) file to see
 all the available options. 

__Quick start__. Download the [pandokoma.latex](pandokoma.latex) file, 
place it next to your source document, and run Pandoc on your
document with that template:

```bash
pandoc --standalone source.md --output destination.pdf --template pandokoma.latex 
```

Add the option `--metadata-file mystylefile.yaml` if you want to read the 
options from a separate yaml file instead. Several examples can
be found in this repository.

Most of the template options require your document to be one of
the KOMA-script classes `scrartcl` (article), `scrbook` (book)
or `scrreprt` (report), so your metavariables should contain:

```yaml
documentclass: scrartcl
```

Advanced font options will typically require using LuaLaTeX or XeLaTeX 
as PDF generator. Use the `--pdf-engine` option, e.g:

```bash
pandoc -s source.md -o destination.pdf --template pandokoma.latex --pdf-engine lualatex --metadata-file mystylefile.yaml
```

__Repository overview__. This repository contains:

1. [pandokoma.latex](pandokoma.latex) the main template.
2. [pandokoma-bare.latex](pandokoma-bare.latex) a lighter alternative
  that doesn't include titlepage templates. 
3. `example` folders containing various example uses.
4. `code` folder that contains the source code for the template. The
  `template.latex` file can be used as template, but it is dependent
  on the associated title template files (called as 'partials'). 
  The root Makefile builds the self-standing `pandokoma.latex` from those.

The repository is under MIT License: you can copy, use and modify it 
as you wish, provided you mention its copyright and license. 
See LICENSE for details. 

Contributions, bug reports, PR are welcome. Possible contributions:
- more examples of use
- title page templates
- documentation
- extensions of the template

## Description

### Background on Pandoc, LaTeX/PDF and KOMA-script classes

[Pandoc](https://pandoc.org/MANUAL.html) is a universal document 
converter that can (inter alia) generate PDF outputs via LaTeX. 

[KOMA-script](https://www.ctan.org/pkg/koma-script?lang=en) is a bundle 
of LaTeX document classes and packages developed by Markus Kohm for good typography and versatile typesetting. They are included in standard LaTeX 
distributions and [extensively documented](http://mirrors.ctan.org/macros/latex/contrib/koma-script/doc/scrguien.pdf)
([in German](http://mirrors.ctan.org/macros/latex/contrib/koma-script/doc/scrguide.pdf) too). They notably include the `scrartcl`, `scrbook` and
`scrreport` document classes to typeset articles, books and reports.

Pandoc already affords some control of PDF output typesetting
via a source document's `metavariables`. If a source is in [markdown
format](https://pandoc.org/MANUAL.html#pandocs-markdown), these can be specified in a [metadata block in YAML format](https://pandoc.org/MANUAL.html#metadata-blocks)] at the beginning of the document, e.g.:

```yaml
---
title: My Oeuvre
author: Seymour Buttz
date: Feb 22th, 2022
documentclass: book
mainfont: Libertinus Serif
mathfont: Libertinus Math
fontsize: 12pt 
---
```

Alternatively (and in particular, when the source isn't in markdown),
the YAML block above can be placed in separate text file, e.g. `sytle.yaml`, given to Pandoc via the command line option `--metadata-file`. 
Pandoc can combine metadata in the source (like author and title) with
metadata in a separate YAML file (like typesetting options). 

In particular, Pandoc can use the KOMA classes when converting
document to LaTeX/PDF output. It gives [some control over LaTeX
typesetting options](https://pandoc.org/MANUAL.html#variables-for-latex),
such as `fontsize`, `lang`, `mainfont` `mathfont`, `papersize`, etc.
But these only cover a small subset of what the KOMA classes can do.
For an advanced typesetting project like a monograph,
an academic article, or even a PhD thesis, more detailed control
is needed. With Pandoc alone the only way to do this is by
introducing LaTeX code in the source document (or associated
metadata file).

### The Pandokoma template

Pandokoma greatly extends Pandoc's ability to control the
design of LaTeX/PDF outputs from metavariable options. 
The YAML syntax for metavariable options is much more
legibile and easy to learn that LaTeX. While you will
probably need to know LaTeX and the KOMA-script user
documentation for advanced projects, you should be 
able to learn a lot already by looking at the
examples here. 

Pandoc uses [Pandoc template files](https://pandoc.org/MANUAL.html#templates) 
to convert documents to various text-based output formats.
Its template for LaTeX output (which is then converted
into PDF) can be seen by running:

```bash
pandoc -D latex > pandoc-default-template.latex
```

Pandoc template files can make use of a document's 
metavariables. Pandoc's default LaTeX template already
takes into account of a number of metavariable fields
such as `documentclass`, `fontsize`, `mainfont`,
`mathfont`, `papersize`, etc. But it can't do more advanced
design such as the content of headers and footers, 
footnote style, specific heading fonts, title page
elements beyond author, title and date. 

For more advanced typesetting, your options would be
(a) editing Pandoc's LaTeX ouput, (b) introducing
large blocks of LaTeX code in your document 
(either directly or in Pandoc's `header-include` 
field) or (c) writing your
own Pandoc template. Option (a) is impractical if you
update your document. Option (b) is limited and 
not readable. Option (c) requires a good
knowledge of both LaTeX and the Pandoc template
syntax. Pandoc template syntax is simple^[Though 
writing Pandoc templates for LaTeX can be tricky. For 
instance, you will get mysterious "perhaps \\item missing"
errors if you have newlines within LaTeX square-bracketed
command options.], but it doesn't make for very legibile
documents and a LaTeX template will require you to
go over much more LaTeX detail than you would
need just for the design. 

Enter Pandokoma. Pandokoma is an alternative to 
Pandoc's default LaTeX template. While it 
offers some ready-made title templates, 
its main emphasis is on 
versatility: it is meant to open up most of
the KOMA-script classes design options to be
set via a document's metavariables. This means 
that instead of writing a new Pandoc template 
running to 500+ lines of mixed LaTeX/Pandoc 
template syntax, you can specify a fine-grained 
PDF design in a shorter and much more legible 
YAML file.

For advanced control of the design you will still need
to be familar with LaTeX and the 
[KOMA-script user guide](https://www.ctan.org/pkg/koma-script?lang=en).
But you can already understand and achieve a lot by 
working from the example files here. 

## Usage

Download one of the template files [`pandokoma.latex`](pandokoma.latex) 
or [`pandokoma-bare.latex`](pandokoma.latex).

* `pandokoma.latex` is the full template, including title page
  templates
* `pandokoma-bare.latex` is a lighter version without title 
  page templates.

Place it in your document's folder, Pandoc's data 
directory, or some other folder. Call Pandoc on 
your source while specifying the new template:

```bash
pandoc --standalone source.md --template path/to/pandokoma.latex --output output.pdf
```

KOMA options are specified through the source document's 
"metadata variables". With a markdown source these can 
be set with a [YAML metadata preamble](https://pandoc.org/MANUAL.html#metadata-blocks) in the document itself. 
Alternatively, they can be provided through a [separate YAML file](https://pandoc.org/MANUAL.html#option--metadata-file):

```bash
pandoc --standalone source.md --template path/to/pandokoma.latex 
--metadata-file path/to/source-style.yaml --output output.pdf
```

Most of the template options require you to use one of the KOMA-script
document classes `scrartcl` (article), `scrbook` (book)
or `scrreprt` (report). You can specify this through your source
 document's metavariables (either in the document itself, or
 as separate file): 

```yaml
documentclass: scrartcl
```

Or give it to Pandoc's via the `-M` command line option:

```bash
pandoc -s source.md --template path/to/pandokma.latex -M documentclass=scrartcl -o output.pdf
```

__Detail of available options, along with examples__ are in the [`pandokoma-options.yaml`](pandokoma-options.yaml) file. 
It is recommended to design your own metadata file by copying relevant
sections of the configuration file into your own metadata file. 
But there is no need to use this `yaml` file in addition to yours:
the template alone sets all the default options. 

For further examples of configurations see the `sample.yaml` files 
in this repository's example folders.

__Title templates__ are activated with a `titletemplate-X`
variable:

```yaml
titletemplate-A: true
```

You can create your own title template as `titletemplate-custom`,
either by modifying `pandokoma.latex` directly or by modifying
`titletemplate-custom.latex` and recompiling `pandokoma`
(see [Customizing and contributing](#customizing-and-contributing) below).
Raw LaTeX code for title pages can also be provided directly
in the metadata. See [`pandokoma-options.yaml`](pandokoma-options.yaml) for details.

## Advanced usage

### Setting a field with an empty value

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

### Modifying the template and adding new title templates

The template is written in 
[Pandoc's template syntax](https://pandoc.org/MANUAL.html#template-syntax).
The [KOMA class user guide](https://www.ctan.org/pkg/koma-script) and the 
[Pandoc manual](https://pandoc.org/MANUAL.html) will be useful.

Running the `make` (or `make build`) command at the root of this 
repository will compile the `pandokoma.latex` and `pandokoma-bare.latex`
files from the source files in `code`. The source files are:

* `template.latex`, the main template.
* `titletemplate-X.latex` title template files.


Instead of rebuilding `pandokoma-latex` each time, you can tell Pandoc
to use `code/template.latex` directly as a document template, *provided* the
title template files are copied next to it. It calls them as 
template 'partials' (cf. [Pandoc's template syntax](https://pandoc.org/MANUAL.html#template-syntax)).

The `titletemplate-custom.latex` file can be used to develop
a new title template. It is activated by setting
 `titletemplate-custom: true` in the source's metadata.

To provide further title templates than A, B add to the 
following lines in `template.latex`:

```
$elseif(titletemplate-custom)$
  $titletemplate-custom()$
$elseif(titletemplate-A)$
  $titletemplate-A()$
$elseif(titletemplate-B)$
  $titletemplate-B()$
```

For example:

```
...
$elseif(titletemplate-B)$
  $titletemplate-B()$
$elseif(titletemplate-tufte)$
  $titletemplate-tufte()$
$elseif(titletemplate-modern-thesis)$
  $titletemplate-modern-thesis()$  
```

The `make build` command will find these lines and insert the corresponding
files `titletemplate-tufte.latex`, etc. in the final `pandokoma.latex`. 

## Contributing

PRs welcome: improvements on the main template, title templates, examples.

## Credits

Pandokoma is based on:

* pandoc's default latex template by John MacFarlane <https://pandoc.org/>
* arabica by Martin Maga <https://github.com/periodicpoint/arabica>
* pandoc-latex-template by Pascal Wagler <https://github.com/Wandmalfarbe/pandoc-latex-template>
* pandoc KOMA template by Karl Voigt <https://github.com/novoid/LaTeX-KOMA-template>
