all: tex pdf

tex: plain.tex oldstyle.tex

pdf: plain.pdf oldstyle.pdf

plain.tex: source.md plain.yaml ../code/template.latex
	pandoc -s --metadata-file plain.yaml --template ../code/template.latex \
		$< -o $@ 

plain.pdf: source.md plain.yaml ../code/template.latex
	pandoc -s --metadata-file plain.yaml --template ../code/template.latex \
		$< -o $@ 

oldstyle.tex: source.md oldstyle.yaml ../code/template.latex
	pandoc -s --metadata-file oldstyle.yaml --template ../code/template.latex \
		$< -o $@ 

oldstyle.pdf: source.md oldstyle.yaml ../code/template.latex
	pandoc -s --metadata-file oldstyle.yaml --template ../code/template.latex \
	--pdf-engine lualatex \
		$< -o $@ 

