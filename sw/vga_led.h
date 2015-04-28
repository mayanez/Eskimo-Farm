#ifndef _VGA_LED_H
#define _VGA_LED_H

//#include <linux/ioctl.h>

#define MAX_SPRITES 20
#define MAX_SPRITE_DIM 128
#define MAX_SPRITE_ID 40 /* Unique number of sprites == # of ROMs */
#define HUD_BOUNDARY 30;
#define MAX_X 640
#define MAX_Y 480

#define SHIP_ID 1
#define SHIP_DIM 32
#define BULLET_ID 5
#define BULLET_DIM 16
#define PIG_ID 2
#define PIG_DIM 32
#define CLOUD_ID 19
#define CLOUD_DIM 23
#define LIVES_ID 18
#define LIVES_DIM 23
#define BEE_ID 3
#define BEE_DIM 32
#define COW_DIM 32
#define COW_ID 4
#define FROG_ID 21
#define FROG_DIM 128
#define GOAT_ID 20
#define GOAT_DIM 64
#define CHICK_ID 22
#define CHICK_DIM 24
#define ONE_ID 7
#define ONE_DIM 10
#define TWO_ID 8
#define TWO_DIM 10
#define THREE_ID 9
#define THREE_DIM 10
#define FOUR_ID 10
#define FOUR_DIM 10
#define FIVE_ID 11
#define FIVE_DIM 10
#define SIX_ID 12
#define SIX_DIM 10
#define SEVEN_ID 13
#define SEVEN_DIM 10
#define EIGHT_ID 14
#define EIGHT_DIM 10
#define NINE_ID 15
#define NINE_DIM 10
#define ZERO_ID 6
#define ZERO_DIM 10
#define S_ID 23
#define S_DIM 10
#define C_ID 24
#define C_DIM 10
#define O_ID 25
#define O_DIM 10
#define R_ID 26
#define R_DIM 10
#define E_ID 27
#define E_DIM 10

typedef struct {
	unsigned int s; /* Sprite Number: Must be assigned in Game Logic. eg. Sprite1 == Player, etc.*/
	unsigned int x;
	unsigned int y;
    unsigned int id;
	unsigned int dim;
} sprite_t;

#define VGA_LED_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_SET_SPRITE _IOW(VGA_LED_MAGIC, 1, sprite_t *)
#define VGA_CLEAR	   _IO(VGA_LED_MAGIC, 2)

#endif
