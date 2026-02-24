module control_unit(
    input [15:0] instruction,
    output [2:0] rd,
    output [2:0] rs,
    output [2:0] rt,
    output [5:0] immidiate,
    output reg_write,
    output [2:0] alu_op,
    output branch,
    output select_imm
    );

    wire [3:0] opcode;
    assign opcode = instruction[15:12];
    assign rd = instruction[11:9];
    assign rs = instruction[8:6];
    assign rt = instructon[5:3];
    assign immidiate = instruction[5:0];

    always (*) begin
        alu_op = 3'b0;
        reg_write = 1'b0;
        select_imm = 1'b0;
        branch = 1'b0;
    end

    case(opcode)
    // R type instruction
    4'b0000 : begin// addition
        alu_op = 3'b000;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0001 : begin// subtraction
        alu_op = 3'b001;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0010 : begin // and
        alu_op = 3'b010;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0011 : begin // or
        alu_op = 3'b011;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0100 : begin // exor
        alu_op = 3'b100;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0101 : begin // move
        alu_op = 3'b101;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0110 : begin // for future
        alu_op = 3'b110;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    4'b0111 : begin // for future
        alu_op = 3'b111;
        select_imm = 1'b0;
        reg_write = 1'b1;
    end

    // I type instructoin

    4'b1000 : begin// addition
        alu_op = 3'b000;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end

    4'b1001 : begin// sub
        alu_op = 3'b001;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end

    4'b1010 : begin//and
        alu_op = 3'b010;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end

    4'b1011 : begin//or
        alu_op = 3'b011;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end

    4'b1100 : begin//exor
        alu_op = 3'b100;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end

    4'b1101 : begin//move
        alu_op = 3'b101;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end

    4'b1111 : begin //future use
        alu_op = 3'b000;
        select_imm = 1'b1;
        reg_write = 1'b1;
    end
    
    4'b1110 : begin // branch if equal
        alu_op = 3'b001; // subtraction
        select_imm = 1'b1;
        reg_write = 1'b0;
        branch = 1'b1;
    end
    endcase
endmodule