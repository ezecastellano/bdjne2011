all: informe.pdf

informe.pdf: informe.tex der.pdf
	xelatex informe.tex && xelatex informe.tex
	rm informe.out informe.log informe.aux informe.toc

clean:
	rm informe.pdf
