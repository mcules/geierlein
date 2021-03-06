prefix := /usr/local
bindir := $(prefix)/bin
datadir := $(prefix)/share
pixmapdir := $(datadir)/pixmaps
desktopfiledir := $(datadir)/applications
pkgdatadir := $(datadir)/geierlein

VERSIONMAJOR := 0
VERSIONMINOR := 7
VERSIONBUILD := 4
VERSION := $(VERSIONMAJOR).$(VERSIONMINOR).$(VERSIONBUILD)
INSTALL := /usr/bin/install -c
INSTALL_DATA := $(INSTALL) -m 644
PYTHON := python2
WEBDRIVERS ?= Chrome Firefox

forge_essentials := \
	chrome/content/lib/forge/js/aes.js \
	chrome/content/lib/forge/js/debug.js \
	chrome/content/lib/forge/js/des.js \
	chrome/content/lib/forge/js/form.js \
	chrome/content/lib/forge/js/hmac.js \
	chrome/content/lib/forge/js/http.js \
	chrome/content/lib/forge/js/jsbn.js \
	chrome/content/lib/forge/js/log.js \
	chrome/content/lib/forge/js/md.js \
	chrome/content/lib/forge/js/md5.js \
	chrome/content/lib/forge/js/pbkdf2.js \
	chrome/content/lib/forge/js/prng.js \
	chrome/content/lib/forge/js/sha1.js \
	chrome/content/lib/forge/js/sha256.js \
	chrome/content/lib/forge/js/socket.js \
	chrome/content/lib/forge/js/task.js \
	chrome/content/lib/forge/js/tls.js \
	chrome/content/lib/forge/js/tlssocket.js \
	chrome/content/lib/forge/js/xhr.js \
	chrome/content/lib/forge/js/random.js \
	chrome/content/lib/forge/js/asn1.js \
	chrome/content/lib/forge/js/forge.js \
	chrome/content/lib/forge/js/mgf.js \
	chrome/content/lib/forge/js/mgf1.js \
	chrome/content/lib/forge/js/oids.js \
	chrome/content/lib/forge/js/pkcs12.js \
	chrome/content/lib/forge/js/pkcs7.js \
	chrome/content/lib/forge/js/pkcs7asn1.js \
	chrome/content/lib/forge/js/pem.js \
	chrome/content/lib/forge/js/pki.js \
	chrome/content/lib/forge/js/pss.js \
	chrome/content/lib/forge/js/rc2.js \
	chrome/content/lib/forge/js/rsa.js \
	chrome/content/lib/forge/js/util.js

gzipjs_essentials := \
	chrome/content/lib/gzip-js/lib/crc32.js \
	chrome/content/lib/gzip-js/lib/gzip.js \
	chrome/content/lib/gzip-js/lib/rawdeflate.js \
	chrome/content/lib/gzip-js/lib/rawinflate.js

jsxml_essentials := \
	chrome/content/lib/jsxml/jsxml.js

xmlwriter_essentials := \
	chrome/content/lib/xmlwriter.js

geierlein_essentials := \
	$(forge_essentials) \
	$(gzipjs_essentials) \
	$(jsxml_essentials) \
	$(xmlwriter_essentials) \
	chrome/content/lib/geierlein/crypto.js \
	chrome/content/lib/geierlein/datenlieferant.js \
	chrome/content/lib/geierlein/geierlein.js \
	chrome/content/lib/geierlein/signer.js \
	chrome/content/lib/geierlein/steuerfall.js \
	chrome/content/lib/geierlein/taxnumber.js \
	chrome/content/lib/geierlein/transfer.js \
	chrome/content/lib/geierlein/ustva.js \
	chrome/content/lib/geierlein/ustsvza.js \
	chrome/content/lib/geierlein/util.js \
	chrome/content/lib/geierlein/validation.js \
	chrome/content/css/bootstrap.min.css \
	chrome/content/css/geierlein.css \
	chrome/content/img/glyphicons-halflings-white.png \
	chrome/content/img/glyphicons-halflings.png \
	chrome/content/img/geierlein-logo-color-white.png \
	chrome/content/index.html \
	chrome/content/lib/bootstrap.min.js \
	chrome/content/js/geierlein.js \
	chrome/content/lib/prefstore/localstorage.js \
	chrome/content/lib/prefstore/xul.js \
	chrome/content/lib/jquery-2.1.3.min.js \
	chrome/content/js/jquery.input.multiply.js \
	chrome/content/js/jquery.input.totalize.js \
	chrome/content/xsl/ustva.xsl

xulapp_essentials := \
	$(geierlein_essentials) \
	chrome/content/css/xulapp.css \
	chrome/content/img/geierlein-logo-color-black.png \
	chrome/content/img/toolbar-convert.png \
	chrome/content/img/toolbar-new.png \
	chrome/content/img/toolbar-open.png \
	chrome/content/img/toolbar-save.png \
	chrome/content/js/xulapp.js \
	chrome/content/main.xul \
	chrome/content/pref/main.js \
	chrome/content/pref/main.xul \
	chrome/content/pref/pref.xul \
	chrome/locale/branding/brand.dtd \
	chrome/locale/branding/brand.properties \
	chrome/chrome.manifest \
	defaults/preferences/prefs.js \
	./chrome.manifest \
	./application.ini

xulapp_wininst := \
	$(xulapp_essentials) \
	logo.ico

version_files := \
	Makefile \
	application.ini \
	chrome/content/lib/geierlein/steuerfall.js \
	package.json \
	tests/_files/ustsvza_datenteil_echt.xml \
	tests/_files/ustsvza_datenteil_test.xml \
	tests/_files/ustsvza_dauerfrist_datenteil_echt.xml \
	tests/_files/ustsvza_dauerfrist_datenteil_test.xml \
	tests/_files/ustva_datenteil_echt.xml \
	tests/_files/ustva_datenteil_test.xml

