#ifndef _VGA_LED_H
#define _VGA_LED_H

#include <linux/ioctl.h>

#define INITIAL_X 0
#define INITIAL_Y 0
#define MAX_SPRITES 20

typedef struct {
	unsigned int x;
	unsigned int y;
        unsigned int id; 
	unsigned int dim;
} sprite_t; /* 32 bit for entire struct == 4bytes*/

#define VGA_LED_MAGIC 'q'
#define BIT_MASK(a, b) (((unsigned) -1 >> (31 - (b))) & ~((1U << (a)) - 1))
/* ioctls and their arguments */
#define VGA_SET_SPRITE _IOW(VGA_LED_MAGIC, 1, sprite_t **)

#endif
