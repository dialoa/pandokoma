SOURCES = $(wildcard *.yaml)
TARGETS_TEX = $(patsubst %.yaml,%.tex,$(wildcard *.yaml))
TARGETS_PDF = $(patsubst %.yaml,%.pdf,$(wildcard *.yaml))
engine = lualatex # use `make article.pdf engine=pdflatex` to change

all: tex pdf

tex: $(TARGETS_TEX)

pdf: $(TARGETS_PDF)

$(TARGETS_TEX): %.tex : %.yaml source.md ../src/template.latex
	pandoc -s --metadata-file $< --template ../src/template.latex \
		source.md -o $@ 

$(TARGETS_PDF):  %.pdf : %.yaml source.md ../src/template.latex
	pandoc -s --metadata-file $< --template ../src/template.latex \
		source.md -o $@ --pdf-engine $(engine)

clean:
	@echo "Cleaning pdf and tex files"
	@rm *.pdf *.tex
