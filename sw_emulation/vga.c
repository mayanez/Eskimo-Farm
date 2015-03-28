#include "vga.h"
#include "sprite.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <linux/fb.h>

#define FBDEV "/dev/fb0"
#define FBOPEN_DEV -1
#define FBOPEN_FSCREENINFO -2
#define FBOPEN_VSCREENINFO -3
#define FBOPEN_MMAP -4
#define FBOPEN_BPP -5
#define BITS_PER_PIXEL 8

/*
 * References:
 *
 * http://raspberrycompote.blogspot.com/2013/01/low-level-graphics-on-raspberry-pi-part_22.html
 *
 */

struct fb_var_screeninfo fb_vinfo;
struct fb_fix_screeninfo fb_finfo;
unsigned char *framebuffer;

int fbopen() {
	  int fd = open(FBDEV, O_RDWR); /* Open the device */
  if (fd == -1) return FBOPEN_DEV;

  if (ioctl(fd, FBIOGET_FSCREENINFO, &fb_finfo)) /* Get fixed info about fb */
    return FBOPEN_FSCREENINFO;

  if (ioctl(fd, FBIOGET_VSCREENINFO, &fb_vinfo)) /* Get varying info about fb */
    return FBOPEN_VSCREENINFO;

  framebuffer = mmap(0, fb_finfo.smem_len, PROT_READ | PROT_WRITE,
		     MAP_SHARED, fd, 0);

  if (framebuffer == (unsigned char *)-1) return FBOPEN_MMAP;

  // Change variable info
  fb_vinfo.bits_per_pixel = 8;
  if (ioctl(fd, FBIOPUT_VSCREENINFO, &fb_vinfo)) {
    printf("Error setting variable information.\n");
  }

  return 0;
}

void fbputpixel(rgb_pixel_t *rgb_pixel, int hcount, int vcount) {
	unsigned char *pixel = framebuffer + ((vcount + fb_vinfo.yoffset) * fb_finfo.line_length) + ((hcount + fb_vinfo.xoffset) * BITS_PER_PIXEL / 8);
	pixel[0] = rgb_pixel->r;
	pixel[1] = rgb_pixel->g;
	pixel[2] = rgb_pixel->b;
	pixel[3] = 0;
}

void draw_rgb_fb() {

	int hcount, vcount;

	for (vcount = 0; vcount < DISPLAY_HEIGHT; vcount++) {
		for (hcount = 0; hcount < DISPLAY_WIDTH; hcount++) {
			rgb_pixel_t *rgb_pixel = vga_rgb_req(hcount, vcount);
			fbputpixel(rgb_pixel, hcount, vcount);
		}
	}

	memset(framebuffer, 0, fb_finfo.smem_len);
}
