module top_cpu(
    input wire clk,
    input wire reset
);
//Program counter wires
wire [7:0] PC;
//instruction memory wires
wire [15:0] instruction;
//control signals
wire branch, zero;
wire [5:0] immidiate;
//linking program counter and instruction memory
program_counter PC_instr(
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .branch(branch),//i think it will be connected according to the signal 
    .zero(zero),//i think it will be connected according to the signal
    .immidiate(immidiate)//i think it will be connected according to the signal
);
instruction_mem instruction_memory(
    .address(PC),
    .instruction(instruction)
);
//instruction decode wires
wire [3:0] opcode;
wire [2:0] rd, rs, rt, alu_op;
wire select_imm, we;
control_unit cu(
    .instruction(instruction),
    .rd(rd),
    .rs(rs),
    .rt(rt),
    .immidiate(immidiate),
    .reg_write(we),//lets see later
    .alu_op(alu_op),//lets see later
    .select_imm(select_imm)//lets see later
);
datapath dp(
    .clk(clk),
    .immidiate(immidiate),
    .select_imm(select_imm),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .alu_op(alu_op),
    .reg_write(we),
    .carry(carry),
    .overflow(overflow),
    .zero(zero)
);

endmodule