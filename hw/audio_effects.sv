
/* Original audio codec code taken from
 * Howard Mao's FPGA blog
 * http://zhehaomao.com/blog/fpga/2014/01/15/sockit-8.html
 * /

/* audio_effects.sv
    Reads the audio data from the ROM blocks and sends them to the 
    audio codec interface
*/

module audio_effects (
    input               clk, //audio clock
    input               sample_end, //sample ends
    input               sample_req, //request new sample
	input [15:0]        audio_sample, //get audio sample from audio codec interface, not needed here
    output [15:0]       audio_output, //sends audio sample to audio codec
    input [15:0]        M_city,    //city sound ROM data
    output [14:0]       addr_city,
    input  [3:0]        control    //Control from avalon bus
);


reg[15:0]   index = 15'd0;     //index through the sound ROM data for different sounds
reg[15:0]   count = 15'd0;


reg [15:0] dat;

assign audio_output = dat;

//assign index to ROM addresses
always @(posedge clk) begin
    addr_city <= index;
end

//Play sound if control is ON
always @(posedge clk) begin

    if (sample_req) begin
        if (control == 1) begin //play city sound
            dat <= M_city;
        end
        
		if (index == 15'd22049)
            index <= 15'd0;
		else
		    index <= index +1'b1;   //increment city index
    
	end
	else
        dat <= 16'd0;
end

endmodule