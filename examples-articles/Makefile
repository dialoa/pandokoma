all: tex pdf

tex: plain.tex

pdf: plain.pdf

plain.tex: plain.md plain.yaml ../code/template.latex
	pandoc -s plain.md --metadata-file plain.yaml --template ../code/template.latex \
		-o plain.tex

plain.pdf: plain.md plain.yaml ../code/template.latex
	pandoc -s plain.md --metadata-file plain.yaml --template ../code/template.latex \
		-o plain.pdf
