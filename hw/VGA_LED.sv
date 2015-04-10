/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module VGA_LED(input logic        clk,
	       input logic 	  reset,
	       input logic [31:0] gl_array, /*32-bits due to iowrite32 */
	       input logic 	  write,
	       input 		  chipselect,
	       input logic [2:0]  address,
	       output logic [7:0] VGA_R, VGA_G, VGA_B,
	       output logic 	  VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	       output logic 	  VGA_SYNC_n);

   wire [9:0] VGA_HCOUNT;
   wire [9:0] VGA_VCOUNT;
   wire VGA_CLOCK;

   VGA_LED_Emulator led_emulator(.clk50(clk), .reset(reset), .VGA_HCOUNT(VGA_HCOUNT), .VGA_VCOUNT(VGA_VCOUNT), .VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_n(VGA_BLANK_n), .VGA_SYNC_n(VGA_SYNC_n));

   Sprite_Controller sprite_controller(.clk(VGA_CLK), .reset(reset), .gl_array(gl_array), .VGA_HCOUNT(VGA_HCOUNT), .VGA_VCOUNT(VGA_VCOUNT), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

endmodule

