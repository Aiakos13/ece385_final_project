module frame (
					input logic Clk,
					input logic [9:0]x,y,
					input logic [31:0] color_in,
					output logic [31:0] color_out
					);
logic [31:0] frame[10][10];
always_comb
begin
color_out = frame[x][y];
end

always_ff @ (posedge Clk)
begin
	frame[x][y] <= color_in;
end
					
endmodule
