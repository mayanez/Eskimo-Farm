CFLAGS = -Wall

SPRITE_TESTER_OBJECTS = vga.o sprite.o tester_sprite.o
VGA_TESTER_OBJECTS = vga.o sprite.o tester_vga.o

sprite_tester: $(SPRITE_TESTER_OBJECTS)
	cc $(CFLAGS) -o sprite_tester $(SPRITE_TESTER_OBJECTS)

vga_tester: $(VGA_TESTER_OBJECTS)
	cc $(CFLAGS) -o vga_tester $(VGA_TESTER_OBJECTS)

vga.o: vga.c vga.h sprite.h Types.h
sprite.o: sprite.c sprite.h Types.h
tester_sprite.o: tester_sprite.c sprite.h Types.h
tester_vga.o: tester_vga.c sprite.h vga.h Types.h

.PHONY : clean
clean:
	rm -rf *.o sprite_tester vga_tester
