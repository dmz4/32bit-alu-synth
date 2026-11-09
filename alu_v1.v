// File: alu_v1.v
// Author: Diego Dominguez
// Hierarchy: alu_v1 (top-level combinational module)
// Function: 32-bit ALU selected by the 4-bit op input.
// Parameters: none. Clock domains: none; all logic is combinational.
// Timing: reported critical path is b[1] to result[31].
// The supplied ABC report has 35 logic levels on this path.
module alu_v1(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output reg [31:0] result
);

    always @(*) begin
            case (op)
                4'b0000: result <= a + b; // Addition
                4'b0001: result <= a - b; // Subtraction
                4'b0010: result <= a & b; // AND
                4'b0011: result <= a | b; // OR
                4'b0100: result <= a ^ b; // XOR
                4'b0101: result <= ~a;     // NOT
                4'b0110: result <= a << 1; // Shift left
                4'b0111: result <= a >> 1; // Shift right
                4'b1000: result <= ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // Less than
                default: result <= 32'b0;
            endcase
        end
endmodule