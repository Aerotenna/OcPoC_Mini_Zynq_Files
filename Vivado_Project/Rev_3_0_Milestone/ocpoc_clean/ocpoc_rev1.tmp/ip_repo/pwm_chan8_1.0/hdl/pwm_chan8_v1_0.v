
`timescale 1 ns / 1 ps

	module pwm_chan8_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 6
	)
	(
		// Users to add ports here
        output wire pwm0,
        output wire pwm1,
        output wire pwm2,
        output wire pwm3,
        output wire pwm4,
        output wire pwm5,
        output wire pwm6,
        output wire pwm7,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
	
	wire [C_S00_AXI_DATA_WIDTH-1 : 0] period0, period1, period2, period3, period4, period5, period6, period7;
	wire [C_S00_AXI_DATA_WIDTH-1 : 0] hi0, hi1, hi2, hi3, hi4, hi5, hi6, hi7;
	
// Instantiation of Axi Bus Interface S00_AXI
	pwm_chan8_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) pwm_chan8_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.slv_reg0(period0),
		.slv_reg1(hi0),
		.slv_reg2(period1),
        .slv_reg3(hi1),
        .slv_reg4(period2),
        .slv_reg5(hi2),
        .slv_reg6(period3),
        .slv_reg7(hi3),
        .slv_reg8(period4),
        .slv_reg9(hi4),
        .slv_reg10(period5),
        .slv_reg11(hi5),    
        .slv_reg12(period6),
        .slv_reg13(hi6),
        .slv_reg14(period7),
        .slv_reg15(hi7)                                           
	);

	// Add user logic here
    pwm_chan pwm_inst0  (
        .clk(s00_axi_aclk),
        .reset(~s00_axi_aresetn),
        .period(period0),
        .hi(hi0),
        .pwm(pwm0));
        
    pwm_chan pwm_inst1  (
       .clk(s00_axi_aclk),
       .reset(~s00_axi_aresetn),
       .period(period1),
       .hi(hi1),
       .pwm(pwm1));
               
    pwm_chan pwm_inst2  (
        .clk(s00_axi_aclk),
        .reset(~s00_axi_aresetn),
        .period(period2),
        .hi(hi2),
        .pwm(pwm2));  
                                 
    pwm_chan pwm_inst3  (
        .clk(s00_axi_aclk),
        .reset(~s00_axi_aresetn),
        .period(period3),
        .hi(hi3),
        .pwm(pwm3));
        
    pwm_chan pwm_inst4  (
        .clk(s00_axi_aclk),
        .reset(~s00_axi_aresetn),
        .period(period4),
        .hi(hi4),
        .pwm(pwm4));
        
    pwm_chan pwm_inst5  (
        .clk(s00_axi_aclk),
        .reset(~s00_axi_aresetn),
        .period(period5),
        .hi(hi5),
        .pwm(pwm5));
                 
     pwm_chan pwm_inst6  (
        .clk(s00_axi_aclk),
        .reset(~s00_axi_aresetn),
        .period(period6),
        .hi(hi6),
        .pwm(pwm6)); 
                                  
     pwm_chan pwm_inst7  (
       .clk(s00_axi_aclk),
       .reset(~s00_axi_aresetn),
       .period(period7),
       .hi(hi7),
       .pwm(pwm7));
	// User logic ends

	endmodule
