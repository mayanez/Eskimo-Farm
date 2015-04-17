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
  sprite_t vla[20];
  int i;
  static const char filename[] = "/dev/vga_led";

  static unsigned char message[8] = { 0x39, 0x6D, 0x79, 0x79,
				      0x66, 0x7F, 0x66, 0x3F };

  printf("VGA LED Userspace program started\n");

  if ( (vga_led_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }

  vla[0].x = 50;
  vla[0].y = 100;
  vla[0].id = 0;
  vla[0].dim = 32;

  ioctl(vga_led_fd, VGA_SET_SPRITE, vla);
  return 0;
}
