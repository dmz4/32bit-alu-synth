// File: tb.v
// Author: Diego Dominguez
// Hierarchy: tb -> alu_v1 and alu_v2.
// Function: drives both ALUs with 100 shared random input vectors.
// Parameters: none. Clock domains: none; both DUTs are combinational.
// Timing: no clocked checks; vectors are sampled after 1 ns delays.
`timescale 1ns / 1ps
module tb;
  reg [31:0] a1, b1, a2, b2;
  reg [3:0] op1, op2;
  wire [31:0] result1, result2;
  integer i;

  alu_v1 alu_v1_inst (
    .a(a1),
    .b(b1),
    .op(op1),
    .result(result1)
  );

  alu_v2 alu_v2_inst (
    .a(a2),
    .b(b2),
    .op(op2),
    .result(result2)
  );
  initial begin
    $monitor($time,
      " a=%d b=%d op=%b alu_v1=%d alu_v2=%d",
      a1, b1, op1, result1, result2);
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  initial begin
    a1 = 0;
    b1 = 0;
    op1 = 0;
    a2 = 0;
    b2 = 0;
    op2 = 0;

    #1;

    for (i = 0; i < 100; i = i + 1) begin
      a1 = $random;
      b1 = $random;
      op1 = $unsigned($random) % 9;
      a2 = a1;
      b2 = b1;
      op2 = op1;

      #1;
    end
    $finish;
  end

endmodule