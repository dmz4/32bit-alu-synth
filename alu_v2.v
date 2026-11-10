// File: alu_v2.v
// Author: Diego Dominguez
// Hierarchy: alu_v2 -> add_lca -> add_lca_4bits.
// Function: 32-bit ALU using a lookahead carry adder for arithmetic and SLT.
// Parameters: none. Clock domains: none; all logic is combinational.
// Timing: reported critical path is a[1] to result[0] (562.02 ps).
module alu_v2(
  input [31:0] a,
  input [31:0] b,
  input [3:0] op,
  output reg [31:0] result
);

  wire [31:0] sum, sub;
  wire slt, overflow;

  add_lca addition (
    .A(a),
    .B(b),
    .Cin(1'b0),
    .Y(sum)
  );

  add_lca substracion (
    .A(a),
    .B(~b),
    .Cin(1'b1),
    .Y(sub)
  );

  assign overflow = (a[31] & ~b[31] & ~sub[31])
    | (~a[31] & b[31] & sub[31]);

  always @(*) begin
    case (op)
      4'b0000: result = sum;
      4'b0001: result = sub;
      4'b0010: result = a & b;
      4'b0011: result = a | b;
      4'b0100: result = a ^ b;
      4'b0101: result = ~a;
      4'b0110: result = a << 1;
      4'b0111: result = a >> 1;
      4'b1000: result = {{31{1'b0}}, sub[31] ^ overflow};
      default: result = 32'b0;
    endcase
  end
endmodule