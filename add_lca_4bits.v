// File: add_lca_4bits.v
// Author: Diego Dominguez
// Hierarchy: add_lca_4bits (instantiated by add_lca).
// Function: four-bit lookahead carry adder group.
// Parameter: N defaults to 4; this implementation is wired for four-bit
// slices.
// Clock domains: none; all logic is combinational.
// Timing: local carry terms determine each group's sum and group-generate.
module add_lca_4bits #(parameter N = 4)(
  input [N-1:0] A,
  input [N-1:0] B,
  input Cin,
  output Gg,
  output Pg,
  output [N-1:0] Y
);

  wire [N-1:0] g, p;
  wire [N-2:0] c;

  // g[i] and p[i] are the generate and propagate signals for bit i.
  assign c[0] = g[0] | (p[0] & Cin);
  assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin);
  assign c[2] = g[2] | (p[2] & g[1])
    | (p[2] & p[1] & g[0])
    | (p[2] & p[1] & p[0] & Cin);

  assign Gg = g[3] | (p[3] & g[2])
    | (p[3] & p[2] & g[1])
    | (p[3] & p[2] & p[1] & g[0]);
  assign Pg = p[3] & p[2] & p[1] & p[0];

  genvar i;
  generate
    for(i = 0; i < N; i = i + 1) begin : gen_prop
      assign g[i] = A[i] & B[i];
      assign p[i] = A[i] ^ B[i];

      if (i == 0) begin
        assign Y[i] = p[i] ^ Cin;
      end else begin
        assign Y[i] = p[i] ^ c[i-1];
      end

    end
  endgenerate

endmodule