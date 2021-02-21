`default_nettype none
`timescale 1ns/1ns
module encoder (
    input clk,
    input reset,
    input a,
    input b,
    output reg [7:0] value
);

   reg oa, ob, error;
   always @(posedge clk) {oa, ob} <= reset ? 0 : {a, b};

   /* Pulsetrain B is slightly offset from A, so if we see events in
    the expected order, we are moving clockwise, otherwise
    counterclock-wise.  There are a total of 4 events (pos and neg and
    each of A and B) and for each event we could be moving either CW
    or CCW.  That covers 8 of the 16 values.  Another 4 correspond to
    idle, and the final four correspond to coincident transitions
    which should be impossible by the contract of the encoder.  We
    will catch and report those.
    */

   reg inc, dec;
   always @(*) begin
      inc = 0;
      dec = 0;
      error = 0;
      case ({oa,a,ob,b}) // NB: I put old before new
// Matt wants to ignore half the events.  Moving on.

        4'b0000: ;          // idle
        4'b0001: dec = 1;   // CCW
//      4'b0010: inc = 1;   // CW
        4'b0011: ;          // idle
        4'b0100: inc = 1;   // CW
        4'b0101: error = 1; // error
        4'b0110: error = 1; // error
//      4'b0111: dec = 1;   // CCW
//      4'b1000: dec = 1;   // CCW
        4'b1001: error = 1; // error
        4'b1010: error = 1; // error
        4'b1011: inc = 1;   // CW
        4'b1100: ;          // idle
//      4'b1101: inc = 1;   // CW
        4'b1110: dec = 1;   // CCW
        4'b1111: ;          // idle
      endcase
   end

   wire en  = inc | dec;
   always @(posedge clk)
     if (reset)
       value <= 0;
     else if (en)
       value <= inc ? value + 1 : value - 1;
endmodule
