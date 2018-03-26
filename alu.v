module alu(alu_Result, alu_zeroFlag, input1, input2, aluCtrl);

output reg [31:0] alu_Result;
input [31:0] input1, input2;
output reg alu_zeroFlag;
input [3:0] aluCtrl;

always@(input1 or input2 or aluCtrl)
begin

	case (aluCtrl)
		4'b0000 : alu_Result = input1 & input2; // AND
		4'b0001 : alu_Result = input1 | input2; // OR
		4'b0010 : alu_Result = input1 + input2; // ADD
		4'b0110 : alu_Result = input1 - input2; // SUBTRACT
		4'b0111 : if (input1 < input2) alu_Result = 32'd1; 
			else alu_Result = 32'd0; //SLT 
		default : alu_Result = 32'hxxxxxxxx;
	endcase

	if (alu_Result == 32'd0)
		alu_zeroFlag = 1;
	else 
		alu_zeroFlag = 0;

end
endmodule 

module testALU();

wire [31:0] alu_Result;
reg [31:0] input1, input2;
wire alu_zeroFlag;
reg [3:0] aluCtrl;

alu a(alu_Result, alu_zeroFlag, input1, input2, aluCtrl);
initial begin
	input1 = 32'd1;
	input2 = 32'd1;
	end

always
	begin
		#100
		aluCtrl = 4'b0000; // AND
		#100
		aluCtrl = 4'b0001; // OR
		#100
		aluCtrl = 4'b0010; // ADD
		#100
		aluCtrl = 4'b0110; // SUBTRACT
		#100
		aluCtrl = 4'b0111; //SLT
		//#100
	end
endmodule
