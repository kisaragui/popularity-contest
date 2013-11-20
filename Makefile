# Makefile
#
# ==============================================================================
# PAQUETE: Popularity-Contest
# ARCHIVO: Makefile
# DESCRIPCIÓN: registra en un log los paquetes instalados para enviarlo a un 
#               servidor de correo y mostrarlos en "pagina web".
# COPYRIGHT:
#  (C) 2013 Noel Jesus Alvarez Suarez <njesusas@gmail.com>
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
	@cp popweb/etch.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/potato.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/potato-nonUS.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/sarge.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/slink.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/slink-nonUS.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/woody.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
	@cp popweb/woody-nonUS.sections $(DESTDIR)/srv/popcon-canaima/popcon-web
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
	
	@rm -rf $(DESTDIR)/srv/popcon-process.sh
	@rm -rf $(DESTDIR)/var/lib/popcon
	@rm -rf $(DESTDIR)/srv/popcon-canaima/
	@rm -rf $(DESTDIR)/usr/sbin/popcon-largest-unused
	@rm -rf $(DESTDIR)/usr/sbin/popularity-contest
	@rm -rf $(DESTDIR)/usr/share/popularity-contest

clean:

	@echo "nada que retomar a su origen"

distclean:

reinstall: uninstall install
