# Makefile
#
# ==============================================================================
# PAQUETE: Popularity-Contest
# ARCHIVO: Makefile
# DESCRIPCIÓN: instalacion de las carpetas en su directorio.
# COPYRIGHT:
#  (C) 2013 Sasha Veronica Solano Grosjean <sashasolano@gmail.com>
# LICENCIA: GPL3
# ==============================================================================
#
# Este programa es software libre. Puede redistribuirlo y/o modificarlo bajo los
# términos de la Licencia Pública General de GNU (versión 3).

HELL := sh -e

all: build

test:



	@echo -n "\n===== Comprobando posibles errores de sintaxis en los scripts de mantenedor =====\n\n"

	@for SCRIPT in $(SCRIPTS); \
	do \
		echo -n "$${SCRIPT}\n"; \
		bash -n $${SCRIPT}; \
	done

	@echo -n "\n=================================================================================\nHECHO!\n\n"

build:


	@echo "Nada para compilar!"
install:
	@mkdir -p $(DESTDIR)/usr/sbin
	@mkdir -p $(DESTDIR)/usr/share/popularity-contest
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/popcon-mail/all-popcon-results
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/popcon-mail/all-popcon-results.stable
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/popcon-mail/new-popcon-entries
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/Mail
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/logs
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/bin
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/popcon-stat
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/popcon-web
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/www
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/www/stable
	@mkdir -p $(DESTDIR)/srv/popcon-canaima/www/stat
	@mkdir -p $(DESTDIR)/var/lib/popcon/bin/popcon-entries
	@touch etch.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch potato.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch potato-nonUS.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch sarge.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch slink.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch slink-nonUS.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch woody.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@touch woody-nonUS.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp imagenes/logo_encuesta_canaima.svg $(DESTDIR)/srv/popcon-canaima/www/stat
	@cp popcon-process.sh $(DESTDIR)/srv
	@cp clean-filter $(DESTDIR)/srv/popcon-canaima/bin
	@cp clean-genpkglist $(DESTDIR)/srv/popcon-canaima/bin
	@cp popcon.pl $(DESTDIR)/srv/popcon-canaima/bin
	@cp popcon-stat.pl $(DESTDIR)/srv/popcon-canaima/bin
	@cp popanal.py $(DESTDIR)/srv/popcon-canaima/bin
	@cp prepop.pl $(DESTDIR)/var/lib/popcon/bin 
	@cp popularity-contest $(DESTDIR)/usr/sbin
	@cp popcon-largest-unused $(DESTDIR)/usr/sbin
	@cp popcon-upload $(DESTDIR)/usr/share/popularity-contest
	@cp default.conf $(DESTDIR)/usr/share/popularity-contest
	@chmod 644 default.conf
	
uninstall:
	
	@rm -rf $(DESTDIR)/srvpopcon-canaima/bin/clean-filter
	@rm -rf $(DESTDIR)/srv/popcon-canaima/bin/clean-genkglist
	@rm -rf $(DESTDIR)/srv/popcon-canaima/in/popcon.pl
	@rm -rf $(DESTDIR)/srv/popcon-canaima/bin/popcon-stat.pl
	@rm -rf $(DESTDIR)/srv/popcon-canaima/bin/popanal.py
	@rm -rf $(DESTDIR)/var/lib/popcon/bin/prepop.pl
	@rm -rf $(DESTDIR)/srv/popcon-process.sh
	@rm -r  $(DESTDIR)/var/lib/popcon
	@rm -r  $(DESTDIR)/srv/popcon-canaima/

clean:

	@echo "nada que retomar a su origen"

distclean:

reinstall: uninstall install
