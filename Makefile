# Makefile for c2i (clipboard-to-imagefile)
# BCS1212-compliant installation

PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man/man1
COMPDIR ?= /etc/bash_completion.d
DESTDIR ?=

SCRIPT  := clipboard-to-imagefile
SYMLINK := c2i
MANPAGE := c2i.1
COMPFILE := c2i.bash_completion

.PHONY: all install uninstall check test help

all: help

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(SCRIPT) $(DESTDIR)$(BINDIR)/$(SCRIPT)
	ln -sf $(SCRIPT) $(DESTDIR)$(BINDIR)/$(SYMLINK)
	install -d $(DESTDIR)$(MANDIR)
	install -m 644 $(MANPAGE) $(DESTDIR)$(MANDIR)/$(MANPAGE)
	@if [ -d $(DESTDIR)$(COMPDIR) ]; then \
	  install -m 644 $(COMPFILE) $(DESTDIR)$(COMPDIR)/$(SYMLINK); \
	fi
	@if [ -z "$(DESTDIR)" ]; then $(MAKE) --no-print-directory check; fi

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(SYMLINK)
	rm -f $(DESTDIR)$(BINDIR)/$(SCRIPT)
	rm -f $(DESTDIR)$(MANDIR)/$(MANPAGE)
	rm -f $(DESTDIR)$(COMPDIR)/$(SYMLINK)

check:
	@command -v $(SYMLINK) >/dev/null 2>&1 \
	  && echo '$(SYMLINK): OK' \
	  || echo '$(SYMLINK): NOT FOUND (check PATH)'
	@command -v $(SCRIPT) >/dev/null 2>&1 \
	  && echo '$(SCRIPT): OK' \
	  || echo '$(SCRIPT): NOT FOUND (check PATH)'

test:
	@$(MAKE) -C tests test

help:
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@echo '  install     Install to $(PREFIX)'
	@echo '  uninstall   Remove installed files'
	@echo '  check       Verify installation'
	@echo '  test        Run test suite'
	@echo '  help        Show this message (default)'

#fin
