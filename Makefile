# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

CC = gcc
CFLAGS = -Wall -std=c99

all: build_dir mctrd

build_dir:
	mkdir -p build

mctrd: src/main.c
	$(CC) $(CFLAGS) -o build/mctrd src/main.c

clean:
	rm -r -f build

.PHONY: all clean