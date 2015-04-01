#ifndef _VGA_H_
#define _VGA_H_
#include "Types.h"

extern int hcount, vcount;

void vga_init();
void draw_rgb_fb();
#endif
