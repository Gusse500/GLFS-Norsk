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
AUTO_CLEAN  ?= 1
THEME_PATH  ?= stylesheets/lfs-xsl
THEME       ?= dark
RENDERTMP   := $(shell mktemp -d)
HTML_ROOT   ?= $(HOME)/public_html
DUMP_ROOT   ?= $(HOME)
CHUNK_QUIET ?= 1
ROOT_ID      =
SHELL        = /bin/bash

ALLXML := $(filter-out $(RENDERTMP)/%, \
	$(wildcard *.xml */*.xml */*/*.xml */*/*/*.xml */*/*/*/*.xml))
ALLXSL := $(filter-out $(RENDERTMP)/%, \
	$(wildcard *.xsl */*.xsl */*/*.xsl */*/*/*.xsl */*/*/*/*.xsl))

ifdef V
  Q =
else
  Q = @
endif

ifndef REV
  REV = sysv
endif
ifneq ($(REV), sysv)
  ifneq ($(REV), systemd)
    $(feil REV må være 'sysv' (standard) eller 'systemd')
  endif
endif

# Used in the book, does not actually change if the book will render for the
# stable git hash, just changes if text for stable release is rendered or not.
ifndef STAB
  STAB = development
endif
ifneq ($(STAB), development)
  ifneq ($(STAB), release)
    $(feil STAB må være 'development' (standard) eller 'release')
  endif
endif

CLEAN = rm -rf $(RENDERTMP)
ifeq ($(AUTO_CLEAN), 0)
  CLEAN =
endif

ifeq ($(REV), sysv)
  BASEDIR         ?= $(HTML_ROOT)/glfs
  DUMPDIR         ?= $(DUMP_ROOT)/glfs-commands
  GLFSHTML        ?= glfs-html.xml
  GLFSHTML2       ?= glfs-html2.xml
  GLFSFULL        ?= glfs-full.xml
else
  BASEDIR         ?= $(HTML_ROOT)/glfs-systemd
  DUMPDIR         ?= $(DUMP_ROOT)/glfs-sysd-commands
  GLFSHTML        ?= glfs-systemd-html.xml
  GLFSHTML2       ?= glfs-systemd-html2.xml
  GLFSFULL        ?= glfs-systemd-full.xml
endif

glfs: html wget-list

help:
	@echo ""
	@echo "make <parametere> <mål>"
	@echo ""
	@echo "Parametere:"
	@echo ""
	@echo "  REV=<rev>            Bygg variant av boken"
	@echo "                        Gyldige verdier for REV er:"
	@echo "                        * sysv    - Bygg boken for SysV"
	@echo "                        * systemd - Bygg boken for systemd"
	@echo "                        Standard er 'sysv'"
	@echo ""
	@echo "  BASEDIR=<dir>        Plasser utdataene i mappen <dir>."
	@echo "                       Standard er"
	@echo "                       '$(HTML_ROOT)/glfs' hvis REV=sysv (eller ikke-satt)"
	@echo "                       eller til"
	@echo "                       '$(HTML_ROOT)/glfs-systemd' hvis REV=systemd"
	@echo ""
	@echo "  V=<val>              Hvis <val> er en ikke-tom verdi, alle"
	@echo "                       trinnene for å produsere resultatet vises."
	@echo "                       Standard er ikke-satt."
	@echo ""
	@echo "  THEME_PATH=<PATH>    Angir stien til temaer (CSS filer)."
	@echo "                       stylesheets/lfs-xsl' er standard."
	@echo ""
	@echo "  THEME=<theme>        Setter temaet for boken, dvs. light/dark."
	@echo "                       'dark' er standard."
	@echo ""
	@echo "Targets:"
	@echo "  help                 Vis denne hjelpeteksten."
	@echo ""
	@echo "  glfs                 Bygger målene 'html' og 'wget-list'."
	@echo ""
	@echo "  html                 Bygger HTML sidene til boken."
	@echo ""
	@echo "  wget-list            Lager en liste over alle pakker som skal lastes ned."
	@echo "                       Utdata er BASEDIR/wget-list"
	@echo ""
	@echo "  validate             Kjører valideringskontroller på XML filene."
	@echo ""
	@echo "  test-links           Kjører valideringskontroller på nettadresser i boken."
	@echo "                       Produserer en fil med navnet BASEDIR/bad_urls som inneholder"
	@echo "                       nettadresser som er ugyldige og en BASEDIR/good_urls"
	@echo "                       som inneholder alle gyldige nettadresser."
	@echo ""

all: glfs
world: all dump-commands test-links

