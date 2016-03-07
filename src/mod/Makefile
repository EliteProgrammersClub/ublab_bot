# Makefile for src/mod/
# $Id: Makefile.in,v 1.22 2011/09/23 20:31:32 thommey Exp $

SHELL = /bin/bash
top_srcdir = ../..
srcdir = .

MOD_UPDIR = ../


INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL}

CC = gcc
LD = gcc
STRIP = touch
CFLAGS = -g -O2 -pipe -Wall -I../.. -I$(top_srcdir) -DHAVE_CONFIG_H $(CFLGS)
CPPFLAGS = 
MOD_CFLAGS = -g -O2 -pipe -Wall -I. -I../../.. -I$(MOD_UPDIR)$(top_srcdir) \
  -I$(MOD_UPDIR)$(top_srcdir)/src/mod -DHAVE_CONFIG_H $(CFLGS)
MOD_CPPFLAGS = 
XLIBS = @XLIBS@
MOD_EXT = so

# Note: The following three lines are automatically adjusted by
#       misc/modconfig. They have to be present here.
mods = assoc.mod blowfish.mod channels.mod compress.mod console.mod ctcp.mod dns.mod filesys.mod irc.mod notes.mod seen.mod server.mod share.mod transfer.mod uptime.mod wire.mod woobie.mod 
mod_objs = assoc.mod_o blowfish.mod_o channels.mod_o compress.mod_o console.mod_o ctcp.mod_o dns.mod_o filesys.mod_o irc.mod_o notes.mod_o seen.mod_o server.mod_o share.mod_o transfer.mod_o uptime.mod_o wire.mod_o woobie.mod_o
mod_libs = assoc.mod_so blowfish.mod_so channels.mod_so compress.mod_so console.mod_so ctcp.mod_so dns.mod_so filesys.mod_so irc.mod_so notes.mod_so seen.mod_so server.mod_so share.mod_so transfer.mod_so uptime.mod_so wire.mod_so woobie.mod_so

modconfig = $(top_srcdir)/misc/modconfig --bindir=../.. \
  --top_srcdir=$(top_srcdir)
egg_ac_parameters =  '--with-tcllib=/usr/lib/x86_64-linux-gnu/libtcl8.6.so' '--with-tclinc=/usr/include/tcl/tcl.h'

MAKE_MOD = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(CC)' 'LD=$(LD)' \
'STRIP=$(STRIP)' 'CFLAGS=$(MOD_CFLAGS)' 'CPPFLAGS=$(MOD_CPPFLAGS)' \
'XLIBS=$(XLIBS)' 'MOD_EXT=$(MOD_EXT)' 'SHELL=$(SHELL)' \
'MODULE_XLIBS=$(MODULE_XLIBS)'

MAKE_MODDEPEND = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(CC)' \
'CFLAGS=-I../../.. -I../../../src/mod -DMAKING_DEPEND -DHAVE_CONFIG_H -DMAKING_MODS'

doofus:
	@echo ""
	@echo "Let's try this from the right directory..."
	@echo ""
	@cd ../.. && $(MAKE)

modules: $(mod_libs)
	@echo ""
	@echo "All modules compiled."

static: $(mod_objs)
	@$(modconfig) static.h

.SUFFIXES:
.SUFFIXES: .mod .mod_so .mod_o

.mod.mod_so:
	@if test ! -d $*.mod; then mkdir $*.mod; fi; \
	if test ! -r $*.mod/Makefile; then \
		cp $(srcdir)/$*.mod/Makefile $*.mod/Makefile; \
	fi; \
	cd $*.mod && $(MAKE_MOD) 'VPATH=$(MOD_UPDIR)$(srcdir)/$*.mod' 'srcdir=$(MOD_UPDIR)$(srcdir)/$*.mod' 'MAKE=$(MAKE)' modules;

.mod.mod_o:
	@if test ! -d $*.mod; then mkdir $*.mod; fi; \
	if test ! -r $*.mod/Makefile; then \
		cp $(srcdir)/$*.mod/Makefile $*.mod/Makefile; \
	fi; \
	cd $*.mod && $(MAKE_MOD) 'VPATH=$(MOD_UPDIR)$(srcdir)/$*.mod' 'srcdir=$(MOD_UPDIR)$(srcdir)/$*.mod' 'MAKE=$(MAKE)' static;

