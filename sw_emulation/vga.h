#ifndef _VGA_H
#define _VGA_H

#include "Types.h"

extern int hcount, vcount;

void vga_init();
void draw_rgb_fb();

#endif