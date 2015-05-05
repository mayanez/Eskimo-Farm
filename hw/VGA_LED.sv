/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module VGA_LED( input logic         clk,
                input logic 	  	reset,
                input logic [31:0] 	gl_input,
                input logic [5:0] 	address,
                input logic 	  	write,
                input logic         read,
                input logic 		chipselect,
                output logic [7:0]  VGA_R, VGA_G, VGA_B,
                output logic 	  	VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n, VGA_SYNC_n,
                output logic[31:0] 	readdata);

    logic [9:0] VGA_HCOUNT;
    logic [9:0] VGA_VCOUNT;
    logic VGA_CLOCK;
    logic [31:0] vsync;

    logic [31:0] sprite1,sprite2,sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, sprite9,
                 sprite10, sprite11, sprite12, sprite13, sprite14, sprite15, sprite16, sprite17,
                 sprite18, sprite19, sprite20, sprite21, sprite22, sprite23, sprite24, sprite25,
                 sprite26, sprite27, sprite28, sprite29, sprite30;
   
    logic [9:0]  addr_ship, addr_pig, addr_bee, addr_cow, addr_mcdonald, addr_zero, addr_one, 
                 addr_two, addr_three, addr_four, addr_five, addr_six, addr_seven, addr_eight, addr_nine, addr_bullet,
                 addr_title, addr_eskimo, addr_cloud, addr_frog, addr_goat, addr_chick, addr_a, addr_e, addr_f, addr_g,
                 addr_i, addr_k, addr_m, addr_n, addr_o, addr_p, addr_r, addr_s, addr_u, addr_v, addr_w, addr_t;
    
    logic [23:0] M_ship, M_pig, M_bee, M_cow, M_mcdonald, M_zero, 
                 M_one, M_two, M_three, M_four, M_five, M_six, M_seven, M_eight, M_nine, M_bullet,
                 M_title, M_eskimo, M_cloud, M_frog, M_goat, M_chick, M_a, M_e, M_f, M_g, M_i, M_k, M_m, M_n, M_o, M_p, M_r, M_s, M_u, M_v, M_w, M_t;

	/* Given an input and address put into array */
	always_ff@(posedge clk)
	begin
        if (reset) begin
            sprite1 <= 0;
			sprite2 <= 0;
			sprite3 <= 0;
            sprite4 <= 0;
            sprite5 <= 0;
            sprite6 <= 0;
            sprite7 <= 0;
            sprite8 <= 0;
            sprite9 <= 0;
            sprite10 <= 0;
            sprite11 <= 0;
            sprite12 <= 0;
            sprite13 <= 0;
            sprite14 <= 0;
            sprite15 <= 0;
            sprite16 <= 0;
            sprite17 <= 0;
            sprite18 <= 0;
            sprite19 <= 0;
            sprite20 <= 0;
            sprite21 <= 0;
            sprite22 <= 0;
            sprite23 <= 0;
            sprite24 <= 0;
            sprite25 <= 0;
            sprite26 <= 0;
            sprite27 <= 0;
            sprite28 <= 0;
            sprite29 <= 0;
            sprite30 <= 0;
		end
        if (write && chipselect) begin
            case(address)
                5'd0: sprite1 <= gl_input;
                5'd1: sprite2 <= gl_input;
                5'd2: sprite3 <= gl_input;
                5'd3: sprite4 <= gl_input;
                5'd4: sprite5 <= gl_input;
                5'd5: sprite6 <= gl_input;
                5'd6: sprite7 <= gl_input;
                5'd7: sprite8 <= gl_input;
                5'd8: sprite9 <= gl_input;
                5'd9: sprite10 <= gl_input;
                5'd10: sprite11 <= gl_input;
                5'd11: sprite12 <= gl_input;
                5'd12: sprite13 <= gl_input;
                5'd13: sprite14 <= gl_input;
                5'd14: sprite15 <= gl_input;
                5'd15: sprite16 <= gl_input;
                5'd16: sprite17 <= gl_input;
                5'd17: sprite18 <= gl_input;
                5'd18: sprite19 <= gl_input;
                5'd19: sprite20 <= gl_input;
                5'd20: sprite21 <= gl_input;
                5'd21: sprite22 <= gl_input;
                5'd22: sprite23 <= gl_input;
                5'd23: sprite24 <= gl_input;
                5'd24: sprite25 <= gl_input;
                5'd25: sprite26 <= gl_input;
                5'd26: sprite27 <= gl_input;
                5'd27: sprite28 <= gl_input;
                5'd28: sprite29 <= gl_input;
                5'd29: sprite30 <= gl_input;
                5'd60: begin
                       sprite1 <= 0;
                       sprite2 <= 0;
                       sprite3 <= 0;
                       sprite4 <= 0;
                       sprite5 <= 0;
                       sprite6 <= 0;
                       sprite7 <= 0;
                       sprite8 <= 0;
                       sprite9 <= 0;
                       sprite10 <= 0;
                       sprite11 <= 0;
                       sprite12 <= 0;
                       sprite13 <= 0;
                       sprite14 <= 0;
                       sprite15 <= 0;
                       sprite16 <= 0;
                       sprite17 <= 0;
                       sprite18 <= 0;
                       sprite19 <= 0;
                       sprite20 <= 0;
                       sprite21 <= 0;
                       sprite22 <= 0;
                       sprite23 <= 0;
                       sprite24 <= 0;
                       sprite25 <= 0;
                       sprite26 <= 0;
                       sprite27 <= 0;
                       sprite28 <= 0;
                       sprite29 <= 0;
                       sprite30 <= 0;
                       end
            endcase
        end
        else if (read && chipselect) begin
            case(address)
                5'd61: readdata <= vsync;
            endcase
        end
    end
	/* END */


    /* Initialize ROM Blocks */
    ship sm(.clock(VGA_CLK), .address(addr_ship), .q(M_ship));
    pig  pg(.clock(VGA_CLK), .address(addr_pig), .q(M_pig));
    bee  be(.clock(VGA_CLK), .address(addr_bee), .q(M_bee));
    cow  cw(.clock(VGA_CLK), .address(addr_cow), .q(M_cow));
    //mcdonald mc(.clock(VGA_CLK), .address(addr_mcdonald), .q(M_mcdonald));
    zero z(.clock(VGA_CLK), .address(addr_zero), .q(M_zero));
    one on(.clock(VGA_CLK), .address(addr_one), .q(M_one));
    two t(.clock(VGA_CLK), .address(addr_two), .q(M_two));
    three th(.clock(VGA_CLK), .address(addr_three), .q(M_three));
    four f(.clock(VGA_CLK), .address(addr_four), .q(M_four));
    five fi(.clock(VGA_CLK), .address(addr_five), .q(M_five));
    six si(.clock(VGA_CLK), .address(addr_six), .q(M_six));
    seven se(.clock(VGA_CLK), .address(addr_seven), .q(M_seven));
    eight ei(.clock(VGA_CLK), .address(addr_eight), .q(M_eight));
    nine n(.clock(VGA_CLK), .address(addr_nine), .q(M_nine));
    bullet bu(.clock(VGA_CLK), .address(addr_bullet), .q(M_bullet));
    cloud cl(.clock(VGA_CLK), .address(addr_cloud), .q(M_cloud));
    eskimo es(.clock(VGA_CLK), .address(addr_eskimo), .q(M_eskimo));
    frog fr(.clock(VGA_CLK), .address(addr_frog), .q(M_frog));
    goat go(.clock(VGA_CLK), .address(addr_goat), .q(M_goat));
    chick ch(.clock(VGA_CLK), .address(addr_chick), .q(M_chick));
    a la(.clock(VGA_CLK), .address(addr_a), .q(M_a));
    e le(.clock(VGA_CLK), .address(addr_e), .q(M_e));
    f lf(.clock(VGA_CLK), .address(addr_f), .q(M_f));
    g lg(.clock(VGA_CLK), .address(addr_g), .q(M_g));
    i li(.clock(VGA_CLK), .address(addr_i), .q(M_i));
    k lk(.clock(VGA_CLK), .address(addr_k), .q(M_k));
    m lm(.clock(VGA_CLK), .address(addr_m), .q(M_m));
    n ln(.clock(VGA_CLK), .address(addr_n), .q(M_n));
    o lo(.clock(VGA_CLK), .address(addr_o), .q(M_o));
    p lp(.clock(VGA_CLK), .address(addr_p), .q(M_p));
    r lr(.clock(VGA_CLK), .address(addr_r), .q(M_r));
    s ls(.clock(VGA_CLK), .address(addr_s), .q(M_s));
    u lu(.clock(VGA_CLK), .address(addr_u), .q(M_u));
    v lv(.clock(VGA_CLK), .address(addr_v), .q(M_v));
    w lw(.clock(VGA_CLK), .address(addr_w), .q(M_w));
    t lt(.clock(VGA_CLK), .address(addr_t), .q(M_t));

   
	VGA_LED_Emulator led_emulator(.clk50(clk), .VGA_SYNC_n(vsync[0]), .*);
    Sprite_Controller sprite_controller(.clk(VGA_CLK), .*);

endmodule
