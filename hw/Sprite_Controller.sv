/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module Sprite_Controller(  input logic clk,
                           input logic reset,
                           input logic [23:0] sprite1, sprite2, sprite3,
                           input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
						   input wire [23:0] M_sprite1, M_sprite2,
						   output logic [9:0] addr_sprite1, addr_sprite2,
                           output logic [7:0] VGA_R, VGA_G, VGA_B);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for id*/
   /* 20 sprite entry array */

   logic [23:0] line_buffer1 [639:0]; /* Read buffer */
   logic [23:0] line_buffer2 [639:0]; /* Prefetch */
   logic [23:0] M_buf;

   logic buf_toggle;


   assign sprite1_on = VGA_VCOUNT >= sprite1[9:0] && VGA_VCOUNT <= (sprite1[9:0] + 10'd31) && VGA_HCOUNT >= sprite1[18:10] && VGA_HCOUNT <= (sprite1[18:10] + 10'd31);
   assign sprite2_on = VGA_VCOUNT >= sprite2[9:0] && VGA_VCOUNT <= (sprite2[9:0] + 10'd31) && VGA_HCOUNT >= sprite2[18:10] && VGA_HCOUNT <= (sprite2[18:10] + 10'd31);

   assign addr_sprite1 = (VGA_HCOUNT - sprite1[18:10]) + ((VGA_VCOUNT + 1 - sprite1[9:0]) << 5);
   assign addr_sprite2 = (VGA_HCOUNT - sprite2[18:10]) + ((VGA_VCOUNT + 1 - sprite2[9:0]) << 5);

   always @(*) begin
      if (sprite1_on)
         M_buf = M_sprite1;
      else if (sprite2_on)
         M_buf = M_sprite2;
      else
         M_buf = 0;
   end

   always@(posedge VGA_VCOUNT[0])
     buf_toggle <= buf_toggle + 1;

   always_ff@(posedge clk) begin

           if(buf_toggle == 0)
             line_buffer1[VGA_HCOUNT] <= M_buf;
           else
             line_buffer2[VGA_HCOUNT] <= M_buf;

   end




       assign VGA_R = (buf_toggle == 0) ? line_buffer2[VGA_HCOUNT][23:16] : line_buffer1[VGA_HCOUNT][23:16];
       assign VGA_G = (buf_toggle == 0) ? line_buffer2[VGA_HCOUNT][15:8] : line_buffer1[VGA_HCOUNT][15:8];
       assign VGA_B = (buf_toggle == 0) ? line_buffer2[VGA_HCOUNT][7:0] : line_buffer1[VGA_HCOUNT][7:0];
           


endmodule
