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

void read_ppm(int, rgb_pixel_t*, int, int);

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
                    read_ppm(50, j, m);
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

void read_ppm(int id, int x, int y) {

    char buf[2048]; //Max width size 640 columns * 3bytes per column
    unsigned int w, h, d;
    int i,j;

    FILE *file;
    file = fopen(id + ".ppm", "r");

    if (file == NULL) {
      return;
    }

    /* Reads format line. ex: P6 */
    fgets(buf, 256, file);
    debug_print("format %s\n", buf);

    /* Reads dimensions */
    fgets(buf, 256, file);
    sscanf(buf, "%u %u", &w, &h);
    debug_print("w: %u h: %u\n", w, h);

    /* Reads the color */
    fscanf(file, "%u", &d);
    debug_print("color: %u\n", d);

    /* Move past last newline char to image start */
    fseek(file, 1, SEEK_CUR);

    size_t rd = 0;
    for (i = y; i < h && i < DISPLAY_HEIGHT; i++){
      for(j = x; j < w && j < DISPLAY_WIDTH; j++){
          rd = fread(buf, 3, 1, file);
          debug_print("%x\n", buf);
          debug_print("%x %x %x\n", buf[0], buf[1], buf[2]);
          Sprite_Array[i][j].r = buf[0];
          Sprite_Array[i][j].g = buf[1];
          Sprite_Array[i][j].b = buf[2];
      }
    }

}

int main() {

read_ppm(1, 0, 0);
}
