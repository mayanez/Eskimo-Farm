#ifndef _USBKEYBOARD_H
#define _USBKEYBOARD_H

#include <libusb-1.0/libusb.h>

#define USB_HID_KEYBOARD_PROTOCOL 1

/* Modifier bits */
#define USB_LCTRL  (1 << 0)
#define USB_LSHIFT (1 << 1)
#define USB_LALT   (1 << 2)
#define USB_LGUI   (1 << 3)
#define USB_RCTRL  (1 << 4)
#define USB_RSHIFT (1 << 5)
#define USB_RALT   (1 << 6) 
#define USB_RGUI   (1 << 7)

#define SHIFT_L 0x02
#define SHIFT_R 0x20
#define ENTER 0x28
#define ESC 0x29
#define BACKSPACE 0x2A
#define TAB 0x2B
#define SPACEBAR 0x2C
#define RIGHT_ARROW 0x4F
#define LEFT_ARROW 0x50
#define UP_ARROW 0x52
#define DOWN_ARROW 0x51


static const unsigned char usb_keycode_ascii[256] = {
            0,  0,  0,  0, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
           'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1',
	   '2', '3', '4', '5', '6', '7', '8', '9', '0', 0, 0, 0, 0, ' ', '-', '=',
	   '[', ']', '\\', 0, ';', '\'', '`', ',', '.', '/' };

static const unsigned char mod_usb_keycode_ascii[256] = {
            0,  0,  0,  0, 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
           'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '!',
	   '@', '#', '$', '%', '^', '&', '*', '(', ')', 0, 0, 0, 0, ' ', '_', '+',
	   '{', '}', '|', 0, ':', '"', '~', '<', '>', '?' };

struct usb_keyboard_packet {
  uint8_t modifiers;
  uint8_t reserved;
  uint8_t keycode[6];
};

struct Xbox360Msg
{
    // -------------------------
    unsigned int type :8;
    unsigned int length :8;
    // data[2] ------------------
    unsigned int dpad_up :1;
    unsigned int dpad_down :1;
    unsigned int dpad_left :1;
    unsigned int dpad_right :1;
    unsigned int start :1;
    unsigned int back :1;
    unsigned int thumb_l :1;
    unsigned int thumb_r :1;
    // data[3] ------------------
    unsigned int lb :1;
    unsigned int rb :1;
    unsigned int guide :1;
    unsigned int dummy1 :1;
    unsigned int a :1;
    unsigned int b :1;
    unsigned int x :1;
    unsigned int y :1;
    // data[4] ------------------
    unsigned int lt :8;
    unsigned int rt :8;
    // data[6] ------------------
    int x1 :16;
    int y1 :16;
    // data[10] -----------------
    int x2 :16;
    int y2 :16;
    // data[14]; ----------------
    unsigned int dummy2 :32;
    unsigned int dummy3 :16;
} __attribute__((__packed__));

/* Find and open a USB keyboard device.  Argument should point to
   space to store an endpoint address.  Returns NULL if no keyboard
   device was found. */
extern struct libusb_device_handle *openkeyboard(uint8_t *);

#endif
