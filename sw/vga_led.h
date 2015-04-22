#ifndef _VGA_LED_H
#define _VGA_LED_H

//#include <linux/ioctl.h>

#define MAX_SPRITES 20
#define MAX_SPRITE_DIM 128
#define MAX_SPRITE_ID 40 /* Unique number of sprites == # of ROMs */
#define MIN_X 0
#define MIN_Y 31
#define MAX_X 607
#define MAX_Y 447

#define SHIP_ID 1
#define PIG_ID 	2
#define BEE_ID 	3
#define HEN_ID	4
#define SHIP_DIM 32
#define BULLET_ID 5
#define BULLET_DIM 16
#define ENEMY_DIM 32

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
