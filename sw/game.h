#include "vga_led.h"

#define MAX_BULLETS 5
#define BULLET_SPEED 20
#define MAX_ENEMIES 15
#define PLAYER_STEP_SIZE 2
#define MAX_CLOUDS 3
#define MAX_LIVES 3
#define PIG_SCORE 16
#define BEE_SCORE 40
#define COW_SCORE 60
#define FROG_SCORE 80
#define GOAT SCORE 100
#define CHICK SCORE 120
#define PIG_SPEED 1
#define BEE_SPEED 2
#define COW_SPEED 3
#define FROG_SPEED 3
#define GOAT_SPEED 3
#define CHICK_SPEED 3

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
    enum direction_t direction;
} enemy_t;

typedef struct {
	enemy_t enemy[MAX_ENEMIES];
} invaders_t;

typedef struct {
	sprite_t sprite_info;
	unsigned int alive;
} life_t;
