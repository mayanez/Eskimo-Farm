/*
 * Userspace program that communicates with the led_vga device driver
 * primarily through ioctls
 *
 * Stephen A. Edwards
 * Columbia University
 */

#include <stdio.h>
#include "vga_led.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

int vga_led_fd;

int main()
{
  sprite_t sprites[2];

  static const char filename[] = "/dev/vga_led";

  printf("VGA LED Userspace program started\n");

  if ( (vga_led_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }

  sprites[0].x = 50;
  sprites[0].y = 100;
  sprites[0].id = 0;
  sprites[0].dim = 32;
  sprites[0].s = 0;

  sprites[1].x = 50;
  sprites[1].y = 50;
  sprites[1].id = 2;
  sprites[1].dim = 32;
  sprites[1].s = 0;

  ioctl(vga_led_fd, VGA_SET_SPRITE, sprites[0]);
  ioctl(vga_led_fd, VGA_SET_SPRITE, sprites[1]);

  return 0;
}
