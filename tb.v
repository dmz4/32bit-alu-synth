// File: tb.v
// Author: Diego Dominguez
// Hierarchy: tb -> alu_v1
// Function: applies 100 randomized input vectors and dumps a VCD trace.
// Parameters: none. Clock domains: none; the DUT is combinational.
// Timing: no clocked checks; vectors are sampled after 1 ns delays.
`timescale 1ns / 1ps
module tb;
  reg [31:0] a, b;
  reg [3:0] op;
  wire [31:0] result;
  integer i;

  alu_v1 uut (
    .a(a),
    .b(b),
    .op(op),
    .result(result)
  );


  initial 
    begin
      $monitor($time, " a=%d b=%d op=%b result=%d", a, b, op, result);
      $dumpfile("tb.vcd");
      $dumpvars(0, tb);
    
    end

  initial
    begin
      a = 0;
      b = 0;
      op = 0;

      #1;

      for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        op = $unsigned($random) % 9; // Random operation between 0 and 8
        
        #1;
      end
      $finish;
    end

endmodule