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
   logic [9:0] VGA_HCOUNT;
   logic [9:0] VGA_VCOUNT;
   logic VGA_CLOCK;

   assign gl_array[0] = gl_input[23:0];
   /* Continue until gl[19] */

   /* One block like this for every sprite we have available */
   logic [14:0] addr_moon; /* The #bits varies on dimensions of sprite */
   logic [11:0] M_moon; /* Change to 24-bit color */
   moon mn(.clock(VGA_CLK), .address(addr_moon), .q(M_moon));
   

   VGA_LED_Emulator led_emulator(.clk50(clk), .*);
   Sprite_Controller sprite_controller(.clk(VGA_CLK), .sprite1(gl_array[0]), .*);

endmodule

