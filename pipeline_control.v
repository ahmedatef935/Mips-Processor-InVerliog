
module control_unit(opcode, RegDst, Branch, jump, RegWrite, ALUSrc, ALUOp,
	MemRead, MemWrite, MemtoReg);	 
	
	input wire [5:0] opcode;
	output reg RegDst, Branch, jump, RegWrite, ALUSrc,
	MemRead, MemWrite, MemtoReg;
	output reg [1:0] ALUOp;
	
	always@(*)
		begin
		case(opcode)   
				//Rformat
			6'b000000:	begin
						RegDst   = 1'b1;
						ALUSrc   = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemRead  = 1'b0;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						jump	 = 1'b0;
						ALUOp[1] = 1'b1;
						ALUOp[0] = 1'b0;
			end
				//load word
			 6'b100011: begin
						RegDst   = 1'b0;
						ALUSrc   = 1'b1;
						MemtoReg = 1'b1;
						RegWrite = 1'b1;
						MemRead  = 1'b1;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						jump	 = 1'b0;
						ALUOp[1] = 1'b0;
						ALUOp[0] = 1'b0;
			 end		
			 	//store word
			 6'b101011:	begin
				 		RegDst   = 1'bx;
						ALUSrc   = 1'b1;
						MemtoReg = 1'bx;
						RegWrite = 1'b0;
						MemRead  = 1'b0;
						MemWrite = 1'b1;
						Branch   = 1'b0; 
						jump	 = 1'b0;
						ALUOp[1] = 1'b0;
						ALUOp[0] = 1'b0;
			 end   
			 	//beq
			 6'b000100: begin
				 		RegDst   = 1'bx;
						ALUSrc   = 1'b0;
						MemtoReg = 1'bx;
						RegWrite = 1'b0;
						MemRead  = 1'b0;
						MemWrite = 1'b0;
						Branch   = 1'b1;
						jump	 = 1'b0;
						ALUOp[1] = 1'b0;
						ALUOp[0] = 1'b1;
			 end	
			 	//jump
			 6'b000010: begin
				 		RegDst   = 1'bx;
						ALUSrc   = 1'bx;
						MemtoReg = 1'bx;
						RegWrite = 1'bx;
						MemRead  = 1'bx;
						MemWrite = 1'bx;
						Branch   = 1'bx;
						jump	 = 1'b1;
						ALUOp[1] = 1'bx;
						ALUOp[0] = 1'bx;
			 end
			endcase
		end
endmodule  
module Test_Control_Unit_sc();
	
	reg [5:0] opcode;
	wire RegDst, Branch, jump, RegWrite, ALUSrc,
			MemRead, MemWrite, MemtoReg;
	wire [1:0] ALUOp;
	control_unit cu(opcode, RegDst, Branch, jump, RegWrite, ALUSrc, ALUOp,
	MemRead, MemWrite, MemtoReg);
	initial 
		begin
		$monitor("opcode = %b\n----\nRegDst = %b\nBranch = %b\njump = %b\nRegWrite = %b\nALUSrc = %b\nMemRead = %b\nMemWrite = %b\nMemtoReg = %b\nALUOp = %b\n****\n",
		opcode, RegDst, Branch, jump, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, ALUOp);
		#5
		opcode = 6'b000000;
		#5
		opcode = 6'b100011;
		#5
		opcode = 6'b101011; 
		#5
		opcode = 6'b000100;
		end
endmodule	