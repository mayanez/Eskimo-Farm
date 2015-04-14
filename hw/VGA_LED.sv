/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module VGA_LED(input logic        clk,
	       input logic 	  reset,
	       input logic [511:0] gl_input, /* 20 * 24-bit entries rounded up to closest power of 2 */
	       input logic 	  write,
	       output logic [7:0] VGA_R, VGA_G, VGA_B,
	       output logic 	  VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	       output logic 	  VGA_SYNC_n);

   logic [23:0] gl_array [19:0]; 
   logic [23:0] M_sprite1;
   logic [9:0] VGA_HCOUNT;
   logic [9:0] VGA_VCOUNT;
   logic VGA_CLOCK;
   logic [4:0] id1;

   assign gl_array[0] = gl_input[23:0];
   assign id1 = gl_array[0][23:19];

   assign M_sprite1 = (id1 == 5'd1') ? M_moon : 0;
 
   /* Continue until gl[19] */

   
   logic [11:0] addr_sprite; /* The #bits varies on dimensions of sprite */
   logic [19:0] addr_background;
   logic [23:0] M_sprite1; /* Change to 24-bit color */
   logic [23:0] M_background;

   moon mn(.clock(VGA_CLK), .address(addr_sprite), .q(M_moon));
   
   VGA_LED_Emulator led_emulator(.clk50(clk), .*);
   Sprite_Controller sprite_controller(.clk(VGA_CLK), .sprite1(gl_array[0]), .*);

endmodule

