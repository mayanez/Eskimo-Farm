/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module Sprite_Controller(  input logic clk,
                           input logic reset,
                           input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,

                           input logic [23:0] sprite1,sprite2,sprite3,sprite4,sprite5,sprite6,sprite7,sprite8,sprite9,sprite10,sprite11,sprite12,sprite13,sprite14,sprite15,sprite16,sprite17,sprite18,sprite19,sprite20,

						   input wire [23:0] M_sprite1,M_sprite2,M_sprite3,M_sprite4,M_sprite5,M_sprite6,M_sprite7,M_sprite8,M_sprite9,M_sprite10,M_sprite11,M_sprite12,M_sprite13,M_sprite14,M_sprite15,M_sprite16,M_sprite17,M_sprite18,M_sprite19,M_sprite20,M_background,

                           output logic [11:0] addr_sprite1,addr_sprite2,addr_sprite3,addr_sprite4,addr_sprite5,addr_sprite6,addr_sprite7,addr_sprite8,addr_sprite9,addr_sprite10,addr_sprite11,addr_sprite12,addr_sprite13,addr_sprite14,addr_sprite15,addr_sprite16,addr_sprite17,addr_sprite18,addr_sprite19,addr_sprite20,

                           output logic [7:0] VGA_R, VGA_G, VGA_B);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for id*/
   /* 20 sprite entry array */

   logic [23:0] line_buffer [639:0];


   logic [8:0] x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20;
   logic [9:0] y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,;


   assign x1 = sprite1[9:0];
   assign y1 = sprite1[18:10];
   
   assign x2 = sprite2[9:0];
   assign y2 = sprite2[18:10];

   assign x3 = sprite3[9:0];
   assign y3 = sprite3[18:10];
   
   assign x4 = sprite4[9:0];
   assign y4 = sprite4[18:10];
   
   assign x5 = sprite5[9:0];
   assign y5 = sprite5[18:10];
   
   assign x6 = sprite6[9:0];
   assign y6 = sprite6[18:10];
   
   assign x7 = sprite7[9:0];
   assign y7 = sprite7[18:10];
   
   assign x8 = sprite8[9:0];
   assign y8 = sprite8[18:10];
   
   assign x9 = sprite9[9:0];
   assign y9 = sprite9[18:10];
   
   assign x10 = sprite10[9:0];
   assign y10 = sprite10[18:10];
   
   assign x11 = sprite11[9:0];
   assign y11 = sprite11[18:10];
   
   assign x12 = sprite12[9:0];
   assign y12 = sprite12[18:10];
   
   assign x13 = sprite13[9:0];
   assign y13 = sprite13[18:10];
   
   assign x14 = sprite14[9:0];
   assign y14 = sprite14[18:10];
   
   assign x15 = sprite15[9:0];
   assign y15 = sprite15[18:10];
   
   assign x16 = sprite16[9:0];
   assign y16 = sprite16[18:10];

   assign x17 = sprite17[9:0];
   assign y17 = sprite17[18:10];
   
   assign x18 = sprite18[9:0];
   assign y18 = sprite18[18:10];
   
   assign x19 = sprite19[9:0];
   assign y19 = sprite19[18:10];
   
   assign x20 = sprite20[9:0];
   assign y20 = sprite20[18:10];


   logic sprite1_on,sprite2_on,sprite3_on,sprite4_on,sprite5_on,sprite6_on,sprite7_on,sprite8_on,sprite9_on,sprite10_on,sprite11_on,sprite12_on,sprite13_on,sprite14_on,sprite15_on,sprite16_on,sprite17_on,sprite18_on,sprite19_on,sprite20_on;
   
   assign sprite1_on = (VGA_VCOUNT >= y1 && VGA_VCOUNT <= y1 + 10'd32 && VGA_HCOUNT >= x1 && VGA_HCOUNT <= x1 + 9'd32) ? 1 : 0;
   assign sprite2_on = (VGA_VCOUNT >= y2 && VGA_VCOUNT <= y2 + 10'd32 && VGA_HCOUNT >= x2 && VGA_HCOUNT <= x2 + 9'd32) ? 1 : 0;
   assign sprite3_on = (VGA_VCOUNT >= y3 && VGA_VCOUNT <= y3 + 10'd32 && VGA_HCOUNT >= x3 && VGA_HCOUNT <= x3 + 9'd32) ? 1 : 0;
   assign sprite4_on = (VGA_VCOUNT >= y4 && VGA_VCOUNT <= y4 + 10'd32 && VGA_HCOUNT >= x4 && VGA_HCOUNT <= x4 + 9'd32) ? 1 : 0;
   assign sprite5_on = (VGA_VCOUNT >= y5 && VGA_VCOUNT <= y5 + 10'd32 && VGA_HCOUNT >= x5 && VGA_HCOUNT <= x5 + 9'd32) ? 1 : 0;
   assign sprite6_on = (VGA_VCOUNT >= y6 && VGA_VCOUNT <= y6 + 10'd32 && VGA_HCOUNT >= x6 && VGA_HCOUNT <= x6 + 9'd32) ? 1 : 0;
   assign sprite7_on = (VGA_VCOUNT >= y7 && VGA_VCOUNT <= y7 + 10'd32 && VGA_HCOUNT >= x7 && VGA_HCOUNT <= x7 + 9'd32) ? 1 : 0;
   assign sprite8_on = (VGA_VCOUNT >= y8 && VGA_VCOUNT <= y8 + 10'd32 && VGA_HCOUNT >= x8 && VGA_HCOUNT <= x8 + 9'd32) ? 1 : 0;
   assign sprite9_on = (VGA_VCOUNT >= y9 && VGA_VCOUNT <= y9 + 10'd32 && VGA_HCOUNT >= x9 && VGA_HCOUNT <= x9 + 9'd32) ? 1 : 0;
   assign sprite10_on = (VGA_VCOUNT >= y10 && VGA_VCOUNT <= y10 + 10'd32 && VGA_HCOUNT >= x10 && VGA_HCOUNT <= x10 + 9'd32) ? 1 : 0;
   assign sprite11_on = (VGA_VCOUNT >= y11 && VGA_VCOUNT <= y11 + 10'd32 && VGA_HCOUNT >= x11 && VGA_HCOUNT <= x11 + 9'd32) ? 1 : 0;
   assign sprite12_on = (VGA_VCOUNT >= y12 && VGA_VCOUNT <= y12 + 10'd32 && VGA_HCOUNT >= x12 && VGA_HCOUNT <= x12 + 9'd32) ? 1 : 0;
   assign sprite13_on = (VGA_VCOUNT >= y13 && VGA_VCOUNT <= y13 + 10'd32 && VGA_HCOUNT >= x13 && VGA_HCOUNT <= x13 + 9'd32) ? 1 : 0;
   assign sprite14_on = (VGA_VCOUNT >= y14 && VGA_VCOUNT <= y14 + 10'd32 && VGA_HCOUNT >= x14 && VGA_HCOUNT <= x14 + 9'd32) ? 1 : 0;
   assign sprite15_on = (VGA_VCOUNT >= y15 && VGA_VCOUNT <= y15 + 10'd32 && VGA_HCOUNT >= x15 && VGA_HCOUNT <= x15 + 9'd32) ? 1 : 0;
   assign sprite16_on = (VGA_VCOUNT >= y16 && VGA_VCOUNT <= y16 + 10'd32 && VGA_HCOUNT >= x16 && VGA_HCOUNT <= x16 + 9'd32) ? 1 : 0;
   assign sprite17_on = (VGA_VCOUNT >= y17 && VGA_VCOUNT <= y17 + 10'd32 && VGA_HCOUNT >= x17 && VGA_HCOUNT <= x17 + 9'd32) ? 1 : 0;
   assign sprite18_on = (VGA_VCOUNT >= y18 && VGA_VCOUNT <= y18 + 10'd32 && VGA_HCOUNT >= x18 && VGA_HCOUNT <= x18 + 9'd32) ? 1 : 0;
   assign sprite19_on = (VGA_VCOUNT >= y19 && VGA_VCOUNT <= y19 + 10'd32 && VGA_HCOUNT >= x19 && VGA_HCOUNT <= x19 + 9'd32) ? 1 : 0;
   assign sprite20_on = (VGA_VCOUNT >= y20 && VGA_VCOUNT <= y20 + 10'd32 && VGA_HCOUNT >= x20 && VGA_HCOUNT <= x20 + 9'd32) ? 1 : 0;

   assign addr_sprite1 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite2 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite3 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite4 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite5 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite6 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite7 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite8 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite9 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite10 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite11 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite12 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite13 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite14 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite15 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite16 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite17 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite18 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite19 = VGA_VCOUNT*32 + VGA_HCOUNT;
   assign addr_sprite20 = VGA_VCOUNT*32 + VGA_HCOUNT;

   always@(posedge clk)
    begin
	  if (sprite1_on)
        line_buffer[VGA_HCOUNT] <= M_sprite1;
      else if (sprite2_on)
        line_buffer[VGA_HCOUNT] <= M_sprite2;
      else if (sprite3_on)
        line_buffer[VGA_HCOUNT] <= M_sprite3;
      else if (sprite4_on)
        line_buffer[VGA_HCOUNT] <= M_sprite4;
      else if (sprite5_on)
        line_buffer[VGA_HCOUNT] <= M_sprite5;
      else if (sprite6_on)
        line_buffer[VGA_HCOUNT] <= M_sprite6;
      else if (sprite7_on)
        line_buffer[VGA_HCOUNT] <= M_sprite7;
      else if (sprite8_on)
        line_buffer[VGA_HCOUNT] <= M_sprite8;
      else if (sprite9_on)
        line_buffer[VGA_HCOUNT] <= M_sprite9;
      else if (sprite10_on)
        line_buffer[VGA_HCOUNT] <= M_sprite10;
      else if (sprite11_on)
        line_buffer[VGA_HCOUNT] <= M_sprite11;
      else if (sprite12_on)
        line_buffer[VGA_HCOUNT] <= M_sprite12;
      else if (sprite13_on)
        line_buffer[VGA_HCOUNT] <= M_sprite13;
      else if (sprite14_on)
        line_buffer[VGA_HCOUNT] <= M_sprite14;
      else if (sprite15_on)
        line_buffer[VGA_HCOUNT] <= M_sprite15;
      else if (sprite16_on)
        line_buffer[VGA_HCOUNT] <= M_sprite16;
      else if (sprite17_on)
        line_buffer[VGA_HCOUNT] <= M_sprite17;
      else if (sprite18_on)
        line_buffer[VGA_HCOUNT] <= M_sprite18;
      else if (sprite19_on)
        line_buffer[VGA_HCOUNT] <= M_sprite19;
      else if (sprite20_on)
        line_buffer[VGA_HCOUNT] <= M_sprite20;
	  else
	     line_buffer[VGA_HCOUNT] <= M_background;
     end


  /* For a given hcount(column) select bits for each color channel */
  assign {VGA_R, VGA_G, VGA_B} = {line_buffer[VGA_HCOUNT][23:16], line_buffer[VGA_HCOUNT][15:8], line_buffer[VGA_HCOUNT][7:0]};



endmodule
