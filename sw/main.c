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
sprite_t score_sprite[5];
sprite_t score_nums[3];

unsigned long ticks;

int vga_led_fd;
unsigned int init_s;
unsigned int health;

int sprite_slots[MAX_SPRITES];
int next_available_sprite_slot;
int next_available_enemy_slot;
int current_enemy_count;
int available_slots;
unsigned int score;

bullet_t bullets[MAX_BULLETS];
enum state_t state;
enum direction_t dir;

struct libusb_device_handle *keyboard;
uint8_t endpoint_address;

pthread_t input_thread;
pthread_mutex_t lock;
pthread_mutex_t controller_lock;

int control_pressed[6];

void player_shoot();
void move_player(enum direction_t);
void draw_player();
void draw_bullets(int);
void draw_invaders();
void draw_hud();
void draw_score();

void init_keyboard() {
    if ( (keyboard = openkeyboard(&endpoint_address)) == NULL ) {
        fprintf(stderr, "Did not find a keyboard\n");
        exit(1);
    }
}

void handle_controller_thread_f2(void *ignored) {
    int i;

    for (;;) {
        pthread_mutex_lock(&controller_lock);

        if (control_pressed[0]){
                pthread_mutex_lock(&lock);
                move_player(right);
                draw_player();
                pthread_mutex_unlock(&lock);
        }
        
        if (control_pressed[1]) {
                pthread_mutex_lock(&lock);
                move_player(left);
                draw_player();
                pthread_mutex_unlock(&lock);
        }

        if (control_pressed[2]) {
                pthread_mutex_lock(&lock);
                move_player(up);
                draw_player();
                pthread_mutex_unlock(&lock);
        }

        if (control_pressed[3]) {
                pthread_mutex_lock(&lock);
                move_player(down);
                draw_player();
                pthread_mutex_unlock(&lock);
        }
        
        if (control_pressed[4]) {
                pthread_mutex_lock(&lock);
                player_shoot();
                draw_bullets(1);
                pthread_mutex_unlock(&lock);
        }

        pthread_mutex_unlock(&controller_lock);
        usleep(27000);

    }
}

