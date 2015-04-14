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
						   input wire [23:0] M_ship, M_pig, M_bee,
						   output logic [9:0] addr_sprite,
                           output logic [7:0] VGA_R, VGA_G, VGA_B);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for id*/
   /* 20 sprite entry array */

   logic [23:0] line_buffer [639:0];
   logic [23:0] M_sprite1, M_sprite2, M_sprite3;

   logic [8:0] x11, x12, x21, x22, x31, x32;
   logic [9:0] y11, y12, y21, y22, y31, y32;
   logic [4:0] id1,id2,id3,id4,id5,id6,id7,id8,id9,id10,id11,id12,id13,id14,id15,id16,id17,id18,id19,id20;

   assign y11 = 0;//sprite1[9:0];
   assign x11 = 0;//sprite1[18:10];
   assign id1 = 1;//sprite1[23:0];

   assign y21 = 10'd65;
   assign x21 = 0;
   assign id2 = 5'd2;

   assign y31 = 10'd140;
   assign x31 = 0;
   assign id3 = 5'd3;

   always_ff@(posedge clk) begin
     if (id1 == 5'd1) begin
       x12 <= x11 + 9'd32;
       y12 <= y11 + 10'd32;
       M_sprite1 <= M_ship;
     end
   end

   always_ff@(posedge clk) begin
     if (id2 == 5'd2) begin
       x22 <= x21 + 9'd32;
       y22 <= y21 + 10'd32;
       M_sprite2 <= M_pig;
     end
   end

   always_ff@(posedge clk) begin
     if (id3 == 5'd3) begin
       x32 <= x31 + 9'd32;
       y32 <= y31 + 10'd32;
       M_sprite3 <= M_bee;
     end
   end

   logic sprite1_on, sprite2_on, sprite3_on;
   
   assign sprite1_on = (VGA_VCOUNT >= y11 && VGA_VCOUNT <= y12 && VGA_HCOUNT >= x11 && VGA_HCOUNT <= x12) ? 1 : 0;
   assign sprite2_on = (VGA_VCOUNT >= y21 && VGA_VCOUNT <= y22 && VGA_HCOUNT >= x21 && VGA_HCOUNT <= x22) ? 1 : 0;
   assign sprite3_on = (VGA_VCOUNT >= y31 && VGA_VCOUNT <= y32 && VGA_HCOUNT >= x31 && VGA_HCOUNT <= x32) ? 1 : 0;
   
   assign addr_sprite = VGA_VCOUNT*32 + VGA_HCOUNT;

   always_ff@(posedge clk)
    begin
	  if (sprite1_on)
        line_buffer[VGA_HCOUNT] <= M_sprite1;
      else if (sprite2_on)
        line_buffer[VGA_HCOUNT] <= M_sprite2;
      else if (sprite3_on)
        line_buffer[VGA_HCOUNT] <= M_sprite3;
	  else
	     line_buffer[VGA_HCOUNT] <= 0;
    end


  /* For a given hcount(column) select bits for each color channel */
  assign {VGA_R, VGA_G, VGA_B} = {line_buffer[VGA_HCOUNT][23:16], line_buffer[VGA_HCOUNT][15:8], line_buffer[VGA_HCOUNT][7:0]};



endmodule
