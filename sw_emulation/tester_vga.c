#include "Types.h"
#include "sprite.h"
#include "vga.h"
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/* Tests Sprite Drawing to FB */
int main() {

    vga_init();

    int x;

    sprite_info_t input_array[INPUT_STRUCT_LENGTH]={0};
    input_array[0].x = 50;
    input_array[0].y = 20;
    input_array[0].id =  2;

    input_array[1].x = 471;
    input_array[1].y = 631;
    input_array[1].id =  3;

    input_array[2].x = 471;
    input_array[2].y = 0;
    input_array[2].id = 49;

    input_array[3].x = 0;
    input_array[3].y = 621;
    input_array[3].id = 50;

  
while(1) {
    sprite_init();
    /*Translates a sprite horizontally */
    if (x % 640 == 0 ) {
       x = 0;
    }
    x++;
    input_array[0].x = x;
    /* Will wait for screen to draw before getting next state */
	/* Updates the rgb_pixels to be drawn to screen */
        gl_state_input(input_array);
        draw_rgb_fb();
    }

    return 0;
}

