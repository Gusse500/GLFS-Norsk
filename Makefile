# vim:ts=3
# Makefile for GLFS Book generation.
# By Tushar Teredesai <tushar@linuxfromscratch.org>
# 2004-01-31
# Edited by Zeckma    <zeckma.tech@gmail.com>
# 2025-01-12

# When rendering for the stable release from the stable branch, invoke
# STAB=release to make.

-include local.mk

# Adjust these to suit your installation, or include the variables
# you wish to change in local.mk, which must be created manually.
REV         ?= systemd
STAB        ?= development
WORKFLOW    ?= n
THEME_PATH  ?= stylesheets/lfs-xsl
THEME       ?= dynamic
RENDERTMP   := $(shell mktemp -d)
HTML_ROOT   ?= $(HOME)/public_html
DUMP_ROOT   ?= $(HOME)
CHUNK_QUIET ?= 1
SHELL        = /bin/bash

ALLXML := $(shell find . -mindepth 1 -name '*.xml' ! -path '$(RENDERTMP)/*')
ALLXSL := $(shell find . -mindepth 1 -name '*.xsl' ! -path '$(RENDERTMP)/*')

ifdef V
  Q =
else
  Q = @
endif

ifneq ($(REV), systemd)
  ifneq ($(REV), sysv)
    $(feil REV må være 'systemd' (standard) eller 'sysv' (ikke vedlikeholdt))
  endif
endif

# Used in the book, does not actually change if the book will render for the
# stable git hash, just changes if text for stable release is rendered or not.
ifneq ($(STAB), development)
  ifneq ($(STAB), release)
    $(feil STAB må være 'development' (standard) eller 'release')
  endif
endif

ifeq ($(REV), systemd)
  BASEDIR         ?= $(HTML_ROOT)/glfs
  DUMPDIR         ?= $(DUMP_ROOT)/glfs-commands
  GLFSHTML        ?= glfs-html.xml
  GLFSHTML2       ?= glfs-html2.xml
  GLFSFULL        ?= glfs-full.xml
else
  BASEDIR         ?= $(HTML_ROOT)/glfs-sysv
  DUMPDIR         ?= $(DUMP_ROOT)/glfs-sysv-commands
  GLFSHTML        ?= glfs-sysv-html.xml
  GLFSHTML2       ?= glfs-sysv-html2.xml
  GLFSFULL        ?= glfs-sysv-full.xml
endif

glfs: html post-render

help:
	@echo ""
	@echo "make <parameters> <targets>"
	@echo ""
	@echo "Parameters:"
	@echo ""
	@echo "  REV=<rev>            Bygg variant av boken"
	@echo "                       Gyldige verdier for REV er:"
	@echo "                       * systemd - Bygg boken for Systemd"
	@echo "                       * sysv    - Bygg boken for SysV"
	@echo "                       Standard er 'systemd'"
	@echo ""
	@echo "  BASEDIR=<dir>        Plasser utdataene i mappen <dir>."
	@echo "                       Standard er"
	@echo "                       '$(HTML_ROOT)/glfs' hvis REV=systemd (eller ikke satt)"
	@echo "                       eller til"
	@echo "                       '$(HTML_ROOT)/glfs-sysv' hvis REV=sysv"
	@echo ""
	@echo "  V=<val>              Hvis <val> er en ikke-tom verdi, alle"
	@echo "                       trinnene for å produsere resultatet vises."
	@echo "                       Standard er ikke satt."
	@echo ""
	@echo "  THEME_PATH=<PATH>    Angir banen til temaene (CSS filer)."
	@echo "                       stylesheets/lfs-xsl' er standard."
	@echo ""
	@echo "  THEME=<theme>        Setter temaet for boken, dvs."
	@echo "                       light/dark/dynamic."
	@echo "                       'dynamic' er standard."
	@echo ""
	@echo "Targets:"
	@echo "  help                 Vis denne hjelpeteksten."
	@echo ""
	@echo "  glfs                 Bygger målet 'html' og 'wget-list'."
	@echo ""
	@echo "  html                 Bygger HTML sidene til boken."
	@echo ""
	@echo "  wget-list            Lager en liste over alle pakker som skal lastes ned."
	@echo "                       Utdataen er i BASEDIR/download/wget-list"
	@echo ""
	@echo "  validate             Kjører valideringskontroller på XML filene."
	@echo ""
	@echo "  test-links           Kjører valideringskontroller på URL-er i boken."
	@echo "                       Produserer en fil med navnet BASEDIR/bad_urls som inneholder"
	@echo "                       URL-er som er ugyldige og en BASEDIR/good_urls"
	@echo "                       som inneholder alle gyldige nettadresser."
	@echo ""

all: glfs
post-render: downloads wget-list assets legacy-html
world: all dump-commands test-links

html: $(BASEDIR)/index.html
$(BASEDIR)/index.html: $(RENDERTMP)/$(GLFSHTML) version
	@echo "Genererer delte XHTML-filer..."
	$(Q)xsltproc --nonet                                    \
					--stringparam chunk.quietly $(CHUNK_QUIET) \
					--stringparam base.dir $(BASEDIR)/         \
					stylesheets/glfs-chunked.xsl               \
					$(RENDERTMP)/$(GLFSHTML)

	@echo "Kjører Tidy og obfuscate.sh på delt XHTML..."
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do       \
      tidy -config tidy.conf $$filename;                          \
      true;                                                       \
      bash obfuscate.sh $$filename;                               \
      sed -i -e "1,20s@text/html@application/xhtml+xml@g" $$filename; \
   done;

