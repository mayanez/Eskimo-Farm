#include <stdio.h>
#include "game.h"
#include "usbkeyboard.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

player_t player;
invaders_t invaders;
sprite_t clouds[MAX_CLOUDS];
life_t lives[MAX_LIVES];

unsigned long ticks;

int vga_led_fd;
unsigned int init_s;
unsigned int health;

int sprite_slots[MAX_SPRITES];
int next_available_sprite_slot;
int available_slots;

bullet_t bullets[MAX_BULLETS];
enum state_t state;

struct libusb_device_handle *keyboard;
uint8_t endpoint_address;

pthread_t input_thread;
pthread_mutex_t lock;

void player_shoot();
void move_player(enum direction_t);
void draw_player();
void draw_bullets(int);
void draw_invaders();
void draw_hud();

void init_keyboard() {
    if ( (keyboard = openkeyboard(&endpoint_address)) == NULL ) {
        fprintf(stderr, "Did not find a keyboard\n");
        exit(1);
    }
}

void handle_keyboard_thread_f(void *ignored) {

    struct usb_keyboard_packet packet;
    int transferred;
    char keystate[12];

    for (;;) {
        libusb_interrupt_transfer(keyboard, endpoint_address,
                  (unsigned char *) &packet, sizeof(packet),
                  &transferred, 0);

        if (transferred == sizeof(packet)) {
            switch(packet.keycode[0]) {
                case RIGHT_ARROW:
                    pthread_mutex_lock(&lock);
                    move_player(right);
                    draw_player();
                    pthread_mutex_unlock(&lock);
                    break;
                case LEFT_ARROW:
                    pthread_mutex_lock(&lock);
                    move_player(left);
                    draw_player();
                    pthread_mutex_unlock(&lock);
                    break;
                case UP_ARROW:
                    pthread_mutex_lock(&lock);
                    move_player(up);
                    draw_player();
                    pthread_mutex_unlock(&lock);
                    break;
                case DOWN_ARROW:
                    pthread_mutex_lock(&lock);
                    move_player(down);
                    draw_player();
                    pthread_mutex_unlock(&lock);
                    break;
                case SPACEBAR:
                    pthread_mutex_lock(&lock);
                    player_shoot();
                    draw_bullets(1);
                    pthread_mutex_unlock(&lock);
                    break;
                default:
                    break;
            }

        }
    }
}

int draw_sprite(sprite_t *sprite) {

    if (sprite->s == -1 && available_slots > 0 && sprite_slots[next_available_sprite_slot] == 0) {
        sprite_slots[next_available_sprite_slot] = 1;
        sprite->s = next_available_sprite_slot;
        available_slots--;
        
        while (sprite_slots[next_available_sprite_slot] != 0 && available_slots > 0) {
            next_available_sprite_slot++;
            if (next_available_sprite_slot >= MAX_SPRITES) {
                next_available_sprite_slot = 0;
            }
        }
    }
    ioctl(vga_led_fd, VGA_SET_SPRITE, sprite);
     
    return 0;
}

int remove_sprite(sprite_t *sprite) {
    sprite_t empty_sprite;
    memset(&empty_sprite, 0, sizeof(sprite_t));

    empty_sprite.s = sprite->s;
	
	if (sprite->s == -1) {
        return -1;
    }

    if (sprite->s == -1) {
        return -1;
    }

    ioctl(vga_led_fd, VGA_SET_SPRITE, &empty_sprite); 
    sprite_slots[sprite->s] = 0;
    sprite->s = -1;
    available_slots++;

    return 0;
}

int draw_background() {
    if (ioctl(vga_led_fd, VGA_CLEAR) < 0) {
        printf("Clear - Device Driver Error\n");
        return -1;
    }

    available_slots = MAX_SPRITES;
    memset(&sprite_slots, 0, MAX_SPRITES);
    return 0;
}

int init_sprite_controller() {
    static const char filename[] = "/dev/vga_led";

    printf("VGA LED Userspace program started\n");

    if ( (vga_led_fd = open(filename, O_RDWR)) == -1) {
        printf("Could not open device");
        return -1;
    }

    next_available_sprite_slot = 0;
    available_slots = MAX_SPRITES;
    return 0;
}

void init_player() {
    player.sprite_info.x = 0;
    player.sprite_info.y = (MAX_Y / 2);
    player.sprite_info.id = SHIP_ID;
    player.sprite_info.dim = SHIP_DIM;
    player.sprite_info.s = -1;
}

