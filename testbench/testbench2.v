`timescale 1ns/1ps

module tb_cpu;
reg clk;
reg reset;

// Instantiate CPU
top_cpu cpu(
    .clk(clk),
    .reset(reset)
);
initial begin
   $display("CPU Testbench Started"); 
end

endmodule