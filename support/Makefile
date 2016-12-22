CONSTANTS=../Sources/constants.swift
SDL:=$(shell cat sdl2-prefix)

all: $(CONSTANTS)
	
$(CONSTANTS): sdl2-prefix constants.c 
	gcc -I$(< sdl2-prefix)/include -o constants constants.c
	./constants > $@
	rm constants

constants.c: sdl2-prefix gen.rb
	ruby gen.rb $(SDL) > constants.c

clean:
	rm -f $(CONSTANTS) $(MODULEMAP) constants.c

.PHONY: all clean