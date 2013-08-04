# Build and install package from development sources

TEXMF=`kpsewhich --expand-var='$$TEXMFLOCAL'`

VENDOR=adobe
FONT=adobecaslon

build: prepare
	fontinst pac-drv.tex
	$(MAKE) fonts
	pdflatex pac-sample.tex

expert: prepare
	cp t1.etx t1a.etx
	patch t1a.etx t1a.etx.diff
	cp t1a.etx t1aa.etx
	patch t1aa.etx t1aa.etx.diff
	cp t1aa.etx t1aa8.etx
	patch t1aa8.etx t1aa8.etx.diff
	fontinst pac-expert-drv.tex
	$(MAKE) fonts
	cat pac-extra.map >> pac.map
	pdflatex pac-sample.tex
	pdflatex pac-sample-expert.tex

prepare:
	latex adobecaslon.ins

fonts:
	fontinst pac-map.tex
	for i in *.pl; do pltotf $$i; done
	for i in *.vpl; do vptovf $$i; done
	pdflatex adobecaslon.dtx
	bibtex adobecaslon
	makeindex adobecaslon.dtx
	pdflatex adobecaslon.dtx

dist:
	mkdir -p texmf-dist/fonts/vf/$(VENDOR)/$(FONT)/
	cp -pf *.vf texmf-dist/fonts/vf/$(VENDOR)/$(FONT)/
	mkdir -p texmf-dist/fonts/tfm/$(VENDOR)/$(FONT)/
	cp -pf *.tfm texmf-dist/fonts/tfm/$(VENDOR)/$(FONT)/
	mkdir -p texmf-dist/fonts/map/dvips/$(FONT)/
	cp -pf *.map texmf-dist/fonts/map/dvips/$(FONT)/
	mkdir -p texmf-dist/tex/latex/$(FONT)/
	cp -pf *.sty *.fd texmf-dist/tex/latex/$(FONT)/
	mkdir -p texmf-dist/doc/tex/latex/$(FONT)/
	cp -pf README *.pdf texmf-dist/doc/tex/latex/$(FONT)/
	cp -pr texmf/* texmf-dist/
	cd texmf-dist/ && zip -r ../adobecaslon.tds.zip .

install: dist
	cp -pfr texmf-dist/* $(TEXMF)/

uninstall:
	rm -f $(TEXMF)/fonts/vf/$(VENDOR)/$(FONT)/*.vf
	rm -f $(TEXMF)/fonts/tfm/$(VENDOR)/$(FONT)/*.tf
	rm -f $(TEXMF)/fonts/map/dvips/$(FONT)/*.map
	rm -f $(TEXMF)/tex/latex/$(FONT)/*.sty
	rm -f $(TEXMF)/tex/latex/$(FONT)/*.fd
	rm -f $(TEXMF)/doc/tex/latex/$(FONT)/README
	rm -f $(TEXMF)/doc/tex/latex/$(FONT)/*.pdf

clean:
	rm -f *.vpl *.pl *.aux *.log *.out *.bbl *.blg *.glo *.idx *.ind *.ilg *.hd *.toc *.fd *.mtx *.tfm *.vf *.pdf pac-drv.tex pac-sample.tex pac-expert-drv.tex pac-sample-expert.tex pac-map.tex pac-rec.tex pac.map adobecaslon.sty t1a.etx t1aa.etx t1aj.etx t1aaj.etx
	rm -rf texmf-dist
