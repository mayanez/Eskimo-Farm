#define DISPLAY_WIDTH 480
#define DISPLAY_HEIGHT 640
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
    rgb_pixel_t[8][8] pixels;
} sprite_t;


