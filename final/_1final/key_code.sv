module  key_code ( 	  input logic			 frame_clk,
							  input logic  [7:0] key_code_in,
                       output logic [7:0]  last_key_code
                     );

always_ff @(posedge frame_clk)
begin
	if (key_code_in == 8'h4f || key_code_in == 8'h50 || key_code_in == 8'h51 || key_code_in == 8'h52)
		last_key_code <= key_code_in;
	else
		last_key_code <= last_key_code;
end

endmodule
