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

#define ESKIMO  50
#define ENEMY   49
#define SKY     1

typedef struct sprite_info_t{
    int x;
    int y;
    int id;
} sprite_info_t;


rgb_pixel_t Sprite_Array [DISPLAY_WIDTH][DISPLAY_HEIGHT] = {{0}}; // initialise to 0


void gl_state_input (sprite_info_t Gl_array[]){
    
    int i;
    int type;
    int xcoord;
    int ycoord;

    for (i = 0; i < INPUT_STRUCT_LENGTH; i++){
        xcoord = Gl_array[i].x;
        ycoord = Gl_array[i].y;
        type = Gl_array[i].id;
        
        for(int j = i; j< 8+i; j++){
            if(type == 50){
            memset(Sprite_Array[j].r,0,8 );
            memset(Sprite_Array[j].g,255,8 );
            memset(Sprite_Array[j].b,0,8 );
            }
            
            else if (type == 49){
                memset(Sprite_Array[j].r,255,8 );
                memset(Sprite_Array[j].g,0,8 );
                memset(Sprite_Array[j].b,0,8 );
            }
            
            else{
                memset(Sprite_Array[j].r,255,8 );
                memset(Sprite_Array[j].g,255,8 );
                memset(Sprite_Array[j].b,0,8 );
            }
        }

    }
        
}


rgb_pixel_t vga_rgb_req(int hcount, int vcount){
    rgb_pixel_t rt;
    rt = Sprite_Array[hcount][vcount];
    return rt;
}
