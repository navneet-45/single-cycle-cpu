//instruction memory module with 16 bit instruction but size of the memory address is 8 bit 
module instruction_mem(
    input [7:0] address,
    output [15:0] instruction
);
reg [7:0] memory [0:255]; //memor location has 256 addresses and each address has 8 bit data 
assign instruction = {memory[address],memory[address+1]};//concatenating two 8 bit instruction to make a 16 bit instruction
//one memory locattion has 8 bit data so the entire instruction is stored in two memory locations add and add + 1
initial begin
    //example instructions to be stored in instruction memory
    memory[0] = 8'b00000001; // first 8 bits of instruction 1
    memory[1] = 8'b00011000; // last 8 bits of instruction 1
    memory[2] = 8'b00010010; // first 8 bits of instruction 2
    memory[3] = 8'b00100100; // last 8 bits of instruction 2
    // Add more instructions as needed
end 



endmodule