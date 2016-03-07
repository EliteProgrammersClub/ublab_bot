#
#  This is the Makefile for EGGDROP (the IRC bot)
#  You should never need to edit this.
#
# $Id: Makefile.in,v 1.43 2010/03/14 18:21:59 pseudo Exp $

SHELL = /bin/bash
top_srcdir = .
srcdir = .



prefix = ${HOME}/eggdrop
DEST = ${prefix}
EGGEXEC = eggdrop
EGGVERSION = 1.6.21

# Extra compiler flags
#
# Things you can put here:
#
#   -Wall            if you're using gcc and it supports it
#                    (configure usually detects this anyway now)
#
#   -DDEBUG          generic debugging code
#   -DDEBUG_ASSERT   to enable assert debugging
#   -DDEBUG_MEM      to be able to debug memory allocation (.debug)
#   -DDEBUG_DNS      to enable dns.mod extra debugging information
#
# Debug defines can be set with configure now.
# See ./configure --help for more information.

CFLGS = 
DEBCFLGS = -g3 -DDEBUG -DDEBUG_ASSERT -DDEBUG_MEM -DDEBUG_DNS

# ./configure SHOULD set these; however you may need to tweak them to get
# modules to compile. If you do, PLEASE let the development team know so
# we can incorporate any required changes into the next release. You can
# contact us via eggdev@eggheads.org

# Defaults
CC = gcc
LD = gcc
STRIP = touch
RANLIB = ranlib

# make 'modegg'
MOD_CC = gcc
MOD_LD = gcc
MOD_STRIP = touch

# make 'modules'
SHLIB_CC = gcc -fPIC
SHLIB_LD = gcc -shared -nostartfiles
SHLIB_STRIP = touch
MOD_EXT = so

# Programs make install uses
LN_S = ln -s
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL}

# Stuff for Tcl
TCLLIB = /usr/lib/x86_64-linux-gnu
TCLLIBFN = tcl8.6.so
XREQS = /usr/lib/x86_64-linux-gnu/libtcl8.6.so

# Extra libraries
# XLIBS will be linked with everything
# MODULE_XLIBS will only be linked with the module objects
XLIBS = -L/usr/lib/x86_64-linux-gnu -ltcl8.6 -lm -ldl -lnsl  -lpthread
MODULE_XLIBS = 

# You shouldn't need to edit anything below this line.

modconf = $(top_srcdir)/misc/modconfig --top_srcdir=$(top_srcdir)

egg_test_run = EGG_LANGDIR=$(top_srcdir)/language ./$(EGGEXEC) -v

post_config  =  echo "" && \
		echo "You can now compile the bot, using \"make\"." && \
		echo ""

post_iconfig =  $(modconf) update-depends && \
		$(modconf) Makefile && \
		(cd src/mod && $(MAKE_CONFIG) config) && \
		$(modconf) Makefile

egg_install_msg =  echo "" && \
		   echo "Now run \"make install\" to install your bot." && \
		   echo ""

MAKE_MODEGG = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(MOD_CC)' 'LD=$(MOD_LD)' \
'STRIP=$(MOD_STRIP)' 'RANLIB=$(RANLIB)' 'CFLGS=$(CFLGS)' \
'TCLLIB=$(TCLLIB)' 'TCLLIBFN=$(TCLLIBFN)' 'XREQS=$(XREQS)' \
'XLIBS=$(XLIBS)' 'EGGEXEC=$(EGGEXEC)' 'EGGBUILD=(standard build)' 'MODOBJS='

MAKE_MODULES = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(SHLIB_CC)' 'LD=$(SHLIB_LD)' \
'STRIP=$(SHLIB_STRIP)' 'CFLGS=$(CFLGS)' 'XLIBS=$(XLIBS)' \
'MOD_EXT=$(MOD_EXT)' 'MODULE_XLIBS=$(MODULE_XLIBS)'

