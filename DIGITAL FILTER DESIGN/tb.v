`timescale 1ns/1ps

module tb_fir_filter;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter COEFF_WIDTH = 8;
    parameter TAPS = 4;

    // Signals
    reg clk = 0;
    reg rst;
    reg signed [DATA_WIDTH-1:0] sample_in;
    reg sample_valid;
    wire signed [DATA_WIDTH+COEFF_WIDTH+1:0] sample_out;
    wire sample_out_valid;

    // Instantiate DUT
    fir_filter #(
        .DATA_WIDTH(DATA_WIDTH),
        .COEFF_WIDTH(COEFF_WIDTH),
        .TAPS(TAPS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .sample_in(sample_in),
        .sample_valid(sample_valid),
        .sample_out(sample_out),
        .sample_out_valid(sample_out_valid)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("Time\tSample_In\tSample_Out\tValid");
        $monitor("%0t\t%d\t\t%d\t\t%b", $time, sample_in, sample_out, sample_out_valid);

        // Reset
        rst = 1;
        sample_valid = 0;
        sample_in = 0;
        #12;
        rst = 0;

        // Apply input samples: x = [1, 2, 3, 4]
        repeat(1) @(posedge clk);
        sample_in = 1; sample_valid = 1;
        repeat(1) @(posedge clk);
        sample_in = 2; sample_valid = 1;
        repeat(1) @(posedge clk);
        sample_in = 3; sample_valid = 1;
        repeat(1) @(posedge clk);
        sample_in = 4; sample_valid = 1;

        // Extra cycles for output to appear
        repeat(4) @(posedge clk);
        sample_valid = 0;

        #50;
        $finish;
    end

endmodule
