# Build and install package from development sources

TEXMF=`kpsewhich --expand-var='$$TEXMFLOCAL'`

VENDOR=adobe
FONT=adobecaslon


build: prepare
	fontinst pac-drv.tex
	$(MAKE) fonts
	pdflatex pac-sample.tex

fontinst-expert: prepare
	cp `kpsewhich t1.etx` t1a.etx
	patch t1a.etx t1a.etx.diff
	cp t1a.etx t1aa.etx
	patch t1aa.etx t1aa.etx.diff
	cp t1aa.etx t1aa8.etx
	patch t1aa8.etx t1aa8.etx.diff
	fontinst pac-expert-drv.tex

build-expert: expert

expert: fontinst-expert
	$(MAKE) fonts
	cat pac-extra.map >> pac.map
	pdflatex pac-sample-expert.tex

build-extraligs: extraligs

extraligs: fontinst-expert
	cp t1aa.etx t1aae.etx
	patch t1aae.etx t1aae.etx.diff
	cp t1aa8.etx t1aa8e.etx
	patch t1aa8e.etx t1aa8e.etx.diff
	fontinst pac-extraligs-drv.tex
	$(MAKE) fonts
	cat pac-extra.map >> pac.map
	pdflatex pac-sample-expert.tex
	pdflatex pac-sample-extraligs.tex

prepare:
	latex adobecaslon.ins

fonts:
	fontinst pac-map.tex
	for i in *.pl; do pltotf $$i; done
	for i in *.vpl; do vptovf $$i; done
	pdflatex adobecaslon.dtx
	- bibtex adobecaslon
	pdflatex adobecaslon.dtx
	- makeindex -s gind.ist -o adobecaslon.ind adobecaslon.idx
	- makeindex -s gglo.ist -o adobecaslon.gls adobecaslon.glo
	pdflatex adobecaslon.dtx
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' adobecaslon.log) \
	do pdflatex adobecaslon.dtx; done

dist: build 
	mkdir -p texmf-dist/fonts/vf/$(VENDOR)/$(FONT)/
	cp -pf *.vf texmf-dist/fonts/vf/$(VENDOR)/$(FONT)/
	mkdir -p texmf-dist/fonts/tfm/$(VENDOR)/$(FONT)/
	cp -pf *.tfm texmf-dist/fonts/tfm/$(VENDOR)/$(FONT)/
	mkdir -p texmf-dist/fonts/map/dvips/$(FONT)/
	cp -pf *.map texmf-dist/fonts/map/dvips/$(FONT)/
	mkdir -p texmf-dist/tex/latex/$(FONT)/
	cp -pf *.sty *.fd texmf-dist/tex/latex/$(FONT)/
	mkdir -p texmf-dist/doc/latex/$(FONT)/
	cp -pf README pac-sample-expert.pdf texmf-dist/doc/latex/$(FONT)/
	cp -pfr texmf/* texmf-dist/
	cd texmf-dist/ && zip -r ../adobecaslon.tds.zip .

install: dist
	cp -pfr texmf/* $(TEXMF)/

uninstall:
	$(RM) -r $(TEXMF)/fonts/vf/$(VENDOR)/$(FONT)
	$(RM) -r $(TEXMF)/fonts/tfm/$(VENDOR)/$(FONT)
	$(RM) -r $(TEXMF)/fonts/map/dvips/$(FONT)
	$(RM) -r $(TEXMF)/tex/latex/$(FONT)
	$(RM) -r $(TEXMF)/doc/tex/latex/$(FONT)

clean:
	$(RM) *.vpl *.pl *.aux *.log *.out *.bbl *.blg *.glo \
	*.idx *.ind *.ilg *.hd *.toc *.fd *.mtx *.tfm *.vf  \
	*.tex *.gls pac.map \
	adobecaslon.sty *.etx *.tgz  \
	$(RM) -r texmf-dist

distclean: clean
	 $(RM) *.zip *.pdf 

archive: build expert dist clean
	mv adobecaslon.tds.zip ..
	tar -C .. -zcvf adobecaslon.tgz --exclude '*CVS*' \
	--exclude '*.pfb' --exclude '*.afm' --exclude '*.inf' \
	--exclude '*.pfm' --exclude '*.tgz' \
	--exclude '.git' --exclude '.gitignore' adobecaslon adobecaslon.tds.zip

