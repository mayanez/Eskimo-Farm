#include "vga_led.h"

#define MAX_BULLETS 5
#define BULLET_SPEED 20
#define MAX_ENEMIES 10
#define PLAYER_STEP_SIZE 2
#define MAX_CLOUDS 3
#define MAX_LIVES 3

enum direction_t {up, down, left, right, stationary};
enum state_t {menu, game, game_over};

typedef struct {
	sprite_t sprite_info;
} player_t;

typedef struct {
    sprite_t sprite_info;
    unsigned int alive;
} bullet_t;

typedef struct {
	sprite_t sprite_info;
	unsigned int alive;
	unsigned int points;
    unsigned int type;
    unsigned int speed;
} enemy_t;

typedef struct {
	enemy_t enemy[MAX_ENEMIES];
	enum direction_t direction;
} invaders_t;

typedef struct {
	sprite_t sprite_info;
	unsigned int alive;
} life_t;
