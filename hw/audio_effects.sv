/* Original audio codec code taken from
 * Howard Mao's FPGA blog
 * http://zhehaomao.com/blog/fpga/2014/01/15/sockit-8.html
 * Reads the audio data from the ROM blocks and sends them to the 
 * audio codec interface
 */
 
module audio_effects (
    input               clk,
    input               sample_end,
    input               sample_req,
	input [15:0]        audio_sample,
    output [15:0]       audio_output,
    input [15:0]        M_background,
    output [16:0]       addr_background,
    input  [3:0]        control
);


reg[16:0]   index = 17'd0;
reg[16:0]   count = 17'd0;


always @(posedge clk) begin

    if (sample_req) begin
        if (control == 1) begin
            audio_output <= M_background;
            addr_background <= 0;
        end
        
		if (index == 17'd117585) /* # of samples in Background */
            addr_background <= 17'd0;
		else
		    addr_background <= addr_background +17'b1;
    
	end
	else
        audio_output <= 17'd0;
end

endmodule
