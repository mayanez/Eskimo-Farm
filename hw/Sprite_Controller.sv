/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module SPRITE_CONTROLLER(  input logic clk,
                           input logic reset,
                           input logic [23:0] gl_array [19:0],
                           input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
                           input logic [2:0]  address,
                           output logic [7:0] VGA_R, VGA_G, VGA_B,
                           output logic       VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
                           output logic       VGA_SYNC_n);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for type*/
   /* 20 sprite entry array */
   
   VGA_LED_Emulator led_emulator(.clk50(clk), .*);

   logic [23:0] line_buffer [639:0];

   
   always_ff @(VGA_VCOUNT)
    begin
        {VGA_R, VGA_G, VGA_B} = {8'hff, 8'h00, 8'h00}; // Red
    end

endmodule

