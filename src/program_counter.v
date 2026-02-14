//program counter module
module program_counter (
    input wire clk,
    //Restarts program from address 0
    input wire reset,
    //this is control signal related to the branch instruction
    input wire branch,
    //when the register value is zero after the alu operation which basically means the value of R1 and R2 are same 
    input wire zero,
    //branch offset SIGNED
    //What is branch offset?
    // making decisions based on the conditions 
    input wire [5:0] immidiate,
    output reg [7:0] PC
);
wire branch_should_happen;
wire [7:0] PC_next;
reg [7:0] branch_offset;
//extending the six bits to 8 bits 
always @(*) begin
    case(immidiate[5])
        1'b0 : branch_offset = { 2'b0 , immidiate};
        1'b1 : branch_offset = {3'b100 , immidiate[4:0]};
    endcase
end
wire [7:0] PC_branch_address;
assign branch_should_happen = branch & zero;
//both conditions should be met for branch to happen
assign PC_next = PC + 2;
assign PC_branch_address = PC + branch_offset + branch_offset;//since each instruction is of two bytes
always @(posedge clk) begin
    if (reset)
    PC <= 8'b0;//Reset : go to the sddress 0
    else if (branch_should_happen)
    PC <= PC_branch_address;//jumping to target address
    else
    PC <= PC_next;//normal opertation as usual PC + 1
end


endmodule