`timescale 1ns/1ps
module tb_cpu2;
reg clk;
reg reset;
//instantiate the cpu
top_cpu cpu(
    .clk(clk),
    .reset(reset)
);
//clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk; //toggles after every 10 ns
end
//loading a program into the instruction memory
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
    //sub R4, R1, R2: opcode=0001, rd=100, rs=001, rt=010
    cpu.instruction_memory.memory[6] = 8'b00011000; // upper 8 bits: 0001 1000
    cpu.instruction_memory.memory[7] = 8'b01010000; // lower 8 bits: 0101 0000
end
//reset
initial begin
    $display("\n====CPU simulation started====\n");
    reset = 1;
    $display("Time = %0t : Reset asserted",$time);
    #40 reset = 0;
    $display("Time = %0t : Reset desserted, CPU running\n",$time);
    #20
    $display("Time = %0t : R1 = %d",$time, cpu.dp.rf.registers[1]);
    #20
    $display("Time = %0t : R2 = %d",$time, cpu.dp.rf.registers[2]);
    #20
    $display("Time = %0t : R3 = %d",$time, cpu.dp.rf.registers[3]);
    #20
    $display("Time = %0t : R4 = %d",$time, cpu.dp.rf.registers[4]);
    #100
    // Final register values
    $display("\n====Final results====\n");
    $display("R1 = %d",cpu.dp.rf.registers[1]);
    $display("R2 = %d",cpu.dp.rf.registers[2]);
    $display("R3 = %d",cpu.dp.rf.registers[3]);
    $display("R4 = %d",cpu.dp.rf.registers[4]);
    $display("\n===Simulation completed===\n");
    #200 $finish;
end
//VCD dump
initial begin
    $dumpfile("tb_cpu2.vcd");
    $dumpvars(0, tb_cpu2);
end

endmodule