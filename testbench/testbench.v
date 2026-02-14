`timescale 1ns/1ps
module tb_cpu;
reg clk;
reg reset;
// Instantiate CPU
top_cpu cpu(
.clk(clk),
.reset(reset)
);
// STEP 2: Generate clock manually
initial begin
clk = 0; // Start with clock low
#10 clk = 1; // At 10ns, set clock high
#10 clk = 0; // At 20ns, set clock low
#10 clk = 1; // At 30ns, set clock high
#10 clk = 0; // At 40ns, set clock low
#10 clk = 1; // At 50ns, set clock high
#10 clk = 0; // At 60ns, set clock low
$display("Clock generation complete");

$finish; // End simulation

end
initial begin
    $dumpfile("tb_cpu.vcd");
    $dumpvars(0, tb_cpu);
    
end
endmodule