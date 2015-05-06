#ifndef _AUDIO_HW_H
#define _AUDIO_HW_H

#include <linux/ioctl.h>

#define BACKGROUND_TRACK 1



#define AUDIO_HW_MAGIC 'q'

/* ioctls and their arguments */
#define AUDIO_SET_CONTROL _IOW(AUDIO_HW_MAGIC, 1, unsigned int *)
#define AUDIO_MUTE	      _IO(AUDIO_HW_MAGIC, 2)

#endif
