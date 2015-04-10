/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module SPRITE_CONTROLLER(  input logic clk,
                           input logic reset,
                           input logic [23:0] gl_array [19:0],
                           input logic sprite_rom_data,
                           input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
                           output logic [7:0] VGA_R, VGA_G, VGA_B);

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for type*/
   /* 20 sprite entry array */

   logic [23:0] line_buffer [639:0]; /*Make sure this is zeroed every time */


   always_ff @(VGA_VCOUNT)
    begin

        /* Assume gl_array has been decoded and every sprite has its own wire.*/
        if (VGA_VCOUNT >= y11 && VGA_VCOUNT <= y12) begin
          line_buffer[x1] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y21 && VGA_VCOUNT <= y22) begin
          line_buffer[x2] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y31 && VGA_VCOUNT <= y32) begin
          line_buffer[x3] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y41 && VGA_VCOUNT <= y42) begin
          line_buffer[x4] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y51 && VGA_VCOUNT <= y52) begin
          line_buffer[x5] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y61 && VGA_VCOUNT <= y62) begin
          line_buffer[x6] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y71 && VGA_VCOUNT <= y72) begin
          line_buffer[x7] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y81 && VGA_VCOUNT <= y82) begin
          line_buffer[x8] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y91 && VGA_VCOUNT <= y92) begin
          line_buffer[x9] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y101 && VGA_VCOUNT <= y102) begin
          line_buffer[x10] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y111 && VGA_VCOUNT <= y112) begin
          line_buffer[x11] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y121 && VGA_VCOUNT <= y122) begin
          line_buffer[x12] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y131 && VGA_VCOUNT <= y132) begin
          line_buffer[x13] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y141 && VGA_VCOUNT <= y142) begin
          line_buffer[x14] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y151 && VGA_VCOUNT <= y152) begin
          line_buffer[x15] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y161 && VGA_VCOUNT <= y162) begin
          line_buffer[x16] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y171 && VGA_VCOUNT <= y172) begin
          line_buffer[x17] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y181 && VGA_VCOUNT <= y182) begin
          line_buffer[x18] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y191 && VGA_VCOUNT <= y192) begin
          line_buffer[x19] <= 24'hff; /*Replace with ROM data */
        end
        else if (VGA_VCOUNT >= y201 && VGA_VCOUNT <= y202) begin
          line_buffer[x20] <= 24'hff; /*Replace with ROM data */
        end
    end

  /* For a given hcount(column) select bits for each color channel */
  assign VGA_R, VGA_G, VGA_B = {line_buffer[VGA_HCOUNT][23:16], line_buffer[VGA_HCOUNT][15:8], line_buffer[VGA_HCOUNT][7:0]};

endmodule

