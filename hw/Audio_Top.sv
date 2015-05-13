
/* Original audio codec code taken from
 * Howard Mao's FPGA blog
 * http://zhehaomao.com/blog/fpga/2014/01/15/sockit-8.html
 * 
 * Top-Level Audio Controller
 */

module Audio_top (
    input               OSC_50_B8A,
    input logic 	    resetn,
	input logic [15:0]  writedata,
	input logic         address,
	input logic         write,
	input logic         chipselect,
	output logic        irq,
    inout               AUD_ADCLRCK,
    input               AUD_ADCDAT,
    inout               AUD_DACLRCK,
    output              AUD_DACDAT,
    output              AUD_XCK, 
    inout               AUD_BCLK,
    output              AUD_I2C_SCLK,
    inout               AUD_I2C_SDAT,
    output              AUD_MUTE,

    input  [3:0]        KEY,
    input  [3:0]        SW,
    output [3:0]        LED
);

assign reset = !KEY[0];
logic main_clk;
logic audio_clk;
logic ctrl;
logic [1:0] sample_end;
logic [1:0] sample_req;
logic [15:0] audio_output;
logic [15:0] audio_sample;
logic [15:0] audio_sw;
logic [15:0] audio_ip;
logic [15:0] audio_input;

logic [15:0] M_background;
logic [16:0] addr_background;

background c0 (.clock(OSC_50_B8A), .address(addr_background), .q(M_background));

clock_pll pll (
    .refclk (OSC_50_B8A),
    .rst (reset),
    .outclk_0 (audio_clk),
    .outclk_1 (main_clk)
);

i2c_av_config av_config (
    .clk (main_clk),
    .reset (reset),
    .i2c_sclk (AUD_I2C_SCLK),
    .i2c_sdat (AUD_I2C_SDAT),
    .status (LED)
);

assign AUD_XCK = audio_clk;
assign AUD_MUTE = (SW != 4'b0);

audio_codec ac (
    .clk (audio_clk),
    .reset (reset),
    .sample_end (sample_end),
    .sample_req (sample_req),
    .audio_output (audio_output),
    .channel_sel (2'b10),

    .AUD_ADCLRCK (AUD_ADCLRCK),
    .AUD_ADCDAT (AUD_ADCDAT),
    .AUD_DACLRCK (AUD_DACLRCK),
    .AUD_DACDAT (AUD_DACDAT),
    .AUD_BCLK (AUD_BCLK)
);

audio_effects ae (
    .clk (audio_clk),
    .sample_end (sample_end[1]),
    .sample_req (sample_req[1]),
    .audio_output (audio_output),
    .audio_sample  (audio_sample),
    .addr_background(addr_background),
    .M_background(M_background),
	.control(ctrl)
);


 always_ff @(posedge OSC_50_B8A)
    if (resetn) begin
        ctrl <= 0;
    end
	else if (chipselect && write)
	begin
		case(address)
            1'b0:	ctrl <= writedata[0];
        endcase
	end
endmodule
