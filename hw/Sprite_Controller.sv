/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module Sprite_Controller(  input logic clk,
                           input logic reset,
                           input logic [24:0] sprite1, sprite2, sprite3,
                           input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
						   input wire [23:0] M_sprite1, M_sprite2, M_sprite3, 
						   output logic [9:0] addr_sprite1, addr_sprite2, addr_sprite3,
                           output logic [7:0] VGA_R, VGA_G, VGA_B);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for id*/
   /* 20 sprite entry array */

   logic [23:0] line_buffer1 [639:0]; /* Read buffer */
   logic [23:0] line_buffer2 [639:0]; /* Prefetch */
   logic [23:0] M_buf;

   logic buf_toggle;
   logic [9:0] x11, y11, x12, y12, x21, y21, x22, y22, x31, y31, x32, y32;

   assign id1 = sprite1[24:20];
   assign x11 = sprite1[9:0];
   assign y11 = sprite1[19:10];
   assign x12 = (id1 == 5'd1 || id1 == 5'd2 || id1 == 5'd3) ? 10'd31 : 0;  /* For all id of same size */
   assign y12 = (id1 == 5'd1 || id1 == 5'd2 || id1 == 5'd3) ? 10'd31 : 0;

   assign id2 = sprite2[24:20];
   assign x21 = sprite2[9:0];
   assign y21 = sprite2[19:10];
   assign x22 = (id2 == 5'd1 || id2 == 5'd2 || id2 == 5'd3) ? 10'd31 : 0;
   assign y22 = (id2 == 5'd1 || id2 == 5'd2 || id2 == 5'd3) ? 10'd31 : 0;

   assign id3 = sprite3[24:20];
   assign x31 = sprite3[9:0];
   assign y31 = sprite3[19:10];
   assign x32 = (id3 == 5'd1 || id3 == 5'd2 || id3 == 5'd3) ? 10'd31 : 0;
   assign y32 = (id3 == 5'd1 || id3 == 5'd2 || id3 == 5'd3) ? 10'd31 : 0;

   assign sprite1_on = VGA_VCOUNT >= y11 && VGA_VCOUNT <= y12 && VGA_HCOUNT >= x11 && VGA_HCOUNT <= x12;
   assign sprite2_on = VGA_VCOUNT >= y21 && VGA_VCOUNT <= y22 && VGA_HCOUNT >= x21 && VGA_HCOUNT <= x22;
   assign sprite3_on = VGA_VCOUNT >= y31 && VGA_VCOUNT <= y32 && VGA_HCOUNT >= x31 && VGA_HCOUNT <= x32;

   assign addr_sprite1 = (VGA_HCOUNT - x11) + ((VGA_VCOUNT + 1 - y11) << 5);
   assign addr_sprite2 = (VGA_HCOUNT - x21) + ((VGA_VCOUNT + 1 - y21) << 5);
   assign addr_sprite3 = (VGA_HCOUNT - x31) + ((VGA_VCOUNT + 1 - y31) << 5);

   always @(*) begin
      if (sprite1_on)
         M_buf = M_sprite1;
      else if (sprite2_on)
         M_buf = M_sprite2;
	  else if (sprite3_on)
         M_buf = M_sprite3;
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
