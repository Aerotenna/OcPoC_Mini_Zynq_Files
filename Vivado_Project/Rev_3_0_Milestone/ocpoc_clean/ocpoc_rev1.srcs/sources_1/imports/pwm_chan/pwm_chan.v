`timescale 1ns / 1ps

module pwm_chan (
input clk,
input reset,
input [31:0] period,
input [31:0] hi,
output pwm);

reg [31:0] counter;
reg [31:0] period_prev;

initial begin
counter = 32'd0;
period_prev = 32'd0;
end

always@(posedge clk)
   begin
      if ( reset )
         counter <= 32'd0;
      else 
         if ( counter == period -1 || period_prev != period )
            begin
               counter <= 32'd0;
               if ( period_prev != period )
                  period_prev <= period;
            end
          else
             counter <= counter + 32'd1;
   
   end
   
   assign pwm = ( counter < hi)? 1: 0;
endmodule 