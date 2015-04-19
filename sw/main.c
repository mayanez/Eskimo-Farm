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
	sprite_slots[sprite->s] = 0;
	sprite->id = 0;
	ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);
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


void move_player(enum direction_t direction) {
	
	if (direction == left) {
		if (player.sprite_info.x > 0) {
			player.sprite_info.x -= 1;
		}
	} else if (direction == right) {
		if (player.sprite_info.x < MAX_X) {
			player.sprite_info.x += 1;
		}
	} else if (direction == up) {
		if (player.sprite_info.y > 0) {
			player.sprite_info.y -= 1;
		}
	} else if (direction == down) {
		if (player.sprite_info.y < MAX_Y) {
			player.sprite_info.y += 1;
		}
	}	

}

int main() {
	
	int quit = 0;
	init_sprite_controller();
	init_player();
	
	draw_background();
	draw_player();

}
