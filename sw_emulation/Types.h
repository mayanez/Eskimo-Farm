#ifndef _TYPES_H
#define _TYPES_H

#define DW 640
#define DH 480
#define INPUT_STRUCT_LENGTH 10

typedef struct {
    int x;
    int y;
    int id;
} sprite_info_t;

typedef struct {
    int r;
    int g;
    int b;
} rgb_pixel_t;

typedef struct {
    int id;
    rgb_pixel_t pixels[8][8];
} sprite_t;

#endif
