module game (
	// Avalon Clock Input
	input logic CLK, VGA_VS,VGA_CLK, 
	// Avalon Reset Input
	input logic RESET,//active high
	// Avalon-MM Slave Signals
	input  logic [31:0] fish_data,//fish_data,	// Avalon-MM Write Data
	input  logic [15:0] hw,
	input  logic [9:0]  Ball_X_Pos,
	input  logic [9:0]  Ball_Y_Pos,
	input  logic [7:0]  last_key_code,
	input  logic [7:0]  key_code_in,
	input  logic [9:0] DrawX, DrawY,       // Current pixel coordinates
	output logic [9:0] fish_x,//read_data,	// Avalon-MM Read Data
	output logic [9:0] fish_y,
	output logic [3:0] sprite,
	output logic [15:0] eaten,
	output logic [3:0] life,	
	output logic Reset_fish

	
	
	//reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10, reg_out11, reg_out12, reg_out13, reg_out14, reg_out15
);
 
//enum logic [3:0] {JODI_SMALL, FISH_SMALL, FISH_MEDIUM, FISH_LARGE, JELLY_FISH, JODI_MEDIUM, JODI_LARGE }   sprite; 
logic[31:0] reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10, reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16; 
//logic[31:0] new_reg_out0, new_reg_out1, new_reg_out2, new_reg_out3, new_reg_out4, new_reg_out5, new_reg_out6, new_reg_out7, new_reg_out8, new_reg_out9, new_reg_out10, new_reg_out11, new_reg_out12, new_reg_out13, new_reg_out14, new_reg_out15; 

logic[3:0] sprite0, sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, sprite9, sprite10, sprite11, sprite12, sprite13, sprite14, sprite15, sprite16; 
logic load0, load1, load2, load3, load4, load5, load6, load7, load8, load9, load10, load11, load12, load13, load14, load15, load16; 

logic clear0, clear1, clear2, clear3, clear4 ,clear5 , clear6, clear7, clear8, clear9, clear10, clear11, clear12, clear13, clear14, clear15, clear16;
logic clear0_in, clear1_in, clear2_in, clear3_in, clear4_in ,clear5_in , clear6_in, clear7_in, clear8_in, clear9_in, clear10_in, clear11_in, clear12_in, clear13_in, clear14_in, clear15_in, clear16_in;

logic [31:0]newInput0, newInput1, newInput2, newInput3, newInput4, newInput5, newInput6, newInput7, newInput8, newInput9, newInput10, newInput11, newInput12, newInput13, newInput14, newInput15, newInput16;
logic [9:0]  fish_x0, fish_x1 ,fish_x2 ,fish_x3 ,fish_x4 ,fish_x5 ,fish_x6 ,fish_x7 ,fish_x8 ,fish_x9 ,fish_x10,fish_x11,fish_x12,fish_x13,fish_x14,fish_x15, fish_x16;
logic [9:0]  fish_y0, fish_y1 ,fish_y2 ,fish_y3 ,fish_y4 ,fish_y5 ,fish_y6 ,fish_y7 ,fish_y8 ,fish_y9 ,fish_y10,fish_y11,fish_y12,fish_y13,fish_y14,fish_y15, fish_y16;

//logic clear_bit0, clear_bit1, clear_bit2, clear_bit3, clear_bit4, clear_bit5, clear_bit6, clear_bit7, clear_bit8, clear_bit9, clear_bit10, clear_bit11, clear_bit12, clear_bit13, clear_bit14, clear_bit15; 
logic [16:0]collision;//, collision_in, col_in;


logic load_jodi_small;
logic [31:0] new_jodi_small, out_jodi_small;
assign new_jodi_small = {{9'd0},{3'd0},{Ball_Y_Pos},{Ball_X_Pos}};

logic load_jodi_med;
logic [31:0] new_jodi_med, out_jodi_med;
assign new_jodi_med = {{9'd0},{3'd0},{Ball_Y_Pos},{Ball_X_Pos}};

logic load_jodi_large;
logic [31:0] new_jodi_large, out_jodi_large;
assign new_jodi_large = {{9'd0},{3'd0},{Ball_Y_Pos},{Ball_X_Pos}};

logic clear_jodi_small;
logic clear_jodi_med  ;
logic clear_jodi_large;

logic [15:0] eaten_in, eaten_clk;
logic [3:0] life_in;
logic Reset_fish_in;

	
logic frame_clk_delayed;
logic frame_clk_rising_edge;
always_ff @ (posedge CLK) begin
	frame_clk_delayed <= VGA_VS;
end
assign frame_clk_rising_edge = (VGA_VS == 1'b1) && (frame_clk_delayed == 1'b0);
  
logic eaten_sig;  
/*
always_ff @ (posedge VGA_CLK) begin
	if (RESET || key_code_in == 8'h2c)
	begin
		eaten_clk <= 16'h0000;
	end
	else
	begin
		eaten_clk <= eaten_in;
	end
end	
	*/
		
