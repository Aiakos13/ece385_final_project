//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( 
							  input Clk, VGA_VS, VGA_CLK, Reset,
							  input [15:0] SRAM_out,
							  input [9:0] Ball_X_Pos,	Ball_Y_Pos,
							  input frame_clk,
							  input [15:0] hw,            // Whether current pixel belongs to ball 
							  input [31:0] fish_data,
                       input [9:0]  DrawX, DrawY,       // Current pixel coordinates
							  input [15:0] keycode,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
							  output logic [19:0] SRAM_ADDR, 	  //.ADDR
							  output logic [15:0] eaten,
							  output logic [3:0] life,
							  output logic Reset_fish 
                     );
    logic [19:0] SRAM_ADDR_in; 	  //.ADDR
	 logic [7:0] last_key_code;
	 
    logic [7:0] Red, Green, Blue;
	 
    logic [31:0] color, color_out;
	 logic [9:0] X, Y;
	 
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
	 always_ff @ (posedge VGA_CLK)
    begin
        if (Reset)
			SRAM_ADDR <= 20'd0;
		  else
			SRAM_ADDR <= SRAM_ADDR_in;			
	 end
	 
	 logic [3:0] sprite; 
	
    logic [9:0] fish_x, fish_y;
	 game game_state(.CLK(Clk), .VGA_VS, .VGA_CLK, .RESET(Reset), .fish_data,.DrawX, .DrawY,.hw, .Ball_X_Pos, .Ball_Y_Pos, .last_key_code, .key_code_in(keycode[7:0]),
	 					  .fish_x, .fish_y, .sprite, .eaten, .life, .Reset_fish 
						  );
		
	
	 key_code kc0 ( .frame_clk, .key_code_in(keycode[7:0]), .last_key_code);
	 //sprite_table st (.frame_clk, .last_key_code, .X(Ball_X_Pos - DrawX - 16), .Y(Ball_Y_Pos - DrawY - 16), .color);
	 //frame last_frame(.Clk(frame_clk),.x(DrawX),.y(DrawY),.color_in(color),.color_out);
    // Assign color based on is_ball signal
    always_comb
    begin
		  X = 0;
		  Y = 0;
		  SRAM_ADDR_in = 20'd0;
		
		
		
		unique case(sprite)
		3'd0:
		begin
		if (eaten < 10)
			begin
				X = DrawX - Ball_X_Pos + 10'd16;//Ball_X_Pos - DrawX - 16; 
				Y = DrawY - Ball_Y_Pos + 10'd16;	
				unique case(last_key_code)//unique-16 case(keycode[7:0])
				//jodi_left	
				8'h50: 
				begin
				if (DrawX > Ball_X_Pos - 10'd16 && DrawX < Ball_X_Pos + 10'd16 && DrawY > Ball_Y_Pos - 10'd16 && DrawY < Ball_Y_Pos + 10'd16 ) 
				SRAM_ADDR_in = (X + ((Y + 20'd32) << 8));		
				end
				//jodi_right
				8'h4F: 
				begin
				if (DrawX > Ball_X_Pos - 10'd16 && DrawX < Ball_X_Pos + 10'd16 && DrawY > Ball_Y_Pos - 10'd16 && DrawY < Ball_Y_Pos + 10'd16 ) 
					SRAM_ADDR_in = (X + 20'd32 + ((Y + 20'd32) << 8));		
				end
				//jodi_up
				8'h52: 
				begin
				if (DrawX > Ball_X_Pos - 10'd16 && DrawX < Ball_X_Pos + 10'd16 && DrawY > Ball_Y_Pos - 10'd16 && DrawY < Ball_Y_Pos + 10'd16 ) 
					SRAM_ADDR_in = (X + (Y << 8));				
				end
				//jodi_down
				8'h51: 
				begin
				if (DrawX > Ball_X_Pos - 10'd16 && DrawX < Ball_X_Pos + 10'd16 && DrawY > Ball_Y_Pos - 10'd16 && DrawY < Ball_Y_Pos + 10'd16 ) 
					SRAM_ADDR_in = (X + 20'd32 + (Y << 8));				
				end	
				default:;
				endcase
			end
		else if (eaten < 30 && eaten >= 10)
			begin
				unique case(last_key_code)//unique-16 case(keycode[7:0])
				//jodi_left	
				8'h50: 
				begin
				X = DrawX - Ball_X_Pos + 10'd32;
				Y = DrawY - Ball_Y_Pos + 10'd16;	
				if (DrawX > Ball_X_Pos - 10'd32 && DrawX < Ball_X_Pos + 10'd32 && DrawY > Ball_Y_Pos - 10'd16 && DrawY < Ball_Y_Pos + 10'd16 ) 
					SRAM_ADDR_in = (X + 20'd64 + ((Y + 20'd0) << 8));		
				end
				//jodi_right
				8'h4F: 
				begin
				X = DrawX - Ball_X_Pos + 10'd32;
				Y = DrawY - Ball_Y_Pos + 10'd16;	
				if (DrawX > Ball_X_Pos - 10'd32 && DrawX < Ball_X_Pos + 10'd32 && DrawY > Ball_Y_Pos - 10'd16 && DrawY < Ball_Y_Pos + 10'd16 ) 
					SRAM_ADDR_in = (X + 20'd64 + ((Y + 20'd32) << 8));		
				end
				//jodi_up
				8'h52: 
				begin
				X = DrawX - Ball_X_Pos + 10'd16;
				Y = DrawY - Ball_Y_Pos + 10'd32;	
				if (DrawX > Ball_X_Pos - 10'd16 && DrawX < Ball_X_Pos + 10'd16 && DrawY > Ball_Y_Pos - 10'd32 && DrawY < Ball_Y_Pos + 10'd32 ) 
					SRAM_ADDR_in = (X + 20'd128 + (Y << 8));				
				end
				//jodi_down
				8'h51: 
				begin
				X = DrawX - Ball_X_Pos + 10'd16;
				Y = DrawY - Ball_Y_Pos + 10'd32;	
				if (DrawX > Ball_X_Pos - 10'd16 && DrawX < Ball_X_Pos + 10'd16 && DrawY > Ball_Y_Pos - 10'd32 && DrawY < Ball_Y_Pos + 10'd32 ) 
					SRAM_ADDR_in = (X + 20'd160 + (Y << 8));				
				end	
				default:;
				endcase			
			end
		else if (eaten >= 30)
		begin
			X = DrawX - Ball_X_Pos + 10'd32;//Ball_X_Pos - DrawX - 16; 
			Y = DrawY - Ball_Y_Pos + 10'd32;	
			unique case(last_key_code)//unique-16 case(keycode[7:0])
			//jodi_left	
			8'h50: 
			begin
			if (DrawX > Ball_X_Pos - 10'd32 && DrawX < Ball_X_Pos + 10'd32 && DrawY > Ball_Y_Pos - 10'd32 && DrawY < Ball_Y_Pos + 10'd32 ) 
			SRAM_ADDR_in = (X + 20'd64 + ((Y + 20'd64) << 8));		
			end
			//jodi_right
			8'h4F: 
			begin
			if (DrawX > Ball_X_Pos - 10'd32&& DrawX < Ball_X_Pos + 10'd32 && DrawY > Ball_Y_Pos - 10'd32 && DrawY < Ball_Y_Pos + 10'd32 ) 
				SRAM_ADDR_in = (X + 20'd128 + ((Y + 20'd64) << 8));		
			end
			//jodi_up
			8'h52: 
			begin
			if (DrawX > Ball_X_Pos - 10'd32 && DrawX < Ball_X_Pos + 10'd32 && DrawY > Ball_Y_Pos - 10'd32 && DrawY < Ball_Y_Pos + 10'd32) 
				SRAM_ADDR_in = (X + 20'd192+ (Y << 8));				
			end
			//jodi_down
			8'h51: 
			begin
			if (DrawX > Ball_X_Pos - 10'd32 && DrawX < Ball_X_Pos + 10'd32&& DrawY > Ball_Y_Pos - 10'd32 && DrawY < Ball_Y_Pos + 10'd32 ) 
				SRAM_ADDR_in = (X + ((Y + 20'd64) << 8));				
			end	
			default:;
			endcase
		end
	end
		3'd1: //small fish
		begin
		if (DrawX > fish_x - 10'd16 && DrawX < fish_x + 10'd16 && DrawY > fish_y - 10'd16 && DrawY < fish_y + 10'd16 ) 
			begin
			X = DrawX - fish_x + 10'd16;//Ball_X_Pos - DrawX - 16; 
			Y = DrawY - fish_y + 10'd16;
			SRAM_ADDR_in = (X + 20'd160 + ((Y + 20'd128) << 8));	
			end
		end

		3'd2: //med fish
		begin
		if (DrawX > fish_x - 10'd32 && DrawX < fish_x + 10'd32 && DrawY > fish_y - 10'd16 && DrawY < fish_y + 10'd16 ) 
			begin
			X = DrawX - fish_x + 10'd32;//Ball_X_Pos - DrawX - 16; 
			Y = DrawY - fish_y + 10'd16;	
			SRAM_ADDR_in = (X + 20'd192 + ((Y + 20'd96) << 8));
			end
		end

		3'd3: //big fish
		begin
		if (DrawX > fish_x - 10'd32 && DrawX < fish_x + 10'd32 && DrawY > fish_y - 10'd32 && DrawY < fish_y + 10'd32 ) 
			begin
			X = DrawX - fish_x + 10'd32;//Ball_X_Pos - DrawX - 16; 
			Y = DrawY - fish_y + 10'd32;	
			SRAM_ADDR_in = (X + 20'd64 + ((Y + 20'd128) << 8));		
			end
		end
	
		3'd4: //jelly
		begin
		if (DrawX > fish_x - 10'd16 && DrawX < fish_x + 10'd16 && DrawY > fish_y - 10'd16 && DrawY < fish_y + 10'd16 ) 
			begin
			X = DrawX - fish_x + 10'd16;//Ball_X_Pos - DrawX - 16; 
			Y = DrawY - fish_y + 10'd16;	
			SRAM_ADDR_in = (X + 20'd128+ ((Y + 20'd128) << 8));		
			end
		end
		
		3'd5: //jelly
		begin
		if (DrawX > fish_x - 10'd32 && DrawX < fish_x + 10'd32 && DrawY > fish_y - 10'd32 && DrawY < fish_y + 10'd32 ) 
			begin
			X = DrawX - fish_x + 10'd32;//Ball_X_Pos - DrawX - 16; 
			Y = DrawY - fish_y + 10'd32;	
			SRAM_ADDR_in = (X + 20'd192+ ((Y + 20'd128) << 8));		
			end
		end
		3'b110: SRAM_ADDR_in = DrawX + 20'hC000 + (DrawY * 20'd640);		

		default:;
		endcase
		
	/*int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = 17;	 
		*/
		if (life == 0)
			SRAM_ADDR_in = DrawX + 20'hC000 + (DrawY * 20'd640);
		
		
     if (SRAM_out != 16'h0000) 
	  begin
			// White ball
			Red = {SRAM_out[4:0], 3'b0};
			Green = {SRAM_out[10:5], 2'b0};
			Blue = {SRAM_out[15:11], 3'b0};
	  end
     else 
	  begin
			// Background with nice color gradient
			Red = 8'h10;//color[7:0]; 	//{data_out[4:0], 3'b111};//8'h10; 
			Green = 8'h00;//color[15:8]; //{data_out[10:5], 2'b0};//8'h00;
			Blue = 8'h7f- {1'b0, DrawY[9:3]};//color[23:16]; //{data_out[15:11], 3'b0};//8'h7f- {1'b0, DrawX[9:3]};;
	  end
     end 
    
endmodule
