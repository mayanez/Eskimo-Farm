/* Original audio codec code taken from
 * Howard Mao's FPGA blog
 * http://zhehaomao.com/blog/fpga/2014/01/15/sockit-8.html
 * 
 * Sends samples to the audio codec SSM2603.
 */

module audio_codec (
    input  clk,
    input  reset,
    output [1:0]  sample_end,
    output [1:0]  sample_req,
    input  [15:0] audio_output,
    input  [1:0] channel_sel,
    output AUD_ADCLRCK,
    input AUD_ADCDAT,
    output AUD_DACLRCK,
    output AUD_DACDAT,  
    output AUD_BCLK
);

logic [7:0] lrck_divider;
logic [1:0] bclk_divider;

logic [15:0] shift_out;
logic [15:0] shift_temp;

assign lrck = !lrck_divider[7];

assign AUD_ADCLRCK = lrck;
assign AUD_DACLRCK = lrck;
assign AUD_BCLK = bclk_divider[1];

assign AUD_DACDAT = shift_out[15];


always @(posedge clk) begin
    if (reset) begin
        lrck_divider <= 8'hff;
        bclk_divider <= 2'b11;
    end else begin
        lrck_divider <= lrck_divider + 1'b1;
        bclk_divider <= bclk_divider + 1'b1;
    end
end

//first 16 bit sample sent after 16 bclks or 4*16=64 mclk
assign sample_end[1] = (lrck_divider == 8'h40);
//second 16 bit sample sent after 48 bclks or 4*48 = 192 mclk 
assign sample_end[0] = (lrck_divider == 8'hc0);

// end of one lrc clk cycle (254 mclk cycles)
assign sample_req[1] = (lrck_divider == 8'hfe);
// end of half lrc clk cycle (126 mclk cycles) so request for next sample
assign sample_req[0] = (lrck_divider == 8'h7e);

assign clr_lrck = (lrck_divider == 8'h7f); // 127 mclk
assign set_lrck = (lrck_divider == 8'hff); // 255 mclk
// high right after bclk is set
assign set_bclk = (bclk_divider == 2'b10 && !lrck_divider[6]);
// high right before bclk is cleared
assign clr_bclk = (bclk_divider == 2'b11 && !lrck_divider[6]);

always @(posedge clk) begin
    if (reset) begin
        shift_out <= 16'h0;
        shift_temp <= 16'h0;
  	 end
	 else if (set_lrck) begin
            shift_out <= audio_output;
            shift_temp <= audio_output;
    end
	 else if (clr_lrck) begin
			shift_out <= shift_temp;
    end else if (clr_bclk == 1) begin
        shift_out <= {shift_out[14:0], 1'b0};
    end
end

endmodule
