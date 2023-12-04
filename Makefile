### Build the full template by inserting title templates
### where the $titletemplate-X()$ commands are.
### Also build a barebones template without the title
### templates code.
TITLE_TEMPLATES_FILES := $(wildcard src/titletemplate-*.latex)
TITLE_TEMPLATES := $(patsubst src/%.latex,%,${TITLE_TEMPLATES_FILES})
SEDMERGE := $(foreach NAME,$(TITLE_TEMPLATES),-e '/\$$$(NAME)()\$$/r code/$(NAME).latex' -e '/\$$$(NAME)()\$$/d')
SEDCLEAN := $(foreach NAME,$(TITLE_TEMPLATES),-e '/\$$$(NAME)()\$$/d')

### Tests
### use `make tests/article.pdf engine=pdflatex` for individual tests
SOURCE = tests/source.md
TEMPLATE = src/template.latex
TESTS = $(wildcard tests/*.yaml)
TARGETS_TEX = $(patsubst %.yaml,%.tex,$(wildcard tests/*.yaml))
TARGETS_PDF = $(patsubst %.yaml,%.pdf,$(wildcard tests/*.yaml))
engine = lualatex 

.PHONY: help
help:
	@echo "Usage: make OPTION"
	@echo "		all			build and test" 
	@echo "		build		build from source" 
	@echo "		test		run all tests" 
	@echo "		testtex		run tests with tex output" 
	@echo "		testpdf		run tests with pdf output"
	@echo "		clean		clean tex and pdf files"
	@echo "Usage: make tests/article.pdf pdfengine=pdflatex for specific tests" 

.PHONY: all
all: build test

.PHONY: test
test: testtex testpdf

testtex: $(TARGETS_TEX)

testpdf: $(TARGETS_PDF)

$(TARGETS_TEX): %.tex : %.yaml $(SOURCE) $(TEMPLATE)
	pandoc -s --metadata-file $< --template $(TEMPLATE) \
		$(SOURCE) -o $@ 

$(TARGETS_PDF):  %.pdf : %.yaml $(SOURCE) $(TEMPLATE)
	pandoc -s --metadata-file $< --template $(TEMPLATE) \
		$(SOURCE) -o $@ --pdf-engine $(engine)

clean:
	@echo "Cleaning pdf and tex files"
	@rm $(TARGETS_TEX) $(TARGETS_PDF)

.PHONY: build
build: pandokoma.latex pandokoma-bare.latex

pandokoma.latex: src/template.latex ${TITLE_TEMPLATES_FILES}
	@sed $(SEDMERGE) $< > $@

pandokoma-bare.latex: src/template.latex
	@sed $(SEDCLEAN) $< > $@
