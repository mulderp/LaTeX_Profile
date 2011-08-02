# From http://www.wlug.org.nz/LatexMakefiles
TARGET=profile
# BIBTAG=master

# make pdf by default
all: ${TARGET}.pdf

# it doesn't really need the .dvi, but this way all the refs are right
%.pdf : %.dvi
#	makeglossaries ${TARGET}
	pdflatex -synctex=-1 --halt-on-error $*

# ${TARGET}.bbl: ${BIBTAG}.bib
# in case we don't already have a .aux file listing citations
# this should probably be a separate makefile target/dependency instead
# of doing it every time... but *shrug*
#	@pdflatex --halt-on-error ${TARGET}.tex
# get the citations out of the bibliography
#	@bibtex ${TARGET}
# do it again in case there are out-of-order cross-references
#	@pdflatex --halt-on-error ${TARGET}.tex

${TARGET}.dvi: # ${TARGET}.bbl ${TARGET}.tex
	@pdflatex --halt-on-error ${TARGET}.tex


# shortcut, so we can say "make ps" -- but I don't use ps to make the
# pdf now since I don't use tree-dvips
ps: ${TARGET}.ps

%.ps: %.dvi
	@dvips -z -o $@ $*.dvi


clean:
	rm -f ${TARGET}.{log,glo,aux,ps,dvi,bbl,blg,log,lox,out,toc,rel,brf}

reallyclean: clean
	rm -f ${TARGET}.{pdf}


getbib:
	wget "http://bibsonomy.org/bib/user/unhammer/${BIBTAG}?bibtex.entriesPerPage=500" -O ${BIBTAG}.bib
	touch ${BIBTAG}.bib


PHONY : ps all clean reallyclean getbib
