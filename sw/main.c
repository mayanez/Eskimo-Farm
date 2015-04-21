#include <stdio.h>
#include "game.h"
#include "usbkeyboard.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

player_t player;
invaders_t invaders;

int vga_led_fd;

int sprite_slots[MAX_SPRITES];
int next_available_sprite_slot;
bullet_t bullets[MAX_BULLETS];
enum state_t state;

struct libusb_device_handle *keyboard;
uint8_t endpoint_address;

void init_keyboard() {
	if ( (keyboard = openkeyboard(&endpoint_address)) == NULL ) {
	    fprintf(stderr, "Did not find a keyboard\n");
	  	exit(1);
	}
}
void draw_sprite(sprite_t *sprite) {

	if (sprite->s == -1) {
		sprite_slots[next_available_sprite_slot] = 1;
		sprite->s = next_available_sprite_slot;


		next_available_sprite_slot++;
		while (sprite_slots[next_available_sprite_slot] != 0) {
			next_available_sprite_slot++;
			if (next_available_sprite_slot > MAX_SPRITES) {
				next_available_sprite_slot = 0;
			}
		}
	}

	ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);
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

	next_available_sprite_slot = 0;
	return 0;
}

void init_player() {
	player.sprite_info.x = 0;
	player.sprite_info.y = (MAX_Y / 2);
	player.sprite_info.id = SHIP_ID;
	player.sprite_info.dim = SHIP_DIM;
	player.sprite_info.s = -1;
	player.lives = 3;
}

void init_invaders() {
	int x;

	invaders.direction = left;
	invaders.speed = 1;
	invaders.dim = PIG_DIM; /* Will need to implement for more enemy types */

	x = MAX_X - invaders.dim;

	/* Initializes one enemy */
	invaders.enemy[0].alive = 1;
	invaders.enemy[0].sprite_info.x = x;
	invaders.enemy[0].sprite_info.y = MAX_Y / 2;
	invaders.enemy[0].sprite_info.id = PIG_ID;
	invaders.enemy[0].sprite_info.dim = PIG_DIM;
}


void draw_player() {
	draw_sprite(&player.sprite_info);
}

void draw_invaders() {
	draw_sprite(&invaders.enemy[0].sprite_info);
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

void init_bullets(bullet_t *b, int max) {
	int i;

	for (i = 0; i < max; i++) {
		b[i].alive = 0;
		b[i].sprite_info.dim = BULLET_DIM;
		b[i].sprite_info.id = BULLET_ID;
	}
}

/*Moves bullet across X dim */
void move_bullets(bullet_t *b, int max, int speed) {
	int i;

	for (i = 0; i < max; i++) {
		if (b[i].alive == 1) {
			if (b[i].sprite_info.x < (MAX_X - b[i].sprite_info.dim) + speed) b[i].sprite_info.x += speed;
			else b[i].alive = 0;
		}
	}
}

/*Set bullet to alive. Set start coordinates */
void player_shoot() {
	int i;
	for (i = 0; i < MAX_BULLETS; i++) {
		if (bullets[i].alive == 0) {
			bullets[i].sprite_info.x = player.sprite_info.x + 1 + player.sprite_info.dim; /* To the right of the player sprite */
			bullets[i].sprite_info.y = player.sprite_info.y + (player.sprite_info.dim/4);/* /4 to center bullet with player sprite */
			bullets[i].alive = 1;
			break;
		}
	}
}

/*Draw or Remove bullet depending on alive state */
void draw_bullets(bullet_t b[], int max) {

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
	init_keyboard();
	init_player();
	init_bullets(bullets, MAX_BULLETS);
 	
	state = game;
	
	struct usb_keyboard_packet packet;
	int transferred;
  	char keystate[12];

	/*Draw initial game state */
	draw_player();

	while (quit == 0) {

		if (state == game) {
			    libusb_interrupt_transfer(keyboard, endpoint_address,
			      (unsigned char *) &packet, sizeof(packet),
			      &transferred, 0);

			if (transferred == sizeof(packet)) {
					switch(packet.keycode[0]) {
						case RIGHT_ARROW:
							printf("right pressed\n");
							move_player(right);
							draw_player();
							break;
						case LEFT_ARROW:
							printf("left pressed\n");
							move_player(left);
							draw_player();
							break;
						default:
							break;
					}
				
			}

			//draw_bullets(bullets, MAX_BULLETS);
			//move_bullets(bullets, MAX_BULLETS, BULLET_SPEED);
		}
	}

}
