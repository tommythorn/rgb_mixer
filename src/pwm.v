`default_nettype none
`timescale 1ns/1ns
module pwm (
    input wire clk,
    input wire reset,
    input wire [7:0] level,
    output wire out
    );
   parameter width = 8;
   reg [width-1:0] counter;
   assign out = reset ? 1'd 0 : counter < level;
   always @(posedge clk) counter <= reset ? 0 : counter + 1'd 1;
endmodule
