module  color_pallete ( input [15:0]   color,
                       output logic [7:0] sprite_r, sprite_g, sprite_b // VGA RGB output
                     );
							
//determine whether to use upper byte or lower byte
//based on whether we're to draw an odd indexed pixel
//or even indexed pixel
/*
assign colordata = (sprite_x [0] == 1)? SRAM_DQ[15:8] : SRAM_DQ[7:0];
 
//color palette
always_comb begin
        unique case(colordata)
 
                8'hFF:begin//transparent
                       sprite_r = 8'd98;
                       sprite_g = 8'd187;
                       sprite_b = 8'd249;
                      end
                8'h00:begin//black
                       sprite_r = 8'd0;
                       sprite_g = 8'd0;
                       sprite_b = 8'd0;
                      end
                8'h02:begin//green
                       sprite_r = 8'd02;
                       sprite_g = 8'd200;
                       sprite_b = 8'd20;
                      end
					 default:begin
                       sprite_r = 8'd02;
                       sprite_g = 8'd200;
                       sprite_b = 8'd20;
                      end
			endcase
			
end
*/
endmodule
					 