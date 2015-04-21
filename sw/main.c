#include <stdio.h>
#include "game.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

player_t player;
int vga_led_fd;

int sprite_slots[MAX_SPRITES];
int next_available_sprite_slot;
bullet_t bullets[MAX_BULLETS];
enum state_t state;

void draw_sprite(sprite_t *sprite) {
	sprite_slots[next_available_sprite_slot] = 1;
	sprite->s = next_available_sprite_slot;

	ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);

	next_available_sprite_slot++;
	while (sprite_slots[next_available_sprite_slot] != 0) {
		next_available_sprite_slot++;
		if (next_available_sprite_slot > MAX_SPRITES) {
			next_available_sprite_slot = 0;
		}
	}
}

int remove_sprite(sprite_t *sprite) {
	sprite->id = 0;
	ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);
	sprite_slots[sprite->s] = 0;
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
}

void draw_background() {
	ioctl(vga_led_fd, VGA_CLEAR);
}


void draw_player() {
	draw_sprite(&player.sprite_info);
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

void init_bullets(struct bullet_t *b, int max) {
	int i;

	for (i = 0; i < max; i++) {
		b[i].alive = 0;
		b[i].sprite_info.dim = BULLET_DIM;
		b[i].sprite_info.id = BULLET_ID;
	}
}

/*Moves bullet across X dim */
void move_bullet(struct bullet_t *b, int max, int speed) {
	int i;

	for (i = 0; i < max; i++) {
		if (b[i].alive == 1) {
			if (b[i].sprite_info.x < (MAX_X - b[i].sprite_info.dim)) {
				b[i].sprite_info.x += speed;
			} else
				b[i].alive = 0;
			}
		}
	}

}

/*Set bullet to alive. Set start coordinates */
void player_shoot() {
	int i;
	for (i = 0; i < MAX_BULLETS; i++) {
		if (bullets[i].alive == 0) {
			bullets[i].sprite_info.x = player.sprite_info.x + (player.sprite_info.dim/2);
			bullets[i].sprite_info.y = player.sprite_info.y + (player.sprite_info.dim/2);
			bullets[i].alive = 1;
			break;
		}
	}
}

/*Draw or Remove bullet depending on alive state */
void draw_bullets() {

	int i;

	for (i = 0; i < max; i++) {
		if (b[i].alive == 1) {
			draw_sprite(&b[i].sprite_info);
		} else if (b[i].alive == 0)
		{
			remove_sprite(&b[i].sprite_info);
		}
	}
}

int main() {

	int quit = 0;
	init_sprite_controller();
	init_player();
	init_bullets(bullets, MAX_BULLETS);

	SDL_Event e;


	while (quit == 0) {

		if (state == game) {

			if (SDL_PollEvent(&e) != 0) {
				if (e.type == SDL_QUIT) {
					quit = 1;
				} else if (e.type == SDL_KEYDOWN) {
					switch(e.key.keysym.sym) {
						case SDLK_RIGHT:
							move_player(right);
							break;
						case SDLK_LEFT:
							move_player(left);
							break;
						case SDLK_UP:
							move_player(up);
							break;
						case SDLK_DOWN:
							move_player(down);
							break;
						case SDLK_SPACE:
							player_shoot();
							break;
						default:
							break;
					}
				}
			}


			draw_player();
			draw_bullets(bullets, MAX_BULLETS);
			move_bullets(bullets, MAX_BULLETS, 20);
		}
	}

}
