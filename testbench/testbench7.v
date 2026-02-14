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
cpu.instruction_memory.memory[0] = 8'h84;
cpu.instruction_memory.memory[1] = 8'h0A;
cpu.instruction_memory.memory[2] = 8'h88;
cpu.instruction_memory.memory[3] = 8'h14;
cpu.instruction_memory.memory[4] = 8'h0D;
cpu.instruction_memory.memory[5] = 8'h28;
end
// Test sequence
initial begin
$dumpfile("tb_cpu3.vcd"); // Output filename
// Dump all signals with depth of 10 levels
$dumpvars(10, tb_cpu3);

$display("\n=== CPU Simulation Started ===");
$display("Time | PC | Instr  | OpCode | rd | rs | rt | Imm | WE | ALUop | R1 | R2 | R3");
$display("-----|-----|--------|--------|-----|-----|-----|-----|-----|-------|-----|-----|-----");

reset = 1;
#40;
reset = 0;

// Monitor signals for 10 cycles
repeat(10) begin
#20;
$display("%4t | %3d | %4h | %4b | %2d | %2d | %2d | %3d | %1b |  %3b  | %3d | %3d | %3d",
    $time,
    cpu.PC,
    cpu.instruction,
    cpu.cu.opcode,
    cpu.cu.rd,
    cpu.cu.rs,
    cpu.cu.rt,
    cpu.cu.immidiate,
    cpu.cu.reg_write,
    cpu.cu.alu_op,
    cpu.dp.rf.registers[1],
    cpu.dp.rf.registers[2],
    cpu.dp.rf.registers[3]);
end

$display("\n=== Simulation Complete ===");
$display("View waveforms with: gtkwave tb_cpu3.vcd\n");
$finish;
end
endmodule