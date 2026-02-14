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
// Dump all signals recursively from top module
$dumpvars(0, tb_cpu3);

$display("\n=== CPU Simulation Started ===");
$display("Dumping all signals to tb_cpu3.vcd\n");

reset = 1;
#40;
reset = 0;

// Run for enough time to see all instructions
#200;

$display("=== Simulation Complete ===");
$display("View waveforms with: gtkwave tb_cpu3.vcd\n");
$finish;
end
endmodule