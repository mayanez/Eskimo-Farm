#include "Types.h"
#include "sprite.h"
#include "vga.h"
#include <pthread.h>

pthread_t sprite_thread, vga_thread;
pthread_mutex_t vga_lock;

void *sprite_thread_f(void *);
void *vga_thread_f(void *);

/* Tests Sprite Drawing to FB */
int main() {

    sprite_init();
    vga_init();

      /* Init Mutex */
      if (pthread_mutex_init(&vga_lock, NULL) != 0) {
            fprintf(stderr, "mutex init failed\n");
            exit(1);
      }

    /*Start Sprite Thread*/
    pthread_create(&sprite_thread, NULL, sprite_thread_f, NULL);

    /*Start VGA Thread */
    pthread_create(&vga_thread, NULL, vga_thread_f, NULL);


    /* Terminate threads */
    pthread_cancel(sprite_thread);
    pthread_cancel(vga_thread);

    /* Destroy lock */
    pthread_mutex_destroy(&vga_lock);

    pthread_join(sprite_thread, NULL);
    pthread_join(vga_thread, NULL);
}

/*
 * 1. Sprite Controller will initialize with Game State.
 * 2. VGA will get RGB from Sprite Controller and draw to screen.
 * 3. Repeat.
 *
 * In hardware this might have to be synchronized using a buffer?
 */

void *vga_thread_f(void *ignored) {
    /* Draws the screen constantly */
    while (1) {

        /* Will wait for Game State to be updated */
        pthread_mutex_lock(&vga_lock);
        draw_rgb_fb();
        pthread_mutex_unlock(&vga_lock);
    }
}

void *sprite_thread_f(void *ignored) {

    sprite_info_t input_array[INPUT_STRUCT_LENGTH]={0};
    input_array[0].x = 0;
    input_array[0].y = 10;
    input_array[0].id =  2;

    input_array[1].x = 631;
    input_array[1].y = 471;
    input_array[1].id =  3;

    input_array[2].x = 0;
    input_array[2].y = 471;
    input_array[2].id = 49;

    input_array[3].x = 621;
    input_array[3].y = 0;
    input_array[3].id = 50;

    int x;

    /*Translates a sprite horizontally */

    while (1) {

        if (x % 640 == 0) {
            x = 0;
        }

        input_array[0].x = x;

        /* Will wait for screen to draw before getting next state */
        pthread_mutex_lock(&vga_lock);
        gl_logic_state_input(input_array);
        pthread_mutex_unlock(&vga_lock);
        x++;
    }
}