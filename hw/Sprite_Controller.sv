/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module SPRITE_CONTROLLER(input logic        clk,
	       input logic 	  reset,
               input logic [23:0] gl_array [19:0],
	       input logic [9:0] hcount, vcount,
	       input logic [2:0]  address,
	       output logic [7:0] RGB_R, RGB_G, RGB_B,
	       output logic 	  VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	       output logic 	  VGA_SYNC_n);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for type*/
   /* 20 sprite entry array */
   
   VGA_LED_Emulator led_emulator(.clk50(clk), .*);

   always_ff @(posedge clk)
     if (reset) begin
	/* Draw Background */
     end else
	x_coord <= writedata[19:10];
	y_coord <= writedata[9:0];
     end

endmodule

