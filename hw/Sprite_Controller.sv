/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 */

module Sprite_Controller(   input logic clk,
                            input logic reset,
                            input logic [31:0] sprite1, sprite2, sprite3,
                            input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
                            input logic [23:0] M_ship, M_pig, M_bee, 
                            output logic [9:0] addr_ship, addr_pig, addr_bee,
                            output logic [7:0] VGA_R, VGA_G, VGA_B);


    logic [23:0] line_buffer1 [639:0]; /* Read buffer */
    logic [23:0] line_buffer2 [639:0]; /* Prefetch */
    logic [23:0] M_buf;
    logic [9:0] addr_sprite1, addr_sprite2, addr_sprite3, addr_sprite4, addr_sprite5, addr_sprite6,
                addr_sprite7, addr_sprite8, addr_sprite9, addr_sprite10, addr_sprite11, addr_sprite12,
                addr_sprite13, addr_sprite14, addr_sprite15, addr_sprite16, addr_sprite17, addr_sprite18,
                addr_sprite19, addr_sprite20;
 
    logic buf_toggle;
    logic [9:0] x11, y11, x12, y12, x21, y21, x22, y22, x31, y31, x32, y32,
                x41, y41, x42, y42, x51, y51, x52, y52, x61, y61, x62, y62,
                x71, y71, x72, y72, x81, y81, x82, y82, x91, y91, x92, y92,
                x10_1, y10_1, x10_2, y10_2, x11_1, y11_1, x11_2, y11_2,
                x12_1, y12_1, x12_2, y12_2, x13_1, y13_1, x13_2, y13_2,
                x14_1, y14_1, x14_2, y14_2, x15_1, y15_1, x15_2, y15_2,
                x16_1, y16_1, x16_2, y16_2, x17_1, y17_1, x17_2, y17_2,
                x18_1, y18_1, x18_2, y18_2, x19_1, y19_1, x19_2, y19_2,
                x20_1, y20_1, x20_2, y20_2;

    logic [6:0] dim1, dim2, dim3, dim4, dim5, dim6, dim7, dim8, dim9, dim10, dim11, dim12, dim13, dim14,
                dim15, dim16, dim17, dim18, dim19, dim20;

    logic [4:0] id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, id14, id15, id16, id17,
                id18, id19, id20;
 
    /* Decode inputs */
    assign dim1 = sprite1[31:25];
    assign id1 = sprite1[24:20];
    assign x11 = sprite1[9:0];
    assign y11 = sprite1[19:10];
    assign x12 = x11 + dim1 - 1; /* -1 due to 0 indexing */
    assign y12 = y11 + dim1 - 1;

    assign dim2 = sprite2[31:25];
    assign id2 = sprite2[24:20];
    assign x21 = sprite2[9:0];
    assign y21 = sprite2[19:10];
    assign x22 = x21 + dim2 - 1;
    assign y22 = y21 + dim2 - 1;

    assign dim3 = sprite3[31:25];
    assign id3 = sprite3[24:20];
    assign x31 = sprite3[9:0];
    assign y31 = sprite3[19:10];
    assign x32 = x31 + dim3 - 1;
    assign y32 = y31 + dim3 - 1;

    assign dim3 = sprite3[31:25];
    assign id3 = sprite3[24:20];
    assign x31 = sprite3[9:0];
    assign y31 = sprite3[19:10];
    assign x32 = x31 + dim3 - 1;
    assign y32 = y31 + dim3 - 1;

    assign dim4 = sprite4[31:25];
    assign id4 = sprite4[24:20];
    assign x41 = sprite4[9:0];
    assign y41 = sprite4[19:0];
    assign x42 = x41 + dim4 - 1;
    assign y42 = y41 + dim4 - 1;

    assign dim5 = sprite5[31:25];
    assign id5 = sprite5[24:20];
    assign x51 = sprite5[9:0];
    assign y51 = sprite5[19:0];
    assign x52 = x51 + dim5 - 1;
    assign y52 = y51 + dim5 - 1;

    assign dim6 = sprite6[31:25];
    assign id6 = sprite6[24:20];
    assign x61 = sprite6[9:0];
    assign y61 = sprite6[19:0];
    assign x62 = x61 + dim6 - 1;
    assign y62 = y61 + dim6 - 1;

    assign dim7 = sprite7[31:25];
    assign id7 = sprite7[24:20];
    assign x71 = sprite7[9:0];
    assign y71 = sprite7[19:0];
    assign x72 = x71 + dim7 - 1;
    assign y72 = y71 + dim7 - 1;

    assign dim8 = sprite8[31:25];
    assign id8 = sprite8[24:20];
    assign x81 = sprite8[9:0];
    assign y81 = sprite8[19:0];
    assign x82 = x81 + dim8 - 1;
    assign y82 = y81 + dim8 - 1;

    assign dim9 = sprite9[31:25];
    assign id9 = sprite9[24:20];
    assign x91 = sprite9[9:0];
    assign y91 = sprite9[19:0];
    assign x92 = x91 + dim9 - 1;
    assign y92 = y91 + dim9 - 1;

    assign dim10 = sprite10[31:25];
    assign id10 = sprite10[24:20];
    assign x10_1 = sprite10[9:0];
    assign y10_1 = sprite10[19:0];
    assign x10_2 = x10_1 + dim10 - 1;
    assign y10_2 = y10_1 + dim10 - 1;

    assign dim11 = sprite11[31:25];
    assign id11 = sprite11[24:20];
    assign x11_1 = sprite11[9:0];
    assign y11_1 = sprite11[19:0];
    assign x11_2 = x11_1 + dim11 - 1;
    assign y11_2 = y11_1 + dim11 - 1;

    assign dim12 = sprite12[31:25];
    assign id12 = sprite12[24:20];
    assign x12_1 = sprite12[9:0];
    assign y12_1 = sprite12[19:0];
    assign x12_2 = x12_1 + dim12 - 1;
    assign y12_2 = y12_1 + dim12 - 1;

    assign dim13 = sprite13[31:25];
    assign id13 = sprite13[24:20];
    assign x13_1 = sprite13[9:0];
    assign y13_1 = sprite13[19:0];
    assign x13_2 = x13_1 + dim13 - 1;
    assign y13_2 = y13_1 + dim13 - 1;

    assign dim14 = sprite14[31:25];
    assign id14 = sprite14[24:20];
    assign x14_1 = sprite14[9:0];
    assign y14_1 = sprite14[19:0];
    assign x14_2 = x14_1 + dim14 - 1;
    assign y14_2 = y14_1 + dim14 - 1;

    assign dim15 = sprite15[31:25];
    assign id15 = sprite15[24:20];
    assign x15_1 = sprite15[9:0];
    assign y15_1 = sprite15[19:0];
    assign x15_2 = x15_1 + dim15 - 1;
    assign y15_2 = y15_1 + dim15 - 1;
    
    assign dim16 = sprite16[31:25];
    assign id16 = sprite16[24:20];
    assign x16_1 = sprite16[9:0];
    assign y16_1 = sprite16[19:0];
    assign x16_2 = x16_1 + dim16 - 1;
    assign y16_2 = y16_1 + dim16 - 1;
    
    assign dim17 = sprite17[31:25];
    assign id17 = sprite17[24:20];
    assign x17_1 = sprite17[9:0];
    assign y17_1 = sprite17[19:0];
    assign x17_2 = x17_1 + dim17 - 1;
    assign y17_2 = y17_1 + dim17 - 1;
    
    assign dim18 = sprite18[31:25];
    assign id18 = sprite18[24:20];
    assign x18_1 = sprite18[9:0];
    assign y18_1 = sprite18[19:0];
    assign x18_2 = x18_1 + dim18 - 1;
    assign y18_2 = y18_1 + dim18 - 1;
    
    assign dim19 = sprite19[31:25];
    assign id19 = sprite19[24:20];
    assign x19_1 = sprite19[9:0];
    assign y19_1 = sprite19[19:0];
    assign x19_2 = x19_1 + dim19 - 1;
    assign y19_2 = y19_1 + dim19 - 1;
    
    assign dim20 = sprite20[31:25];
    assign id20 = sprite20[24:20];
    assign x20_1 = sprite20[9:0];
    assign y20_1 = sprite20[19:0];
    assign x20_2 = x20_1 + dim20 - 1;
    assign y20_2 = y20_1 + dim20 - 1;
    /* END */
 
    /* Verify if sprite is in region */
    assign sprite1_on = (sprite1 > 0) ? VGA_VCOUNT >= y11 && VGA_VCOUNT <= y12 && VGA_HCOUNT >= x11 && VGA_HCOUNT <= x12 : 0;
    assign sprite2_on = (sprite2 > 0) ? VGA_VCOUNT >= y21 && VGA_VCOUNT <= y22 && VGA_HCOUNT >= x21 && VGA_HCOUNT <= x22 : 0;
    assign sprite3_on = (sprite3 > 0) ? VGA_VCOUNT >= y31 && VGA_VCOUNT <= y32 && VGA_HCOUNT >= x31 && VGA_HCOUNT <= x32 : 0;
    assign sprite4_on = (sprite4 > 0) ? VGA_VCOUNT >= y41 && VGA_VCOUNT <= y42 && VGA_HCOUNT >= x41 && VGA_HCOUNT <= x42;
    assign sprite5_on = (sprite5 > 0) ? VGA_VCOUNT >= y51 && VGA_VCOUNT <= y52 && VGA_HCOUNT >= x51 && VGA_HCOUNT <= x52;
    assign sprite6_on = (sprite6 > 0) ? VGA_VCOUNT >= y61 && VGA_VCOUNT <= y62 && VGA_HCOUNT >= x61 && VGA_HCOUNT <= x62;
    assign sprite7_on = (sprite7 > 0) ? VGA_VCOUNT >= y71 && VGA_VCOUNT <= y72 && VGA_HCOUNT >= x71 && VGA_HCOUNT <= x72;
    assign sprite8_on = (sprite8 > 0) ? VGA_VCOUNT >= y81 && VGA_VCOUNT <= y82 && VGA_HCOUNT >= x81 && VGA_HCOUNT <= x82;
    assign sprite9_on = (sprite9 > 0) ? VGA_VCOUNT >= y91 && VGA_VCOUNT <= y92 && VGA_HCOUNT >= x91 && VGA_HCOUNT <= x92;
    assign sprite10_on = (sprite10 > 0) ? VGA_VCOUNT >= y10_1 && VGA_VCOUNT <= y10_2 && VGA_HCOUNT >= x10_1 && VGA_HCOUNT <= x10_2;
    assign sprite11_on = (sprite11 > 0) ? VGA_VCOUNT >= y11_1 && VGA_VCOUNT <= y11_2 && VGA_HCOUNT >= x11_1 && VGA_HCOUNT <= x11_2;
    assign sprite12_on = (sprite12 > 0) ? VGA_VCOUNT >= y12_1 && VGA_VCOUNT <= y12_2 && VGA_HCOUNT >= x12_1 && VGA_HCOUNT <= x12_2;
    assign sprite13_on = (sprite13 > 0) ? VGA_VCOUNT >= y13_1 && VGA_VCOUNT <= y13_2 && VGA_HCOUNT >= x13_1 && VGA_HCOUNT <= x13_2;
    assign sprite14_on = (sprite14 > 0) ? VGA_VCOUNT >= y14_1 && VGA_VCOUNT <= y14_2 && VGA_HCOUNT >= x14_1 && VGA_HCOUNT <= x14_2;
    assign sprite15_on = (sprite15 > 0) ? VGA_VCOUNT >= y15_1 && VGA_VCOUNT <= y15_2 && VGA_HCOUNT >= x15_1 && VGA_HCOUNT <= x15_2;
    assign sprite16_on = (sprite16 > 0) ? VGA_VCOUNT >= y16_1 && VGA_VCOUNT <= y16_2 && VGA_HCOUNT >= x16_1 && VGA_HCOUNT <= x16_2;
    assign sprite17_on = (sprite17 > 0) ? VGA_VCOUNT >= y17_1 && VGA_VCOUNT <= y17_2 && VGA_HCOUNT >= x17_1 && VGA_HCOUNT <= x17_2;
    assign sprite18_on = (sprite18 > 0) ? VGA_VCOUNT >= y18_1 && VGA_VCOUNT <= y18_2 && VGA_HCOUNT >= x18_1 && VGA_HCOUNT <= x18_2;
    assign sprite19_on = (sprite19 > 0) ? VGA_VCOUNT >= y19_1 && VGA_VCOUNT <= y19_2 && VGA_HCOUNT >= x19_1 && VGA_HCOUNT <= x19_2;
    assign sprite20_on = (sprite20 > 0) ? VGA_VCOUNT >= y20_1 && VGA_VCOUNT <= y20_2 && VGA_HCOUNT >= x20_1 && VGA_HCOUNT <= x20_2;
    /* END */
 
    /* Calculate address offset for sprite */
    assign addr_sprite1 = (VGA_HCOUNT - x11) + ((VGA_VCOUNT + 1 - y11)*dim1);
    assign addr_sprite2 = (VGA_HCOUNT - x21) + ((VGA_VCOUNT + 1 - y21)*dim2);
    assign addr_sprite3 = (VGA_HCOUNT - x31) + ((VGA_VCOUNT + 1 - y31)*dim3);
    assign addr_sprite4 = (VGA_HCOUNT - x41) + ((VGA_VCOUNT + 1 - y41)*dim4);
    assign addr_sprite5 = (VGA_HCOUNT - x51) + ((VGA_VCOUNT + 1 - y51)*dim5);
    assign addr_sprite6 = (VGA_HCOUNT - x61) + ((VGA_VCOUNT + 1 - y61)*dim6);
    assign addr_sprite7 = (VGA_HCOUNT - x71) + ((VGA_VCOUNT + 1 - y71)*dim7);
    assign addr_sprite8 = (VGA_HCOUNT - x81) + ((VGA_VCOUNT + 1 - y81)*dim8);
    assign addr_sprite9 = (VGA_HCOUNT - x91) + ((VGA_VCOUNT + 1 - y91)*dim9);
    assign addr_sprite10 = (VGA_HCOUNT - x10_1) + ((VGA_VCOUNT + 1 - y10_1)*dim10);
    assign addr_sprite11 = (VGA_HCOUNT - x11_1) + ((VGA_VCOUNT + 1 - y11_1)*dim11);
    assign addr_sprite12 = (VGA_HCOUNT - x12_1) + ((VGA_VCOUNT + 1 - y12_1)*dim12);
    assign addr_sprite13 = (VGA_HCOUNT - x13_1) + ((VGA_VCOUNT + 1 - y13_1)*dim13);
    assign addr_sprite14 = (VGA_HCOUNT - x14_1) + ((VGA_VCOUNT + 1 - y14_1)*dim14);
    assign addr_sprite15 = (VGA_HCOUNT - x15_1) + ((VGA_VCOUNT + 1 - y15_1)*dim15);
    assign addr_sprite16 = (VGA_HCOUNT - x16_1) + ((VGA_VCOUNT + 1 - y16_1)*dim16);
    assign addr_sprite17 = (VGA_HCOUNT - x17_1) + ((VGA_VCOUNT + 1 - y17_1)*dim17);
    assign addr_sprite18 = (VGA_HCOUNT - x18_1) + ((VGA_VCOUNT + 1 - y18_1)*dim18);
    assign addr_sprite19 = (VGA_HCOUNT - x19_1) + ((VGA_VCOUNT + 1 - y19_1)*dim19);
    assign addr_sprite20 = (VGA_HCOUNT - x20_1) + ((VGA_VCOUNT + 1 - y20_1)*dim20);
    /* END */
 

    /* Given a sprite type and ON status, assign address to correct ROM */
    assign addr_ship    = (sprite1_on && id1 == 1) ? addr_sprite1 :
                          (sprite2_on && id2 == 1) ? addr_sprite2 : 
                          (sprite3_on && id3 == 1) ? addr_sprite3 : 0;
    assign addr_pig     = (sprite1_on && id1 == 5'd2) ? addr_sprite1 : 
                          (sprite2_on && id2 == 5'd2) ? addr_sprite2 : 
                          (sprite3_on && id3 == 5'd2) ? addr_sprite3 : 0;
    assign addr_bee     = (sprite1_on && id1 == 5'd3) ? addr_sprite1 : 
                          (sprite2_on && id2 == 5'd3) ? addr_sprite2 : 
                          (sprite3_on && id3 == 5'd3) ? addr_sprite3 : 0;
    /* END */
 
    /* Assign sprite to buffer */
    always@(*)
    begin
        if (sprite1_on && id1 == 1)          M_buf = M_ship;
        else if (sprite1_on && id1 == 5'd2)  M_buf = M_pig;
        else if (sprite1_on && id1 == 5'd3)  M_buf = M_bee;
        
        else if (sprite2_on && id2 == 1)     M_buf = M_ship;
        else if (sprite2_on && id2 == 5'd2)  M_buf = M_pig;
        else if (sprite2_on && id2 == 5'd3)  M_buf = M_bee;
        
        else if (sprite3_on && id3 == 1)     M_buf = M_ship;
        else if (sprite3_on && id3 == 5'd2)  M_buf = M_pig;
        else if (sprite3_on && id3 == 5'd3)  M_buf = M_bee;
        
        else                                 M_buf = 24'd4046075; /* Background color */
    end
    /* END */

    /* Toggle between line buffers */
    always_ff@(posedge VGA_VCOUNT[0])
        buf_toggle <= buf_toggle + 1;

    always_ff@(posedge clk)
    begin
        if(buf_toggle == 0) line_buffer1[VGA_HCOUNT] <= M_buf;
        else                line_buffer2[VGA_HCOUNT] <= M_buf;
    end
    /* END */

    /* Assign color output to VGA */
    assign VGA_R = (buf_toggle == 0) ? line_buffer2[VGA_HCOUNT][23:16] : line_buffer1[VGA_HCOUNT][23:16];
    assign VGA_G = (buf_toggle == 0) ? line_buffer2[VGA_HCOUNT][15:8] : line_buffer1[VGA_HCOUNT][15:8];
    assign VGA_B = (buf_toggle == 0) ? line_buffer2[VGA_HCOUNT][7:0] : line_buffer1[VGA_HCOUNT][7:0];
    /* END */

endmodule
