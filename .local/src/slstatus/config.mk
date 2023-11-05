# slstatus version
VERSION = 1.0

# customize below to fit your system

include ../flags.mk

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# flags
CPPFLAGS = -I$(X11INC) -D_DEFAULT_SOURCE -DVERSION=\"${VERSION}\" ${HARDENING_CPPFLAGS}
CFLAGS   = -std=c99 -pedantic -Wall -Wextra -Wno-unused-parameter ${O_FLAG} ${HARDENING_CFLAGS}
LDFLAGS  = -L$(X11LIB) -s ${HARDENING_LDFLAGS}
# OpenBSD: add -lsndio
# FreeBSD: add -lkvm -lsndio
LDLIBS   = -lX11

# compiler and linker
CC = cc
