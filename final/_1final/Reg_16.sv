//needs to be modified to be 16 bits
/*module reg_20 (input  logic Clk, Reset, Load, 
              input  logic [20:0]  D,
              output logic [20:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset)
			  Data_Out <= 20'h0;
		 else if (Load)
			  Data_Out <= D;
		 else
		 	  Data_Out <= D + 1;
    end
endmodule
*/