validate: $(RENDERTMP)/$(GLFSFULL)
$(RENDERTMP)/$(GLFSFULL): general.ent packages.ent $(ALLXML) $(ALLXSL) version
	$(Q)mkdir -p $(RENDERTMP)
	
	@echo "Gjengir boken for $(REV)..."
	$(Q)xsltproc --nonet                               \
                --xinclude                            \
                --output $(RENDERTMP)/$(GLFSHTML2)    \
                --stringparam profile.revision $(REV) \
                stylesheets/lfs-xsl/profile.xsl       \
                index.xml
	
	@echo "Validerer boken..."
	$(Q)xmllint --nonet                             \
               --noent                             \
               --postvalid                         \
               --output $(RENDERTMP)/$(GLFSFULL)   \
               $(RENDERTMP)/$(GLFSHTML2)

profile-html: $(RENDERTMP)/$(GLFSHTML)
$(RENDERTMP)/$(GLFSHTML): $(RENDERTMP)/$(GLFSFULL) version
	@echo "Genererer profilert XML for XHTML..."
	$(Q)xsltproc --nonet                              \
                --stringparam profile.condition html \
                --output $(RENDERTMP)/$(GLFSHTML)    \
                stylesheets/lfs-xsl/profile.xsl      \
                $(RENDERTMP)/$(GLFSFULL)

downloads: $(BASEDIR)/download
$(BASEDIR)/download: html
	@echo "Kopiering av nedlastbart innhold til $(BASEDIR)/download ..."
	$(Q)mkdir -p $(BASEDIR)/download
	$(Q)rm -rf $(BASEDIR)/download/*
	$(Q)cp -R download/* $(BASEDIR)/download
	$(Q)rm -rf $(BASEDIR)/patches
	$(Q)ln -snf download $(BASEDIR)/patches

wget-list: $(BASEDIR)/download/wget-list
$(BASEDIR)/download/wget-list: $(RENDERTMP)/$(GLFSFULL) version html downloads
	@echo "Genererer $(REV) wget-list til $(BASEDIR)/download..."
	$(Q)xsltproc --nonet                                \
                --output $(BASEDIR)/download/wget-list \
                stylesheets/wget-list.xsl              \
                $(RENDERTMP)/$(GLFSFULL)

legacy-html: $(BASEDIR)/archive
$(BASEDIR)/archive: html
	@echo "Kopiering av eldre HTML..."
	$(Q)mkdir -p $(BASEDIR)/archive
	$(Q)cp -R archive/*.html $(BASEDIR)/archive

assets: $(BASEDIR)/stylesheets $(BASEDIR)/images
$(BASEDIR)/stylesheets: html
	@echo "Kopierer CSS..."
	$(Q)mkdir -p $(BASEDIR)/stylesheets
	$(Q)cp $(THEME_PATH)/$(THEME).lfs.css $(BASEDIR)/stylesheets/lfs.css
	$(Q)cp stylesheets/lfs-xsl/lfs-print.css $(BASEDIR)/stylesheets
	$(Q)sed -i 's|../stylesheet|stylesheet|' $(BASEDIR)/index.html
$(BASEDIR)/images: html
	@echo "Kopierer bilder..."
	$(Q)mkdir -p $(BASEDIR)/images
	$(Q)cp -R images/* $(BASEDIR)/images
	$(Q)cd $(BASEDIR)/; sed -e "s@../images@images@g" -i *.html

test-links: $(BASEDIR)/test-links
$(BASEDIR)/test-links: $(RENDERTMP)/$(GLFSFULL) version
	@echo "Genererer test-lenke fil..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet                        \
                --stringparam list_mode full   \
                --output $(BASEDIR)/test-links \
                stylesheets/wget-list.xsl      \
                $(RENDERTMP)/$(GLFSFULL)
	
	@echo "Sjekker URL-er, første omgang..."
	$(Q)rm -f $(BASEDIR)/{good,bad,true_bad}_urls
	$(Q)for URL in `cat $(BASEDIR)/test-links`; do                     \
         wget --spider --tries=2 --timeout=60 $$URL >>/dev/null 2>&1; \
         if test $$? -ne 0 ; then                                     \
            echo $$URL >> $(BASEDIR)/bad_urls ;                       \
         else                                                         \
            echo $$URL >> $(BASEDIR)/good_urls 2>&1;                  \
         fi;                                                          \
   done
	
	@echo "Sjekker URL-er, andre omgang..."
	$(Q)for URL2 in `cat $(BASEDIR)/bad_urls`; do                       \
         wget --spider --tries=2 --timeout=60 $$URL2 >>/dev/null 2>&1; \
         if test $$? -ne 0 ; then                                      \
           echo $$URL2 >> $(BASEDIR)/true_bad_urls ;                   \
         else                                                          \
           echo $$URL2 >> $(BASEDIR)/good_urls 2>&1;                   \
         fi; \
   done

test-options:
	$(Q)xsltproc --xinclude --nonet stylesheets/test-options.xsl index.xml

dump-commands: $(DUMPDIR)
$(DUMPDIR): $(RENDERTMP)/$(GLFSFULL) version
	@echo "Dumper bokkommandoer på $(DUMPDIR)..."
	$(Q)xsltproc --output $(DUMPDIR)/          \
                stylesheets/dump-commands.xsl \
                $(RENDERTMP)/$(GLFSFULL)
	$(Q)touch $(DUMPDIR)

.PHONY: glfs post-render all world html validate profile-html downloads \
   wget-list assets test-links dump-commands version test-options

version:
	$(Q)REV=$(REV) STAB=$(STAB) WORKFLOW=$(WORKFLOW) ./git-version.sh
