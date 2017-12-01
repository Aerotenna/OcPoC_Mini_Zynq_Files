`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Aerotenna
// Engineer: Yan Li
// 
// Create Date: 08/04/2015 04:45:13 PM
// Design Name: 
// Module Name: pulse_timer
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


module pulse_timer(
   input clk,
   input reset,
   input pulse_in,
   output rdy,
   output value,
   output [30:0] counter
    );
    
   reg r_end_pulse;
   reg r_prev_input;
   reg r_pulse_in;
   reg r_value;
   reg [30:0] r_counter;
   reg [30:0] tick_counter;
   
   
   initial begin
      r_counter <= 31'd0;
      tick_counter <= 31'd0;
   end
   
   
   always@(posedge clk)
      begin 
         if ( reset )
            begin
               r_counter <= 31'd0;
               tick_counter <= 31'd0;
               r_prev_input <= 1'b0;
               r_pulse_in <= 1'b0;
               r_end_pulse <= 1'b0;
            end
         else
            r_pulse_in <= pulse_in;
            r_prev_input <= r_pulse_in;
            if (r_pulse_in != r_prev_input ) 
               begin
                  tick_counter <= 0;
                  r_counter <= tick_counter + 31'd1;
                  r_end_pulse <= 1'b1;
                  r_value <= r_prev_input;
               end
            else
               begin
                  tick_counter <= tick_counter + 31'd1;
                  r_counter <= r_counter;
                  r_value <= r_value;
                  r_end_pulse <= 1'b0;
               end   
      end
      
   assign rdy = r_end_pulse;
   assign value = r_value;
   assign counter = r_counter;
endmodule
