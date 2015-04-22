#include <stdio.h>
#include "game.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define P_WIDTH 32
#define P_HEIGHT 32

player_t player;
int vga_led_fd;

int sprite_slots[MAX_SPRITES];
int next_available_sprite_slot = -1;
int next_available_bullet_slot = -1;
bullet_t bullets[MAX_BULLETS];
enum state_t state;
Uint8 *keystate = 0;
static SDL_Surface *screen;
static SDL_Surface *background_screen;
static SDL_Surface *pig_img;
static SDL_Surface *hen_img;
static SDL_Surface *bee_img;
static SDL_Surface *ship_img;
static SDL_Surface *bullet_img;

void draw_sprite(sprite_t *sprite) {
	sprite_slots[next_available_sprite_slot] = 1;
	sprite->s = next_available_sprite_slot;

	ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);

	next_available_sprite_slot++;	
	if (next_available_sprite_slot > MAX_SPRITES)
		next_available_sprite_slot = 0;
	while (sprite_slots[next_available_sprite_slot] != 0) {
		if (next_available_sprite_slot > MAX_SPRITES) {
			next_available_sprite_slot = 0;
		else next_available_sprite_slot++;		
		}
	}
	
}

int remove_sprite(sprite_t *sprite) {
	sprite->id = 0;
	ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);
	sprite_slots[sprite->s] = 0; //vacanct
}

int init_sprite_controller() {
  	static const char filename[] = "/dev/vga_led";

  	printf("VGA LED Userspace program started\n");

  	if ( (vga_led_fd = open(filename, O_RDWR)) == -1) {
		printf("Could not open device");
   	 	return -1;
  	}

	return 0;
}

void init_player() {
	player.sprite_info.x = 0;
	player.sprite_info.y = (MAX_Y / 2);
	player.sprite_info.id = SHIP_ID;
	player.sprite_info.dim = SHIP_DIM;
	player.lives = 3;
	player.hitbox.x = 0;
	player.hitbox.y = (MAX_Y / 2);
	player.hitbox.w = P_WIDTH;
	player.hitbox.h = P_HEIGHT;
}

void init_enemies(){

}

void draw_background() {
	ioctl(vga_led_fd, VGA_CLEAR);
}


void draw_player() {
	draw_sprite(&player.sprite_info);
	SDL_Rect src;

	src.x = 0;
	src.y = 0;
	src.w = P_WIDTH;
	src.h = P_HEIGHT;

	SDL_BlitSurface(ship_img, &src, screen, &player.hitbox);
}

/* Moves player in all dimensions */
void move_player(enum direction_t direction) {

	if (direction == left) {
		if (player.sprite_info.x > 0) {
			player.sprite_info.x -= 1;
		}
	} else if (direction == right) {
		if (player.sprite_info.x < (MAX_X - player.sprite_info.x)) {
			player.sprite_info.x += 1;
		}
	} else if (direction == up) {
		if (player.sprite_info.y > 0) {
			player.sprite_info.y -= 1;
		}
	} else if (direction == down) {
		if (player.sprite_info.y < (MAX_Y - player.sprite_info.y)) {
			player.sprite_info.y += 1;
		}
	}

}

void init_bullets() {
	int i;

	for (i = 0; i < max; i++) {
		bullets[i].alive = 0;
		bullets[i].sprite_info.dim = BULLET_DIM;
		bullets[i].sprite_info.id = BULLET_ID;
	}
}

/*Moves bullet across X dim */
void move_bullet(int speed) {
	int i;

	for (i = 0; i < max; i++) {
		if (bullets[i].alive == 1) {
			if (bullets[i].sprite_info.x < ((MAX_X - bullets[i].sprite_info.dim) + speed) ){
				bullets[i].sprite_info.x += speed;
				bullets[i].hitbox.x = bullets[i].sprite_info.x;
			} else
				bullets[i].alive = 0;
			}
		}
	}

}

