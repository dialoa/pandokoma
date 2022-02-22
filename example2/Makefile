all: tex pdf

tex: output.tex

pdf: output.pdf

output.tex: sample.md sample.yaml ../code/template.latex
	pandoc -s sample.md --metadata-file sample.yaml --template ../code/template.latex \
		--pdf-engine lualatex -o output.tex

output.pdf: sample.md sample.yaml ../pandokoma.latex
	pandoc -s sample.md --metadata-file sample.yaml --template ../code/template.latex \
		--pdf-engine lualatex -o output.pdf
