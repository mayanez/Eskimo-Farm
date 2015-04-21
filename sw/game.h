#include "vga_led.h"

#define MAX_BULLETS 10

enum direction_t {up, down, left, right, stationary};
enum state_t {menu, game, game_over};

typedef struct {
	sprite_t sprite_info;
	unsigned int lives;
} player_t;

typedef struct {
    sprite_t sprite_info;
    unsigned int alive;
} bullet_t;