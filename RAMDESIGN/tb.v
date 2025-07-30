`timescale 1ns / 1ps

module tb_ram;
    reg clk, rst;
    reg we, re;
    reg [3:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    ram uut (
        .clk(clk),
        .rst(rst),
        .we(we),
        .re(re),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Time\tWE\tRE\tADDR\tDIN\tDOUT");
        $monitor("%0t\t%b\t%b\t%h\t%h\t%h", $time, we, re, addr, din, dout);

        // Initialize
        clk = 0; rst = 1; we = 0; re = 0; addr = 0; din = 0; #10;
        rst = 0;

        // Write Data
        addr = 4'h1; din = 8'hAA; we = 1; re = 0; #10;
        addr = 4'h2; din = 8'hBB; #10;
        addr = 4'h3; din = 8'hCC; #10;

        // Read Data
        we = 0; re = 1;
        addr = 4'h1; #10;
        addr = 4'h2; #10;
        addr = 4'h3; #10;

        // Done
        $finish;
    end
endmodule
