`timescale 1ns/1ps
module tb_cpu3;
reg clk;
reg reset;
top_cpu cpu(
.clk(clk),
.reset(reset)
);
// Clock generation
initial begin
clk = 0;
forever #10 clk = ~clk;
end
// Load program
initial begin
    //LI R1, 30: opcode=1111, rd=001, imm=011110
    cpu.instruction_memory.memory[0] = 8'b11110010; // upper 8 bits: 1111 0010
    cpu.instruction_memory.memory[1] = 8'b00011110; // lower 8 bits: 0010 1000
    //LI R2, 20: opcode=1111, rd=010, imm=010100
    cpu.instruction_memory.memory[2] = 8'b11110100; // upper 8 bits: 1111 0100
    cpu.instruction_memory.memory[3] = 8'b00010100; // lower 8 bits: 0100 0000
    //ADD R3, R1, R2: opcode=0000, rd=011, rs=001, rt=010
    cpu.instruction_memory.memory[4] = 8'b00000110; // upper 8 bits: 0000 0110
    cpu.instruction_memory.memory[5] = 8'b01010000; // lower 8 bits: 0101 0000
end
// STEP 7: Monitor EVERY clock cycle
initial begin
$display("\n=== CPU Simulation Started ===");
$display("Time | PC | Instruction | R1 | R2 | R3");
$display("-----|-----|-------------|-----|-----|-----");
reset = 1;
#40;
reset = 0;
#20; // Wait for one full clock cycle after reset release
// Monitor for 6 clock cycles (should see PC = 0, 2, 4, 6, 8, 10)
repeat(6) begin
// Print current state
$display("%5t | %3d | %4h | %3d | %3d | %3d",
$time,
cpu.PC,
cpu.instruction,
cpu.dp.rf.registers[1],
cpu.dp.rf.registers[2],
cpu.dp.rf.registers[3]);
#20; // Wait for next clock cycle
end
$display("\n=== Simulation Complete ===\n");
$finish;
end
endmodule