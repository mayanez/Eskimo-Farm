/*
 * Top-level module for graphics processing.
 * Instantiates sprite ROM + Communicates with Avalon Bus
 */
module gfx_controller(input logic clk,
                      input logic reset,
                      input logic [23:0] gl_array [19:0],
                      output logic [7:0] VGA_R, VGA_G, VGA_B,
                      output logic       VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
                      output logic       VGA_SYNC_n);

wire [9:0] VGA_HCOUNT;
wire [9:0] VGA_VCOUNT;

wire [23:0] sprite_rom_data;

VGA_LED_Emulator led_emulator(.clk50(clk), .*);

/* Initialize sprite ROM */
sprite_rom sprite_rom(.clock(clk), .address(addr), .q(sprite_rom_data)) /* sample */

Sprite_Controller sprite_controller(.*);




endmodule