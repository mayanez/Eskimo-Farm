/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module VGA_LED( input logic         clk,
                input logic 	  	reset,
                input logic [31:0] 	gl_input,
                input logic [4:0] 	address,
                input logic 	  	write,
                input logic 		chipselect,
                output logic [7:0]  VGA_R, VGA_G, VGA_B,
                output logic 	  	VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
                output logic 	  	VGA_SYNC_n);

    logic [9:0] VGA_HCOUNT;
    logic [9:0] VGA_VCOUNT;
    logic VGA_CLOCK;

    logic [31:0] sprite1,sprite2,sprite3;
   
    logic [9:0]  addr_ship, addr_pig, addr_bee;
    logic [23:0] M_ship, M_pig, M_bee;

	/* Given an input and address put into array */
	always_ff@(posedge clk)
	begin
        if (reset) begin
            sprite1 <= 0;
			sprite2 <= 0;
			sprite3 <= 0;
		end
        if (write && chipselect) begin
            case(address)
                5'd0: sprite1 <= gl_input;
                5'd1: sprite2 <= gl_input;
                5'd2: sprite3 <= gl_input;
                5'd60: begin    /* Force Reset from Driver */
                    sprite1 <= 0;
                    sprite2 <= 0;
                    sprite3 <= 0;
                end
            endcase
        end
    end
	/* END */


    /* Initialize ROM Blocks */
    ship sm(.clock(VGA_CLK), .address(addr_ship), .q(M_ship));
    pig  pg(.clock(VGA_CLK), .address(addr_pig), .q(M_pig));
    bee  be(.clock(VGA_CLK), .address(addr_bee), .q(M_bee));
   
	VGA_LED_Emulator led_emulator(.clk50(clk), .*);
    Sprite_Controller sprite_controller(.clk(VGA_CLK), .*);

endmodule
