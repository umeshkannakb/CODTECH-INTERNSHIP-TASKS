module ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input                    clk,
    input                    rst,
    input                    we,       // Write Enable
    input                    re,       // Read Enable
    input  [ADDR_WIDTH-1:0]  addr,
    input  [DATA_WIDTH-1:0]  din,
    output reg [DATA_WIDTH-1:0] dout
);

    localparam DEPTH = 1 << ADDR_WIDTH;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (rst)
            dout <= 0;
        else if (we)
            mem[addr] <= din;
        else if (re)
            dout <= mem[addr];
    end
endmodule
