`default_nettype none
`timescale 1ns/1ns
module rgb_mixer (
    input clk,
    input reset,
    input enc0_a,
    input enc0_b,
    input enc1_a,
    input enc1_b,
    input enc2_a,
    input enc2_b,
    output pwm0_out,
    output pwm1_out,
    output pwm2_out
);

   wire enc0_a, enc0_b, enc1_a, enc1_b, enc2_a, enc2_b;
   wire enc0_a_debounced, enc0_b_debounced, enc1_a_debounced,
        enc1_b_debounced, enc2_a_debounced, enc2_b_debounced;
   wire [7:0] enc0, enc1, enc2;

   debounce debounce0_a(clk, reset, enc0_a, enc0_a_debounced);
   debounce debounce0_b(clk, reset, enc0_b, enc0_b_debounced);
   encoder  encoder_0(clk, reset, enc0_a_debounced, enc0_b_debounced, enc0);
   pwm      pwm0(clk, reset, enc0, pwm0_out);

   debounce debounce1_a(clk, reset, enc1_a, enc1_a_debounced);
   debounce debounce1_b(clk, reset, enc1_b, enc1_b_debounced);
   encoder  encoder_1(clk, reset, enc1_a_debounced, enc1_b_debounced, enc1);
   pwm      pwm1(clk, reset, enc1, pwm1_out);

   debounce debounce2_a(clk, reset, enc2_a, enc2_a_debounced);
   debounce debounce2_b(clk, reset, enc2_b, enc2_b_debounced);
   encoder  encoder_2(clk, reset, enc2_a_debounced, enc2_b_debounced, enc2);
   pwm      pwm2(clk, reset, enc2, pwm2_out);
endmodule
