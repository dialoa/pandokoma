### Build the full template by inserting title templates
### where the $titletemplate-X()$ commands are.
### Also build a barebones template without the title
### templates code.
TITLE_TEMPLATES_FILES := $(wildcard code/titletemplate-*.latex)
TITLE_TEMPLATES := $(patsubst code/%.latex,%,${TITLE_TEMPLATES_FILES})
SEDMERGE := $(foreach NAME,$(TITLE_TEMPLATES),-e '/\$$$(NAME)()\$$/r code/$(NAME).latex' -e '/\$$$(NAME)()\$$/d')
SEDCLEAN := $(foreach NAME,$(TITLE_TEMPLATES),-e '/\$$$(NAME)()\$$/d')
### We apply to test files
TESTFILES := $(wildcard example*/sample.md)

all: build test

build: pandokoma.latex pandokoma-bare.latex

pandokoma.latex: code/template.latex ${TITLE_TEMPLATES_FILES}
	@sed $(SEDMERGE) $< > $@

pandokoma-bare.latex: code/template.latex
	@sed $(SEDCLEAN) $< > $@

test: tex pdf

tex: $(TESTFILES:md=tex) 

pdf: $(TESTFILES:md=pdf) 

$(TESTFILES:md=tex): $(TESTFILES) $(TESTFILES:md=yaml) pandokoma.latex
	pandoc -s --template pandokoma.latex --metadata-file $(@:tex=yaml) \
	$< --output $@

$(TESTFILES:md=pdf): $(TESTFILES) $(TESTFILES:md=yaml)
	pandoc -s --template pandokoma.latex --metadata-file $(@:tex=yaml) \
	$< --output $@