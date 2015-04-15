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
   
  always_ff@(posedge clk) begin
      if (write) begin
	   gl_array[0] <= gl_input[23:0];
      end
   end

   assign sprite1 = gl_array[0];


   logic [9:0] addr_sprite1;
   logic [23:0] M_ship;

   ship sm(.clock(VGA_CLK), .address(addr_sprite1), .q(M_ship));

   VGA_LED_Emulator led_emulator(.clk50(clk), .*);
   Sprite_Controller sprite_controller(.clk(VGA_CLK), .M_sprite1(M_ship), .*);

endmodule
