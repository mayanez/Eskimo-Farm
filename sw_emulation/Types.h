#ifndef _TYPES_H
#define _TYPES_H

#define DISPLAY_WIDTH 640
#define DISPLAY_HEIGHT 480
#define INPUT_STRUCT_LENGTH 10

#define debug_print(fmt, ...) \ do { if (DEBUG) fprintf(stderr, __VA_ARGS__); } while (0)

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
