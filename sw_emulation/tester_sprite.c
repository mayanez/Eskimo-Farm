#include "Types.h"
#include "sprite.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N INPUT_STRUCT_LENGTH


int verify_static_output() {
    sprite_init();
    sprite_info_t input_array[N]={0};
    input_array[0].x = 0;
    input_array[0].y = 0;
    input_array[0].id =  2; // Green

    input_array[1].x = 471;
    input_array[1].y = 631;
    input_array[1].id =  3; //Red

    input_array[2].x = 471;
    input_array[2].y = 0;
    input_array[2].id = 49;//Blue

    input_array[3].x =  0;
    input_array[3].y = 621;
    input_array[3].id = 50;//


    int i,j;
    int k=0;

    rgb_pixel_t golden_output[ROW][COL];
    rgb_pixel_t test_output[ROW][COL];

    gl_state_input (input_array);

    memset(golden_output,0,ROW*COL*sizeof(rgb_pixel_t));

    for(i=input_array[0].x; i< input_array[0].x + 8 ; i++) {
        for (j= input_array[0].y; j< input_array[0].y + 8;j++){
            golden_output[i][j].r = 0;
            golden_output[i][j].g = 255;
            golden_output[i][j].b = 255;
        }
    }

    for(i=input_array[1].x; i< input_array[1].x + 8 ; i++) {
        for (j= input_array[1].y; j< input_array[1].y + 8;j++){
            golden_output[i][j].r = 255;
            golden_output[i][j].g = 255;
            golden_output[i][j].b = 0;
        }
    }

    for(i=input_array[2].x; i< input_array[2].x + 8 ; i++) {
        for (j= input_array[2].y; j< input_array[2].y + 8;j++){
            golden_output[i][j].r = 0;
            golden_output[i][j].g = 255;
            golden_output[i][j].b = 0;
        }
    }


    for(i=input_array[3].x; i< input_array[3].x + 8 ; i++) {
        for (j= input_array[3].y; j< input_array[3].y + 8;j++){
            golden_output[i][j].r = 255;
            golden_output[i][j].g = 0;
            golden_output[i][j].b = 0;
        }
    }

    for(i=0;i<ROW;i++)
        for(j=0;j<COL;j++)
            test_output[i][j] = vga_rgb_req(i,j);

    for(i=0;i<ROW;i++) {
        for(j=0;j<COL;j++) {
            if(test_output[i][j].r != golden_output[i][j].r || test_output[i][j].g != golden_output[i][j].g || test_output[i][j].b != golden_output[i][j].b){
                return -1;
            }
        }
    }
    return 0;
}

int verify_sprite_from_ppm() {
    return -1;
}

int main(int argc, char const *argv[])
{
    if (verify_static_output() < 0) {
        printf("verify_static_output failed\n");
        return -1;
    }

    if (verify_sprite_from_ppm() < 0) {
        printf("verify_sprite_from_ppm failed\n");
        return -1;
    }

    printf("All tests passed!\n");

    return 0;
}