void init_invaders() {
    int i;

    invaders.direction = left;

    /* Initializes one enemy */
	for (i = 0; i < MAX_ENEMIES; i++) {
		invaders.enemy[i].alive = 0;
		invaders.enemy[i].speed = 0;
		invaders.enemy[i].sprite_info.x = 0;
    	invaders.enemy[i].sprite_info.y = 0;
    	invaders.enemy[i].sprite_info.id = 0;
    	invaders.enemy[i].sprite_info.dim = 0;
    	invaders.enemy[i].sprite_info.s = -1;
	}

    invaders.enemy[0].alive = 1;
    invaders.enemy[0].speed = 3;
    invaders.enemy[0].sprite_info.x = MAX_X - PIG_DIM;
    invaders.enemy[0].sprite_info.y = MAX_Y / 2;
    invaders.enemy[0].sprite_info.id = PIG_ID;
    invaders.enemy[0].sprite_info.dim = PIG_DIM;
    invaders.enemy[0].sprite_info.s = -1;
}

void init_mutex() {
    /* Init Mutex */
    if (pthread_mutex_init(&lock, NULL) != 0) {
        fprintf(stderr, "mutex init failed\n");
        exit(1);
    }
}

void init_bullets() {
    int i;

    for (i = 0; i < MAX_BULLETS; i++) {
        bullets[i].alive = 0;
        bullets[i].sprite_info.dim = BULLET_DIM;
        bullets[i].sprite_info.id = BULLET_ID;
		bullets[i].sprite_info.x = player.sprite_info.x + player.sprite_info.dim;
		bullets[i].sprite_info.y = player.sprite_info.y;
        bullets[i].sprite_info.s = -1;
    }
}

void init_state() {
    state = game;
	health = MAX_LIVES;
    draw_player();
	draw_hud();
}

void init_clouds() {
    int i;

    init_s = MAX_SPRITES - 1;

    for (i = 1; i < MAX_CLOUDS; i++) {
        clouds[i].x = MAX_X - CLOUD_DIM;
        clouds[i].y = MAX_Y/4 + i*100;
        clouds[i].dim = CLOUD_DIM;
        clouds[i].id = CLOUD_ID;
        clouds[i].s = init_s;

        sprite_slots[init_s] = 1;
        init_s--;
        available_slots--;
    }

    clouds[0].x = MAX_X - CLOUD_DIM - 50;
    clouds[0].y = MAX_Y/4 + 50;
    clouds[0].dim = CLOUD_DIM;
    clouds[0].id = CLOUD_ID;
    clouds[0].s = init_s;
    
    sprite_slots[init_s] = 1;
    available_slots--;
 
}

void init_hud() {
	int i;

	for (i = 0; i < MAX_LIVES; i++) {
		lives[i].alive = 1;
		lives[i].sprite_info.x = i*LIVES_DIM;
		lives[i].sprite_info.y = 0;
		lives[i].sprite_info.s = -1;
		lives[i].sprite_info.dim = LIVES_DIM;
		lives[i].sprite_info.id = LIVES_ID;
	}
}

void draw_hud() {
	int i;

	for (i = 0; i < MAX_LIVES; i++) {
		if (lives[i].alive == 1) {
			draw_sprite(&lives[i].sprite_info);
		} else if (lives[i].alive == 0 && lives[i].sprite_info.s != -1) {
			remove_sprite(&lives[i].sprite_info);
		}
	}
	
}

void draw_player() {
    draw_sprite(&player.sprite_info);
}

void draw_invaders() {
	int i;

	for (i = 0; i < MAX_ENEMIES; i++) {
		if (invaders.enemy[i].alive == 1) {
			draw_sprite(&invaders.enemy[i].sprite_info);
		} else if (invaders.enemy[i].alive == 0 && invaders.enemy[i].sprite_info.s != -1) {
			printf("s %d\n", invaders.enemy[i].sprite_info.s);
			remove_sprite(&invaders.enemy[i].sprite_info);
		}

	}
}

/*Draw or Remove bullet depending on alive state */
void draw_bullets(int max) {

    int i;

    for (i = 0; i < max; i++) {
        if (bullets[i].alive == 1) {
            draw_sprite(&bullets[i].sprite_info);
        }else if (bullets[i].alive == 0 && bullets[i].sprite_info.s != -1) {
            remove_sprite(&bullets[i].sprite_info);
        }
    }
}

void draw_clouds() {
    int i;
    int speed;

    speed = 2;
    for (i = 0; i < MAX_CLOUDS; i++) {
        if (clouds[i].x > 0 + CLOUD_DIM) {
            clouds[i].x -= speed;
        } else {
            clouds[i].x = MAX_X - CLOUD_DIM;
            speed++;
        }
        
        draw_sprite(&clouds[i]);
    }
}

/* Moves player in all dimensions */
void move_player(enum direction_t direction) {

    if (direction == left) {
        if (player.sprite_info.x > 0) {
            player.sprite_info.x -= PLAYER_STEP_SIZE;
        }
    } else if (direction == right) {
        if (player.sprite_info.x < (MAX_X - player.sprite_info.dim)) {
            player.sprite_info.x += PLAYER_STEP_SIZE;
        }
    } else if (direction == up) {
        if (player.sprite_info.y > 0) {
            player.sprite_info.y -= PLAYER_STEP_SIZE;
        }
    } else if (direction == down) {
        if (player.sprite_info.y < (MAX_Y - player.sprite_info.dim)) {
            player.sprite_info.y += PLAYER_STEP_SIZE;
        }
    }

}

