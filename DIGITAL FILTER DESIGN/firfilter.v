module fir_filter #(
    parameter DATA_WIDTH = 8,
    parameter COEFF_WIDTH = 8,
    parameter TAPS = 4
)(
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] sample_in,
    input sample_valid,
    output reg signed [DATA_WIDTH+COEFF_WIDTH+1:0] sample_out,
    output reg sample_out_valid
);

    // Shift register for input samples
    reg signed [DATA_WIDTH-1:0] shift_reg [0:TAPS-1];
    reg signed [DATA_WIDTH+COEFF_WIDTH+1:0] acc;
    integer i;

    // Move COEFFS to local constant array inside always_comb or use explicit case
    // Define coefficients explicitly
    function signed [COEFF_WIDTH-1:0] get_coeff;
        input integer idx;
        begin
            case (idx)
                0: get_coeff = 1;
                1: get_coeff = 2;
                2: get_coeff = 3;
                3: get_coeff = 4;
                default: get_coeff = 0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < TAPS; i = i + 1)
                shift_reg[i] <= 0;
            sample_out <= 0;
            sample_out_valid <= 0;
        end else if (sample_valid) begin
            // Shift input samples
            for (i = TAPS-1; i > 0; i = i - 1)
                shift_reg[i] <= shift_reg[i-1];
            shift_reg[0] <= sample_in;

            // Convolution accumulation
            acc = 0;
            for (i = 0; i < TAPS; i = i + 1)
                acc = acc + shift_reg[i] * get_coeff(i);

            sample_out <= acc;
            sample_out_valid <= 1;
        end else begin
            sample_out_valid <= 0;
        end
    end

endmodule
