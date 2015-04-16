#ifndef _VGA_LED_H
#define _VGA_LED_H

#include <linux/ioctl.h>

#define INITIAL_X 0
#define INITIAL_Y 0
#define MAX_SPRITES 20

typedef struct {
    unsigned int id:5; /* Will round up to 32 bit for entire struct == 4bytes*/
	unsigned int x:10;
	unsigned int y:10;
} sprite_t;

#define VGA_LED_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_SET_SPRITE _IOW(VGA_LED_MAGIC, 1, sprite_t **)

#endif
