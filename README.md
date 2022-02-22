# Pandokoma - versatile KOMA-script template for Pandoc

v0.9. Copyright: © 2022 Julien Dutant <julien.dutant@kcl.ac.uk>
License:  MIT - see LICENSE file for details.

Pandokoma is a versatile KOMA-script template for Pandoc. It provides
control for a large subset of the KOMA-script classes features directly
from a source document's metadata, such as:

- setting KOMA class options,
- full control of title pages, either via KOMA's commands 
  (`\frontispiece`, `\extratitle`, ...) or by directly providing 
  title code,
- title page templates,
- setting and defining new koma font styles,
- advanced control of page headers and footers,
- advanced control of division headings style and spacing,
- redefining footnote style,
- defining colors,
- loading a range of LaTeX packages (`multicol`, `nowidow`, `bussproofs`, ...)
- and more.

These are controlled by YAML metadata fields. For instance, a new
font style `headerauthor` can be defined thus:

```yaml
newkomafont:
- element: headerauthor
  font: 'Libertinus Serif'
  fontoptions: 'Numbers=OldStyle'
  command: \scshape
```

Left-page headers can then be set to display 'Jane Doe' in that font with the `lehead` field:

```yaml
lehead: \usekomafont{headauthor}Jane Doe
```

This repository provides the template ([pandokoma.latex](pandokoma.latex)),
a lighter alternative that doesn't include title templates 
([pandokoma-bare.latex](pandokoma.latex)) and some examples of use.

The repository is under MIT License: you can copy, use and modify it 
as you wish, provided you mention its copyright and license. 
See LICENSE for details. 

Contributions and bug reports are welcome. 

## Introduction

[KOMA-script](https://www.ctan.org/pkg/koma-script?lang=en) is a bundle 
of classes and packages developed by Markus Kohm for good typography 
and versatile typesetting. They are included in standard LaTeX 
distributions and [extensively documented](http://mirrors.ctan.org/macros/latex/contrib/koma-script/doc/scrguien.pdf)
([in German](http://mirrors.ctan.org/macros/latex/contrib/koma-script/doc/scrguide.pdf) too). They notably include the `scrartcl`, `scrbook` and
`scrreport` document classes to typeset articles, books and reports.

[Pandoc](https://pandoc.org/MANUAL.html) is a universal document 
converter that allows you (inter alia) to write documents in markdown 
and convert them to various output formats, including PDF via LaTeX. 

Pandoc can already use the KOMA classes when converting documents
to LaTeX or PDF outputs, and give [some control over LaTeX
typesetting options](https://pandoc.org/MANUAL.html#variables-for-latex),
such as `fontsize`, `lang`, `mainfont` `mathfont`, `papersize`, etc.
But these only cover a small subset of what the KOMA classes can do.
For an advanced typesetting project like a monograph,
an academic article, or even a PhD thesis, more detailed control
is needed. With Pandoc alone the only way to do this is by
introducing LaTeX code in the source document (or associated
metadata file).

Pandokoma provides a advanced control of KOMA's 
typesetting features using the source document's metavariables. 
If the source is in markdown, features can be specified through its 
[YAML metadata block](https://pandoc.org/MANUAL.html#metadata-blocks)], 
just like the title, author etc. Alternatively, they can be
specified in a separate [separate YAML file](https://pandoc.org/MANUAL.html#option--metadata-file). Pandokoma also
provides ready-made title page templates. 

See the [pandokoma-configuration.yaml file](pandokoma-configuration.yaml)
for the detail of options that the template provides.

## Basic usage

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

Out of the box, your document will be typeset using KOMA's article
class `scrartcl` with a default look and feel. 

KOMA options are specified through the source document's 
"metadata variables". With a markdown source these can 
be set with a [YAML metadata preamble](https://pandoc.org/MANUAL.html#metadata-blocks) in the document itself. 
Alternatively, they can be provided through a [separate YAML file](https://pandoc.org/MANUAL.html#option--metadata-file):

```bash
pandoc --standalone source.md --template path/to/pandokoma.latex 
--metadata-file path/to/source-style.yaml --output output.pdf
```

__Detail of available options, along with examples__ are in the [`pandokoma-configuration.yaml`](pandokoma-configuration.yaml) file. 
It is recommended to design your own metadata file by copying relevant
sections of the configuration file into your own metadata file. 
But there is no need to use this `yaml` file in addition to yours:
the template alone sets all the default options. 

For further examples of configurations see the `sample.yaml` files 
in this repository's example folders.

__Warning: `documentclass` disabled__. Pandokoma ignores
the `documentclass` variable and applies KOMA's article
class `scrartcl` by default. To set another document class 
(`scrbook`, or a even non-KOMA class like `Memoir`), use
the `komaclass` metavariable:

```
komaclass: scrreprt
```

However if you're using a non-article class it's still 
useful to let Pandoc know via the `documentclass` variable,
as this will automatically set the level 1 headings to 
chapters:

```
komaclass: scrbook
documentclass: scrbook
```

This could be used to trigger a different class when 
compiling with Pandoc's own LaTeX template vs Pandokoma:

```
documentclass: book # use the standard LaTeX book class with Pandoc's template
komaclass: scrbook # use KOMA's `scrbook` class with Pandokoma
```

(This behaviour was necessary to ensure that the KOMA article 
class would be applied if no document class is specified. 
Pandoc sets the variable `documentclass` to `article` 
when the user doesn't specify it and there is no way for
the template to examine whether this variable has been
set by the user to some other value. Hence to ensure that
a KOMA class is applied by default and the user's favoured
class otherwise, it was necessary to introduce a 
new `komaclass` field.)

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
in the metadata. See [`pandokoma-configuration.yaml`](pandokoma-configuration.yaml) for details.

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

Running the `make` file will also compile `sample.md` files contained
in each `exampleXXX/` folder. Each `sample.md` much be accompanied with
a non-empty `sample.yaml` file. If you have no need for such a file simply
paste the following into an empty text file and save it as `sample.yaml`:

```
dummyvariable: false
```

Use `make tex` to compile the LaTeX output only (faster than PDF).

Instead of rebuilding `pandokoma-latex` each time, you can set use
`template.latex` directly as a document template, *provided* the
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