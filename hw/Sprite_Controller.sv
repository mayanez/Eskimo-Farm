/*
 * Avalon memory-mapped peripheral
 */

module Sprite_Controller(   input logic clk,
                            input logic reset,
                            input logic [31:0] sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, sprite9, sprite10,
                                               sprite11, sprite12, sprite13, sprite14, sprite15, sprite16, sprite17, sprite18, sprite19, sprite20,
                                               sprite21, sprite22, sprite23, sprite24, sprite25, sprite26, sprite27, sprite28, sprite29, sprite30,
                            input logic [9:0]  VGA_HCOUNT, VGA_VCOUNT,
                            input logic        VGA_HS,
                            input logic [11:0] M_ship, M_pig, M_bee, M_cow, M_mcdonald, M_bullet, M_zero, M_one, M_two, M_three, M_four, M_five, M_six, 
                                               M_seven, M_eight, M_nine, M_eskimo, M_cloud, M_title, M_goat, M_frog, M_chick, M_a, M_e, M_f, M_g, M_i, 
                                               M_k, M_m, M_n, M_o, M_p, M_r, M_s, M_u, M_v, M_w, M_t,
                            output logic [9:0] addr_ship, addr_pig, addr_bee, addr_cow, addr_bullet, /*addr_mcdonald,*/ addr_zero, addr_one, addr_two,
                                               addr_three, addr_four, addr_five, addr_six, addr_seven, addr_eight, addr_nine, addr_eskimo, addr_cloud, 
                                               addr_goat, addr_frog, addr_chick, addr_a, addr_e, addr_f, addr_g, addr_i, addr_k, addr_m, addr_n, addr_o,
                                               addr_p, addr_r, addr_s, addr_u, addr_v, addr_w, addr_t,
                            output logic [7:0] VGA_R, VGA_G, VGA_B);


    logic [11:0] line_buffer1 [639:0]; /* Read buffer */
    logic [11:0] line_buffer2 [639:0]; /* Prefetch */
    logic [11:0] M_buf;
    logic [9:0] addr_sprite1, addr_sprite2, addr_sprite3, addr_sprite4, addr_sprite5, addr_sprite6,
                addr_sprite7, addr_sprite8, addr_sprite9, addr_sprite10, addr_sprite11, addr_sprite12,
                addr_sprite13, addr_sprite14, addr_sprite15, addr_sprite16, addr_sprite17, addr_sprite18,
                addr_sprite19, addr_sprite20, addr_sprite21, addr_sprite22, addr_sprite23, addr_sprite24,
                addr_sprite25, addr_sprite26, addr_sprite27, addr_sprite28, addr_sprite29, addr_sprite30, addr_buf;
                
 
    logic buf_toggle, grass_on, sprite1_on, sprite2_on, sprite3_on, sprite4_on, sprite5_on, sprite6_on, sprite7_on,
          sprite8_on, sprite9_on, sprite10_on, sprite11_on, sprite12_on, sprite13_on, sprite14_on, sprite15_on, sprite16_on,
          sprite17_on, sprite18_on, sprite19_on, sprite20_on, sprite21_on, sprite22_on, sprite23_on, sprite24_on, sprite25_on,
          sprite26_on, sprite27_on, sprite28_on, sprite29_on, sprite30_on;
          
    logic [9:0] x11, y11, x12, y12, x21, y21, x22, y22, x31, y31, x32, y32,
                x41, y41, x42, y42, x51, y51, x52, y52, x61, y61, x62, y62,
                x71, y71, x72, y72, x81, y81, x82, y82, x91, y91, x92, y92,
                x10_1, y10_1, x10_2, y10_2, x11_1, y11_1, x11_2, y11_2,
                x12_1, y12_1, x12_2, y12_2, x13_1, y13_1, x13_2, y13_2,
                x14_1, y14_1, x14_2, y14_2, x15_1, y15_1, x15_2, y15_2,
                x16_1, y16_1, x16_2, y16_2, x17_1, y17_1, x17_2, y17_2,
                x18_1, y18_1, x18_2, y18_2, x19_1, y19_1, x19_2, y19_2,
                x20_1, y20_1, x20_2, y20_2, x21_1, y21_1, x21_2, y21_2,
                x22_1, y22_1, x22_2, y22_2, x23_1, y23_1, x23_2, y23_2,
                x24_1, y24_1, x24_2, y24_2, x25_1, y25_1, x25_2, y25_2,
                x26_1, y26_1, x26_2, y26_2, x27_1, y27_1, x27_2, y27_2,
                x28_1, y28_1, x28_2, y28_2, x29_1, y29_1, x29_2, y29_2,
                x30_1, y30_1, x30_2, y30_2;
                
    logic [9:0] grass_x, grass_y;

    logic [5:0] dim1, dim2, dim3, dim4, dim5, dim6, dim7, dim8, dim9, dim10, dim11, dim12, dim13, dim14,
                dim15, dim16, dim17, dim18, dim19, dim20, dim21, dim22, dim23, dim24, dim25, dim26,
                dim27, dim28, dim29, dim30, dim_grass;

    logic [5:0] id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, id14, id15, id16, id17,
                id18, id19, id20, id21, id22, id23, id24, id25, id26, id27, id28, id29, id30, id_temp, id_buf;
 
    /* Decode inputs */
    assign dim1 = sprite1[31:26];
    assign id1 = sprite1[25:20];
    assign x11 = sprite1[9:0];
    assign y11 = sprite1[19:10];
    assign x12 = x11 + dim1 - 1; /* -1 due to 0 indexing */
    assign y12 = y11 + dim1 - 1;

    assign dim2 = sprite2[31:26];
    assign id2 = sprite2[25:20];
    assign x21 = sprite2[9:0];
    assign y21 = sprite2[19:10];
    assign x22 = x21 + dim2 - 1;
    assign y22 = y21 + dim2 - 1;

    assign dim3 = sprite3[31:26];
    assign id3 = sprite3[25:20];
    assign x31 = sprite3[9:0];
    assign y31 = sprite3[19:10];
    assign x32 = x31 + dim3 - 1;
    assign y32 = y31 + dim3 - 1;

    assign dim4 = sprite4[31:26];
    assign id4 = sprite4[25:20];
    assign x41 = sprite4[9:0];
    assign y41 = sprite4[19:10];
    assign x42 = x41 + dim4 - 1;
    assign y42 = y41 + dim4 - 1;

    assign dim5 = sprite5[31:26];
    assign id5 = sprite5[25:20];
    assign x51 = sprite5[9:0];
    assign y51 = sprite5[19:10];
    assign x52 = x51 + dim5 - 1;
    assign y52 = y51 + dim5 - 1;

    assign dim6 = sprite6[31:26];
    assign id6 = sprite6[25:20];
    assign x61 = sprite6[9:0];
    assign y61 = sprite6[19:10];
    assign x62 = x61 + dim6 - 1;
    assign y62 = y61 + dim6 - 1;

    assign dim7 = sprite7[31:26];
    assign id7 = sprite7[25:20];
    assign x71 = sprite7[9:0];
    assign y71 = sprite7[19:10];
    assign x72 = x71 + dim7 - 1;
    assign y72 = y71 + dim7 - 1;

    assign dim8 = sprite8[31:26];
    assign id8 = sprite8[25:20];
    assign x81 = sprite8[9:0];
    assign y81 = sprite8[19:10];
    assign x82 = x81 + dim8 - 1;
    assign y82 = y81 + dim8 - 1;

    assign dim9 = sprite9[31:26];
    assign id9 = sprite9[25:20];
    assign x91 = sprite9[9:0];
    assign y91 = sprite9[19:10];
    assign x92 = x91 + dim9 - 1;
    assign y92 = y91 + dim9 - 1;

    assign dim10 = sprite10[31:26];
    assign id10 = sprite10[25:20];
    assign x10_1 = sprite10[9:0];
    assign y10_1 = sprite10[19:10];
    assign x10_2 = x10_1 + dim10 - 1;
    assign y10_2 = y10_1 + dim10 - 1;

    assign dim11 = sprite11[31:26];
    assign id11 = sprite11[25:20];
    assign x11_1 = sprite11[9:0];
    assign y11_1 = sprite11[19:10];
    assign x11_2 = x11_1 + dim11 - 1;
    assign y11_2 = y11_1 + dim11 - 1;

    assign dim12 = sprite12[31:26];
    assign id12 = sprite12[25:20];
    assign x12_1 = sprite12[9:0];
    assign y12_1 = sprite12[19:10];
    assign x12_2 = x12_1 + dim12 - 1;
    assign y12_2 = y12_1 + dim12 - 1;

    assign dim13 = sprite13[31:26];
    assign id13 = sprite13[25:20];
    assign x13_1 = sprite13[9:0];
    assign y13_1 = sprite13[19:10];
    assign x13_2 = x13_1 + dim13 - 1;
    assign y13_2 = y13_1 + dim13 - 1;

    assign dim14 = sprite14[31:26];
    assign id14 = sprite14[25:20];
    assign x14_1 = sprite14[9:0];
    assign y14_1 = sprite14[19:10];
    assign x14_2 = x14_1 + dim14 - 1;
    assign y14_2 = y14_1 + dim14 - 1;

    assign dim15 = sprite15[31:26];
    assign id15 = sprite15[25:20];
    assign x15_1 = sprite15[9:0];
    assign y15_1 = sprite15[19:10];
    assign x15_2 = x15_1 + dim15 - 1;
    assign y15_2 = y15_1 + dim15 - 1;
    
    assign dim16 = sprite16[31:26];
    assign id16 = sprite16[25:20];
    assign x16_1 = sprite16[9:0];
    assign y16_1 = sprite16[19:10];
    assign x16_2 = x16_1 + dim16 - 1;
    assign y16_2 = y16_1 + dim16 - 1;
    
    assign dim17 = sprite17[31:26];
    assign id17 = sprite17[25:20];
    assign x17_1 = sprite17[9:0];
    assign y17_1 = sprite17[19:10];
    assign x17_2 = x17_1 + dim17 - 1;
    assign y17_2 = y17_1 + dim17 - 1;
    
    assign dim18 = sprite18[31:26];
    assign id18 = sprite18[25:20];
    assign x18_1 = sprite18[9:0];
    assign y18_1 = sprite18[19:10];
    assign x18_2 = x18_1 + dim18 - 1;
    assign y18_2 = y18_1 + dim18 - 1;
    
    assign dim19 = sprite19[31:26];
    assign id19 = sprite19[25:20];
    assign x19_1 = sprite19[9:0];
    assign y19_1 = sprite19[19:10];
    assign x19_2 = x19_1 + dim19 - 1;
    assign y19_2 = y19_1 + dim19 - 1;
    
    assign dim20 = sprite20[31:26];
    assign id20 = sprite20[25:20];
    assign x20_1 = sprite20[9:0];
    assign y20_1 = sprite20[19:10];
    assign x20_2 = x20_1 + dim20 - 1;
    assign y20_2 = y20_1 + dim20 - 1;
    
    assign dim21 = sprite21[31:26];
    assign id21 = sprite21[25:20];
    assign x21_1 = sprite21[9:0];
    assign y21_1 = sprite21[19:10];
    assign x21_2 = x21_1 + dim21 - 1;
    assign y21_2 = y21_1 + dim21 - 1;
    
    assign dim22 = sprite22[31:26];
    assign id22 = sprite22[25:20];
    assign x22_1 = sprite22[9:0];
    assign y22_1 = sprite22[19:10];
    assign x22_2 = x22_1 + dim22 - 1;
    assign y22_2 = y22_1 + dim22 - 1;
    
    assign dim23 = sprite23[31:26];
    assign id23 = sprite23[25:20];
    assign x23_1 = sprite23[9:0];
    assign y23_1 = sprite23[19:10];
    assign x23_2 = x23_1 + dim23 - 1;
    assign y23_2 = y23_1 + dim23 - 1;
    
    assign dim24 = sprite24[31:26];
    assign id24 = sprite24[25:20];
    assign x24_1 = sprite24[9:0];
    assign y24_1 = sprite24[19:10];
    assign x24_2 = x24_1 + dim24 - 1;
    assign y24_2 = y24_1 + dim24 - 1;
    
    assign dim25 = sprite25[31:26];
    assign id25 = sprite25[25:20];
    assign x25_1 = sprite25[9:0];
    assign y25_1 = sprite25[19:10];
    assign x25_2 = x25_1 + dim25 - 1;
    assign y25_2 = y25_1 + dim25 - 1;
    
    assign dim26 = sprite26[31:26];
    assign id26 = sprite26[25:20];
    assign x26_1 = sprite26[9:0];
    assign y26_1 = sprite26[19:10];
    assign x26_2 = x26_1 + dim26 - 1;
    assign y26_2 = y26_1 + dim26 - 1;
    
    assign dim27 = sprite27[31:26];
    assign id27 = sprite27[25:20];
    assign x27_1 = sprite27[9:0];
    assign y27_1 = sprite27[19:10];
    assign x27_2 = x27_1 + dim27 - 1;
    assign y27_2 = y27_1 + dim27 - 1;
    
    assign dim28 = sprite28[31:26];
    assign id28 = sprite28[25:20];
    assign x28_1 = sprite28[9:0];
    assign y28_1 = sprite28[19:10];
    assign x28_2 = x28_1 + dim28 - 1;
    assign y28_2 = y28_1 + dim28 - 1;
    
    assign dim29 = sprite29[31:26];
    assign id29 = sprite29[25:20];
    assign x29_1 = sprite29[9:0];
    assign y29_1 = sprite29[19:10];
    assign x29_2 = x29_1 + dim29 - 1;
    assign y29_2 = y29_1 + dim29 - 1;
    
    assign dim30 = sprite30[31:26];
    assign id30 = sprite30[25:20];
    assign x30_1 = sprite30[9:0];
    assign y30_1 = sprite30[19:10];
    assign x30_2 = x30_1 + dim30 - 1;
    assign y30_2 = y30_1 + dim30 - 1;
    
    assign dim_grass = 6'd32;
    assign grass_y = 10'd448;
    
    /* END */
 
    /* Verify if sprite is in region */
    assign sprite1_on = (sprite1 > 0) ? VGA_VCOUNT >= y11 && VGA_VCOUNT <= y12 && VGA_HCOUNT >= x11 && VGA_HCOUNT <= x12 : 0;
    assign sprite2_on = (sprite2 > 0) ? VGA_VCOUNT >= y21 && VGA_VCOUNT <= y22 && VGA_HCOUNT >= x21 && VGA_HCOUNT <= x22 : 0;
    assign sprite3_on = (sprite3 > 0) ? VGA_VCOUNT >= y31 && VGA_VCOUNT <= y32 && VGA_HCOUNT >= x31 && VGA_HCOUNT <= x32 : 0;
    assign sprite4_on = (sprite4 > 0) ? VGA_VCOUNT >= y41 && VGA_VCOUNT <= y42 && VGA_HCOUNT >= x41 && VGA_HCOUNT <= x42 : 0;
    assign sprite5_on = (sprite5 > 0) ? VGA_VCOUNT >= y51 && VGA_VCOUNT <= y52 && VGA_HCOUNT >= x51 && VGA_HCOUNT <= x52 : 0;
    assign sprite6_on = (sprite6 > 0) ? VGA_VCOUNT >= y61 && VGA_VCOUNT <= y62 && VGA_HCOUNT >= x61 && VGA_HCOUNT <= x62 : 0;
    assign sprite7_on = (sprite7 > 0) ? VGA_VCOUNT >= y71 && VGA_VCOUNT <= y72 && VGA_HCOUNT >= x71 && VGA_HCOUNT <= x72 : 0;
    assign sprite8_on = (sprite8 > 0) ? VGA_VCOUNT >= y81 && VGA_VCOUNT <= y82 && VGA_HCOUNT >= x81 && VGA_HCOUNT <= x82 : 0;
    assign sprite9_on = (sprite9 > 0) ? VGA_VCOUNT >= y91 && VGA_VCOUNT <= y92 && VGA_HCOUNT >= x91 && VGA_HCOUNT <= x92 : 0;
    assign sprite10_on = (sprite10 > 0) ? VGA_VCOUNT >= y10_1 && VGA_VCOUNT <= y10_2 && VGA_HCOUNT >= x10_1 && VGA_HCOUNT <= x10_2 : 0;
    assign sprite11_on = (sprite11 > 0) ? VGA_VCOUNT >= y11_1 && VGA_VCOUNT <= y11_2 && VGA_HCOUNT >= x11_1 && VGA_HCOUNT <= x11_2 : 0;
    assign sprite12_on = (sprite12 > 0) ? VGA_VCOUNT >= y12_1 && VGA_VCOUNT <= y12_2 && VGA_HCOUNT >= x12_1 && VGA_HCOUNT <= x12_2 : 0;
    assign sprite13_on = (sprite13 > 0) ? VGA_VCOUNT >= y13_1 && VGA_VCOUNT <= y13_2 && VGA_HCOUNT >= x13_1 && VGA_HCOUNT <= x13_2 : 0;
    assign sprite14_on = (sprite14 > 0) ? VGA_VCOUNT >= y14_1 && VGA_VCOUNT <= y14_2 && VGA_HCOUNT >= x14_1 && VGA_HCOUNT <= x14_2 : 0;
    assign sprite15_on = (sprite15 > 0) ? VGA_VCOUNT >= y15_1 && VGA_VCOUNT <= y15_2 && VGA_HCOUNT >= x15_1 && VGA_HCOUNT <= x15_2 : 0;
    assign sprite16_on = (sprite16 > 0) ? VGA_VCOUNT >= y16_1 && VGA_VCOUNT <= y16_2 && VGA_HCOUNT >= x16_1 && VGA_HCOUNT <= x16_2 : 0;
    assign sprite17_on = (sprite17 > 0) ? VGA_VCOUNT >= y17_1 && VGA_VCOUNT <= y17_2 && VGA_HCOUNT >= x17_1 && VGA_HCOUNT <= x17_2 : 0;
    assign sprite18_on = (sprite18 > 0) ? VGA_VCOUNT >= y18_1 && VGA_VCOUNT <= y18_2 && VGA_HCOUNT >= x18_1 && VGA_HCOUNT <= x18_2 : 0;
    assign sprite19_on = (sprite19 > 0) ? VGA_VCOUNT >= y19_1 && VGA_VCOUNT <= y19_2 && VGA_HCOUNT >= x19_1 && VGA_HCOUNT <= x19_2 : 0;
    assign sprite20_on = (sprite20 > 0) ? VGA_VCOUNT >= y20_1 && VGA_VCOUNT <= y20_2 && VGA_HCOUNT >= x20_1 && VGA_HCOUNT <= x20_2 : 0;
    assign sprite21_on = (sprite21 > 0) ? VGA_VCOUNT >= y21_1 && VGA_VCOUNT <= y21_2 && VGA_HCOUNT >= x21_1 && VGA_HCOUNT <= x21_2 : 0;
    assign sprite22_on = (sprite22 > 0) ? VGA_VCOUNT >= y22_1 && VGA_VCOUNT <= y22_2 && VGA_HCOUNT >= x22_1 && VGA_HCOUNT <= x22_2 : 0;
    assign sprite23_on = (sprite23 > 0) ? VGA_VCOUNT >= y23_1 && VGA_VCOUNT <= y23_2 && VGA_HCOUNT >= x23_1 && VGA_HCOUNT <= x23_2 : 0;
    assign sprite24_on = (sprite24 > 0) ? VGA_VCOUNT >= y24_1 && VGA_VCOUNT <= y24_2 && VGA_HCOUNT >= x24_1 && VGA_HCOUNT <= x24_2 : 0;
    assign sprite25_on = (sprite25 > 0) ? VGA_VCOUNT >= y25_1 && VGA_VCOUNT <= y25_2 && VGA_HCOUNT >= x25_1 && VGA_HCOUNT <= x25_2 : 0;
    assign sprite26_on = (sprite26 > 0) ? VGA_VCOUNT >= y26_1 && VGA_VCOUNT <= y26_2 && VGA_HCOUNT >= x26_1 && VGA_HCOUNT <= x26_2 : 0;
    assign sprite27_on = (sprite27 > 0) ? VGA_VCOUNT >= y27_1 && VGA_VCOUNT <= y27_2 && VGA_HCOUNT >= x27_1 && VGA_HCOUNT <= x27_2 : 0;
    assign sprite28_on = (sprite28 > 0) ? VGA_VCOUNT >= y28_1 && VGA_VCOUNT <= y28_2 && VGA_HCOUNT >= x28_1 && VGA_HCOUNT <= x28_2 : 0;
    assign sprite29_on = (sprite29 > 0) ? VGA_VCOUNT >= y29_1 && VGA_VCOUNT <= y29_2 && VGA_HCOUNT >= x29_1 && VGA_HCOUNT <= x29_2 : 0;
    assign sprite30_on = (sprite30 > 0) ? VGA_VCOUNT >= y30_1 && VGA_VCOUNT <= y30_2 && VGA_HCOUNT >= x30_1 && VGA_HCOUNT <= x30_2 : 0;
    
    assign grass_on = VGA_VCOUNT >= grass_y;
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
    assign addr_sprite21 = (VGA_HCOUNT - x21_1) + ((VGA_VCOUNT + 1 - y21_1)*dim21);
    assign addr_sprite22 = (VGA_HCOUNT - x22_1) + ((VGA_VCOUNT + 1 - y22_1)*dim22);
    assign addr_sprite23 = (VGA_HCOUNT - x23_1) + ((VGA_VCOUNT + 1 - y23_1)*dim23);
    assign addr_sprite24 = (VGA_HCOUNT - x24_1) + ((VGA_VCOUNT + 1 - y24_1)*dim24);
    assign addr_sprite25 = (VGA_HCOUNT - x25_1) + ((VGA_VCOUNT + 1 - y25_1)*dim25);
    assign addr_sprite26 = (VGA_HCOUNT - x26_1) + ((VGA_VCOUNT + 1 - y26_1)*dim26);
    assign addr_sprite27 = (VGA_HCOUNT - x27_1) + ((VGA_VCOUNT + 1 - y27_1)*dim27);
    assign addr_sprite28 = (VGA_HCOUNT - x28_1) + ((VGA_VCOUNT + 1 - y28_1)*dim28);
    assign addr_sprite29 = (VGA_HCOUNT - x29_1) + ((VGA_VCOUNT + 1 - y29_1)*dim29);
    assign addr_sprite30 = (VGA_HCOUNT - x30_1) + ((VGA_VCOUNT + 1 - y30_1)*dim30);
    /* END */
 

    /* Given a sprite type and ON status, assign address to correct ROM */
    always@(*) begin
        if (sprite1_on) addr_buf = addr_sprite1;
        else if (sprite2_on) addr_buf = addr_sprite2;
        
        else if (sprite3_on) addr_buf = addr_sprite3;
        else if (sprite4_on) addr_buf = addr_sprite4;
        else if (sprite5_on) addr_buf = addr_sprite5;
        else if (sprite6_on) addr_buf = addr_sprite6;
        else if (sprite7_on) addr_buf = addr_sprite7;
        else if (sprite8_on) addr_buf = addr_sprite8;
        else if (sprite9_on) addr_buf = addr_sprite9;
        else if (sprite10_on) addr_buf = addr_sprite10;
        else if (sprite11_on) addr_buf = addr_sprite11;
        else if (sprite12_on) addr_buf = addr_sprite12;
        else if (sprite13_on) addr_buf = addr_sprite13;
        else if (sprite14_on) addr_buf = addr_sprite14;
        else if (sprite15_on) addr_buf = addr_sprite15;
        else if (sprite16_on) addr_buf = addr_sprite16;
        else if (sprite17_on) addr_buf = addr_sprite17;
        else if (sprite18_on) addr_buf = addr_sprite18;
        else if (sprite19_on) addr_buf = addr_sprite19;
        else if (sprite20_on) addr_buf = addr_sprite20;
        else if (sprite21_on) addr_buf = addr_sprite21;
        else if (sprite22_on) addr_buf = addr_sprite22;
        else if (sprite23_on) addr_buf = addr_sprite23;
        else if (sprite24_on) addr_buf = addr_sprite24;
        else if (sprite25_on) addr_buf = addr_sprite25;
        else if (sprite26_on) addr_buf = addr_sprite26;
        else if (sprite27_on) addr_buf = addr_sprite27;
        else if (sprite28_on) addr_buf = addr_sprite28;
        else if (sprite29_on) addr_buf = addr_sprite29;
        else if (sprite30_on) addr_buf = addr_sprite30;
        else addr_buf = 0;
    end

    assign id_buf = (sprite1_on) ? id1 : 
                    (sprite2_on) ? id2 : 
                    (sprite3_on) ? id3 : 
                    (sprite4_on) ? id4 : 
                    (sprite5_on) ? id5 : 
                    (sprite6_on) ? id6 :
                    (sprite7_on) ? id7 : 
                    (sprite8_on) ? id8 : 
                    (sprite9_on) ? id9 : 
                    (sprite10_on) ? id10 : 
                    (sprite11_on) ? id11 : 
                    sprite12_on ? id12 :
                    (sprite13_on) ? id13 : 
                    sprite14_on ? id14 : 
                    sprite15_on ? id15 : 
                    sprite16_on ? id16 : 
                    sprite17_on ? id17 : 
                    sprite18_on ? id18 :
                    sprite19_on ? id19 : 
                    sprite20_on ? id20 : 
                    sprite21_on ? id21 : 
                    sprite22_on ? id22 : 
                    sprite23_on ? id23 :
                    sprite24_on ? id24 :
                    sprite25_on ? id25 : 
                    sprite26_on ? id26 : 
                    sprite27_on ? id27 : 
                    sprite28_on ? id28 : 
                    sprite29_on ? id29 : 
                    sprite30_on ? id30 : 
                    grass_on    ? 6'd60: 0;
    
    assign addr_ship = (id_buf == 6'd1) ? addr_buf : 0;
    assign addr_pig = (id_buf == 6'd2) ? addr_buf : 0;
    assign addr_bee = (id_buf == 6'd3) ? addr_buf : 0;
    assign addr_cow = (id_buf == 6'd4) ? addr_buf : 0;
    assign addr_bullet = (id_buf == 6'd5) ? addr_buf : 0;
    assign addr_zero = (id_buf == 6'd6) ? addr_buf : 0;
    assign addr_one = (id_buf == 6'd7) ? addr_buf : 0;
    assign addr_two = (id_buf == 6'd8) ? addr_buf : 0;
    assign addr_three = (id_buf == 6'd9) ? addr_buf : 0;
    assign addr_four = (id_buf == 6'd10) ? addr_buf : 0;
    assign addr_five = (id_buf == 6'd11) ? addr_buf : 0;
    assign addr_six = (id_buf == 6'd12) ? addr_buf : 0;
    assign addr_seven = (id_buf == 6'd13) ? addr_buf : 0;
    assign addr_eight = (id_buf == 6'd14) ? addr_buf : 0;
    assign addr_nine = (id_buf == 6'd15) ? addr_buf : 0;
    assign addr_eskimo = (id_buf == 6'd18) ? addr_buf : 0;
    assign addr_cloud = (id_buf == 6'd19) ? addr_buf : 0;
    assign addr_goat = (id_buf == 6'd20) ? addr_buf : 0;
    assign addr_frog = (id_buf == 6'd21) ? addr_buf : 0;
    assign addr_chick = (id_buf == 6'd22) ? addr_buf : 0;
    assign addr_a = (id_buf == 6'd23) ? addr_buf : 0;
    assign addr_e = (id_buf == 6'd24) ? addr_buf : 0;
    assign addr_f = (id_buf == 6'd25) ? addr_buf : 0;
    assign addr_g = (id_buf == 6'd26) ? addr_buf : 0;
    assign addr_i = (id_buf == 6'd27) ? addr_buf : 0;
    assign addr_k = (id_buf == 6'd28) ? addr_buf : 0;
    assign addr_m = (id_buf == 6'd29) ? addr_buf : 0;
    assign addr_n = (id_buf == 6'd30) ? addr_buf : 0;
    assign addr_o = (id_buf == 6'd31) ? addr_buf : 0;
    assign addr_p = (id_buf == 6'd32) ? addr_buf : 0;
    assign addr_r = (id_buf == 6'd33) ? addr_buf : 0;
    assign addr_s = (id_buf == 6'd34) ? addr_buf : 0;
    assign addr_u = (id_buf == 6'd35) ? addr_buf : 0;
    assign addr_v = (id_buf == 6'd36) ? addr_buf : 0;
    assign addr_w = (id_buf == 6'd37) ? addr_buf : 0;
    assign addr_t = (id_buf == 6'd38) ? addr_buf : 0;
    
    always@(*) begin
        if (id_buf == 6'd1) M_buf = M_ship;
        else if (id_buf == 6'd2) M_buf = M_pig;
        else if (id_buf == 6'd3) M_buf = M_bee; 
        else if (id_buf == 6'd4) M_buf = M_cow ;
        else if (id_buf == 6'd5) M_buf = M_bullet;
        else if (id_buf == 6'd6) M_buf = M_zero;
        else if (id_buf == 6'd7) M_buf = M_one ;
        else if (id_buf == 6'd8) M_buf = M_two ;
        else if (id_buf == 6'd9) M_buf = M_three;
        else if (id_buf == 6'd10) M_buf = M_four  ;
        else if (id_buf == 6'd11) M_buf = M_five  ;
        else if (id_buf == 6'd12) M_buf = M_six   ;
        else if (id_buf == 6'd13) M_buf = M_seven ;
        else if (id_buf == 6'd14) M_buf = M_eight ;
        else if (id_buf == 6'd15) M_buf = M_nine  ;
        else if (id_buf == 6'd18) M_buf = M_eskimo;
        else if (id_buf == 6'd19) M_buf = M_cloud ;
        else if (id_buf == 6'd20) M_buf = M_goat  ;
        else if (id_buf == 6'd21) M_buf = M_frog  ;
        else if (id_buf == 6'd22) M_buf = M_chick ;
        else if (id_buf == 6'd23) M_buf = M_a;
        else if (id_buf == 6'd24) M_buf = M_e;
        else if (id_buf == 6'd25) M_buf = M_f;
        else if (id_buf == 6'd26) M_buf = M_g;
        else if (id_buf == 6'd27) M_buf = M_i;
        else if (id_buf == 6'd28) M_buf = M_k;
        else if (id_buf == 6'd29) M_buf = M_m;
        else if (id_buf == 6'd30) M_buf = M_n;
        else if (id_buf == 6'd31) M_buf = M_o;
        else if (id_buf == 6'd32) M_buf = M_p;
        else if (id_buf == 6'd33) M_buf = M_r;
        else if (id_buf == 6'd34) M_buf = M_s;
        else if (id_buf == 6'd35) M_buf = M_u;
        else if (id_buf == 6'd36) M_buf = M_v;
        else if (id_buf == 6'd37) M_buf = M_w;
        else if (id_buf == 6'd38) M_buf = M_t;
        else if (id_buf == 6'd60) M_buf = 12'd448; /* Grass */
        else    M_buf = 12'd1231;
    end
    
    /* END */
  
    /* Toggle between line buffers */
    always_ff@(posedge VGA_HS)
        buf_toggle <= buf_toggle + 1;

    always_ff@(posedge clk)
    begin
        if(buf_toggle == 0) line_buffer1[VGA_HCOUNT] <= M_buf;
        else                line_buffer2[VGA_HCOUNT] <= M_buf;
    end
    /* END */

    /* Assign color output to VGA */
    assign VGA_R = (buf_toggle == 0) ? {line_buffer2[VGA_HCOUNT][11:8], line_buffer2[VGA_HCOUNT][11:8]} : {line_buffer1[VGA_HCOUNT][11:8], line_buffer1[VGA_HCOUNT][11:8]} ;
    assign VGA_G = (buf_toggle == 0) ? {line_buffer2[VGA_HCOUNT][7:4], line_buffer2[VGA_HCOUNT][7:4]} : {line_buffer1[VGA_HCOUNT][7:4], line_buffer1[VGA_HCOUNT][7:4]};
    assign VGA_B = (buf_toggle == 0) ? {line_buffer2[VGA_HCOUNT][3:0], line_buffer2[VGA_HCOUNT][3:0]} : {line_buffer1[VGA_HCOUNT][3:0], line_buffer1[VGA_HCOUNT][3:0]};
    /* END */

endmodule
