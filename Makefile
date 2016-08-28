PDFLATEX=pdflatex
SKIM = skim_revert.sh
OTT := ott
OTT_FLAGS := -tex_wrap false -tex_show_meta true -picky_multiple_parses false

all : pdf

pdf : main.pdf
	$(SKIM) $(CURDIR)/main.pdf
	$(SKIM) $(CURDIR)/main.pdf

main.pdf : main.tex references.bib Makefile
	$(PDFLATEX) main.tex
	bibtex main
	$(PDFLATEX) main.tex
	$(PDFLATEX) main.tex
	$(PDFLATEX) main.tex

clean : 
	rm -f *.aux *.dvi *.ps *.log *~ *.out *.bbl *.blg
