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
   logic [4:0] id1;
   logic [23:0] sprite1,sprite2,sprite3,sprite4,sprite5,sprite6,sprite7,sprite8,sprite9,sprite10,sprite11,sprite12,sprite13,sprite14,sprite15,sprite16,sprite17,sprite18,sprite19,sprite20;
   logic VGA_CLOCK;

   assign gl_array[0] = gl_input[23:0];
   assign gl_array[0] = gl_input[23:0];
   assign gl_array[1] = gl_input[45:24];


   assign sprite1 = gl_array[0];
   assign sprite2 = gl_array[1];
   assign sprite3 = gl_array[2];


   logic [9:0] addr_sprite; 
   logic [23:0] M_ship, M_pig, M_bee; 

   ship sm(.clock(VGA_CLK), .address(addr_sprite), .q(M_ship));
   pig pg(.clock(VGA_CLK), .address(addr_sprite), .q(M_pig));
   bee be(.clock(VGA_CLK), .address(addr_sprite), .q(M_bee));

   VGA_LED_Emulator led_emulator(.clk50(clk), .*);
   Sprite_Controller sprite_controller(.clk(VGA_CLK), .*);

endmodule
