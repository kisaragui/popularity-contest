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

	@mkdir -p $(DESTDIR)/srv/mirror/debian/dists/stable/contrib/binary-i386
	@mkdir -p $(DESTDIR)/srv/mirror/debian/dists/stable/main/binary-i386
	@mkdir -p $(DESTDIR)/srv/mirror/debian/dists/stable/non-free/binary-i386
	@mkdir -p $(DESTDIR)/srv/mirror/debian/dists/unstable/contrib/binary-i386
	@mkdir -p $(DESTDIR)/srv/mirror/debian/dists/unstable/main/binary-i386
	@mkdir -p $(DESTDIR)/srv/mirror/debian/dists/unstable/non-free/binary-i386
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/popcon-mail/all-popcon-results
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/popcon-mail/all-popcon-results.stable
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/popcon-mail/new-popcon-entries
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/Mail
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/logs
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/bin
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/popcon-stat
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/popcon-web
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/www
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/www/stable
	@mkdir -p $(DESTDIR)/srv/popcon.debian.org/www/stat
	@mkdir -p $(DESTDIR)/var/lib/popcon/bin/popcon-entries 
	@cp popcon-process.sh $(DESTDIR)/srv
        @cp clean-filter $(DESTDIR)/srv/popcon.debian.org/bin
	@cp clean-genpkglist $(DESTDIR)/srv/popcon.debian.org/bin
	@cp popcon.pl $(DESTDIR)/srv/popcon.debian.org/bin
	@cp popcon-stat.pl $(DESTDIR)/srv/popcon.debian.org/bin
	@cp popanal.py $(DESTDIR)/srv/popcon.debian.org/bin
	@cp prepop.pl $(DESTDIR)/var/lib/popcon/bin 

uninstall:
	
        @rm -rf $(DESTDIR)/srv/popcon.debian.org/bin/clean-filter
	@rm -rf $(DESTDIR)/srv/popcon.debian.org/bin/clean-genkglist
	@rm -rf $(DESTDIR)/srv/popcon.debian.org/bin/popcon.pl
	@rm -rf $(DESTDIR)/srv/popcon.debian.org/bin/popcon-stat.pl
	@rm -rf $(DESTDIR)/srv/popcon.debian.org/bin/popanal.py
	@rm -rf $(DESTDIR)/var/lib/popcon/bin/prepop.pl
	@rm -rf $(DESTDIR)/srv/popcon-process.sh
	@rm -r  $(DESTDIR)/var/lib/popcon
	@rm -r  $(DESTDIR)/srv/popcon.debian.org

clean:

	@echo "nada que retomar a su origen"

distclean:

reinstall: uninstall install
