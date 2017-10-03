`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Aerotenna 
// Engineer: Yan Li
// 
// Create Date: 08/05/2015 02:16:34 PM
// Design Name: 
// Module Name: pulse_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pulse_buffer(
    input clk,
    input reset,
    input pulse_in,
    output rdy,
    output [31:0] pulse_data,
    input rd
    );
    
    
    wire rd_en;
    wire wr_en;
    wire [31:0] pulse_data_out;
    wire got_pulse;
    wire [8:0] rd_count;
    wire [8:0] wr_count;
    wire fifo_empty;
    wire fifo_full;
    
    FIFO_SYNC_MACRO #(
    .DEVICE("7SERIES"),
    .ALMOST_EMPTY_OFFSET(9'h080),
    .ALMOST_FULL_OFFSET(9'h080),
    .DATA_WIDTH(32),
    .DO_REG(0),
    .FIFO_SIZE("18Kb")
    ) FIFO_SYNC_MACRO_inst (
    //.ALMOSTEMPTY(ALMOSTEMPTY),
    //.ALMOSTFULL(ALMOSTFULL),
    .DO(pulse_data),
    .EMPTY(fifo_empty),
    .FULL(fifo_full),
    .RDCOUNT(rd_count),
    //.RDERR(RDERR),
    .WRCOUNT(wr_count),
    //.WRERR(WRERR),
    .CLK(clk),
    .DI(pulse_data_out),
    .RDEN(rd_en),
    .RST(reset),
    .WREN(wr_en)
    );
    

    
    
    pulse_timer pulse_timer_inst(
    .clk(clk),
    .reset(1'b0),
    .pulse_in(pulse_in),
    .rdy(got_pulse),
    .value(pulse_data_out[31]),
    .counter(pulse_data_out[30:0])
    );
    
    
    assign rd_en = ( rd&~fifo_empty )|fifo_full;
    assign wr_en = got_pulse;
    assign rdy = ~fifo_empty;
    
    
endmodule
