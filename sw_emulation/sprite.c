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


rgb_pixel_t Sprite_Array [DISPLAY_HEIGHT][DISPLAY_WIDTH];
void sprite_init() {
   memset(Sprite_Array, 0, DISPLAY_WIDTH * DISPLAY_HEIGHT * sizeof(rgb_pixel_t));
}

void gl_state_input (sprite_info_t Gl_array[]){

    int i,j,m;
    int type;
    int xcoord;
    int ycoord;

    for (i = 0; i < INPUT_STRUCT_LENGTH; i++){
        xcoord = Gl_array[i].x;
        ycoord = Gl_array[i].y;
        type = Gl_array[i].id;

       for (j = xcoord; j< xcoord + 8 ; j++)
        {
            for(m = ycoord; m< ycoord + 8; m++)
            {
                if(type == 50){
                    read_ppm(50, &Sprite_Array, j, m);
                 }
                else if (type == 49){
                    Sprite_Array[j][m].r = 0;
                    Sprite_Array[j][m].g = 255;
                    Sprite_Array[j][m].b = 0;
                }
                else if (type == 3){
                    Sprite_Array[j][m].r = 255;
                    Sprite_Array[j][m].g = 255;
                    Sprite_Array[j][m].b = 0;
                }
                else {
                    Sprite_Array[j][m].r = 0;
                    Sprite_Array[j][m].g = 255;
                    Sprite_Array[j][m].b = 255;
                }
          }

       }

    }

}


rgb_pixel_t vga_rgb_req(int hcount, int vcount){
    rgb_pixel_t rt;
    rt = Sprite_Array[hcount][vcount];
    return rt;
}

void read_ppm(int id, rgb_pixel_t *state_array, int x, int y) {

    char buf[256];
    unsigned int w, h;

    FILE *file;
    file = fopen("sprite.ppm", "r");

    if (file == NULL) return NULL;
    fgets(buf, 256, file);
    fgets(buf, 256, file);
    sscanf(buf, "%u %u", &w, &h);
    fgets(buf, 256, file);
    fseek(file, 1, SEEK_CUR);

    size_t rd = fread((*state_array)[x][y], 3, w*h, file);

    if (rd <  h*w) {
        return NULL;
    }

}
