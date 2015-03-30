CFLAGS = -Wall

OBJECTS = vga.o sprite.o tester_sprite.o

vga: $(OBJECTS)
	cc $(CFLAGS) -o emulator $(OBJECTS) -pthread

vga_tester: vga.o sprite.o tester_vga.o
	cc $(CFLAGS) -o vga_tester vga.o sprite.o tester_vga.o -pthread

vga.o: vga.c vga.h sprite.h Types.h
sprite.o: sprite.c sprite.h Types.h
tester_sprite.o: tester_sprite.c sprite.h Types.h
tester_vga.o: tester_vga.c sprite.h vga.h Types.h

.PHONY : clean
clean:
	rm -rf *.o emulator
