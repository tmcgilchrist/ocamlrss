#
PACKAGES=xmlm

OF_FLAGS=-package $(PACKAGES) -annot
OCAMLFIND=ocamlfind
OCAMLC=$(OCAMLFIND) ocamlc $(OF_FLAGS)
OCAMLOPT=$(OCAMLFIND) ocamlopt $(OF_FLAGS)
OCAMLDOC=$(OCAMLFIND) ocamldoc $(OF_FLAGS)

all: byte opt
byte: rss.cma
opt: rss.cmxa

CMOFILES= \
	rss_date.cmo \
	rss_types.cmo \
	rss_io.cmo \
	rss.cmo

CMXFILES=$(CMOFILES:.cmo=.cmx)
CMIFILES=$(CMOFILES:.cmo=.cmi)

rss.cma: $(CMIFILES) $(CMOFILES)
	$(OCAMLC) -o $@ -a $(CMOFILES)

rss.cmxa: $(CMIFILES) $(CMXFILES)
	$(OCAMLOPT) -o $@ -a $(CMXFILES)

# installation :
################
install: byte opt
	$(OCAMLFIND) install rss META LICENSE rss.cmi rss.cma rss.cmxa rss.a

uninstall:
	ocamlfind remove rss

# Cleaning :
############
clean:
	rm -f *.cm* *.a *.annot *.o

# headers :
###########
HEADFILES=Makefile *.ml *.mli
headers: dummy
	headache -h header -c .headache_config $(HEADFILES)

noheaders: dummy
	headache -r -c .headache_config $(HEADFILES)

# generic rules :
#################
.SUFFIXES: .mli .ml .cmi .cmo .cmx .mll .mly .sch .html .mail

%.cmi:%.mli
	$(OCAMLC) -c $<

%.cmo:%.ml
	$(OCAMLC) -c $<

%.cmi %.cmo:%.ml
	$(OCAMLC) -c $<

%.cmx %.o:%.ml
	$(OCAMLOPT) -c $<

