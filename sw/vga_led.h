#ifndef _VGA_LED_H
#define _VGA_LED_H

#include <linux/ioctl.h>

#define MAX_SPRITES 40
#define MAX_SPRITE_DIM 128
#define MAX_SPRITE_ID 40 /* Unique number of sprites == # of ROMs */
#define MAX_X 640
#define MAX_Y 480

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
