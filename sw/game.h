#include "vga_led.h"

#define MAX_BULLETS 10
#define BULLET_SPEED 20
#define MAX_ENEMIES 10
#define PLAYER_STEP_SIZE 2

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

typedef struct {
	sprite_t sprite_info;
	unsigned int alive;
	unsigned int points;
} enemy_t;

typedef struct {
	enemy_t enemy[MAX_ENEMIES];
	enum direction_t direction;
	unsigned int killed;
	int speed;
	int state;
	int dim;
} invaders_t;
