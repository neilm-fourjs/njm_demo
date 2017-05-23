

export FGLLDPATH=$(GREDIR)/lib
GITVER=$(shell git describe --always)
GARNAME=njm_demo-$(GENVER)
GARFILE=$(GARNAME).gar

all: etc/gitver.txt app $(GARFILE)

etc/gitver.txt:
	echo $(GITVER) > etc/gitver.txt

bin$(GENVER)/weboe.42r:
	gsmake njm_demo$(GENVER).4pw

app: bin$(GENVER)/weboe.42r
	$(info Done)

run: all
	run.sh menu.42r

run2: all
	run.sh webOE3.42r

clean:
	rm -f *.gar;
	rm -f *.tgz;
	rm -f *.4pw??;
	rm -f gbc/njm_gbc.tgz;
	rm -f etc/gitver.txt;
	find . -name \*.42? -exec rm {} \;
	find . -name \*.err -exec rm {} \;
	find . -name \*.out -exec rm {} \;
	find . -name \*.rdd -exec rm {} \;
	find . -name \*.log -exec rm {} \;
	find . -name \*.pdf -exec rm {} \;
	find . -name \*.xml -exec rm {} \;
	find . -name \*.bm -exec rm {} \;

packit: gbc/njm_gbc.tgz
	$(info Building TGZ of deployables ...) 
	tar cvzf njm_demo-$(GENVER)-$(GITVER).tgz bin$(GENVER) gas$(GENVER) etc pics db/njm_demo.exp.tgz db/imp.sh gbc/njm_gbc.tgz gbc/njm_demo.html

gbc/njm_gbc.tgz:
	cd gbc ; ./packit.sh

gar: app $(GARFILE)
	$(info Done)

# NOTE: can't use fglgar because it assumes a lazy folder layout where 
# everything is dumped into a single folder!! ( including the MANIFEST file )
#	fglgar --gar --input-source ./messy
$(GARFILE): gas$(GENVER)/MANIFEST gas$(GENVER)/gdemo.xcf
	$(info Building Genero Archive $(GARFILE) ...)
	@cp gas$(GENVER)/MANIFEST .
	@zip -qr $(GARNAME)-$(GITVER).gar MANIFEST gas$(GENVER)/g*.xcf bin$(GENVER) etc pics
	ln -s $(GARNAME)-$(GITVER).gar $(GARFILE)
	$(info Done)
	

# ----------------------
# GAS Deploy 3.00

undeploy:
	gasadmin --disable-archive $(GARNAME)
	gasadmin --undeploy-archive $(GARNAME)

deploy: $(GARFILE)
	gasadmin --deploy-archive $(GARFILE)
	gasadmin --enable-archive $(GARNAME)

redeploy: undeploy deploy
	$(info Done)

# ----------------------
# GAS Deploy 3.10

undeploy310:
	gasadmin gar --disable-archive $(GARNAME)
	gasadmin gar --undeploy-archive $(GARNAME)

deploy310: $(GARFILE)
	gasadmin gar --deploy-archive $(GARFILE)
	gasadmin gar --enable-archive $(GARNAME)

redeploy310: undeploy310 deploy310
	$(info Done)