MAKE_STATIC = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(CC)' 'LD=$(LD)' \
'STRIP=$(STRIP)' 'RANLIB=$(RANLIB)' 'CFLGS=$(CFLGS) -DSTATIC' \
'TCLLIB=$(TCLLIB)' 'TCLLIBFN=$(TCLLIBFN)' 'XREQS=$(XREQS)' \
'XLIBS=$(XLIBS)' 'EGGEXEC=$(EGGEXEC)' 'EGGBUILD=(static version)' \
'MODOBJS=mod/*.o'

MAKE_DEBEGG = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(MOD_CC)' 'LD=$(MOD_LD)' \
'STRIP=touch' 'RANLIB=$(RANLIB)' 'CFLGS=$(DEBCFLGS) $(CFLGS)' \
'TCLLIB=$(TCLLIB)' 'TCLLIBFN=$(TCLLIBFN)' 'XREQS=$(XREQS)' \
'XLIBS=$(XLIBS)' 'EGGEXEC=$(EGGEXEC)' 'EGGBUILD=(debug version)' 'MODOBJS='

MAKE_DEBMODULES = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(SHLIB_CC)' 'LD=$(SHLIB_LD)' \
'XLIBS=$(XLIBS)' 'STRIP=touch' 'CFLGS=$(DEBCFLGS) $(CFLGS)' \
'MOD_EXT=$(MOD_EXT)' 'MODULE_XLIBS=$(MODULE_XLIBS)'

MAKE_SDEBUG = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(CC)' 'LD=$(LD)' \
'STRIP=touch' 'RANLIB=$(RANLIB)' 'CFLGS=$(DEBCFLGS) $(CFLGS) -DSTATIC' \
'TCLLIB=$(TCLLIB)' 'TCLLIBFN=$(TCLLIBFN)' 'XREQS=$(XREQS)' 'XLIBS=$(XLIBS)' \
'EGGEXEC=$(EGGEXEC)' 'EGGBUILD=(static debug version)' 'MODOBJS=mod/*.o'

MAKE_DEPEND = $(MAKE) 'MAKE=$(MAKE)' 'CC=$(CC)'

MAKE_CONFIG = $(MAKE) 'MAKE=$(MAKE)'

MAKE_INSTALL = $(MAKE) 'MAKE=$(MAKE)' 'DEST=$(DEST)'

all: eggdrop

eggclean:
	@rm -f $(EGGEXEC) *.$(MOD_EXT) *.stamp core DEBUG *~
	@cd doc && $(MAKE) clean
	@cd scripts && $(MAKE) clean
	@cd src && $(MAKE) clean
	@cd src/md5 && $(MAKE) clean
	@cd src/compat && $(MAKE) clean

clean: eggclean
	@cd src/mod && $(MAKE) clean

distclean: eggclean clean-modconfig
	@cd src/mod && $(MAKE) distclean
	@rm -f Makefile doc/Makefile scripts/Makefile src/Makefile src/md5/Makefile src/compat/Makefile src/mod/Makefile
	@rm -f config.cache config.log config.status config.h lush.h
	@rm -rf autom4te.cache

distrib:
	misc/releaseprep

depend:
	@cat /dev/null > lush.h
	@cd src && $(MAKE_DEPEND) depend
	@cd src/md5 && $(MAKE_DEPEND) depend
	@cd src/mod && $(MAKE_DEPEND) depend
	@cd src/compat && $(MAKE_DEPEND) depend

config:
	@$(modconf) modules-still-exist
	@$(modconf) detect-modules
	@$(modconf) update-depends
	@$(modconf) Makefile
	@cd src/mod && $(MAKE_CONFIG) config
	@$(modconf) Makefile
	@$(post_config)

new-iconfig:
	@$(modconf) modules-still-exist
	@$(modconf) update-depends
	@$(modconf) -n configure
	@$(post_iconfig)
	@$(post_config)

iconfig:
	@$(modconf) modules-still-exist
	@$(modconf) detect-modules
	@$(modconf) update-depends
	@$(modconf) configure
	@$(post_iconfig)
	@$(post_config)

clean-modconfig:
	@rm -f .modules .known_modules

conftest:
	@if test ! -f .modules; then \
		echo ""; \
		echo "You have NOT configured modules yet. This has to be done before you"; \
		echo "can start compiling."; \
		echo ""; \
		echo "   Run \"make config\" or \"make iconfig\" now."; \
		echo ""; \
		exit 1; \
	fi

reconfig: clean-modconfig config

eggdrop: modegg modules

modegg: modtest
	@rm -f src/mod/mod.xlibs
	@cd src && $(MAKE_MODEGG) $(EGGEXEC)

modules: modtest
	@cd src/mod && $(MAKE_MODULES) modules
	@echo ""
	@echo "Test run of ./eggdrop -v:"
	@$(egg_test_run)
	@echo ""
	@echo "Eggdrop successfully compiled:"
	@ls -l $(EGGEXEC)
	@echo ""
	@echo "Modules successfully compiled:"
	@ls -l *.$(MOD_EXT)
	@$(egg_install_msg)

static: eggtest
	@echo ""
	@echo "Making module objects for static linking..."
	@echo ""
	@rm -f src/mod/mod.xlibs
	@cd src/mod && $(MAKE_STATIC) static
	@echo ""
	@echo "Making core eggdrop for static linking..."
	@echo ""
	@cd src && $(MAKE_STATIC) $(EGGEXEC)
	@echo ""
	@echo "Test run of ./eggdrop -v:"
	@$(egg_test_run)
	@echo ""
	@echo "Eggdrop successfully compiled:"
	@ls -l $(EGGEXEC)
	@echo ""
	@$(egg_install_msg)

debug: debegg debmodules

debegg: modtest
	@cd src && $(MAKE_DEBEGG) $(EGGEXEC)

debmodules: modtest
	@cd src/mod && $(MAKE_DEBMODULES) modules
	@echo ""
	@echo "Test run of ./eggdrop -v:"
	@$(egg_test_run)
	@echo ""
	@echo "Eggdrop successfully compiled:"
	@ls -l $(EGGEXEC)
	@echo ""
	@echo "Modules successfully compiled:"
	@ls -l *.$(MOD_EXT)
	@$(egg_install_msg)

sdebug: eggtest
	@echo ""
	@echo "Making module objects for static linking."
	@echo ""
	@rm -f src/mod/mod.xlibs
	@cd src/mod && $(MAKE_SDEBUG) static
	@echo ""
	@echo "Making eggdrop core for static linking."
	@echo ""
	@cd src && $(MAKE_SDEBUG) $(EGGEXEC)
	@echo ""
	@echo "Test run of ./eggdrop -v:"
	@$(egg_test_run)
	@echo ""
	@echo "Eggdrop successfully compiled:"
	@ls -l $(EGGEXEC)
	@echo ""
	@$(egg_install_msg)

eggtest: conftest
	@if test -f EGGMOD.stamp; then \
		echo "You're trying to do a STATIC build of eggdrop when you've";\
		echo "already run 'make' for a module build.";\
		echo "You must first type \"make clean\" before you can build";\
		echo "a static version.";\
		exit 1;\
	fi
	@echo "stamp" >EGGDROP.stamp

modtest: conftest
	@if [ -f EGGDROP.stamp ]; then \
		echo "You're trying to do a MODULE build of eggdrop when you've";\
		echo "already run 'make' for a static build.";\
		echo "You must first type \"make clean\" before you can build";\
		echo "a module version.";\
		exit 1;\
	fi
	@echo "stamp" >EGGMOD.stamp

install: ainstall

dinstall: eggdrop ainstall

sinstall: static ainstall

ainstall: install-start install-bin install-modules install-data \
install-help install-language install-filesys install-doc \
install-scripts install-end

install-start:
	@if test ! -f $(EGGEXEC); then \
		echo ""; \
		echo "You haven't compiled Eggdrop yet."; \
		echo "To compile Eggdrop, use:"; \
		echo ""; \
		echo "  make [target]"; \
		echo ""; \
		echo "Valid targets: 'eggdrop', 'static', 'debug', 'sdebug'."; \
		echo "Default target: 'eggdrop'."; \
		echo ""; \
		exit 1; \
	fi
	@if test "x$(DEST)" = "x"; then \
		echo "You must specify a destination directory."; \
		echo "Example:"; \
		echo ""; \
		echo "  make install DEST=\"/home/wcc/mybot\""; \
		echo ""; \
		exit 1; \
	fi
	@echo ""
	@$(egg_test_run)
	@echo ""
	@echo "Installing in directory: '$(DEST)'."
	@echo ""
	@if test ! -d $(DEST); then \
		echo "Creating directory '$(DEST)'."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST) >/dev/null; \
	fi

install-bin:
	@if test -f $(DEST)/o$(EGGEXEC); then \
		rm -f $(DEST)/o$(EGGEXEC); \
	fi
	@if test -h $(DEST)/$(EGGEXEC); then \
		echo "Removing symlink to archival eggdrop binary."; \
		rm -f $(DEST)/$(EGGEXEC); \
	fi
	@if test -f $(DEST)/$(EGGEXEC); then \
		echo "Renaming old '$(EGGEXEC)' executable to 'o$(EGGEXEC)'."; \
		mv -f $(DEST)/$(EGGEXEC) $(DEST)/o$(EGGEXEC); \
	fi
	@echo "Copying new '$(EGGEXEC)' executable and creating symlink."
	@$(INSTALL_PROGRAM) $(EGGEXEC) $(DEST)/$(EGGEXEC)-$(EGGVERSION)
	@(cd $(DEST) && $(LN_S) $(EGGEXEC)-$(EGGVERSION) $(EGGEXEC))

install-modules:
	@if test -h $(DEST)/modules; then \
		echo "Removing symlink to archival modules subdirectory."; \
		rm -f $(DEST)/modules; \
	fi
	@if test -d $(DEST)/modules; then \
		echo "Moving old modules into 'modules.old' subdirectory."; \
		rm -rf $(DEST)/modules.old; \
		mv -f $(DEST)/modules $(DEST)/modules.old; \
	fi
	@if test ! "x`echo *.$(MOD_EXT)`" = "x*.$(MOD_EXT)"; then \
		if test ! -d $(DEST)/modules-$(EGGVERSION); then \
			echo "Creating 'modules-$(EGGVERSION)' subdirectory and symlink."; \
			$(top_srcdir)/misc/mkinstalldirs $(DEST)/modules-$(EGGVERSION) >/dev/null; \
		fi; \
		(cd $(DEST) && $(LN_S) modules-$(EGGVERSION) modules); \
		echo "Copying new modules."; \
		for i in *.$(MOD_EXT); do \
			$(INSTALL_PROGRAM) $$i $(DEST)/modules-$(EGGVERSION)/; \
		done; \
	fi

install-data:
	@if test ! -f $(DEST)/eggdrop.conf; then \
		$(INSTALL_DATA) $(srcdir)/eggdrop.conf $(DEST)/; \
	fi
	@if test ! -d $(DEST)/logs; then \
		echo "Creating 'logs' subdirectory."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/logs >/dev/null; \
		$(INSTALL_DATA) $(srcdir)/logs/CONTENTS $(DEST)/logs/; \
	fi;
	@if test ! -d $(DEST)/text; then \
		echo "Creating 'text' subdirectory."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/text >/dev/null; \
	fi;
	@if test ! -f $(DEST)/text/motd; then \
		$(INSTALL_DATA) $(srcdir)/text/motd $(DEST)/text/; \
	fi
	@if test ! -f $(DEST)/text/banner; then \
		$(INSTALL_DATA) $(srcdir)/text/banner $(DEST)/text/; \
	fi

install-help:
	@echo "Copying help files."
	@if test ! "x`echo $(srcdir)/help/*.help`" = "x$(srcdir)/help/*.help"; then \
		if test ! -d $(DEST)/help; then \
			echo "Creating 'help' subdirectory."; \
			$(top_srcdir)/misc/mkinstalldirs $(DEST)/help >/dev/null; \
		fi; \
		for i in $(srcdir)/help/*.help; do \
			$(INSTALL_DATA) $$i $(DEST)/help/; \
		done; \
	fi
	@if test ! "x`echo $(srcdir)/help/msg/*.help`" = "x$(srcdir)/help/msg/*.help"; then \
		if test ! -d $(DEST)/help/msg; then \
			echo "Creating 'help/msg' subdirectory."; \
			$(top_srcdir)/misc/mkinstalldirs $(DEST)/help/msg >/dev/null; \
		fi; \
		for i in $(srcdir)/help/msg/*.help; do \
			$(INSTALL_DATA) $$i $(DEST)/help/msg/; \
		done; \
	fi
	@if test ! "x`echo $(srcdir)/help/set/*.help`" = "x$(srcdir)/help/set/*.help"; then \
		if test ! -d $(DEST)/help/set; then \
			echo "Creating 'help/set' subdirectory."; \
			$(top_srcdir)/misc/mkinstalldirs $(DEST)/help/set >/dev/null; \
		fi; \
		for i in $(srcdir)/help/set/*.help; do \
			$(INSTALL_DATA) $$i $(DEST)/help/set/; \
		done; \
	fi
	@cd src/mod/ && $(MAKE_INSTALL) install-help

install-language:
	@echo "Copying language files."
	@if test ! "x`echo $(srcdir)/language/*.lang`" = "x$(srcdir)/language/*.lang"; then \
		if test ! -d $(DEST)/language; then \
			echo "Creating 'language' subdirectory."; \
			$(top_srcdir)/misc/mkinstalldirs $(DEST)/language >/dev/null; \
		fi; \
		for i in $(srcdir)/language/*.lang; do \
			$(INSTALL_DATA) $$i $(DEST)/language/; \
		done; \
	fi
	@cd src/mod && $(MAKE_INSTALL) install-language

install-filesys:
	@if test ! -d $(DEST)/filesys; then \
		echo "Creating skeletal filesystem subdirectories."; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/filesys >/dev/null; \
		$(top_srcdir)/misc/mkinstalldirs $(DEST)/filesys/incoming >/dev/null; \
	fi

install-doc:
	@$(INSTALL_DATA) $(srcdir)/README $(DEST)
	@cd doc/ && $(MAKE_INSTALL) install

install-scripts:
	@cd scripts/ && $(MAKE_INSTALL) install

install-end:
	@echo
	@echo "Installation completed."
	@echo ""
	@echo "You MUST ensure that you edit/verify your configuration file."
	@echo "An example configuration file, eggdrop.conf, is distributed with Eggdrop."
	@echo ""
	@echo "Remember to change directory to $(DEST) before you proceed."
	@echo ""

#safety hash
