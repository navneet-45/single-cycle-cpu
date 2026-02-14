module ALU(
    input [7:0] A,
    input [7:0] B,
    input [2:0] alu_op,
    output reg [7:0] out_put,
    output zero,
    output overflow,
    output carry
);
   reg [8:0] temp_out;
   assign zero = (out_put == 8'b0);
   assign carry = temp_out[8];
   assign overflow = (alu_op == 3'b000)? (A[7]&B[7]&~(out_put[7])|~(A[7])&~(B[7])&out_put[7]):
                     (alu_op == 3'b001)? (A[7]&~(B[7])&~(out_put[7])|~(A[7])&B[7]&out_put[7]):
                     1'b0;
   always @(*) begin 
        
        temp_out = 9'b0;
        case (alu_op)
        //addition
        3'b000: begin 
            temp_out = A + B;
            out_put = temp_out[7:0];
        end
        //subtraction
        3'b001: begin
            temp_out = A - B;
            out_put = temp_out[7:0];
        end
        //logical operations
        3'b010: out_put = A & B;
        3'b011: out_put = A | B;
        3'b100: out_put = A ^ B;
        //MOV
        3'b101: out_put = B;
        3'b110: out_put = 8'b0;
        3'b111: out_put = 8'b0;
        default : out_put = 8'b0;
        endcase
   end                 
   
endmodule
