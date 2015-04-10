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

   /* At least 9 bits for 480 and at least 10 bits for 640 and 5bits for id*/
   /* 20 sprite entry array */

   logic [23:0] line_buffer [639:0]; /*Make sure this is zeroed every time */
   logic [23:0] sprite1,sprite2,sprite3,sprite4,sprite5,sprite6,sprite7,sprite8,sprite9,sprite10,sprite11,sprite12,sprite13,sprite14,sprite15,sprite16,sprite17,sprite18,sprite19,sprite20;
   logic [8:0] x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20;
   logic [9:0] y11,y12,y21,y22,y31,y32,y41,y42,y51,y52,y61,y62,y71,y72,y81,y82,y91,y92,y101,y102,y111,y112,y121,y122,y131,y132,y141,y142,y151,y152,y161,y162,y171,y172,y181,y182,y191,y192,y201,y202;
   logic [4:0] id1,id2,id3,id4,id5,id6,id7,id8,id9,id10,id11,id12,id13,id14,id15,id16,id17,id18,id19,id20;


   always_comb begin
     sprite1 = gl_array[0];
     x1 = sprite1[8:0];
     y11 = sprite1 [18:9];
     id1 = sprite1[23:19];
   
     case (id1)
        5'd1: y12 = 10'd639; /* Background */
        5'd2: y12 = y11 + ; /* Ship */
        5'd3: y12 = y11 + ; /* Enemy1 */
        5'd4: y12 = y11 + ; /* Enemy2 */
        5'd5: y12 = y11 + ; /* Enemy3 */
        5'd6: y12 = y11 + ; /* Enemy4 */
        5'd7: y12 = y11 + ; /* Enemy5 */
        5'd8: y12 = y11 + ; /* Score */
        5'd9: y12 = y11 + ; /* digit 0 */
        5'd10: y12 = y11 + ; /* digit 1 */
        5'd11: y12 = y11 + ; /* digit 2 */
        5'd12: y12 = y11 + ; /* digit 3 */
        5'd13: y12 = y11 + ; /* digit 4 */
        5'd14: y12 = y11 + ; /* digit 5 */
        5'd15: y12 = y11 + ; /* digit 6 */
        5'd16: y12 = y11 + ; /* digit 7 */
        5'd17: y12 = y11 + ; /* digit 8 */
        5'd18: y12 = y11 + ; /* digit 9 */
        5'd19: y12 = y11 + ; /* Health */
        5'd20: y12 = y11 + ; /* Eskimo */
     endcase
 end

  always_comb begin
     sprite2 = gl_array[1];
     x2 = sprite2[8:0];
     y21 = sprite2 [18:9];
     id2 = sprite2 [23:19];
   
     case (id2)
        5'd1: y22 = 10'd639; /* Background */
        5'd2: y22 = y21 + ; /* Ship */
        5'd3: y22 = y21 + ; /* Enemy1 */
        5'd4: y22 = y21 + ; /* Enemy2 */
        5'd5: y22 = y21 + ; /* Enemy3 */
        5'd6: y22 = y21 + ; /* Enemy4 */
        5'd7: y22 = y21 + ; /* Enemy5 */
        5'd8: y22 = y21 + ; /* Score */
        5'd9: y22 = y21 + ; /* digit 0 */
        5'd10: y22 = y21 + ; /* digit 1 */
        5'd11: y22 = y21 + ; /* digit 2 */
        5'd12: y22 = y21 + ; /* digit 3 */
        5'd13: y22 = y21 + ; /* digit 4 */
        5'd14: y22 = y21 + ; /* digit 5 */
        5'd15: y22 = y21 + ; /* digit 6 */
        5'd16: y22 = y21 + ; /* digit 7 */
        5'd17: y22 = y21 + ; /* digit 8 */
        5'd18: y22 = y21 + ; /* digit 9 */
        5'd19: y22 = y21 + ; /* Health */
        5'd20: y22 = y21 + ; /* Eskimo */
     endcase
  end

    always_comb begin
     sprite3 = gl_array[2];
     x3 = sprite3[8:0];
     y31 = sprite3 [18:9];
     id3 = sprite3 [23:19];
   
     case (id3)
        5'd1: y32 = 10'd639; /* Background */
        5'd2: y32 = y31 + ; /* Ship */
        5'd3: y32 = y31 + ; /* Enemy1 */
        5'd4: y32 = y31 + ; /* Enemy2 */
        5'd5: y32 = y31 + ; /* Enemy3 */
        5'd6: y32 = y31 + ; /* Enemy4 */
        5'd7: y32 = y31 + ; /* Enemy5 */
        5'd8: y32 = y31 + ; /* Score */
        5'd9: y32 = y31 + ; /* digit 0 */
        5'd10: y32 = y31 + ; /* digit 1 */
        5'd11: y32 = y31 + ; /* digit 2 */
        5'd12: y32 = y31 + ; /* digit 3 */
        5'd13: y32 = y31 + ; /* digit 4 */
        5'd14: y32 = y31 + ; /* digit 5 */
        5'd15: y32 = y31 + ; /* digit 6 */
        5'd16: y32 = y31 + ; /* digit 7 */
        5'd17: y32 = y31 + ; /* digit 8 */
        5'd18: y32 = y31 + ; /* digit 9 */
        5'd19: y32 = y31 + ; /* Health */
        5'd20: y32 = y31 + ; /* Eskimo */
     endcase
  end
  
  always_comb begin
     sprite4 = gl_array[3];
     x1 = sprite4[8:0];
     y41 = sprite4 [18:9];
     id4 = sprite4 [23:19];
   
     case (id4)
        5'd1: y42 = 10'd639; /* Background */
        5'd2: y42 = y41 + ; /* Ship */
        5'd3: y42 = y41 + ; /* Enemy1 */
        5'd4: y42 = y41 + ; /* Enemy2 */
        5'd5: y42 = y41 + ; /* Enemy3 */
        5'd6: y42 = y41 + ; /* Enemy4 */
        5'd7: y42 = y41 + ; /* Enemy5 */
        5'd8: y42 = y41 + ; /* Score */
        5'd9: y42 = y41 + ; /* digit 0 */
        5'd10: y42 = y41 + ; /* digit 1 */
        5'd11: y42 = y41 + ; /* digit 2 */
        5'd12: y42 = y41 + ; /* digit 3 */
        5'd13: y42 = y41 + ; /* digit 4 */
        5'd14: y42 = y41 + ; /* digit 5 */
        5'd15: y42 = y41 + ; /* digit 6 */
        5'd16: y42 = y41 + ; /* digit 7 */
        5'd17: y42 = y41 + ; /* digit 8 */
        5'd18: y42 = y41 + ; /* digit 9 */
        5'd19: y42 = y41 + ; /* Health */
        5'd20: y42 = y41 + ; /* Eskimo */
     endcase
     end

     always_comb begin
     sprite5 = gl_array[4];
     x5 = sprite5[8:0];
     y51 = sprite5 [18:9];
     id5 = sprite5 [23:19];
   
     case (id5)
        5'd1: y52 = 10'd639; /* Background */
        5'd2: y52 = y51 + ; /* Ship */
        5'd3: y52 = y51 + ; /* Enemy1 */
        5'd4: y52 = y51 + ; /* Enemy2 */
        5'd5: y52 = y51 + ; /* Enemy3 */
        5'd6: y52 = y51 + ; /* Enemy4 */
        5'd7: y52 = y51 + ; /* Enemy5 */
        5'd8: y52 = y51 + ; /* Score */
        5'd9: y52 = y51 + ; /* digit 0 */
        5'd10: y52 = y51 + ; /* digit 1 */
        5'd11: y52 = y51 + ; /* digit 2 */
        5'd12: y52 = y51 + ; /* digit 3 */
        5'd13: y52 = y51 + ; /* digit 4 */
        5'd14: y52 = y51 + ; /* digit 5 */
        5'd15: y52 = y51 + ; /* digit 6 */
        5'd16: y52 = y51 + ; /* digit 7 */
        5'd17: y52 = y51 + ; /* digit 8 */
        5'd18: y52 = y51 + ; /* digit 9 */
        5'd19: y52 = y51 + ; /* Health */
        5'd20: y52 = y51 + ; /* Eskimo */
     endcase
     end

     always_comb begin
     sprite6 = gl_array[5];
     x6 = sprite6[8:0];
     y61 = sprite6 [18:9];
     id6 = sprite6 [23:19];
   
     case (id6)
        5'd1: y32 = 10'd639; /* Background */
        5'd2: y62 = y61 + ; /* Ship */
        5'd3: y62 = y61 + ; /* Enemy1 */
        5'd4: y62 = y61 + ; /* Enemy2 */
        5'd5: y62 = y61 + ; /* Enemy3 */
        5'd6: y62 = y61 + ; /* Enemy4 */
        5'd7: y62 = y61 + ; /* Enemy5 */
        5'd8: y62 = y61 + ; /* Score */
        5'd9: y62 = y61 + ; /* digit 0 */
        5'd10: y62 = y61 + ; /* digit 1 */
        5'd11: y62 = y61 + ; /* digit 2 */
        5'd12: y62 = y61 + ; /* digit 3 */
        5'd13: y62 = y61 + ; /* digit 4 */
        5'd14: y62 = y61 + ; /* digit 5 */
        5'd15: y62 = y61 + ; /* digit 6 */
        5'd16: y62 = y61 + ; /* digit 7 */
        5'd17: y62 = y61 + ; /* digit 8 */
        5'd18: y62 = y61 + ; /* digit 9 */
        5'd19: y62 = y61 + ; /* Health */
        5'd20: y62 = y61 + ; /* Eskimo */
     endcase
     end
     
     always_comb begin
     sprite7 = gl_array[6];
     x7 = sprite7[8:0];
     y71 = sprite7 [18:9];
     id7 = sprite7 [23:19];
   
     case (id7)
        5'd1: y72 = 10'd639; /* Background */
        5'd2: y72 = y71 + ; /* Ship */
        5'd3: y72 = y71 + ; /* Enemy1 */
        5'd4: y72 = y71 + ; /* Enemy2 */
        5'd5: y72 = y71 + ; /* Enemy3 */
        5'd6: y72 = y71 + ; /* Enemy4 */
        5'd7: y72 = y71 + ; /* Enemy5 */
        5'd8: y72 = y71 + ; /* Score */
        5'd9: y72 = y71 + ; /* digit 0 */
        5'd10: y72 = y71 + ; /* digit 1 */
        5'd11: y72 = y71 + ; /* digit 2 */
        5'd12: y72 = y71 + ; /* digit 3 */
        5'd13: y72 = y71 + ; /* digit 4 */
        5'd14: y72 = y71 + ; /* digit 5 */
        5'd15: y72 = y71 + ; /* digit 6 */
        5'd16: y72 = y71 + ; /* digit 7 */
        5'd17: y72 = y71 + ; /* digit 8 */
        5'd18: y72 = y71 + ; /* digit 9 */
        5'd19: y72 = y71 + ; /* Health */
        5'd20: y72 = y71 + ; /* Eskimo */
     endcase
     end

    always_comb begin
     sprite8 = gl_array[7];
     x8 = sprite8[8:0];
     y81 = sprite8 [18:9];
     id8 = sprite8 [23:19];
   
     case (id8)
        5'd1: y82 = 10'd639; /* Background */
        5'd2: y82 = y81 + ; /* Ship */
        5'd3: y82 = y81 + ; /* Enemy1 */
        5'd4: y82 = y81 + ; /* Enemy2 */
        5'd5: y82 = y81 + ; /* Enemy3 */
        5'd6: y82 = y81 + ; /* Enemy4 */
        5'd7: y82 = y81 + ; /* Enemy5 */
        5'd8: y82 = y81 + ; /* Score */
        5'd9: y82 = y81 + ; /* digit 0 */
        5'd10: y82 = y81 + ; /* digit 1 */
        5'd11: y82 = y81 + ; /* digit 2 */
        5'd12: y82 = y81 + ; /* digit 3 */
        5'd13: y82 = y81 + ; /* digit 4 */
        5'd14: y82 = y81 + ; /* digit 5 */
        5'd15: y82 = y81 + ; /* digit 6 */
        5'd16: y82 = y81 + ; /* digit 7 */
        5'd17: y82 = y81 + ; /* digit 8 */
        5'd18: y82 = y81 + ; /* digit 9 */
        5'd19: y82 = y81 + ; /* Health */
        5'd20: y82 = y81 + ; /* Eskimo */
     endcase
     end

     always_comb begin
     sprite9 = gl_array[8];
     x9 = sprite9[8:0];
     y91 = sprite9[18:9];
     id9 = sprite9 [23:19];
   
     case (id9)
        5'd1: y92 = 10'd639; /* Background */
        5'd2: y92 = y91 + ; /* Ship */
        5'd3: y92 = y91 + ; /* Enemy1 */
        5'd4: y92 = y91 + ; /* Enemy2 */
        5'd5: y92 = y91 + ; /* Enemy3 */
        5'd6: y92 = y91 + ; /* Enemy4 */
        5'd7: y92 = y91 + ; /* Enemy5 */
        5'd8: y92 = y91 + ; /* Score */
        5'd9: y92 = y91 + ; /* digit 0 */
        5'd10: y92 = y91 + ; /* digit 1 */
        5'd11: y92 = y91 + ; /* digit 2 */
        5'd12: y92 = y91 + ; /* digit 3 */
        5'd13: y92 = y91 + ; /* digit 4 */
        5'd14: y92 = y91 + ; /* digit 5 */
        5'd15: y92 = y91 + ; /* digit 6 */
        5'd16: y92 = y91 + ; /* digit 7 */
        5'd17: y92 = y91 + ; /* digit 8 */
        5'd18: y92 = y91 + ; /* digit 9 */
        5'd19: y92 = y91 + ; /* Health */
        5'd20: y92 = y91 + ; /* Eskimo */
     endcase
     end

     always_comb begin
     sprite10 = gl_array[9];
     x10 = sprite10[8:0];
     y101 = sprite10 [18:9];
     id10 = sprite10 [23:19];
   
     case (id10)
        5'd1: y102 = 10'd639; /* Background */
        5'd2: y102 = y101 + ; /* Ship */
        5'd3: y102 = y101 + ; /* Enemy1 */
        5'd4: y102 = y101 + ; /* Enemy2 */
        5'd5: y102 = y101 + ; /* Enemy3 */
        5'd6: y102 = y101 + ; /* Enemy4 */
        5'd7: y102 = y101 + ; /* Enemy5 */
        5'd8: y102 = y101 + ; /* Score */
        5'd9: y102 = y101 + ; /* digit 0 */
        5'd10: y102 = y101 + ; /* digit 1 */
        5'd11: y102 = y101 + ; /* digit 2 */
        5'd12: y102 = y101 + ; /* digit 3 */
        5'd13: y102 = y101 + ; /* digit 4 */
        5'd14: y102 = y101 + ; /* digit 5 */
        5'd15: y102 = y101 + ; /* digit 6 */
        5'd16: y102 = y101 + ; /* digit 7 */
        5'd17: y102 = y101 + ; /* digit 8 */
        5'd18: y102 = y101 + ; /* digit 9 */
        5'd19: y102 = y101 + ; /* Health */
        5'd20: y102 = y101 + ; /* Eskimo */
     endcase
   end






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