depend:
	@for i in $(mods); do \
		if test ! -d $$i; then mkdir $$i; fi; \
		if test ! -r $$i/Makefile; then \
			cp $(srcdir)/$$i/Makefile $$i/Makefile; \
		fi; \
		(cd $$i && $(MAKE_MODDEPEND) "VPATH=$(MOD_UPDIR)$(srcdir)/$$i" "srcdir=$(MOD_UPDIR)$(srcdir)/$$i" depend); \
	done

config:
	@for i in $(mods); do \
		if test -f $(srcdir)/$$i/configure; then \
			modname=`echo $$i | sed -e 's/.mod//'`; \
			echo ""; \
			echo "Configuring module '$${modname}'."; \
			if test ! -d $$i; then mkdir $$i; fi; \
			(cd $$i && $(MOD_UPDIR)$(srcdir)/$$i/configure --disable-option-checking $(egg_ac_parameters) --cache-file=../../../config.cache --srcdir=$(MOD_UPDIR)$(top_srcdir)/src/mod/$$i); \
		fi; \
	done; \
	echo ""

clean:
	@rm -f *.o *.$(MOD_EXT) *~ static.h mod.xlibs
	@for i in *.mod; do \
		if test ! -d $$i; then mkdir $$i; fi; \
		if (test ! -r $$i/Makefile) && \
		   (test -r $(srcdir)/$$i/Makefile); then \
			cp $(srcdir)/$$i/Makefile $$i/Makefile; \
		fi; \
		if (test -r $$i/Makefile); then \
			(cd $$i; $(MAKE) "VPATH=$(MOD_UPDIR)$(srcdir)/$$i" "srcdir=$(MOD_UPDIR)$(srcdir)/$$i" 'MAKE=$(MAKE)' clean); \
		fi; \
	done

distclean:
	@rm -f *.o *.$(MOD_EXT) *~ static.h mod.xlibs
	@for i in *.mod; do \
		if test ! -d $$i; then mkdir $$i; fi; \
		if (test ! -r $$i/Makefile) && \
		   (test -r $(srcdir)/$$i/Makefile); then \
			cp $(srcdir)/$$i/Makefile $$i/Makefile; \
		fi; \
		if (test -r $$i/Makefile); then \
			(cd $$i; $(MAKE) "VPATH=$(MOD_UPDIR)$(srcdir)/$$i" "srcdir=$(MOD_UPDIR)$(srcdir)/$$i" 'MAKE=$(MAKE)' distclean); \
		fi; \
	done

install: install-help install-language

install-help:
	@echo "Copying module help files."
	@if test ! -d $(DEST)/help; then \
		echo "Creating 'help' subdirectory."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/help >/dev/null; \
	fi; \
	for i in $(mods); do \
		if test ! "x`echo $(srcdir)/$$i/help/*.help`" = "x$(srcdir)/$$i/help/*.help"; then \
			for h in $(srcdir)/$$i/help/*.help; do \
				$(INSTALL_DATA) $$h $(DEST)/help/; \
			done; \
		fi; \
	done;
	@if test ! -d $(DEST)/help/msg; then \
		echo "Creating 'help/msg' subdirectory."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/help/msg >/dev/null; \
	fi; \
	for i in $(mods); do \
		if test ! "x`echo $(srcdir)/$$i/help/msg/*.help`" = "x$(srcdir)/$$i/help/msg/*.help"; then \
			for h in $(srcdir)/$$i/help/msg/*.help; do \
				$(INSTALL_DATA) $$h $(DEST)/help/msg/; \
			done; \
		fi; \
	done;
	@if test ! -d $(DEST)/help/set; then \
		echo "Creating 'help/set' subdirectory."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/help/set >/dev/null; \
	fi; \
	for i in $(mods); do \
		if test ! "x`echo $(srcdir)/$$i/help/set/*.help`" = "x$(srcdir)/$$i/help/set/*.help"; then \
			for h in $(srcdir)/$$i/help/set/*.help; do \
				$(INSTALL_DATA) $$h $(DEST)/help/set/; \
			done; \
		fi; \
	done;

install-language:
	@echo "Copying module language files."
	@if test ! -d $(DEST)/language; then \
		echo "Creating 'language' subdirectory."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/language >/dev/null; \
	fi; \
	for i in $(mods); do \
		if test ! "x`echo $(srcdir)/$$i/language/*.lang`" = "x$(srcdir)/$$i/language/*.lang"; then \
			for h in $(srcdir)/$$i/language/*.lang; do \
				$(INSTALL_DATA) $$h $(DEST)/language/; \
			done; \
		fi; \
	done;

#safety hash
