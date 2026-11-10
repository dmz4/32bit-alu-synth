// File: add_lca.v
// Author: Diego Dominguez
// Hierarchy: add_lca -> eight add_lca_4bits blocks.
// Function: 32-bit grouped lookahead carry adder with carry-in and carry-out.
// Parameter: N defaults to 32; this implementation is wired for 32-bit
// inputs.
// Clock domains: none; all logic is combinational.
// Timing: group carry logic forms the adder's long combinational path.
module add_lca #(parameter N = 32)(
  input [N-1:0] A,
  input [N-1:0] B,
  input Cin,
  output [N-1:0] Y,
  output Cout
);

  localparam n = N >> 2;
  localparam j = 4;
  // Gsg and Psg hold generate/propagate signals for each four-bit group.
  wire [n-1:0] Gsg, Psg;
  wire [1:0] Gg, Pg;
  wire [7:0] c;

  add_lca_4bits sum3_0 (
    .A(A[3:0]),
    .B(B[3:0]),
    .Cin(Cin),
    .Gg(Gsg[0]),
    .Pg(Psg[0]),
    .Y(Y[3:0])
  );

  add_lca_4bits sum7_4 (
    .A(A[7:4]),
    .B(B[7:4]),
    .Cin(c[0]),
    .Gg(Gsg[1]),
    .Pg(Psg[1]),
    .Y(Y[7:4])
  );

  add_lca_4bits sum11_8 (
    .A(A[11:8]),
    .B(B[11:8]),
    .Cin(c[1]),
    .Gg(Gsg[2]),
    .Pg(Psg[2]),
    .Y(Y[11:8])
  );

  add_lca_4bits sum15_12 (
    .A(A[15:12]),
    .B(B[15:12]),
    .Cin(c[2]),
    .Gg(Gsg[3]),
    .Pg(Psg[3]),
    .Y(Y[15:12])
  );

  add_lca_4bits sum19_16 (
    .A(A[19:16]),
    .B(B[19:16]),
    .Cin(c[3]),
    .Gg(Gsg[4]),
    .Pg(Psg[4]),
    .Y(Y[19:16])
  );

  add_lca_4bits sum23_20 (
    .A(A[23:20]),
    .B(B[23:20]),
    .Cin(c[4]),
    .Gg(Gsg[5]),
    .Pg(Psg[5]),
    .Y(Y[23:20])
  );

  add_lca_4bits sum27_24 (
    .A(A[27:24]),
    .B(B[27:24]),
    .Cin(c[5]),
    .Gg(Gsg[6]),
    .Pg(Psg[6]),
    .Y(Y[27:24])
  );

  add_lca_4bits sum31_28 (
    .A(A[31:28]),
    .B(B[31:28]),
    .Cin(c[6]),
    .Gg(Gsg[7]),
    .Pg(Psg[7]),
    .Y(Y[31:28])
  );

  // c[k] is the carry-in to group k+1.
  assign c[0] = Gsg[0] | (Psg[0] & Cin);
  assign c[1] = Gsg[1] | (Psg[1] & Gsg[0]) | (Psg[1] & Psg[0] & Cin);
  assign c[2] = Gsg[2] | (Psg[2] & Gsg[1])
    | (Psg[2] & Psg[1] & Gsg[0])
    | (Psg[2] & Psg[1] & Psg[0] & Cin);

  assign Gg[0] = Gsg[3] | (Psg[3] & Gsg[2])
    | (Psg[3] & Psg[2] & Gsg[1])
    | (Psg[3] & Psg[2] & Psg[1] & Gsg[0]);

  assign Pg[0] = Psg[3] & Psg[2] & Psg[1] & Psg[0];


  assign c[3] = Gg[0] | (Pg[0] & Cin);

  assign c[4] = Gsg[4] | (Psg[4] & Gg[0]) | (Psg[4] & Pg[0] & Cin);
  assign c[5] = Gsg[5] | (Psg[5] & Gsg[4])
    | (Psg[5] & Psg[4] & Gg[0])
    | (Psg[5] & Psg[4] & Pg[0] & Cin);
  assign c[6] = Gsg[6] | (Psg[6] & Gsg[5])
    | (Psg[6] & Psg[5] & Gsg[4])
    | (Psg[6] & Psg[5] & Psg[4] & Gg[0])
    | (Psg[6] & Psg[5] & Psg[4] & Pg[0] & Cin);

  assign Gg[1] = Gsg[7] | (Psg[7] & Gsg[6])
    | (Psg[7] & Psg[6] & Gsg[5])
    | (Psg[7] & Psg[6] & Psg[5] & Gsg[4]);
  assign Pg[1] = Psg[7] & Psg[6] & Psg[5] & Psg[4];

  assign Cout = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & Cin);

endmodule