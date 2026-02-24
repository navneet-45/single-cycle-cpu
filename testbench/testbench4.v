`timescale 1ns/1ps

//generatio of the reset signal
module tb_cpu2;
reg clk;
reg reset;
// instantiate the cpu module 
top_cpu cpu(
    .clk(clk),
    .reset(reset)
);
//clock
initial begin
    clk = 0;
    forever #10 clk = ~clk;

end
//reset signal generation
initial begin
    reset = 1;//reset is asserted at the beginning of the simulation
    #20 reset = 0;//dessert after 20 ns#200 $finsh;
    #200 $finish;//end the simulation
     // end the simulation after 200 ns
    
end
endmodule