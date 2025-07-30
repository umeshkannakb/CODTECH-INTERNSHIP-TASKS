
module alu (
    input  [3:0]  a,       // 4-bit input A
    input  [3:0]  b,       // 4-bit input B
    input  [2:0]  sel,     // Operation selector
    output reg [3:0] result,
    output reg       carry_out,
    output reg       zero
);

    always @(*) begin
        carry_out = 0;
        case (sel)
            3'b000: {carry_out, result} = a + b;       // Addition
            3'b001: {carry_out, result} = a - b;       // Subtraction
            3'b010: result = a & b;                    // AND
            3'b011: result = a | b;                    // OR
            3'b100: result = ~a;                       // NOT (on A)
            default: result = 4'b0000;
        endcase

        zero = (result == 4'b0000) ? 1'b1 : 1'b0;
    end
endmodule
