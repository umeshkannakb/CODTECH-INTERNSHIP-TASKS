module pipeline_processor (
    input clk,
    input rst
);
    // ==== Instruction Encoding ====
    // Opcode [7:6]: 2'b00 = ADD, 2'b01 = SUB, 2'b10 = LOAD
    // Format:
    //  ADD/SUB: {OP[7:6], RD[5:4], RS[3:2], RT[1:0]}
    //  LOAD  : {OP[7:6], RD[5:4], ADDR[3:0]}

    reg [7:0] instr_mem [0:15]; // 16 instruction memory
    reg [7:0] data_mem [0:15];  // 16 data memory
    reg [7:0] reg_file [0:3];   // 4 general purpose registers

    reg [3:0] pc;

    // Pipeline Registers
    reg [7:0] IF_ID_instr;
    reg [7:0] ID_EX_instr;
    reg [7:0] ID_EX_rs_data, ID_EX_rt_data;
    reg [7:0] EX_MEM_result;
    reg [1:0] EX_MEM_rd;
    reg       EX_MEM_is_load;

    // Instruction Fetch
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else
            IF_ID_instr <= instr_mem[pc];
    end

    // Instruction Decode
    wire [1:0] opcode = IF_ID_instr[7:6];
    wire [1:0] rd     = IF_ID_instr[5:4];
    wire [1:0] rs     = IF_ID_instr[3:2];
    wire [1:0] rt     = IF_ID_instr[1:0];
    wire [3:0] addr   = IF_ID_instr[3:0];

    always @(posedge clk) begin
        ID_EX_instr   <= IF_ID_instr;
        ID_EX_rs_data <= reg_file[rs];
        ID_EX_rt_data <= reg_file[rt];
        pc <= pc + 1;
    end

    // Execute Stage
    wire [1:0] ex_opcode = ID_EX_instr[7:6];
    wire [1:0] ex_rd     = ID_EX_instr[5:4];
    wire [3:0] ex_addr   = ID_EX_instr[3:0];

    reg [7:0] alu_result;

    always @(posedge clk) begin
        case (ex_opcode)
            2'b00: alu_result <= ID_EX_rs_data + ID_EX_rt_data; // ADD
            2'b01: alu_result <= ID_EX_rs_data - ID_EX_rt_data; // SUB
            2'b10: alu_result <= ex_addr;                       // LOAD (address only)
            default: alu_result <= 0;
        endcase

        EX_MEM_result  <= alu_result;
        EX_MEM_rd      <= ex_rd;
        EX_MEM_is_load <= (ex_opcode == 2'b10);
    end

    // Memory Stage
    always @(posedge clk) begin
        if (EX_MEM_is_load)
            reg_file[EX_MEM_rd] <= data_mem[EX_MEM_result];
        else
            reg_file[EX_MEM_rd] <= EX_MEM_result;
    end

    // Initialize Memories
    initial begin
        pc = 0;
        instr_mem[0] = 8'b00000101; // ADD R0 = R0 + R1
        instr_mem[1] = 8'b01011010; // SUB R1 = R1 - R2
        instr_mem[2] = 8'b10000001; // LOAD R0, [1]
        instr_mem[3] = 8'b00011011; // ADD R1 = R2 + R3

        reg_file[0] = 8'd5;
        reg_file[1] = 8'd3;
        reg_file[2] = 8'd1;
        reg_file[3] = 8'd2;

        data_mem[1] = 8'd99;
    end
endmodule
