
`timescale 1ns / 1ps

module tb_alu;
    reg  [3:0] a, b;
    reg  [2:0] sel;
    wire [3:0] result;
    wire       carry_out;
    wire       zero;

    alu uut (
        .a(a),
        .b(b),
        .sel(sel),
        .result(result),
        .carry_out(carry_out),
        .zero(zero)
    );

    initial begin
        $display("Time\t A\tB\tSel\tResult\tCarry\tZero");
        $monitor("%0t\t %b\t%b\t%b\t%b\t%b\t%b", $time, a, b, sel, result, carry_out, zero);

        // Test ADD
        a = 4'b0101; b = 4'b0011; sel = 3'b000; #10;
        
        // Test SUB
        a = 4'b0101; b = 4'b0001; sel = 3'b001; #10;

        // Test AND
        a = 4'b1100; b = 4'b1010; sel = 3'b010; #10;

        // Test OR
        a = 4'b1100; b = 4'b1010; sel = 3'b011; #10;

        // Test NOT
        a = 4'b1010; b = 4'b0000; sel = 3'b100; #10;

        // Test invalid opcode
        sel = 3'b111; #10;

        $finish;
    end
endmodule
