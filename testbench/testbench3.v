`timescale 1ns/1ps

module tb_cpu1;
    reg clk;
    reg reset;

    top_cpu cpu(
        .clk(clk),
        .reset(reset)
    );
    //we are using loop for generating the clock 
    initial begin 
        clk = 0;
        forever begin
            #10 clk = ~clk; //clock toggles after every 10 nano seconds
        end
        $display("clock generation completed");//this wiil never be printed because of the forever loop
        $finish; // end the simulation
    end
    initial begin
        reset = 1;
        #20 reset = 0;
        #200 $finish;  // Ends simulation after 200ns
    end

    initial begin
        reset = 1;
        #20 reset = 0;
        #200 $finish;
    end

    initial begin
        $dumpfile("tb_cpu1.vcd");
        $dumpvars(0, tb_cpu1);
    end
endmodule
//forever loop can also be written as 
//forever #10 clk = ~clk; this also does the same operation