/*Set bullet to alive. Set start coordinates */
void player_shoot() {
	int i;
	next_available_bullet_slot++;	
	if (next_available_bullet_slot > MAX_BULLETS)
		next_available_bullet_slot = 0;
	while (bullets[next_available_bullet_slot].alive != 0) {
		if (next_available_bullet_slot > MAX_SPRITES) {
			next_available_bullet_slot = 0;
		else next_available_bullet_slot++;		
		}
	}
	i = next_available_bullet_slot;
			bullets[i].sprite_info.x = player.sprite_info.x + 1 + player.sprite_info.dim;
			bullets[i].sprite_info.y = player.sprite_info.y ;
			bullets[i].alive = 1;
			bullets[i].hitbox.x = b[i].sprite_info.x;
			bullets[i].hitbox.y = b[i].sprite_info.y;
			bullets[i].hitbox.w = BULLET_DIM;
			bullets[i].hitbox.h = BULLET_DIM;

}

/*Draw or Remove bullet depending on alive state */
void draw_bullets() {

	int i;
	SDL_Rect src;

	src.x = 0;
	src.y = 0;
	src.w = BULLET_DIM;
	src.h = BULLET_DIM;

	for (i = 0; i < max; i++) {
		if (bullets[i].alive == 1) {
			draw_sprite(&bullets[i].sprite_info);
			SDL_BlitSurface(bullet_img, &src, screen, &b[i].hitbox);
		} else if (bullets[i].alive == 0)
		{
			remove_sprite(&bullets[i].sprite_info);
		}
	}
}

void enemy_bullet_collision(){
	int i= 0;
	int j=0;
	for (i=0;i<MAX_BULLETS;i++){
		if(bullets[i].alive==1){
			for
		}
	}
	return ;
}

//Load image files
int load_image(char filename[], SDL_Surface **surface) {
	
	SDL_Surface *temp;
	
	//load image 
	temp = SDL_LoadBMP(filename);
	
	if (temp == NULL) {
	
		printf("Unable to load %s.\n", filename);
		return 1;
	}

	//convert the image surface to the same type as the screen
	(*surface) = SDL_DisplayFormat(temp);
	
	if ((*surface) == NULL) {
	
		printf("Unable to convert bitmap.\n");
		return 1;
	}
	
	SDL_FreeSurface(temp);

	return 0;
}

int main() {

	if (SDL_Init(SDL_INIT_VIDEO) != 0) {

		printf("Unable to initialize SDL: %s\n", SDL_GetError());
		return 1;
	}
	
	/* Make sure SDL_Quit gets called when the program exits! */
	atexit(SDL_Quit);
	
	/* Attempt to set a 800x600 8 bit color video mode */
	screen = SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, 8, SDL_DOUBLEBUF );
	
	if (screen == NULL) {
		
		printf("Unable to set video mode: %s\n", SDL_GetError());
		return 1;
	}

	load_image("background.bmp", &background_screen);
	load_image("pig.bmp", &pig_img);
	load_image("hen.bmp", &hen_img);
	load_image("bee.bmp", &bee_img);
	load_image("ship.bmp", &ship_img);
	load_image("bullet.bmp", &bullet_img);

	int quit = 0;
	init_sprite_controller();
	init_player();
	init_bullets();
	init_enemies();
	state = menu;

	SDL_Event e;


	while (quit == 0) {
			keystate = SDL_GetKeyState(NULL);
//		if (state == game) {
			if (SDL_PollEvent(&e) != 0) {
				switch(e.type){
					case SDL_KEYDOWN:
						switch(e.key.keysym.sym){
							case SDL_QUIT:
								quit = 1;
								break;
							case SDLK_SPACE:
								if(state==menu){
									state = game;
								}else if(state == game){
									player_shoot();
									//saucer_ai();
								}
								break;
							case SDLK_RIGHT:
								if(state==game)
									move_player(right);
								break;

							case SDLK_LEFT:
								if(state==game)
								move_player(left);
							break;

							case SDLK_UP:
								if(state==game)
									move_player(up);
								break;

							case SDLK_DOWN:
								if(state==game)
									move_player(down);
								break;

							default: 
								break;
						}
					break;
				}
			}
			if(state==game){
				draw_player();
				draw_bullets();
				draw_enemies();
				move_bullets(1);
				draw_enemies();
				enemy_bullet_collision();
				enemy_player_collision();
				enemy_ai();
				
			}
			
		}
	}

}
