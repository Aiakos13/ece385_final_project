module testbench ();
/*
timeunit 10ns;
timeprecision 1ns;

// Internal logic signals
//logic clk, reset_n, run, ready;
//logic [127:0] msg_en, msg_de, key;
module game (
	// Avalon Clock Input
	input logic CLK, VGA_VS,
	// Avalon Reset Input
	input logic RESET,//active high
	// Avalon-MM Slave Signals
	input  logic [31:0] fish_data,//fish_data,	// Avalon-MM Write Data
	input  logic [9:0] DrawX, DrawY,       // Current pixel coordinates
	output logic [9:0] fish_x,//read_data,	// Avalon-MM Read Data
	output logic [9:0] fish_y,
	output logic [3:0] sprite
	//reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10, reg_out11, reg_out12, reg_out13, reg_out14, reg_out15
);
logic CLK;
logic RESET;
logic VGA_VS;
logic [31:0] fish_data;//
logic [9:0] DrawX; 
logic [9:0] DrawY;
logic [9:0] fish_x;
logic [9:0] fish_y;
logic [3:0] sprite;
// Instantiate the AES module to be tested
game gm (.*);

// Test program
initial begin : TEST_PROGRAM
    RESET = 0;
    AES_START = 0;
    AES_KEY    = 128'h000102030405060708090a0b0c0d0e0f;
    AES_MSG_ENC = 128'hDAEC3055DF058E1C39E814EA76F6747E;

    #4 RESET = 1;
    #10 AES_START = 1;
end

// Clock generation and initialization
always begin : CLOCK_GENERATION
    #1 CLK = ~CLK;
end

initial begin : CLOCK_INITIALIZATION
    CLK = 0;
end
*/
endmodule