always_ff @ (posedge VGA_CLK) begin
	if (RESET || key_code_in == 8'h2c)
	begin
		eaten <= 16'h0000;
		life  <= 4'd10;
		Reset_fish <= 1;
		clear0 <= 0;
		clear1 <= 0;
		clear2 <= 0;
		clear3 <= 0;
		clear4 <= 0;
		clear5 <= 0;
		clear6 <= 0;
		clear7 <= 0;
		clear8 <= 0;
		clear9 <= 0;
		clear10 <=0;
		clear11 <=0;
		clear12 <=0;
		clear13 <=0;
		clear14 <=0;
		clear15 <=0;
		clear16 <=0;
	end
	else
	begin
		eaten <= eaten_in;
		life  <= life_in;
		Reset_fish <= Reset_fish_in;
		clear0 <=  clear0_in; 
		clear1 <=  clear1_in; 
		clear2 <=  clear2_in; 
		clear3 <=  clear3_in; 
		clear4 <=  clear4_in; 
		clear5 <=  clear5_in; 
		clear6 <=  clear6_in; 
		clear7 <=  clear7_in; 
		clear8 <=  clear8_in; 
		clear9 <=  clear9_in; 
		clear10 <=clear10_in;
		clear11 <=clear11_in;
		clear12 <=clear12_in;
		clear13 <=clear13_in;
		clear14 <=clear14_in;
		clear15 <=clear15_in;
		clear16 <=clear16_in;
		
		
		
		
		
		
		
/*		if(clear0_in)
			clear0 <= clear0_in;
		else if (frame_clk_rising_edge) 
			clear0 <= 0; 			
		else 
			clear0 <= clear0; 

		if(clear1_in)	
			clear1  <= clear1_in ;
		else if (frame_clk_rising_edge) 
			clear1 <= 0; 	
		else 
			clear1 <= clear1; 
		
		if(clear2_in)	
			clear2  <= clear2_in ;
		else if (frame_clk_rising_edge) 
			clear2 <= 0; 	
		else 
			clear2 <= clear2; 
			
		if(clear3_in)	
			clear3  <= clear3_in ;
		else if (frame_clk_rising_edge) 
			clear3 <= 0; 	
		else 
			clear3 <= clear3; 
		
		if(clear4_in)	
			clear4  <= clear4_in ;
		else if (frame_clk_rising_edge) 
			clear4 <= 0; 	
		else 
			clear4 <= clear4; 
		
		if(clear5_in)	
			clear5  <= clear5_in ;
		else if (frame_clk_rising_edge) 
			clear5 <= 0; 	
		else 
			clear5 <= clear5; 
		
		if(clear6_in)	
			clear6  <= clear6_in ;
		else if (frame_clk_rising_edge) 
			clear6 <= 0; 	
		else 
			clear6 <= clear6; 
		
		if(clear7_in)	
			clear7  <= clear7_in ;
		else if (frame_clk_rising_edge) 
			clear7 <= 0; 			
		else 
			clear7 <= clear7; 
		
		if(clear8_in)	
			clear8  <= clear8_in ;
		else if (frame_clk_rising_edge) 
			clear8 <= 0; 		
		else 
			clear8 <= clear8; 
		
		if(clear9_in)	
			clear9  <= clear9_in ;
		else if (frame_clk_rising_edge) 
			clear9 <= 0; 	
		else 
			clear9 <= clear9; 
		
		if(clear10_in)	
			clear10 <= clear10_in;
		else if (frame_clk_rising_edge) 
			clear10 <= 0; 		
		else 
			clear10 <= clear10; 
		
		if(clear11_in)	
			clear11 <= clear11_in;
		else if (frame_clk_rising_edge) 
			clear11 <= 0; 		
		else 
			clear11 <= clear11; 
		
		if(clear12_in)	
			clear12 <= clear12_in;
		else if (frame_clk_rising_edge) 
			clear12 <= 0; 	
		else 
			clear12 <= clear12; 
		
		if(clear13_in)	
			clear13 <= clear13_in;
		else if (frame_clk_rising_edge) 
			clear13 <= 0; 	
		else 
			clear13 <= clear13; 
		
		if(clear14_in)	
			clear14 <= clear14_in;
		else if (frame_clk_rising_edge) 
			clear14 <= 0; 		
		else 
			clear14 <= clear14; 
		
		if(clear15_in)	
			clear15 <= clear15_in;
		else if (frame_clk_rising_edge) 
			clear15 <= 0; 	
		else 
			clear15 <= clear15; 
		
		if(clear16_in)	
			clear16 <= clear16_in;
		else if (frame_clk_rising_edge) 
			clear16 <= 0; 	
		else 
			clear16 <= clear16; 
*/		
	end
 	
end 
 
 
always_comb
begin
load0  = (reg_out0  != 32'd0)? 1'b1 : 1'b0;
load1  = (reg_out1  != 32'd0)? 1'b1 : 1'b0;
load2  = (reg_out2  != 32'd0)? 1'b1 : 1'b0;
load3  = (reg_out3  != 32'd0)? 1'b1 : 1'b0;
load4  = (reg_out4  != 32'd0)? 1'b1 : 1'b0;
load5  = (reg_out5  != 32'd0)? 1'b1 : 1'b0;
load6  = (reg_out6  != 32'd0)? 1'b1 : 1'b0; 
load7  = (reg_out7  != 32'd0)? 1'b1 : 1'b0;
load8  = (reg_out8  != 32'd0)? 1'b1 : 1'b0;
load9  = (reg_out9  != 32'd0)? 1'b1 : 1'b0;
load10 = (reg_out10 != 32'd0)? 1'b1 : 1'b0;
load11 = (reg_out11 != 32'd0)? 1'b1 : 1'b0;
load12 = (reg_out12 != 32'd0)? 1'b1 : 1'b0;
load13 = (reg_out13 != 32'd0)? 1'b1 : 1'b0;
load14 = (reg_out14 != 32'd0)? 1'b1 : 1'b0;
load15 = (reg_out15 != 32'd0)? 1'b1 : 1'b0;
load16 = (reg_out16 != 32'd0)? 1'b1 : 1'b0;

load_jodi_small = 1'b0;
load_jodi_med = 1'b0;
load_jodi_large = 1'b0;
clear_jodi_small = 1'b0;
clear_jodi_med   = 1'b0;
clear_jodi_large = 1'b0;

if (eaten < 10)
	begin
	load_jodi_small  = 1'b1;
	load_jodi_med    = 1'b0;
	load_jodi_large  = 1'b0;
	clear_jodi_small = 1'b0;
	clear_jodi_med   = 1'b1;
	clear_jodi_large = 1'b1;
	end
else if (eaten < 30 && eaten >= 10)
	begin
	load_jodi_small = 1'b0;
	load_jodi_med = 1'b1;
	load_jodi_large = 1'b0;
	clear_jodi_small = 1'b1;
	clear_jodi_med   = 1'b0;
	clear_jodi_large = 1'b1;
	end
else if (eaten >= 30)
	begin
	load_jodi_small = 1'b0;
	load_jodi_med = 1'b0;
	load_jodi_large = 1'b1;
   clear_jodi_small = 1'b1;
	clear_jodi_med   = 1'b1;
	clear_jodi_large = 1'b0;
	end
unique case (fish_data[22:20])
//4'b0000:;

3'd1: //small fish
begin
if (reg_out0  == 0 && hw == 16'd0)
	load0 = 1'b1;
else if (reg_out1  == 0 && hw == 16'd1)
	load1 = 1'b1;
else if (reg_out2  == 0 && hw == 16'd2)
	load2 = 1'b1;
else if (reg_out3  == 0 && hw == 16'd3)
	load3 = 1'b1;
else if (reg_out4  == 0 && hw == 16'd4)
	load4 = 1'b1;
else if (reg_out5  == 0 && hw == 16'd5)
	load5 = 1'b1;
end

3'd2:
begin
//load6  = (reg_out6  != 32'd0)? 1 : 0; 
if (reg_out6  == 0 && hw == 16'd6)
	load6 = 1'b1;
else if (reg_out7  == 0 && hw == 16'd7)
	load7 = 1'b1;              
else if (reg_out8  == 0 && hw == 16'd8)
	load8 = 1'b1;              
else if (reg_out9  == 0 && hw == 16'd9)
	load9 = 1'b1;
end
3'd3: 
begin
if (reg_out10  == 0 && hw == 16'd10)
	load10 = 1'b1;
else if (reg_out11  == 0 && hw == 16'd11)
	load11 = 1'b1;              
else if (reg_out12  == 0 && hw == 16'd12)
	load12 = 1'b1;              
else if (reg_out13  == 0 && hw == 16'd13)
	load13 = 1'b1;
end

3'd4:
begin
if (reg_out14  == 0 && hw == 16'd14)
	load14 = 1'b1;
else if (reg_out15  == 0 && hw == 16'd15)
	load15 = 1'b1;
end
3'd5:
begin
if (reg_out16  == 0 && hw == 16'd16)
	load16 = 1'b1;	
end
default:;
endcase
/*
new_reg_out0   = reg_out0 + 32'd1;
new_reg_out1   = reg_out1 + 32'd1;
new_reg_out2   = reg_out2 + 32'd1;
new_reg_out3   = reg_out3 + 32'd1;
new_reg_out4   = reg_out4 + 32'd1;
new_reg_out5   = reg_out5 + 32'd1;
new_reg_out6   = reg_out6 + 32'd1;
new_reg_out7   = reg_out7 + 32'd1;
new_reg_out8   = reg_out8 + 32'd1;
new_reg_out9   = reg_out9 + 32'd1;
new_reg_out10  = reg_out10+ 32'd1;
new_reg_out11  = reg_out11+ 32'd1;
new_reg_out12  = reg_out12+ 32'd1;
new_reg_out13  = reg_out13+ 32'd1;
new_reg_out14  = reg_out14+ 32'd1;
new_reg_out15  = reg_out15+ 32'd1;
*/

fish_x0  = reg_out0  [9:0];
fish_x1  = reg_out1  [9:0];
fish_x2  = reg_out2  [9:0];
fish_x3  = reg_out3  [9:0];
fish_x4  = reg_out4  [9:0];
fish_x5  = reg_out5  [9:0];
fish_x6  = reg_out6  [9:0];
fish_x7  = reg_out7  [9:0];
fish_x8  = reg_out8  [9:0];
fish_x9  = reg_out9  [9:0];
fish_x10 = reg_out10 [9:0];
fish_x11 = reg_out11 [9:0];
fish_x12 = reg_out12 [9:0];
fish_x13 = reg_out13 [9:0];
fish_x14 = reg_out14 [9:0];
fish_x15 = reg_out15 [9:0];
fish_x16 = reg_out16 [9:0];


fish_y0  = reg_out0  [19:10];
fish_y1  = reg_out1  [19:10];
fish_y2  = reg_out2  [19:10];
fish_y3  = reg_out3  [19:10];
fish_y4  = reg_out4  [19:10];
fish_y5  = reg_out5  [19:10];
fish_y6  = reg_out6  [19:10];
fish_y7  = reg_out7  [19:10];
fish_y8  = reg_out8  [19:10];
fish_y9  = reg_out9  [19:10];
fish_y10 = reg_out10 [19:10];
fish_y11 = reg_out11 [19:10];
fish_y12 = reg_out12 [19:10];
fish_y13 = reg_out13 [19:10];
fish_y14 = reg_out14 [19:10];
fish_y15 = reg_out15 [19:10];
fish_y16 = reg_out16 [19:10];


sprite0  = reg_out0  [22:20];
sprite1  = reg_out1  [22:20];
sprite2  = reg_out2  [22:20];
sprite3  = reg_out3  [22:20];
sprite4  = reg_out4  [22:20];
sprite5  = reg_out5  [22:20];
sprite6  = reg_out6  [22:20];
sprite7  = reg_out7  [22:20];
sprite8  = reg_out8  [22:20];
sprite9  = reg_out9  [22:20];
sprite10 = reg_out10 [22:20];
sprite11 = reg_out11 [22:20];
sprite12 = reg_out12 [22:20];
sprite13 = reg_out13 [22:20];
sprite14 = reg_out14 [22:20];
sprite15 = reg_out15 [22:20];
sprite16 = reg_out16 [22:20];

clear0_in  = 0;
clear1_in  = 0;
clear2_in  = 0;
clear3_in  = 0;
clear4_in  = 0;
clear5_in  = 0;
clear6_in  = 0;
clear7_in  = 0;
clear8_in  = 0;
clear9_in  = 0;
clear10_in = 0;
clear11_in = 0;
clear12_in = 0;
clear13_in = 0;
clear14_in = 0;
clear15_in = 0;
clear16_in = 0;

///range from 2 - 10

fish_x =  10'b0;
fish_y =  10'b0;
sprite =  3'b111;
collision = 17'b0;

eaten_in = eaten;
life_in = life;
Reset_fish_in = 0;
eaten_sig = 0;
		// prof
		if (DrawX > fish_x16 - 32 && DrawX < fish_x16 + 32 && DrawY > fish_y16 - 32 && DrawY < fish_y16 + 32 )
			begin 
			fish_x =  fish_x16;																											
			fish_y =  fish_y16;																											
			sprite =  sprite16;	
			end    
		
		//jellyfish                                                                                       
		if (DrawX > fish_x14 - 16 && DrawX < fish_x14 + 16 && DrawY > fish_y14 - 16 && DrawY < fish_y14  + 16   )
			begin              	                      		                       	                        	  	     	
			fish_x =  fish_x14;  	                      		                       	                        	  	   
			fish_y =  fish_y14;  	                      		                       	                        	  	   
			sprite =  sprite14;  	                      		                       	                        	  	   				
			end                	                      		                       	                        	  	    	
		if (DrawX > fish_x15 - 16 && DrawX < fish_x15 + 16 && DrawY > fish_y15 - 16 && DrawY < fish_y15  + 16   )
			begin              	                      	                      	                      	    				
			fish_x =  fish_x15;  	                      	                      	                      	     			
			fish_y =  fish_y15;  	                      	                      	                      	     			
			sprite =  sprite15;  	                      	                      	                      	      		
			end  
			
		//jodi_large
		if (load_jodi_large && DrawX > Ball_X_Pos- 32 && DrawX < Ball_X_Pos + 32 && DrawY > Ball_Y_Pos - 32 && DrawY < Ball_Y_Pos + 32 ) 
		begin
			if (sprite == 3'd5)
			begin
				eaten_in = eaten + 16'd10;
				collision[16] = 1'b1;
			end
			else if (sprite == 3'd4)
				eaten_in = 16'd0;
			else 			
			begin
				fish_x =  Ball_X_Pos;  	                      	                      	                      	     				
				fish_y =  Ball_X_Pos;  	                      	                      	                      	    				
				sprite =  3'd0; 
			end
		end  	
		
		
		//large fish       
		if(DrawX > fish_x10 - 32 && DrawX < fish_x10  + 32 && DrawY > fish_y10  - 32 && DrawY < fish_y10 + 32  ) 
			begin  
			if (sprite == 3'd0)
			begin
				//collision[10] = 1'b1;
				if(eaten >=30)
				begin
					eaten_sig = 1;
					eaten_in = eaten + 16'd1;
				end
			end
			if (sprite == 3'd0)
			begin
				collision[10] = 1'b1;
			end
			else
				begin
				fish_x =  fish_x10; 		                     			                 		    	               		      
				fish_y =  fish_y10;  	                      		                       	                        	  	   
				sprite =  sprite10;
				end
			end                	                      		                       	                        	  	    	
		if (DrawX > fish_x11 - 32 && DrawX < fish_x11  + 32 && DrawY > fish_y11  - 32 && DrawY < fish_y11 + 32  ) 
			begin
			if (sprite == 3'd0)
			begin
				//collision[10] = 1'b1;
				if(eaten >=30)
				begin
					eaten_sig = 1;
					eaten_in = eaten + 16'd1;
				end
			end
			if (sprite == 3'd0)
			begin
				collision[11] = 1'b1;
			end
			else
				begin	
				//eaten_in = eaten; 
				fish_x =  fish_x11;  	                      		                       	                        	  	   
				fish_y =  fish_y11;  	                      		                       	                        	  	   
				sprite =  sprite11;  
				end
			end                	                      		                       	                        	  	    	
		if (DrawX > fish_x12 - 32 && DrawX < fish_x12  + 32 && DrawY > fish_y12  - 32 && DrawY < fish_y12 + 32 ) 
			begin
			if (sprite == 3'd0)
			begin
				//collision[10] = 1'b1;
				if(eaten >=30)
				begin
					eaten_sig = 1;
					eaten_in = eaten + 16'd1;
				end
			end
			if (sprite == 3'd0)
			begin
				collision[12] = 1'b1;
			end
			else
				begin			
				fish_x =  fish_x12;  	                      		                       	                        	  	   
				fish_y =  fish_y12;  	                      		                       	                        	  	   
				sprite =  sprite12;  
				end
			end             	   	                      		                       	                        	  	   
		if (DrawX > fish_x13 - 32 && DrawX < fish_x13  + 32 && DrawY > fish_y13  - 32 && DrawY < fish_y13 + 32  ) 
			begin
			if (sprite == 3'd0)
			begin
				//collision[10] = 1'b1;
				if(eaten >=30)
				begin
					eaten_sig = 1;
					eaten_in = eaten + 16'd1;
				end
			end
			if (sprite == 3'd0)
			begin
				collision[13] = 1'b1;
			end	
			else
				begin
				fish_x =  fish_x13;  	                      		                       	                        	  	   
				fish_y =  fish_y13;  	                      		                       	                        	  	   
				sprite =  sprite13;  	  
				end
			end
	/*if (load_jodi_large && DrawX > Ball_X_Pos- 32 && DrawX < Ball_X_Pos + 32 && DrawY > Ball_Y_Pos - 32 && DrawY < Ball_Y_Pos + 32 ) 
	begin
		if (eaten_sig == 1)
			eaten_in = eaten + 16'd1;
	end*/
	//jodi_med
	if (load_jodi_med && ((DrawX > Ball_X_Pos - 32 && DrawX < Ball_X_Pos + 32 && DrawY > Ball_Y_Pos - 16 && DrawY < Ball_Y_Pos + 16 && (last_key_code == 8'h4f || last_key_code == 8'h50)) || (DrawX > Ball_X_Pos - 16 && DrawX < Ball_X_Pos + 16 && DrawY > Ball_Y_Pos - 32 && DrawY < Ball_Y_Pos + 32 && (last_key_code == 8'h52 || last_key_code == 8'h51))))
	begin
	   if (sprite == 3'd5)
		begin
			eaten_in = eaten + 16'd10;
			collision[16] = 1'b1;
		end
		else if (sprite == 3'd4)
		begin
			eaten_in = 16'd0;
		end
		else if (sprite == 3'd3)
		begin
			life_in = life - 4'd1;
			Reset_fish_in = 1;
		end
		begin
			//eaten_in = eaten; 
			fish_x =  Ball_X_Pos;  	                      	                      	                      	     				
			fish_y =  Ball_X_Pos;  	                      	                      	                      	    				
			sprite =  3'd0; 
		end
	end  			
		//medium fish
		if (DrawX > fish_x6- 32 && DrawX < fish_x6 + 32 && DrawY > fish_y6 - 16 && DrawY < fish_y6 + 16 ) 
			begin
			if (sprite == 3'd0)
				begin
				collision[6] = 1'b1;
				if(eaten >= 10)
				begin
					eaten_sig = 1;
					eaten_in = eaten + 16'd1;
				end
				end
			else if (sprite ==	3'd3)
				collision[6] = 1'b1;
			else 
				begin
				fish_x =  fish_x6;  	                      	                      	                      	     	
				fish_y =  fish_y6;  	                      	                      	                      	     	
				sprite =  sprite6;
				end
			end                	                      	                      	                      	    	
	 if (DrawX > fish_x7- 32 && DrawX < fish_x7 + 32 && DrawY > fish_y7 - 16 && DrawY < fish_y7 + 16 ) 
		begin  
		if (sprite == 3'd0)
			begin
			collision[7] = 1'b1;
			if(eaten >= 10)
			begin
				eaten_sig = 1;
				eaten_in = eaten + 16'd1;
			end
			end
		else if (sprite == 3'd3)
			collision[7] = 1'b1;
		else 
			begin			
			fish_x =  fish_x7;  	                      	                      	                      	     	
			fish_y =  fish_y7;  	                      	                      	                      	     	
			sprite =  sprite7;  
			end
		end               	                      	                      	                      	    	
	if (DrawX > fish_x8- 32 && DrawX < fish_x8 + 32 && DrawY > fish_y8 - 16 && DrawY < fish_y8 + 16 ) 
		begin  
		if (sprite == 3'd0)
		begin
			collision[8] = 1'b1;
			if(eaten >=10)
			begin
				eaten_sig = 1;
				eaten_in = eaten + 16'd1;
			end
		end
		else if (sprite ==	3'd3)
			collision[8] = 1'b1;
		else 
			begin				
				fish_x =  fish_x8;  	                      	                      	                      	     	
				fish_y =  fish_y8;  	                      	                      	                      	     	
				sprite =  sprite8;  	
			end
		end               	                      	                      	                      	    		
	if (DrawX > fish_x9- 32 && DrawX < fish_x9 + 32 && DrawY > fish_y9 - 16 && DrawY < fish_y9 + 16 ) 
		begin 
		if (sprite == 3'd0)
		begin
			collision[9] = 1'b1;
			if(eaten >=10)
			begin
				eaten_sig = 1;
				eaten_in = eaten + 16'd1;
			end
		end
		else if (sprite ==	3'd3)
			collision[9] = 1'b1;
		else 
			begin
				fish_x =  fish_x9;  	                      	                      	                      	     				
				fish_y =  fish_y9;  	                      	                      	                      	    				
				sprite =  sprite9; 
			end
		end  	  
	/*	
	if (load_jodi_med && ((DrawX > Ball_X_Pos - 32 && DrawX < Ball_X_Pos + 32 && DrawY > Ball_Y_Pos - 16 && DrawY < Ball_Y_Pos + 16 && (last_key_code == 8'h4f || last_key_code == 8'h50)) || (DrawX > Ball_X_Pos - 16 && DrawX < Ball_X_Pos + 16 && DrawY > Ball_Y_Pos - 32 && DrawY < Ball_Y_Pos + 32 && (last_key_code == 8'h52 || last_key_code == 8'h51))))
	begin
		if (eaten_sig == 1)
			eaten_in = eaten + 16'd1;
	end*/
	//jodi_small
	if (load_jodi_small && DrawX > Ball_X_Pos- 16 && DrawX < Ball_X_Pos + 16 && DrawY > Ball_Y_Pos - 16 && DrawY < Ball_Y_Pos + 16 ) 
		begin
	   if (sprite == 3'd5)
		begin
			eaten_in = eaten + 16'd10;
			collision[16] = 1'b1;
		end
		else if (sprite == 3'd4)
		begin
			eaten_in = 16'd0;
		end
		else if (sprite == 3'd3 || sprite == 3'd2)
		begin
			life_in = life - 4'd1;
			Reset_fish_in = 1;
		end
		else 			
		begin
			//eaten_in = eaten; 
			fish_x =  Ball_X_Pos;  	                      	                      	                      	     				
			fish_y =  Ball_X_Pos;  	                      	                      	                      	    				
			sprite =  3'd0; 
		end
		end  
	
	//small fish
	if (DrawX > fish_x0 - 16 && DrawX < fish_x0 + 16 && DrawY > fish_y0 - 16 && DrawY < fish_y0 + 16 ) // 0
		begin  
		if (sprite == 3'd0)
		begin
			collision[0] = 1'b1;
			if(eaten >=0)
			begin
				eaten_sig = 1;
				eaten_in = eaten + 16'd1;
			end
		end
		else if (sprite ==	3'd3 || sprite == 3'd2)
			collision[0] = 1'b1;
		else 		
			begin
				fish_x =  fish_x0;                                                                          				//			0
				fish_y =  fish_y0;                                                                          				//			0
				sprite =  sprite0;                                                                           			//			0				
			end
		end                                                                                        					
	if (DrawX > fish_x1 - 16 && DrawX < fish_x1 + 16 && DrawY > fish_y1 - 16 && DrawY < fish_y1 + 16 ) //  1
		begin
		if (sprite == 3'd0)
		begin
			collision[1] = 1'b1;
			if(eaten >=0)
			begin
					eaten_sig = 1;
			eaten_in = eaten + 16'd1;
			end			
		end
		
		else if (sprite ==	3'd3 || sprite == 3'd2)
			collision[1] = 1'b1;
			
		else 
			begin
				fish_x =  fish_x1;                                                                          				//			1
				fish_y =  fish_y1;                                                                          				//			1
				sprite =  sprite1;   
			end						
		end                                                                                        					
	if (DrawX > fish_x2 - 16 && DrawX < fish_x2 + 16 && DrawY > fish_y2 - 16 && DrawY < fish_y2 + 16 ) //  2
		begin
		if (sprite == 3'd0)
		begin
			collision[2] = 1'b1;
			if(eaten >=0)
			begin
			eaten_sig = 1;
			eaten_in = eaten + 16'd1;
			end
		end	
		
		else if (sprite ==	3'd3 || sprite == 3'd2)
			collision[2] = 1'b1;
		else 
			begin			
				fish_x =  fish_x2;                                                                          				//			2
				fish_y =  fish_y2;                                                                          				//			2
				sprite =  sprite2;   
			end																					
		end                                                                                        								
	if (DrawX > fish_x3 - 16 && DrawX < fish_x3 + 16 && DrawY > fish_y3 - 16 && DrawY < fish_y3 + 16 ) //  3
		begin
		if (sprite == 3'd0)
		begin
			collision[3] = 1'b1;
			if(eaten >=0)
			begin
					eaten_sig = 1;
			eaten_in = eaten + 16'd1;
			end
		end
		else if (sprite ==	3'd3 || sprite == 3'd2|| sprite == 3'd0)
			collision[3] = 1'b1;
		else 
			begin				
				fish_x =  fish_x3;                                                                          				
				fish_y =  fish_y3;                                                                         				
				sprite =  sprite3;	
			end
		end      
		
	if (DrawX > fish_x4 - 16 && DrawX < fish_x4 + 16 && DrawY > fish_y4 - 16 && DrawY < fish_y4 + 16 ) 
		begin
		if (sprite == 3'd0)
		begin
			collision[4] = 1'b1;
			if(eaten >=0)
			begin
					eaten_sig = 1;
			eaten_in = eaten + 16'd1;
			end
		end
		else if (sprite ==	3'd3 || sprite == 3'd2|| sprite == 3'd0)
			collision[4] = 1'b1;
		else 
			begin				
				fish_x =  fish_x4;                                                                          			
				fish_y =  fish_y4;                                                                          			
				sprite =  sprite4;			
			end
		end                                                                                        				
	if (DrawX > fish_x5 - 16 && DrawX < fish_x5 + 16 && DrawY > fish_y5 - 16 && DrawY < fish_y5 + 16 )
		begin 
		if (sprite == 3'd0)
		begin
			collision[5] = 1'b1;
			if(eaten >=0)
			begin
			eaten_sig = 1;
			eaten_in = eaten + 16'd1;
			end
		end
		else if (sprite ==	3'd3 || sprite == 3'd2|| sprite == 3'd0)
			collision[5] = 1'b1;
		else 
			begin
			fish_x =  fish_x5;																											
			fish_y =  fish_y5;																											
			sprite =  sprite5;	
			end
		end             	                      	                      	                      	   				
/*		                                   	                      	                      	    		
	if (DrawX > Ball_X_Pos- 16 && DrawX < Ball_X_Pos + 16 && DrawY > Ball_Y_Pos - 16 && DrawY < Ball_Y_Pos + 16 ) 
	begin
		if (eaten_sig == 1)
			eaten_in = eaten + 16'd1;
	end
*/
																																	
clear0_in = (fish_x0  < 0 || fish_x0  > 680 || fish_y0  < 0 || fish_y0  > 480 || collision[0 ] || Reset_fish)? 1'b1 : 1'b0;
clear1_in = (fish_x1  < 0 || fish_x1  > 680 || fish_y1  < 0 || fish_y1  > 480 || collision[1 ] || Reset_fish)? 1'b1 : 1'b0;
clear2_in = (fish_x2  < 0 || fish_x2  > 680 || fish_y2  < 0 || fish_y2  > 480 || collision[2 ] || Reset_fish)? 1'b1 : 1'b0;
clear3_in = (fish_x3  < 0 || fish_x3  > 680 || fish_y3  < 0 || fish_y3  > 480 || collision[3 ] || Reset_fish)? 1'b1 : 1'b0;
clear4_in = (fish_x4  < 0 || fish_x4  > 680 || fish_y4  < 0 || fish_y4  > 480 || collision[4 ] || Reset_fish)? 1'b1 : 1'b0;
clear5_in = (fish_x5  < 0 || fish_x5  > 680 || fish_y5  < 0 || fish_y5  > 480 || collision[5 ] || Reset_fish)? 1'b1 : 1'b0;
clear6_in = (fish_x6  < 0 || fish_x6  > 680 || fish_y6  < 0 || fish_y6  > 480 || collision[6 ] || Reset_fish)? 1'b1 : 1'b0;
clear7_in = (fish_x7  < 0 || fish_x7  > 680 || fish_y7  < 0 || fish_y7  > 480 || collision[7 ] || Reset_fish)? 1'b1 : 1'b0;
clear8_in = (fish_x8  < 0 || fish_x8  > 680 || fish_y8  < 0 || fish_y8  > 480 || collision[8 ] || Reset_fish)? 1'b1 : 1'b0;
clear9_in = (fish_x9  < 0 || fish_x9  > 680 || fish_y9  < 0 || fish_y9  > 480 || collision[9 ] || Reset_fish)? 1'b1 : 1'b0;
clear10_in= (fish_x10 < 0 || fish_x10 > 680 || fish_y10 < 0 || fish_y10 > 480 || collision[10] || Reset_fish)? 1'b1 : 1'b0;
clear11_in= (fish_x11 < 0 || fish_x11 > 680 || fish_y11 < 0 || fish_y11 > 480 || collision[11] || Reset_fish)? 1'b1 : 1'b0;
clear12_in= (fish_x12 < 0 || fish_x12 > 680 || fish_y12 < 0 || fish_y12 > 480 || collision[12] || Reset_fish)? 1'b1 : 1'b0;
clear13_in= (fish_x13 < 0 || fish_x13 > 680 || fish_y13 < 0 || fish_y13 > 480 || collision[13] || Reset_fish)? 1'b1 : 1'b0;
clear14_in= (fish_x14 < 0 || fish_x14 > 680 || fish_y14 < 0 || fish_y14 > 480 || collision[14] || Reset_fish)? 1'b1 : 1'b0;
clear15_in= (fish_x15 < 0 || fish_x15 > 680 || fish_y15 < 0 || fish_y15 > 480 || collision[15] || Reset_fish)? 1'b1 : 1'b0;
clear16_in= (fish_x16 < 0 || fish_x16 > 680 || fish_y16 < 0 || fish_y16 > 480 || collision[16] || Reset_fish)? 1'b1 : 1'b0;


newInput0  = (clear0  == 1 || reg_out0  == 32'd0  )? fish_data : reg_out0 + 32'd2 ;
newInput1  = (clear1  == 1 || reg_out1  == 32'd0  )? fish_data : reg_out1 + 32'd3 ;
newInput2  = (clear2  == 1 || reg_out2  == 32'd0  )? fish_data : reg_out2 + 32'd3 ;
newInput3  = (clear3  == 1 || reg_out3  == 32'd0  )? fish_data : reg_out3 + 32'd3 ;
newInput4  = (clear4  == 1 || reg_out4  == 32'd0  )? fish_data : reg_out4 + 32'd2 ;
newInput5  = (clear5  == 1 || reg_out5  == 32'd0  )? fish_data : reg_out5 + 32'd3 ;
newInput6  = (clear6  == 1 || reg_out6  == 32'd0  )? fish_data : reg_out6 + 32'd4 ;
newInput7  = (clear7  == 1 || reg_out7  == 32'd0  )? fish_data : reg_out7 + 32'd4 ;
newInput8  = (clear8  == 1 || reg_out8  == 32'd0  )? fish_data : reg_out8 + 32'd4 ;
newInput9  = (clear9  == 1 || reg_out9  == 32'd0  )? fish_data : reg_out9 + 32'd5 ;
newInput10 = (clear10 == 1 || reg_out10 == 32'd0  )? fish_data : reg_out10+ 32'd3 ;
newInput11 = (clear11 == 1 || reg_out11 == 32'd0  )? fish_data : reg_out11+ 32'd4 ;
newInput12 = (clear12 == 1 || reg_out12 == 32'd0  )? fish_data : reg_out12+ 32'd3 ;
newInput13 = (clear13 == 1 || reg_out13 == 32'd0  )? fish_data : reg_out13+ 32'd1 ;
newInput14 = (clear14 == 1 || reg_out14 == 32'd0  )? fish_data : reg_out14+ 32'd3 ;
newInput15 = (clear15 == 1 || reg_out15 == 32'd0  )? fish_data : reg_out15+ 32'd2 ;
newInput16 = (clear16 == 1 || reg_out16 == 32'd0  )? fish_data : reg_out16+ 32'd5 ;


if (life == 0)
begin
clear0_in  = 1;
clear1_in  = 1;
clear2_in  = 1;
clear3_in  = 1;
clear4_in  = 1;
clear5_in  = 1;
clear6_in  = 1;
clear7_in  = 1;
clear8_in  = 1;
clear9_in  = 1;
clear10_in = 1;
clear11_in = 1;
clear12_in = 1;
clear13_in = 1;
clear14_in = 1;
clear15_in = 1;
clear16_in = 1;
clear_jodi_small = 1;
clear_jodi_med   = 1;
clear_jodi_large = 1;
sprite = 3'b110;
end

end 
reg_32 R0  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear0  ), .Load(load0 ),  .D(newInput0),  .Data_Out(reg_out0)) ;  //small fish  
reg_32 R1  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear1  ), .Load(load1 ),  .D(newInput1),  .Data_Out(reg_out1)) ;  //small fish 
reg_32 R2  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear2  ), .Load(load2 ),  .D(newInput2),  .Data_Out(reg_out2)) ;  //small fish 
reg_32 R3  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear3  ), .Load(load3 ),  .D(newInput3),  .Data_Out(reg_out3)) ;  //small fish
reg_32 R4  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear4  ), .Load(load4 ),  .D(newInput4),  .Data_Out(reg_out4)) ;  //small fish 
reg_32 R5  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear5  ), .Load(load5 ),  .D(newInput5),  .Data_Out(reg_out5)) ;  //small fish 
reg_32 R6  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear6  ), .Load(load6 ),  .D(newInput6),  .Data_Out(reg_out6)) ;  //med fish 
reg_32 R7  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear7  ), .Load(load7 ),  .D(newInput7),  .Data_Out(reg_out7)) ;  //med fish 
reg_32 R8  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear8  ), .Load(load8 ),  .D(newInput8),  .Data_Out(reg_out8)) ;  //med fish 
reg_32 R9  (.Clk(frame_clk_rising_edge), .Reset(RESET || clear9  ), .Load(load9 ),  .D(newInput9),  .Data_Out(reg_out9)) ;  //med fish 
reg_32 R10 (.Clk(frame_clk_rising_edge), .Reset(RESET || clear10 ), .Load(load10),  .D(newInput10), .Data_Out(reg_out10));  //large fish 
reg_32 R11 (.Clk(frame_clk_rising_edge), .Reset(RESET || clear11 ), .Load(load11),  .D(newInput11), .Data_Out(reg_out11));  //large fish
reg_32 R12 (.Clk(frame_clk_rising_edge), .Reset(RESET || clear12 ), .Load(load12),  .D(newInput12), .Data_Out(reg_out12));  //large fish 
reg_32 R13 (.Clk(frame_clk_rising_edge), .Reset(RESET || clear13 ), .Load(load13),  .D(newInput13), .Data_Out(reg_out13));  //large fish 
reg_32 R14 (.Clk(frame_clk_rising_edge), .Reset(RESET || clear14 ), .Load(load14),  .D(newInput14), .Data_Out(reg_out14));  //jelly 
reg_32 R15 (.Clk(frame_clk_rising_edge), .Reset(RESET || clear15 ), .Load(load15),  .D(newInput15), .Data_Out(reg_out15));  //jelly 
reg_32 prof(.Clk(frame_clk_rising_edge), .Reset(RESET || clear16 ), .Load(load16),  .D(newInput16), .Data_Out(reg_out16));  //prof right

reg_32 jodi_small (.Clk(frame_clk_rising_edge), .Reset(RESET || clear_jodi_small), .Load(load_jodi_small),  .D(new_jodi_small), .Data_Out(out_jodi_small));  //small jodi 
reg_32 jodi_med   (.Clk(frame_clk_rising_edge), .Reset(RESET || clear_jodi_med  ), .Load(load_jodi_med)  ,  .D(new_jodi_med)  , .Data_Out(out_jodi_med  ));  //med jodi 
reg_32 jodi_large (.Clk(frame_clk_rising_edge), .Reset(RESET || clear_jodi_large), .Load(load_jodi_large),  .D(new_jodi_large), .Data_Out(out_jodi_large));  //large jodi 


endmodule

module reg_32 (input  logic Clk, Reset, Load, //active high
              input  logic [31:0]  D,
              output logic [31:0]  Data_Out);

    always_ff @ (posedge Clk, posedge Reset)
    begin
	 	 if (Reset) //notice, this is an asycnrhonous reset
			  Data_Out <= 32'b0;
		 else if (Load)
			  Data_Out <= D;	
    end
endmodule

/*
module mux_3to1 (
						input  logic [31:0]  fish_data,
						input  logic [31:0]  reg_val,
						input  logic clear, reg_out, col,
						output logic [31:0]  Data_Out);

    always_comb
    begin
	 	 if (clear || col) //notice, this is a sycnrhonous reset, which is recommended on the FPGA 
			  Data_Out = 32'b0;
		 else if (Load)
			  Data_Out <= D;	
    end
endmodule*/