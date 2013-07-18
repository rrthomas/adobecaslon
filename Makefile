# Build and install package from development sources

TEXMF=`kpsewhich --expand-var='$$TEXMFLOCAL'`

VENDOR=adobe
FONT=adobecaslon

build:
	latex adobecaslon.ins
	fontinst pac-drv.tex
	fontinst pac-map.tex
	for i in *.pl; do pltotf $$i; done
	for i in *.vpl; do vptovf $$i; done
	pdflatex adobecaslon.dtx
	bibtex adobecaslon
	makeindex adobecaslon.dtx
	pdflatex adobecaslon.dtx
	pdflatex pacsample.tex

install:
	mkdir -p $(TEXMF)/fonts/vf/$(VENDOR)/$(FONT)/
	cp -pf *.vf $(TEXMF)/fonts/vf/$(VENDOR)/$(FONT)/
	mkdir -p $(TEXMF)/fonts/tfm/$(VENDOR)/$(FONT)/
	cp -pf *.tfm $(TEXMF)/fonts/tfm/$(VENDOR)/$(FONT)/
	mkdir -p $(TEXMF)/fonts/map/dvips/$(FONT)/
	cp -pf *.map $(TEXMF)/fonts/map/dvips/$(FONT)/
	mkdir -p $(TEXMF)/tex/latex/$(FONT)/
	cp -pf *.sty *.fd $(TEXMF)/tex/latex/$(FONT)/
	mkdir -p $(TEXMF)/doc/tex/latex/$(FONT)/
	cp -pf README *.pdf $(TEXMF)/doc/tex/latex/$(FONT)/

uninstall:
	rm -f $(TEXMF)/fonts/vf/$(VENDOR)/$(FONT)/*.vf
	rm -f $(TEXMF)/fonts/tfm/$(VENDOR)/$(FONT)/*.tf
	rm -f $(TEXMF)/fonts/map/dvips/$(FONT)/*.map
	rm -f $(TEXMF)/tex/latex/$(FONT)/*.sty
	rm -f $(TEXMF)/tex/latex/$(FONT)/*.fd
	rm -f $(TEXMF)/doc/tex/latex/$(FONT)/README
	rm -f $(TEXMF)/doc/tex/latex/$(FONT)/*.pdf

clean:
	rm -f *.vpl *.pl *.aux *.log *.out *.bbl *.blg *.glo *.idx *.ind *.ilg *.hd *.toc *.fd *.etx *.mtx *.tfm *.vf *.pdf pac-drv.tex pac-map.tex pac-rec.tex pac.map adobecaslon.sty
