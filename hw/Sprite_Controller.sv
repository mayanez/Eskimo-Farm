/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module Sprite_Controller(  input logic clk,
                           input logic reset,
                           input logic [31:0] gl_array,
                           input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
						   input wire [11:0] M_moon,
						   output logic [14:0] addr_t,
                           output logic [7:0] VGA_R, VGA_G, VGA_B);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for id*/
   /* 20 sprite entry array */

   reg [11:0] line_buffer [639:0];

   logic [11:0] M_temp;

   logic [8:0] x11, x12;
   logic [9:0] y11,y12;
   logic [4:0] id1;
   reg buf_count;

   assign x11 = 0;
   assign x12 = 9'd64;
   assign y11 = 0;
   assign y12 = 10'd64;

   logic sprite1_on;

   assign sprite1_on = (VGA_VCOUNT >= y11 && VGA_VCOUNT <= y12 && VGA_HCOUNT >= x11 && VGA_HCOUNT <= x12) ? 1 : 0;
   assign addr_t = VGA_VCOUNT*64 + VGA_HCOUNT;

   always@(posedge clk)
    begin
	  if (sprite1_on)
        line_buffer[VGA_HCOUNT] <= M_moon;
	  else
	     line_buffer[VGA_HCOUNT] <= 0;
    end


  /* For a given hcount(column) select bits for each color channel */
  //assign {VGA_R, VGA_G, VGA_B} = {line_buffer[VGA_HCOUNT][23:16], line_buffer[VGA_HCOUNT][15:8], line_buffer[VGA_HCOUNT][7:0]};
  assign VGA_R = {line_buffer[VGA_HCOUNT][11:8],line_buffer[VGA_HCOUNT][11:8]}; 
assign VGA_G = {line_buffer[VGA_HCOUNT][7:4],line_buffer[VGA_HCOUNT][7:4]};
assign VGA_B = {line_buffer[VGA_HCOUNT][3:0],line_buffer[VGA_HCOUNT][3:0]};


endmodule
