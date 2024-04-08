//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module feeding_frenzy( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX6, HEX7,//HEX5,
				 // SRAM
				 /*output logic CE, UB, LB, OE, WE,
				 output logic [19:0] SRAM_ADDR,
				 inout wire [15:0] Data, //tristate buffers need to be of type wire
*/
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				//SRAM Interface for Nios II Software
				 inout wire   [15:0]	SRAM_DQ, 	  //sram_wire.DQ
				 output logic [19:0] SRAM_ADDR, 	  //.ADDR
				 output logic  		SRAM_LB_N, 	  //.LB_N
				 output logic        SRAM_UB_N,     //.UB_N
				 output logic 			SRAM_CE_N,	  //.CE_N
				 output logic        SRAM_OE_N,     //.OE_N
				 output logic 			SRAM_WE_N	  //.WE_N
				 				
                    );
    logic [15:0] Data_value, Data_to_SRAM, Data_from_SRAM;
	 assign Data_value = {{Data_from_SRAM[7:0]}, {Data_from_SRAM[15:8]}};
    
	 logic [9:0]   DrawX, DrawY;       // Current pixel coordinates
    logic  is_ball;

	 logic [15:0] eaten;
	 logic [3:0] life;
	 logic Reset_fish; 
 
	 
    logic Reset_h, Clk;
    logic [15:0] keycode;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
	 assign SRAM_OE_N = 1'b0;
	 assign SRAM_WE_N = 1'b1;
	 //assign SRAM_ADDR = 20'd0;

	 logic Reset_ball;
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
				Reset_ball <= ~(KEY[2]);
	 end
    
	 always_ff @ (posedge Clk) begin
        if(Reset_h)
		  begin
            VGA_CLK <= 1'b0;
		  end
		  else
		  begin
            VGA_CLK <= ~VGA_CLK;
		  end
    end
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs;

	 tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~SRAM_WE_N), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(SRAM_DQ)
);
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)
    );
  	 logic [31:0] fish_data;
	 logic [15:0] hw;
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),      /////////////////////////////////////////NEED COMMA
									  .data_from_sof_export(fish_data),   //   data_from_sof.export
									  .hardware_sig_export(hw)
   );
 
  
  
    // Use PLL to generate the 25MHZ VGA_CLK. Do not modify it.
    // vga_clk vga_clk_instance(
    //     .clk_clk(Clk),
    //     .reset_reset_n(1'b1),
    //     .altpll_0_c0_clk(VGA_CLK),
    //     .altpll_0_areset_conduit_export(),    
    //     .altpll_0_locked_conduit_export(),
    //     .altpll_0_phasedone_conduit_export()
    // );

    
    // TODO: Fill in the connections for the rest of the modules 
	 
	 VGA_controller vga_controller_instance(
										.Clk,         // 50 MHz clock
                              .Reset(Reset_h),       // Active-high reset signal
										.VGA_HS,      // Horizontal sync pulse.  Active low
                              .VGA_VS,      // Vertical sync pulse.  Active low
										.VGA_CLK,     // 25 MHz VGA clock input
										.VGA_BLANK_N, // Blanking interval indicator.  Active low.
                              .VGA_SYNC_N,  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                              // but the video DAC on the DE2 board requires an input for it.
										.DrawX,       // horizontal coordinate
                              .DrawY        // vertical coordinate
                        );  

  	 logic [9:0] Ball_X_Pos,	Ball_Y_Pos;	
    ball ball_instance(      
									  .Clk,                // 50 MHz clock
                             .Reset(Reset_ball ||Reset_fish),              // Active-high reset signal
                             .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
                             .DrawX, 
									  .DrawY,       // Current pixel coordinates
									  .keycode,
                             .is_ball,             // Whether current pixel belongs to ball or background
									  .Ball_X_Pos,	
									  .Ball_Y_Pos
							  );
    
    color_mapper color_instance( 
	 									.Clk,                // 50 MHz clock
										.VGA_VS,
										.VGA_CLK,
										.Reset(Reset_h),       // Active-high reset signal
										.SRAM_out(Data_value),
										.Ball_X_Pos,.Ball_Y_Pos,
										.frame_clk(Clk),
										.hw,
										.fish_data,								
										.DrawX, 
										.DrawY,       // Current pixel coordinates
										.keycode,
										.VGA_R, 
										.VGA_G, 
										.VGA_B, // VGA RGB output
										.SRAM_ADDR,
										.eaten,
										.life,
										.Reset_fish
										);	
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (eaten[3:0], HEX0);
    HexDriver hex_inst_1 (eaten[7:4], HEX1);
	 HexDriver hex_inst_2 (eaten[11:8], HEX2);
    HexDriver hex_inst_3 (eaten[15:12], HEX3);
	 
	 HexDriver hex_inst_4 (life, HEX4);
    //HexDriver hex_inst_5 (VGA_R[7:4], HEX5);
	 HexDriver hex_inst_6 (keycode[3:0], HEX6);
    HexDriver hex_inst_7 (keycode[7:4], HEX7);
//	 HexDriver hex_inst_2 (keycode[3:0], HEX4);

endmodule
