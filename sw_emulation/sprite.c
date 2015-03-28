
#include "sprite.h"
#include "vga.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <linux/fb.h>

#define ESKIMO  3
#define ENEMY   2
#define SKY     1

int Sprite_Array [DISPLAY_WIDTH][DISPLAY_HEIGHT] = {{0}}; // initialise to 0

void gl_state_input (sprite_info_t Gl_array[]){
    
    int i;
    for (i = 0; i < INPUT_STRUCT_LENGTH; i++)
        priority_checker(Gl_array, i);
}

void priority_checker (sprite_info_t Gl_array[], int i){
    int type = Gl_array[i].id;
    int xcoord = Gl_array[i].x;
    int ycoord = Gl_array[i].y;
    int check = Sprite_Array[xcoord][ycoord];
    
    switch(type){
        case (check < type) :
            Sprite_Array[xcoord][ycoord] = type;
            break;
        default:
            Sprite_Array[xcoord][ycoord] = type;
    }
}

rgb_pixel_t vga_rgb_req(int hcount, int vcount){
    int type = Sprite_Array[hcount][vcount];
    rgb_pixel_t rt;
    
    if (type == ESKIMO){
        rt.r = 0;
        rt.g = 255;
        rt.b = 0;
    }
    
    else if (type == ENEMY){
        rt.r = 255;
        rt.g = 0;
        rt.b = 0;
    }
    
    else {
        rt.r = 0;
        rt.g = 255;
        rt.b = 255;
    }
    
    return rt;
}
