/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module VGA_LED(input logic    clk,
	       input logic 	  		reset,
	       input logic [31:0] 	gl_input,
			 input logic [4:0] 	address,
	       input logic 	  		write,
          input logic 			chipselect,
	       output logic [7:0]  VGA_R, VGA_G, VGA_B,
	       output logic 	  		VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	       output logic 	  		VGA_SYNC_n);

   logic [31:0] gl_array [19:0]; 
   logic [9:0] VGA_HCOUNT;
   logic [9:0] VGA_VCOUNT;
   logic [4:0] id1;
   logic [31:0] sprite1,sprite2,sprite3;
   logic VGA_CLOCK;
   
   logic [9:0] addr_ship, addr_pig, addr_bee;
   logic [23:0] M_sprite1, M_sprite2, M_sprite3, M_ship, M_pig, M_bee;

	/* Given an input and address put into array */
	always_ff@(posedge clk)
	begin
      if (write && chipselect)
		begin
       case(address)
	5'd0: gl_array[0] <= gl_input;
        5'd1: gl_array[1] <= gl_input;
        5'd2: gl_array[2] <= gl_input;
       endcase
      end
   end
	/* END */

	/* Decode array entries */
   assign sprite1 = gl_array[0];
   assign sprite2 = gl_array[1];
   assign sprite3 = gl_array[2];

   assign id1 = sprite1[24:20];
   assign id2 = sprite2[24:20];
   assign id3 = sprite3[24:20];
	/* END */
	
	/* Given ID select which ROM block to read from */
	always_comb 
	begin
		if (id1 == 5'd0) 			M_sprite1 = M_ship;
		else if (id1 == 5'd2)	M_sprite1 = M_pig;
		else if (id1 == 5'd3)	M_sprite1 = M_bee;
		else							M_sprite1 = 0;
	end

	always_comb 
	begin
		if (id2 == 5'd0)			M_sprite2 = M_ship;
		else if (id2 == 5'd2)	M_sprite2 = M_pig;
		else if (id2 == 5'd3)	M_sprite2 = M_bee;
		else							M_sprite2 = 0;
	end
	
	always_comb
	begin
		if (id3 == 5'd0)			M_sprite3 = M_ship;
		else if (id3 == 5'd2)	M_sprite3 = M_pig;
		else if (id3 == 5'd3)	M_sprite3 = M_bee;
		else							M_sprite3 = 0;
	end
	/* END */

	ship sm(.clock(VGA_CLK), .address(addr_ship), .q(M_ship));
   pig  pg(.clock(VGA_CLK), .address(addr_pig), .q(M_pig));
   bee  be(.clock(VGA_CLK), .address(addr_bee), .q(M_bee));
   
	VGA_LED_Emulator led_emulator(.clk50(clk), .*);
   Sprite_Controller sprite_controller(.clk(VGA_CLK), .*);

endmodule
