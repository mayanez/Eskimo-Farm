CFLAGS = -Wall

OBJECTS = vga.o sprite.o tester_sprite.o

vga: $(OBJECTS)
	cc $(CFLAGS) -o emulator $(OBJECTS)


vga.o: vga.c vga.h sprite.h Types.h
sprite.o: sprite.c sprite.h Types.h
tester_sprite.o: tester_sprite.c sprite.h Types.h

.PHONY : clean
clean:
	rm -rf *.o emulator
