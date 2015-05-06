#ifndef _VGA_LED_H
#define _VGA_LED_H

#include <linux/ioctl.h>

#define MAX_SPRITES 30
#define MAX_SPRITE_DIM 32
#define MAX_SPRITE_ID 40 /* Unique number of sprites == # of ROMs */
#define HUD_BOUNDARY 34
#define MAX_X 640
#define MAX_Y 448
#define START_NUM 5
#define PAUSE_NUM 5
#define GAMEOVER_NUM 8
#define WIN_NUM 3

#define FONT_DIM 32

#define SHIP_ID 1
#define SHIP_DIM 32
#define BULLET_ID 5
#define BULLET_DIM 16
#define PIG_ID 2
#define PIG_DIM 32
#define CLOUD_ID 19
#define CLOUD_DIM 32
#define LIVES_ID 18
#define LIVES_DIM 32
#define BEE_ID 3
#define BEE_DIM 32
#define COW_DIM 32
#define COW_ID 4
#define FROG_ID 21
#define FROG_DIM 32
#define GOAT_ID 20
#define GOAT_DIM 32
#define CHICK_ID 22
#define CHICK_DIM 32
#define ONE_ID 7
#define TWO_ID 8
#define THREE_ID 9
#define FOUR_ID 10
#define FIVE_ID 11
#define SIX_ID 12
#define SEVEN_ID 13
#define EIGHT_ID 14
#define NINE_ID 15
#define ZERO_ID 6

#define A_ID 23
#define E_ID 24
#define F_ID 25
#define G_ID 26
#define I_ID 27
#define K_ID 28
#define M_ID 29
#define N_ID 30
#define O_ID 31
#define P_ID 32
#define R_ID 33
#define S_ID 34
#define U_ID 35
#define V_ID 36
#define W_ID 37
#define T_ID 38

typedef struct {
	unsigned int s; /* Sprite Number: Must be assigned in Game Logic. eg. Sprite1 == Player, etc.*/
	unsigned int x;
	unsigned int y;
    unsigned int id;
	unsigned int dim;
} sprite_t;

typedef struct {
    unsigned int ready;
} vga_ready_t;

#define VGA_LED_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_SET_SPRITE _IOW(VGA_LED_MAGIC, 1, sprite_t *)
#define VGA_CLEAR	   _IO(VGA_LED_MAGIC, 2)
#define VGA_READY      _IOR(VGA_LED_MAGIC, 3, vga_ready_t *)

#endif
