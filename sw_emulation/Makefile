CFLAGS = -Wall

OBJECTS = vga.o sprite.o

vga: $(OBJECTS)
	cc $(CFLAGS) -o emulator $(OBJECTS)


vga.o: vga.c vga.h sprite.h Types.h
sprite.o: sprite.c sprite.h Types.h

.PHONY : clean
clean:
	rm -rf *.o emulator