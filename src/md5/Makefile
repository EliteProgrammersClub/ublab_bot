# Makefile for src/md5/
# $Id: Makefile.in,v 1.14 2011/07/09 15:07:48 thommey Exp $

SHELL = /bin/bash
top_srcdir = ../..
srcdir = .



INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL}

CC = gcc
LD = gcc
STRIP = touch
CFLAGS = -g -O2 -pipe -Wall -I. -I../.. -I$(top_srcdir) -I$(top_srcdir)/src -DHAVE_CONFIG_H $(CFLGS)
CPPFLAGS = 

OBJS = md5c.o

doofus:
	@echo ""
	@echo "Let's try this from the right directory..."
	@echo ""
	@cd ../.. && $(MAKE)

depend:
	$(CC) -I../.. -I../../src -DMAKING_DEPEND -DHAVE_CONFIG_H -MM *.c > .depend

clean:
	@rm -f .depend *.o *~

md5: $(OBJS)

.SUFFIXES:
.SUFFIXES: .c .o .h

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

#safety hash
md5c.o: md5c.c md5.h ../../src/compat/compat.h \
 ../../src/compat/inet_aton.h ../../src/main.h ../../config.h \
 ../../lush.h ../../src/lang.h ../../src/eggdrop.h ../../src/flags.h \
 ../../src/proto.h ../../src/misc_file.h ../../src/cmdt.h \
 ../../src/tclegg.h ../../src/tclhash.h ../../src/chan.h \
 ../../src/users.h ../../src/compat/compat.h ../../src/compat/snprintf.h \
 ../../src/compat/memset.h ../../src/compat/memcpy.h \
 ../../src/compat/strcasecmp.h ../../src/compat/strdup.h \
 ../../src/compat/strftime.h
