module datapath(
        input clk,
        input [5:0] immidiate,
        input select_imm,
        input [2:0] rs, rt, rd, alu_op,
        input reg_write,
        output carry,
        output overflow,
        output zero
);



wire [7:0] x;
reg [7:0] y;
wire [7:0] z;
reg [7:0] immidiate_8;
wire [7:0] w;
wire alu_carry, alu_overflow, alu_zero;

assign carry = alu_carry;
assign overflow = alu_overflow;
assign zero = alu_zero;
always @(*) begin
    case(immidiate[5])
        1'b0 : immidiate_8 = { 2'b0 , immidiate};
        1'b1 : immidiate_8 = {3'b100 , immidiate[4:0]};
    endcase
end

always @(*) begin
    case(select_imm)
        1'b0: y = w;
        1'b1: y = immidiate_8;
    endcase
end

register_file rf(
    .clk(clk),
    .we(reg_write),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .wd(z),
    .rd1(x),
    .rd2(w)
);

ALU al(
    .A(x),
    .B(y),
    .out_put(z),
    .carry(alu_carry),
    .overflow(alu_overflow),
    .zero(alu_zero),
    .alu_op(alu_op)
);

endmodule