void handle_keyboard_thread_f(void *ignored) {
    
    struct Xbox360Msg packet;
    int transferred;
    char keystate[12];
    
    for (;;) {
        libusb_interrupt_transfer(keyboard, endpoint_address,
                                  (unsigned char *) &packet, sizeof(packet),
                                  &transferred, 0);
        
        if (transferred == sizeof(packet)) {
           if (packet.dpad_right){
                    pthread_mutex_lock(&lock);
                    move_player(right);
                    draw_player();
                    pthread_mutex_unlock(&lock);
            }
            
            if (packet.dpad_left) {
                    pthread_mutex_lock(&lock);
                    move_player(left);
                    draw_player();
                    pthread_mutex_unlock(&lock);
            }

            if (packet.dpad_up) {
                    pthread_mutex_lock(&lock);
                    move_player(up);
                    draw_player();
                    pthread_mutex_unlock(&lock);
            }

            if (packet.dpad_down) {
                    pthread_mutex_lock(&lock);
                    move_player(down);
                    draw_player();
                    pthread_mutex_unlock(&lock);
            }
            
            if (packet.b) {
                    pthread_mutex_lock(&lock);
                    player_shoot();
                    draw_bullets(1); /* Check this */
                    pthread_mutex_unlock(&lock);
            }

            pthread_mutex_lock(&controller_lock);
            control_pressed[0] = packet.dpad_right;
            control_pressed[1] = packet.dpad_left;
            control_pressed[2] = packet.dpad_up;
            control_pressed[3] = packet.dpad_down;
            control_pressed[4] = packet.b;
            pthread_mutex_unlock(&controller_lock);
            
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

    return 0;
}

int init_sprite_controller() {
    static const char filename[] = "/dev/vga_led";
    
    printf("VGA LED Userspace program started\n");
    
    if ( (vga_led_fd = open(filename, O_RDWR)) == -1) {
        printf("Could not open device");
        return -1;
    }

    draw_background();
    init_s = MAX_SPRITES - 1;
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
    current_enemy_count = 0;
    next_available_enemy_slot = 0;
    
    
    /* Initializes 2 enemy */
	for (i = 0; i < MAX_ENEMIES; i++) {
    	invaders.enemy[i].alive = 0;
    	invaders.enemy[i].speed = 0;
    	invaders.enemy[i].sprite_info.x = 0;
    	invaders.enemy[i].sprite_info.y = 0;
    	invaders.enemy[i].sprite_info.id = 0;
    	invaders.enemy[i].sprite_info.dim = 0;
    	invaders.enemy[i].sprite_info.s = -1;
        invaders.enemy[i].points = 0;
        invaders.enemy[i].direction = left;
	}
    
    invaders.enemy[0].alive = 1;
    invaders.enemy[0].speed = 2;
    invaders.enemy[0].sprite_info.x = MAX_X - PIG_DIM;
    invaders.enemy[0].sprite_info.y = MAX_Y - 400;
    invaders.enemy[0].sprite_info.id = PIG_ID;
    invaders.enemy[0].sprite_info.dim = PIG_DIM;
    invaders.enemy[0].sprite_info.s = -1;
    invaders.enemy[0].points = 1; //PIG
    invaders.enemy[0].direction = left;
    current_enemy_count++;
    next_available_enemy_slot++;
    
    invaders.enemy[1].alive = 1;
    invaders.enemy[1].speed = 2;
    invaders.enemy[1].sprite_info.x = MAX_X - PIG_DIM;
    invaders.enemy[1].sprite_info.y = MAX_Y - 250;
    invaders.enemy[1].sprite_info.id = PIG_ID;
    invaders.enemy[1].sprite_info.dim = PIG_DIM;
    invaders.enemy[1].sprite_info.s = -1;
    invaders.enemy[1].points = 1; //PIG
    invaders.enemy[1].direction = left;
    current_enemy_count++;
    next_available_enemy_slot++;
}

void init_mutex() {
    /* Init Mutex */
    if (pthread_mutex_init(&lock, NULL) != 0 && pthread_mutex_init(&controller_lock, NULL) != 0) {
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
	score = 0;
    draw_player();
	draw_hud();
    draw_score();
}

void init_clouds() {
    int i;
    
    for (i = 1; i < MAX_CLOUDS; i++) {
        clouds[i].x = MAX_X - CLOUD_DIM;
        clouds[i].y = MAX_Y/4 + i*100 + 1;
        clouds[i].dim = CLOUD_DIM;
        clouds[i].id = CLOUD_ID;
        clouds[i].s = init_s;
        
        sprite_slots[init_s] = 1;
        init_s--;
        available_slots--;
    }
    
    clouds[0].x = MAX_X - CLOUD_DIM - 50;
    clouds[0].y = MAX_Y/4 + 50 + 1;
    clouds[0].dim = CLOUD_DIM;
    clouds[0].id = CLOUD_ID;
    clouds[0].s = init_s;
    
    sprite_slots[init_s] = 1;
    available_slots--;

    init_s--;
    
}

void init_hud() {
	int i;
    
	for (i = 0; i < MAX_LIVES; i++) {
		lives[i].alive = 1;
		lives[i].sprite_info.x = i*LIVES_DIM;
		lives[i].sprite_info.y = 1;
		lives[i].sprite_info.s = init_s;
		lives[i].sprite_info.dim = LIVES_DIM;
		lives[i].sprite_info.id = LIVES_ID;

        sprite_slots[init_s] = 1;
        init_s--;
        available_slots--;
	}

    /*
    for (i = 0; i < 5; i++) {
        score_sprite[i].x = SCORE_OFFSET + i*S_DIM;
        score_sprite[i].y = 1;
        score_sprite[i].s = init_s;
        score_sprite[i].dim = S_DIM;
        score_sprite[i].id = S_ID + i;

        sprite_slots[init_s] = 1;
        init_s--;
        available_slots--;
        draw_sprite(&score_sprite[i]);
    } */
    
    for (i = 0; i < 3; i++) {
        score_nums[i].s = init_s;
        sprite_slots[init_s] = 1;
        init_s--;
        available_slots--;
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
    
    speed = 3;
    for (i = 0; i < MAX_CLOUDS; i++) {
        if (clouds[i].x > speed) {
            clouds[i].x -= speed;
        } else {
            clouds[i].x = MAX_X - CLOUD_DIM;
            //speed++;
        }
        
        draw_sprite(&clouds[i]);
    }
}

int find_num_id(unsigned int val) {
    
    switch(val) {
        case 0:
            return ZERO_ID;
        case 1:
            return ONE_ID;
        case 2:
            return TWO_ID;
        case 3:
            return THREE_ID;
        case 4:
            return FOUR_ID;
        case 5:
            return FIVE_ID;
        case 6:
            return SIX_ID;
        case 7:
            return SEVEN_ID;
        case 8:
            return EIGHT_ID;
        case 9:
            return NINE_ID;
    }
}

void draw_score() {
        
    unsigned int units = score % 10;
    unsigned int tens = (score / 10) % 10;
    unsigned int hundreds = (score / 100) % 10;
    
    int units_id = find_num_id(units);
    int tens_id = find_num_id(tens);
    int hundreds_id = find_num_id(hundreds);

    int ids[3] = { hundreds_id, tens_id, units_id};
    

    int i;

    for (i = 0; i < 3; i++) {
        score_nums[i].x = 310 + ZERO_DIM*i;
        score_nums[i].y = 1;
        score_nums[i].id = ids[i];
        score_nums[i].dim = ZERO_DIM;
        draw_sprite(&score_nums[i]);
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
        if (player.sprite_info.y > HUD_BOUNDARY) {
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
                    current_enemy_count--;
					bullets[i].alive = 0;
					score += invaders.enemy[j].points;
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
				
                lives[health-1].alive = 0;
				health--;
                invaders.enemy[i].alive = 0;
                current_enemy_count--;
                remove_sprite(&player.sprite_info);
                sleep(2);
                draw_sprite(&player.sprite_info);
                
            }
        }
    }
}

void move_enemy(enemy_t *enemy) {
    
    if(enemy->direction == left && enemy->alive == 1){
        if (enemy->sprite_info.x > 0 + enemy->speed)
            enemy->sprite_info.x -= 2*enemy->speed;
        else {
            enemy->sprite_info.x = MAX_X - enemy->sprite_info.dim;
        }
    }
    
    else if(enemy->direction == up && enemy->alive == 1){
        if (enemy->sprite_info.x > 0 + enemy->speed )
            enemy->sprite_info.x -= enemy->speed;
        else {
            enemy->sprite_info.x = MAX_X - enemy->sprite_info.dim;
        }

        if ((enemy->sprite_info.y > LIVES_DIM + enemy->speed) && enemy->alive == 1)
            enemy->sprite_info.y = enemy->sprite_info.y - enemy->speed;

        else if ((enemy->sprite_info.y <= LIVES_DIM + enemy->speed) && enemy->alive == 1){
            enemy->direction = down;
            enemy->sprite_info.y = enemy->sprite_info.y + enemy->speed;
        }
    }
    
    else if(enemy->direction == down && enemy->alive == 1){
        if (enemy->sprite_info.x >= 0 + enemy->speed)
            enemy->sprite_info.x -= enemy->speed;
        else {
            enemy->sprite_info.x = MAX_X - enemy->sprite_info.dim;
        }

        if ((enemy->sprite_info.y < MAX_Y - PIG_DIM - enemy->speed) && enemy->alive == 1)
            enemy->sprite_info.y = enemy->sprite_info.y + enemy->speed;
        
        else if ((enemy->sprite_info.y >= MAX_Y - PIG_DIM - enemy->speed) && enemy->alive == 1){
            enemy->direction = up;
            enemy->sprite_info.y = enemy->sprite_info.y - enemy->speed;
        }
    }
}

void add_enemy() {
    int index;
	if ((ticks % TICKS_FREQ == 0 ) && current_enemy_count < MAX_ENEMIES) {
        if(next_available_enemy_slot >= MAX_ENEMIES){
            next_available_enemy_slot = 0;
        }
        
        while(invaders.enemy[next_available_enemy_slot].alive != 0){
            next_available_enemy_slot++;
            if(next_available_enemy_slot >= MAX_ENEMIES){
                next_available_enemy_slot =0;
            }
        }

        index = next_available_enemy_slot;
        invaders.enemy[index].alive = 1;
        
        int ycord = rand() % (MAX_Y - 32);
        
        
        int value = rand() % 3;
        
        if(value == 0)
            dir = up;
        else if (value == 1)
            dir = left;
        else
            dir = down;
        
        
        if(score <= PIG_SCORE){
            invaders.enemy[index].sprite_info.x = MAX_X - PIG_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = PIG_ID;
            invaders.enemy[index].sprite_info.dim = PIG_DIM;
            invaders.enemy[index].points = 1;
            invaders.enemy[index].speed = 2;
            invaders.enemy[index].direction = dir;
            
        } else if(score <= BEE_SCORE){
            invaders.enemy[index].sprite_info.x = MAX_X - BEE_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = BEE_ID;
            invaders.enemy[index].sprite_info.dim = BEE_DIM;
            invaders.enemy[index].points = 2;
            invaders.enemy[index].speed = 3;
            invaders.enemy[index].direction = dir;
            
        } else if(score <= COW_SCORE){
            invaders.enemy[index].sprite_info.x = MAX_X - COW_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = COW_ID;
            invaders.enemy[index].sprite_info.dim = COW_DIM;
            invaders.enemy[index].points = 3;
            invaders.enemy[index].speed = 4;
            invaders.enemy[index].direction = dir;
            
        } else if(score <= FROG_SCORE){
            invaders.enemy[index].sprite_info.x = MAX_X - FROG_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = FROG_ID;
            invaders.enemy[index].sprite_info.dim = FROG_DIM;
            invaders.enemy[index].points = 3;
            invaders.enemy[index].speed = 3;
            invaders.enemy[index].direction = dir;
            
        } else if(score <= GOAT_SCORE){
            invaders.enemy[index].sprite_info.x = MAX_X - GOAT_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = GOAT_ID;
            invaders.enemy[index].sprite_info.dim = GOAT_DIM;
            invaders.enemy[index].points = 3;
            invaders.enemy[index].speed = 3;
            invaders.enemy[index].direction = dir;
            
        } else if (score <= CHICK_SCORE){
            invaders.enemy[index].sprite_info.x = MAX_X - CHICK_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = CHICK_ID;
            invaders.enemy[index].sprite_info.dim = CHICK_DIM;
            invaders.enemy[index].points = 3;
            invaders.enemy[index].speed = 4;
            invaders.enemy[index].direction = dir;
        } else {
            invaders.enemy[index].sprite_info.x = MAX_X - PIG_DIM;
            invaders.enemy[index].sprite_info.y = ycord;
            invaders.enemy[index].sprite_info.id = PIG_ID;
            invaders.enemy[index].sprite_info.dim = PIG_DIM;
            invaders.enemy[index].points = 3;
            invaders.enemy[index].speed = 3;
            invaders.enemy[index].direction = dir;
        }
        
        next_available_enemy_slot++;
        current_enemy_count++;
    }
    
}


void enemy_ai() {
    int i;
    
    for (i = 0; i < MAX_ENEMIES; i++) {
        if (invaders.enemy[i].alive == 1) {
            move_enemy(&invaders.enemy[i]);
        }
    }
    
}

void game_over_ai() {

    if (health <= 0) {
        state = game_over;
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
    init_state();
    pthread_mutex_unlock(&lock);
	
    pthread_create(&input_thread, NULL, handle_keyboard_thread_f, NULL);
    pthread_create(&input_thread, NULL, handle_controller_thread_f2, NULL);
    
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
            draw_score();
            enemy_ai();
			add_enemy();
            game_over_ai();
            pthread_mutex_unlock(&lock);
            usleep(27000);
        } else if (state == game_over) {
            sprite_t game_over;

            game_over.x = MAX_X /2;
            game_over.y = MAX_Y /2;
            game_over.id = TITLE_ID;
            game_over.dim = TITLE_DIM;
            game_over.s = -1;
            pthread_mutex_lock(&lock);
            draw_sprite(&game_over);
            pthread_mutex_unlock(&lock);
        
        }

		ticks++;
    }
    
    pthread_cancel(input_thread);
    
    /* Destroy lock */
    pthread_mutex_destroy(&lock);
    
    /* Wait for the network thread to finish */
    pthread_join(input_thread, NULL);
    
}
