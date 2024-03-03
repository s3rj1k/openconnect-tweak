CC = gcc
CFLAGS = -shared -fPIC
SRC = library.c
TARGET = openconnect-tweak.so

all: clean format compile strip

format:
	clang-format --style=Microsoft --sort-includes -i $(SRC)

compile:
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) -ldl

strip:
	strip --strip-unneeded $(TARGET)

clean:
	rm -f $(TARGET)
