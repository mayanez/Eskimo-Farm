#include "vga.h"
//#include "sprite.h"

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
char *framebuffer;

int fbopen() {
	  int fd = open(FBDEV, O_RDWR); /* Open the device */
  if (fd == -1) return FBOPEN_DEV;

  if (ioctl(fd, FBIOGET_FSCREENINFO, &fb_finfo)) /* Get fixed info about fb */
    return FBOPEN_FSCREENINFO;

  if (ioctl(fd, FBIOGET_VSCREENINFO, &fb_vinfo)) /* Get varying info about fb */
    return FBOPEN_VSCREENINFO;

  fb_vinfo.bits_per_pixel = 8;
  if (ioctl(fd, FBIOPUT_VSCREENINFO, &fb_vinfo)) {
    printf("Error setting variable information.\n");
  }

  framebuffer = (char *)mmap(0, fb_finfo.smem_len, PROT_READ | PROT_WRITE,
		     MAP_SHARED, fd, 0);

  if (framebuffer == (char *)-1) return FBOPEN_MMAP;

  return 0;
}

void put_pixel_RGB32(rgb_pixel_t *rgb_pixel, int x, int y)
{
    // remember to change main(): vinfo.bits_per_pixel = 24;
    // and: screensize = vinfo.xres * vinfo.yres *
    //                   vinfo.bits_per_pixel / 8;

    // calculate the pixel's byte offset inside the buffer
    // note: x * 3 as every pixel is 3 consecutive bytes
    unsigned int pix_offset = x * 4 + y * fb_finfo.line_length;

    // now this is about the same as 'fbp[pix_offset] = value'
    *((char*)(framebuffer + pix_offset)) = rgb_pixel->b;
    *((char*)(framebuffer + pix_offset + 1)) = rgb_pixel->g;
    *((char*)(framebuffer + pix_offset + 2)) = rgb_pixel->r;
    *((char*)(framebuffer + pix_offset + 3)) = 0;

}
void fbputpixel(rgb_pixel_t *rgb_pixel, int hcount, int vcount) {
	printf("Start fbputpixel()\n");
        printf("rgb_pixel %d\n", rgb_pixel->r);
	printf("bbp %d\n", fb_vinfo.bits_per_pixel);
	unsigned int pix_offset = hcount + vcount * fb_finfo.line_length;
	//pixel[0] = rgb_pixel->r;
	//pixel[1] = rgb_pixel->g;
	//pixel[2] = rgb_pixel->b;
	//pixel[3] = 0;

	//*((char*)(framebuffer + pix_offset)) = 0xff;
        memset(framebuffer + pix_offset, 0xff, fb_vinfo.bits_per_pixel); 
}

void draw_rgb_fb() {

	int hcount, vcount;

	for (vcount = 0; vcount < DISPLAY_HEIGHT; vcount++) {
		for (hcount = 0; hcount < DISPLAY_WIDTH; hcount++) {
			printf("h: %d v: %d\n", hcount, vcount);
			rgb_pixel_t rgb_pixel = { 255, 0, 0 };//vga_rgb_req(hcount, vcount);
			put_pixel_RGB32(&rgb_pixel, hcount, vcount);
		}
	}

	memset(framebuffer, 0, fb_finfo.smem_len);
}

int main() {
fbopen();
draw_rgb_fb();
}