all: bin/xgeierlein wininst.nsi

clean:
	rm -f bin/xgeierlein wininst.nsi

bin/xgeierlein: bin/xgeierlein.in Makefile
	sed -e "s;@pkgdatadir@;$(pkgdatadir);g" $< > $@
	chmod +x $@

wininst.nsi: wininst.nsi.in Makefile
	sed -e "s;@instfiles@;$(foreach file,$(xulapp_wininst),\n\tsetOutPath \$$INSTDIR\\\$(subst /,\\\,$(dir $(file))) \n\n\tFile $(subst /,\\\,$(file)));g" \
	    -e "s;@deletefiles@;$(subst /,\\\,$(foreach file,$(xulapp_wininst),\n\tDelete \$$INSTDIR\\\$(file)));g" \
	    -e "s;@VERSIONMAJOR@;$(VERSIONMAJOR);g" \
	    -e "s;@VERSIONMINOR@;$(VERSIONMINOR);g" \
	    -e "s;@VERSIONBUILD@;$(VERSIONBUILD);g" \
	    -e "s;@VERSION@;$(VERSION);g" \
	    -e "s;@INSTSIZE@;$(shell du --apparent-size --block-size=1024 --total $(xulapp_wininst) | awk 'END { print $$1 }');g" \
	    $< > $@

dist-nsis: wininst.nsi
	makensis $<

install: bin/xgeierlein
	for file in $(xulapp_essentials); do \
	  installdir="$${file%/*}"; \
	  $(INSTALL) -d "$(DESTDIR)$(pkgdatadir)/$$installdir"; \
	  $(INSTALL_DATA) -t "$(DESTDIR)$(pkgdatadir)/$$installdir" "$$file"; \
	done
	$(INSTALL) -d "$(DESTDIR)$(desktopfiledir)"
	$(INSTALL_DATA) -t "$(DESTDIR)$(desktopfiledir)" geierlein.desktop
	$(INSTALL) -d "$(DESTDIR)$(pixmapdir)"
	$(INSTALL_DATA) -t "$(DESTDIR)$(pixmapdir)" geierlein.png
	$(INSTALL) -d "$(DESTDIR)$(bindir)"
	$(INSTALL) -t "$(DESTDIR)$(bindir)" bin/xgeierlein

uninstall:
	rm -vrf $(DESTDIR)$(pkgdatadir)
	rm -vf $(DESTDIR)$(desktopfiledir)/geierlein.desktop
	rm -vf $(DESTDIR)$(pixmapdir)/geierlein.png
	rm -vf $(DESTDIR)$(bindir)/bin/xgeierlein

geierlein-$(VERSION).tar.gz:
	git archive --prefix geierlein-$(VERSION)/ -o geierlein-$(VERSION).tar.gz master

geierlein-$(VERSION).zip:
	git archive --prefix geierlein-$(VERSION)/ -o geierlein-$(VERSION).zip master

geierlein-$(VERSION).tar.xz: geierlein-$(VERSION).tar.gz
	gzip -cd $< | xz -ezcv > $@

dist: dist-nsis geierlein-$(VERSION).zip geierlein-$(VERSION).tar.xz
	git tag -f V$(VERSION)

autodist: dist
	cp Makefile Makefile.autodist
	$(MAKE) -f Makefile.autodist autodist-run
	rm -f Makefile.autodist
	git push
	git push --tags

autodist-run:
	scp geierlein-$(VERSION)-installer.exe stesie@gandalf.zerties.org:/srv/www/taxbird.de/downloads/geierlein
	git checkout gh-pages
	sed -e "s/geierlein\/archive\/V[0-9\.]\+\.zip/geierlein\/archive\/V$(VERSION).zip/" \
		-e "s/geierlein-[0-9\.]\+-installer.exe/geierlein-$(VERSION)-installer.exe/" \
		-i~ _layouts/default.html
	git commit _layouts/default.html -m "Update links to version $(VERSION)"
	git checkout master

test:
	npm test

test-forge:
	nodeunit chrome/content/lib/forge/tests/nodeunit

test-online:
	(set -e; for A in $(WEBDRIVERS); do \
		WEBDRIVER=$$A $(PYTHON) -m unittest discover -s tests/selenium/ -p "test_online*.py"; \
	done)

test-offline:
	(set -e; for A in $(WEBDRIVERS); do \
		WEBDRIVER=$$A $(PYTHON) -m unittest discover -s tests/selenium/ -p "test_offline*.py"; \
	done)

test-all: test-forge test test-offline test-online

bump-version: $(version_files)
	@if [ "$(NEW_VERSION)" = "" ]; then \
	  echo NEW_VERSION argument not provided.; \
	  echo Usage: make bump-version NEW_VERSION=0.7.4; \
	  exit 1; \
	fi
	(bump_version() { \
		sed -i~ Makefile -e "s/\(VERSIONMAJOR :=\) .*/\1 $$1/" \
			-e "s/\(VERSIONMINOR :=\) .*/\1 $$2/" \
			-e "s/\(VERSIONBUILD :=\) .*/\1 $$3/"; \
	}; IFS=.; version="$(NEW_VERSION)"; bump_version $$version; unset IFS;)
	sed -e 's;$(subst .,\.,$(VERSION));$(NEW_VERSION);g' -i~ $^
	sed -e "s/^BuildID=.*/BuildID=`date +%Y%m%d`/" -i~ application.ini
	git commit -m "Bump version to $(NEW_VERSION)" $^

.PHONY: all clean autodist autodist-run dist install test test-forge test-all test-online test-offline uninstall bump-version dist-nsis
