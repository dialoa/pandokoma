### Build the full template by inserting title templates
### where the $titletemplate-X()$ commands are.
### Also build a barebones template without the title
### templates code.
TITLE_TEMPLATES_FILES := $(wildcard src/titletemplate-*.latex)
TITLE_TEMPLATES := $(patsubst src/%.latex,%,${TITLE_TEMPLATES_FILES})
SEDMERGE := $(foreach NAME,$(TITLE_TEMPLATES),-e '/\$$$(NAME)()\$$/r code/$(NAME).latex' -e '/\$$$(NAME)()\$$/d')
SEDCLEAN := $(foreach NAME,$(TITLE_TEMPLATES),-e '/\$$$(NAME)()\$$/d')

all: build

build: pandokoma.latex pandokoma-bare.latex

pandokoma.latex: src/template.latex ${TITLE_TEMPLATES_FILES}
	@sed $(SEDMERGE) $< > $@

pandokoma-bare.latex: src/template.latex
	@sed $(SEDCLEAN) $< > $@