/*Moves bullet across X dim */
void move_bullets(int max, int speed) {
    int i;

    for (i = 0; i < max; i++) {
        if (bullets[i].alive == 1) {
            if (bullets[i].sprite_info.x < (MAX_X - (bullets[i].sprite_info.dim + speed))) {
                bullets[i].sprite_info.x += speed;
            }
            else {
                bullets[i].alive = 0;
            }
        }
    }
}

/*Set bullet to alive. Set start coordinates */
void player_shoot() {
    int i;
    for (i = 0; i < MAX_BULLETS; i++) {
        if (bullets[i].alive == 0) {
            bullets[i].sprite_info.x = player.sprite_info.x + 2 + player.sprite_info.dim; /* To the right of the player sprite */
            bullets[i].sprite_info.y = player.sprite_info.y + 8;/* /4 to center bullet with player sprite */
            bullets[i].alive = 1;
            break;
        }
    }
}

/* Detect a collision between two sprites */
int detect_collision(sprite_t *a, sprite_t *b) {
    if (a->y + a->dim < b->y) {
        return 0;
    }

    if (a->y > b->y + b->dim) {
        return 0;
    }

    if (a->x > b->x + b->dim) {
        return 0;
    }

    if (a->x + a->dim < b->x) {
        return 0;
    }

    return 1;
}

void enemy_bullet_collision () {
	int i, j;
	for (i = 0; i < MAX_BULLETS; i++) {
		for (j = 0; j < MAX_ENEMIES; j++) {
			if (bullets[i].alive == 1 && invaders.enemy[j].alive == 1) {
				if (detect_collision(&bullets[i].sprite_info, &invaders.enemy[j].sprite_info)) {
					invaders.enemy[j].alive = 0;
					bullets[i].alive = 0;
				}
			}
		}
	}
}

void enemy_player_collision() {
    int i, j;
    for (i = 0; i < MAX_ENEMIES; i ++) {
        if (invaders.enemy[i].alive == 1) {
            if (detect_collision(&player.sprite_info, &invaders.enemy[i].sprite_info)) {
				printf("health: %d\n", health);
                lives[health-1].alive = 0;
				health--;
                invaders.enemy[i].alive = 0;
                remove_sprite(&player.sprite_info);
                sleep(2);
                draw_sprite(&player.sprite_info);
            }
        }
    }
}

void move_enemy(enemy_t *enemy, enum direction_t direction) {

    if (direction == left) {
        if (enemy->sprite_info.x > 0 + enemy->sprite_info.dim) {
            enemy->sprite_info.x -= enemy->speed;
        }
        else {
            enemy->alive = 0;
        }
    }
}

void add_enemy() {
	if (ticks == 140) {
		invaders.enemy[1].alive = 1;
    	invaders.enemy[1].speed = 3;
    	invaders.enemy[1].sprite_info.x = MAX_X - PIG_DIM;
    	invaders.enemy[1].sprite_info.y = MAX_Y / 2;
    	invaders.enemy[1].sprite_info.id = PIG_ID;
    	invaders.enemy[1].sprite_info.dim = PIG_DIM;
    	invaders.enemy[1].sprite_info.s = -1;
	}
}
void enemy_ai() {
    int i;
    
    for (i = 0; i < MAX_ENEMIES; i++) {
        if (invaders.enemy[i].alive == 1) {
            move_enemy(&invaders.enemy[i], invaders.direction);
        }
    }
    
}

int main() {

    int quit = 0;
    init_sprite_controller();
    init_keyboard();
    init_mutex();
    init_player();
    init_invaders();
    init_bullets(MAX_BULLETS);
    init_clouds();
	init_hud();

    state = game;
	ticks = 0;
    
    /*Draw initial game state */
    pthread_mutex_lock(&lock);
    draw_background();
    init_state();
    pthread_mutex_unlock(&lock);
	
    pthread_create(&input_thread, NULL, handle_keyboard_thread_f, NULL);

    while (quit == 0) {
        if (state == game) {
            pthread_mutex_lock(&lock);
            draw_bullets(MAX_BULLETS);
			draw_invaders();
            draw_clouds();
			draw_hud();
			enemy_bullet_collision();
            enemy_player_collision();
            move_bullets(MAX_BULLETS, BULLET_SPEED);
            enemy_ai();
			add_enemy();
            pthread_mutex_unlock(&lock);
            usleep(40000);
        }
		ticks++;
    }

    pthread_cancel(input_thread);

    /* Destroy lock */
    pthread_mutex_destroy(&lock);

    /* Wait for the network thread to finish */
    pthread_join(input_thread, NULL);

}
