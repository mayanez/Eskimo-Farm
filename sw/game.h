#include "vga_led.h"

#define MAX_BULLETS 10
#define MAX_ENEMIES 20

enum direction_t {up, down, left, right, stationary};
enum state_t {menu, game, game_over};

typedef struct {
	sprite_t sprite_info;
	unsigned int lives;
	SDL_Rect hitbox;
} player_t;

typedef struct {
    sprite_t sprite_info;
    unsigned int alive; 
 	SDL_Rect hitbox;   
} bullet_t;

typedef struct {
	sprite_t sprite_info;
	unsigned int alive = 0 ; //can be re-allotted to another sprite
	unsigned int points;
	enum direction_t direction;
	SDL_Rect hitbox;
	/*
		int speed;
	int state;
	int state_speed;
	Uint32 state_time;
*/

}enemy_t; 
