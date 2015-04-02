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
#define DW 640
#define DH 480

rgb_pixel_t Sprite_Array [DH][DW];

void read_ppm(int, int, int);

void sprite_init() {
    read_ppm(1,0,0);
    //memset(Sprite_Array, 0, DW * DH * sizeof(rgb_pixel_t));
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
        if(type == ESKIMO){
            read_ppm(50, xcoord, ycoord);
        }
        
    }
}


rgb_pixel_t vga_rgb_req(int hcount, int vcount){
    rgb_pixel_t rt;
    rt = Sprite_Array[vcount][hcount];
    return rt;
}

void read_ppm(int id, int x, int y) {
    
    char buf[2048]; //Max width size 640 columns * 3bytes per column
    unsigned int w, h, d;
    int i,j;
    

    FILE *file;
    if(id == 1)
        file = fopen("1.ppm","r");
    else if (id == 50)
        file = fopen("50.ppm", "r");
    else
        printf("Invalid Id");
    
    if (file == NULL) {
        return;
    }
    
    /* Reads format line. ex: P6 */
    fgets(buf, 256, file);
    //    debug_print("format %s\n", buf);
    
    /* Reads dimensions */
    fgets(buf, 256, file);
    sscanf(buf, "%u %u", &w, &h);
    //   debug_print("w: %u h: %u\n", w, h);
    
    /* Reads the color */
    fscanf(file, "%u", &d);
    
    /* Move past last newline char to image start */
    fseek(file, 1, SEEK_CUR);
    
    size_t rd = 0;
    for (i = y; i < y + h && i < DH; i++){
        for(j = x; j < x + w && j < DW; j++){
            rd = fread(buf, 3, 1, file);
            Sprite_Array[i][j].r = buf[0];
            Sprite_Array[i][j].g = buf[1];
            Sprite_Array[i][j].b = buf[2];
        }
    }
    
    fclose(file);
}
