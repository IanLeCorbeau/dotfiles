# Global Makefile for Suckless tools

MAKE    = make -C
SUBDIRS = dwm st dmenu slstatus

all:
	for _dir in ${SUBDIRS}; do \
        ${MAKE} $$_dir; \
        done

install:
	for _dir in ${SUBDIRS}; do \
        ${MAKE} $$_dir clean install; \
        done

clean:
	for _dir in ${SUBDIRS}; do \
        ${MAKE} $$_dir clean; \
        done