html: $(BASEDIR)/index.html
$(BASEDIR)/index.html: $(RENDERTMP)/$(GLFSHTML) version wget-list
	@echo "Generering av delte XHTML filer..."
	$(Q)xsltproc --nonet                                    \
					--stringparam chunk.quietly $(CHUNK_QUIET) \
					--stringparam rootid "$(ROOT_ID)"          \
					--stringparam base.dir $(BASEDIR)/         \
					stylesheets/glfs-chunked.xsl               \
					$(RENDERTMP)/$(GLFSHTML)

	@echo "Kopiering av CSS kode, bilder og nedlastinger..."
	$(Q)if [ ! -e $(BASEDIR)/stylesheets ]; then \
      mkdir -p $(BASEDIR)/stylesheets;          \
   fi;

	$(Q)cp $(THEME_PATH)/$(THEME).lfs.css $(BASEDIR)/stylesheets/lfs.css
	$(Q)cp stylesheets/lfs-xsl/lfs-print.css $(BASEDIR)/stylesheets
	$(Q)sed -i 's|../stylesheet|stylesheet|' $(BASEDIR)/index.html

	$(Q)if [ ! -e $(BASEDIR)/images ]; then \
      mkdir -p $(BASEDIR)/images;          \
   fi;
	$(Q)cp -R images/* $(BASEDIR)/images

	$(Q)cd $(BASEDIR)/; sed -e "s@../images@images@g"           \
                           -i *.html

	$(Q)if [ ! -e $(BASEDIR)/download ]; then \
		mkdir -p $(BASEDIR)/download;          \
   fi;
	$(Q)rm -rf $(BASEDIR)/download/*
	$(Q)cp -R download/* $(BASEDIR)/download
	$(Q)rm -rf $(BASEDIR)/patches
	$(Q)ln -sf download $(BASEDIR)/patches

	@echo "Kjører Tidy og obfuscate.sh på delt XHTML..."
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do       \
      tidy -config tidy.conf $$filename;                          \
      true;                                                       \
      bash obfuscate.sh $$filename;                               \
      sed -i -e "1,20s@text/html@application/xhtml+xml@g" $$filename; \
   done;

	@echo "Kopierer over eldre HTML..."
	$(Q)if [ ! -e $(BASEDIR)/archive ]; then \
		mkdir -p $(BASEDIR)/archive;          \
	fi;
	$(Q)cp -R archive/*.html $(BASEDIR)/archive

	$(Q)$(CLEAN)

validate: $(RENDERTMP)/$(GLFSFULL)
$(RENDERTMP)/$(GLFSFULL): general.ent packages.ent $(ALLXML) $(ALLXSL) version
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)
	$(Q)trap '$(CLEAN)' EXIT

	@echo "Renderer boken for $(REV)..."
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

wget-list: $(BASEDIR)/wget-list
$(BASEDIR)/wget-list: $(RENDERTMP)/$(GLFSFULL) version
	@echo "Genererer wget liste for $(REV) på $(BASEDIR)/wget-list ..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet                       \
                --output $(BASEDIR)/wget-list \
                stylesheets/wget-list.xsl     \
                $(RENDERTMP)/$(GLFSFULL)

test-links: $(BASEDIR)/test-links
$(BASEDIR)/test-links: $(RENDERTMP)/$(GLFSFULL) version
	@echo "Genererer test-links fil..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet                        \
                --stringparam list_mode full   \
                --output $(BASEDIR)/test-links \
                stylesheets/wget-list.xsl      \
                $(RENDERTMP)/$(GLFSFULL)

	@echo "Sjekk av nettadresser, første omgang..."
	$(Q)rm -f $(BASEDIR)/{good,bad,true_bad}_urls
	$(Q)for URL in `cat $(BASEDIR)/test-links`; do                     \
         wget --spider --tries=2 --timeout=60 $$URL >>/dev/null 2>&1; \
         if test $$? -ne 0 ; then                                     \
            echo $$URL >> $(BASEDIR)/bad_urls ;                       \
         else                                                         \
            echo $$URL >> $(BASEDIR)/good_urls 2>&1;                  \
         fi;                                                          \
   done

	@echo "Sjekk av nettadresser, andre omgang..."
	$(Q)for URL2 in `cat $(BASEDIR)/bad_urls`; do                       \
         wget --spider --tries=2 --timeout=60 $$URL2 >>/dev/null 2>&1; \
         if test $$? -ne 0 ; then                                      \
           echo $$URL2 >> $(BASEDIR)/true_bad_urls ;                   \
         else                                                          \
           echo $$URL2 >> $(BASEDIR)/good_urls 2>&1;                   \
         fi; \
   done

	$(Q)$(CLEAN)

test-options:
	$(Q)trap '$(CLEAN)' EXIT
	$(Q)xsltproc --xinclude --nonet stylesheets/test-options.xsl index.xml
	$(Q)$(CLEAN)

dump-commands: $(DUMPDIR)
$(DUMPDIR): $(RENDERTMP)/$(GLFSFULL) version
	@echo "Dumping av bokkommandoer på $(DUMPDIR)..."
	$(Q)xsltproc --output $(DUMPDIR)/          \
                stylesheets/dump-commands.xsl \
                $(RENDERTMP)/$(GLFSFULL)
	$(Q)touch $(DUMPDIR)
	$(Q)$(CLEAN)

.PHONY: glfs all world html validate profile-html wget-list test-links \
   dump-commands version test-options

version:
	$(Q)REV=$(REV) STAB=$(STAB) ./git-version.sh
