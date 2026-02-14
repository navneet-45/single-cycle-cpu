module register_file ( 
    input clk,
    input we,
    input [2:0]rs,
    input [2:0]rt,
    input [2:0]rd,
    input [7:0]wd,
    output [7:0]rd1,
    output [7:0]rd2
);

integer i;
reg [7:0] registers [0:7];


//assigning register to rd1 and rd2
assign rd1 = registers[rs];
assign rd2 = registers[rt];



always @(posedge clk) begin
    if (we) begin
        registers[rd] <= wd;
    end
end


initial begin
    for(i = 0; i < 8; i = i + 1) begin
        registers[i] = 8'b0;
    end
end
endmodule