#ifndef _SPRITE_H
#define _SPRITE_H

#include "Types.h"

sprite_info_t Gl_array[INPUT_STRUCT_LENGTH];

void sprite_init();
void gl_state_input (sprite_info_t Gl_array[INPUT_STRUCT_LENGTH]);
rgb_pixel_t vga_rgb_req(int h, int v);

#endif
