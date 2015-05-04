#include "vga_led.h"

#define MAX_BULLETS 5
#define BULLET_SPEED 20
#define MAX_ENEMIES 8
#define PLAYER_STEP_SIZE 2
#define MAX_CLOUDS 6
#define MAX_LIVES 3
#define PIG_SCORE 16
#define BEE_SCORE 40
#define COW_SCORE 60
#define FROG_SCORE 80
#define GOAT_SCORE 100
#define CHICK_SCORE 120
#define PIG_SPEED 1
#define BEE_SPEED 2
#define COW_SPEED 3
#define FROG_SPEED 3
#define GOAT_SPEED 3
#define CHICK_SPEED 3
#define SCORE_OFFSET 280
#define TICKS_FREQ 50
#define PAUSE_OFFSET_X 280
#define PAUSE_OFFSET_Y 240
#define GAMEOVER_OFFSET_X 280
#define GAMEOVER_OFFSET_Y 240
#define WIN_OFFSET_X 280
#define WIN_OFFSET_Y 240
#define START_OFFSET_X 280
#define START_OFFSET_Y 240

enum direction_t {up, down, left, right, stationary};
enum state_t {game, start, game_pause, game_over};

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
