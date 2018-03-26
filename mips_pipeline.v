module mips_pipeline(clk);
input wire clk;

//************************Control pipeline definitions**************************//
	wire RegDst, Branch, jump, RegWrite, ALUSrc,
	MemRead, MemWrite, MemtoReg;
	wire [1:0] ALUOp;
/********************************************************************************/
/********************************************************************************/
	

//************************IF stage definitions**********************************//
	//PC
	wire [31:0] PC_in, PC_out;
	reg PC_reset;
	reg PCWrite;
	wire [31:0] inst_mem_OutputData;
	wire [31:0] PC_Add32_out;
/********************************************************************************/
/********************************************************************************/


//*********************IF/ID pipeline register definitions**********************//
	reg [31:0] IF_ID_instruction;
	reg [31:0] IF_ID_updated_PC;
/********************************************************************************/
/********************************************************************************/


//************************ID stage definitions**********************************//
	reg [5:0] opcode;
	reg [4:0] readRegister1, readRegister2, writeRegister;
	reg [15:0] immediate;
	wire [31:0] readData1, readData2, regWriteData;
	wire [31:0] extended_out;
	reg ID_muxCtrl, IF_ID_Write;
/********************************************************************************/
/********************************************************************************/


//*********************ID_EX pipeline register definitions**********************//
	reg [31:0] ID_EX_readData1, ID_EX_readData2, ID_EX_extended_out, ID_EX_updated_PC;
	reg [4:0] ID_EX_readRegister1, ID_EX_readRegister2,ID_EX_writeRegister; 
	
	reg ID_EX_RegDst, ID_EX_Branch, ID_EX_jump, ID_EX_RegWrite, ID_EX_ALUSrc,
		ID_EX_MemRead, ID_EX_MemWrite, ID_EX_MemtoReg;
	reg [1:0] ID_EX_ALUOp;
/********************************************************************************/
/********************************************************************************/


//************************EX stage definitions**********************************//
	reg [31:0] immediate_shifted_left2;
	wire [31:0] alu_input1, alu_input2, alu_Result;
	reg [5:0] funct;
	wire [4:0] RegDstination;
	wire Zero;
	wire [3:0] ALUOpInput;//input to ALU
	wire [31:0] PC_branch_signal;
	wire [1:0] ForwardA, ForwardB;
	wire [31:0] ForwardB_mux_out;
/********************************************************************************/
/********************************************************************************/


//*********************EX_MEM pipeline register definitions**********************//
	reg [31:0] EX_MEM_ALU_Result, EX_MEM_ReadData2;
	reg [4:0] EX_MEM_RegDstination;
	reg EX_MEM_ALU_Zero;
	//branch pc
	reg [31:0] EX_MEM_updated_PC;
	reg EX_MEM_Branch, EX_MEM_jump, EX_MEM_RegWrite, 
		EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_MemtoReg;
/********************************************************************************/
/********************************************************************************/


//************************MEM stage definitions*********************************//
	wire [31:0]MemReadData;
	wire PCSrc;
/********************************************************************************/
/********************************************************************************/


//*********************MEM_WBpipeline register definitions**********************//
	reg [31:0] MEM_WB_MemReadData, MEM_WB_ALU_Result;
	reg [4:0] MEM_WB_RegDstination;
	reg MEM_WB_jump, MEM_WB_RegWrite, MEM_WB_MemtoReg;
/********************************************************************************/
/********************************************************************************/

// IF satage

initial begin
PC_reset = 1'b1;
PCWrite = 1'b1;
IF_ID_Write = 1'b1;
ID_muxCtrl = 1'b1;
@(posedge clk)
	PC_reset <= 1'b0;
end

reg32 PC(clk, PC_reset, PC_in, PC_out);
assign PC_Add32_out = PCWrite? PC_out + 1: PC_out - 1;


//add32 PC_plus_1(PC_Add32_out, PC_out, 32'd1); //memory is word addressable
mem32 instruction_memory(inst_mem_OutputData, PC_out, 32'd0, 1'b0, 1'b1, clk, 1'b0);
mux2way_32bit pc_source(PC_in, PC_Add32_out, EX_MEM_updated_PC, 1'b0/*PCSrc*/);

always@(ID_EX_MemRead or ID_EX_readRegister2 or readRegister1 or readRegister2)
begin
if (ID_EX_MemRead 
	&& ((ID_EX_readRegister2 == readRegister1) 
	|| (ID_EX_readRegister2 == readRegister2))) // hazard detection
		begin	
			PCWrite = 1'b0;
			IF_ID_Write = 1'b0;
			ID_muxCtrl = 1'b0;
		end
	else 
		begin
			PCWrite = 1'b1;
			IF_ID_Write = 1'b1;
			ID_muxCtrl = 1'b1;
		end
end
/////////////////////////////

always@(posedge clk)// IF/ID pipeline register
begin
	if(IF_ID_Write)
	begin
		IF_ID_instruction <= inst_mem_OutputData;
		IF_ID_updated_PC <= PC_in;
	end
end


/*********************************************************************************/


//ID stage 
	

always@(IF_ID_instruction or IF_ID_updated_PC)
begin
	readRegister1 = IF_ID_instruction[25:21];
	readRegister2 = IF_ID_instruction[20:16];
	writeRegister = IF_ID_instruction[15:11]; 
	immediate = IF_ID_instruction[15:0];
	opcode = IF_ID_instruction[31:26];
end


control_unit cu(opcode, RegDst, Branch, jump, RegWrite, ALUSrc, ALUOp,
	MemRead, MemWrite, MemtoReg);

reg_file rf(readData1, readData2, readRegister1, readRegister2, MEM_WB_RegDstination, regWriteData, 
MEM_WB_RegWrite, clk);

sign_extend extend_immediate(extended_out, immediate); 

always@(posedge clk)//ID/EX pipeline register
begin
	ID_EX_readData1 <= readData1;
	ID_EX_readData2 <= readData2;
	ID_EX_extended_out <= extended_out;
	ID_EX_updated_PC <= IF_ID_updated_PC;
	ID_EX_readRegister1 <= readRegister1;
	ID_EX_readRegister2 <= readRegister2;
	ID_EX_writeRegister <= writeRegister;

	

	if (ID_muxCtrl)
		begin
			ID_EX_RegDst <= RegDst;
			ID_EX_Branch <= Branch;
			ID_EX_jump <= jump;
			ID_EX_RegWrite <= RegWrite;
			ID_EX_ALUSrc <= ALUSrc;
			ID_EX_MemRead <= MemRead;
			ID_EX_MemWrite <= MemWrite;
			ID_EX_MemtoReg <= MemtoReg;
			ID_EX_ALUOp <= ALUOp;
		end
	else if (ID_muxCtrl == 0)
		begin
			ID_EX_RegDst <= 1'b0;
			ID_EX_Branch <= 1'b0;
			ID_EX_jump <= 1'b0;
			ID_EX_RegWrite <= 1'b0;
			ID_EX_ALUSrc <= 1'b0;
			ID_EX_MemRead <= 1'b0;
			ID_EX_MemWrite <= 1'b0;
			ID_EX_MemtoReg <= 1'b0;
			ID_EX_ALUOp <= 2'b00;	
		end
end
/*********************************************************************************/


//Ex stage
always@(ID_EX_readData1 or ID_EX_readData2 or ID_EX_extended_out or ID_EX_updated_PC)
begin
	funct = ID_EX_extended_out[5:0];
	immediate_shifted_left2 = ID_EX_extended_out << 2;
end
mux2way_5bit RegsterDestination(RegDstination, ID_EX_readRegister2, ID_EX_writeRegister, ID_EX_RegDst);

ALUcontrol aluctrl(funct, ID_EX_ALUOp, ALUOpInput);
alu ALU(alu_Result, Zero, alu_input1, alu_input2, ALUOpInput);
add32 PC_branch(PC_branch_signal, ID_EX_updated_PC, immediate_shifted_left2);

mux2way_32bit alusrc(alu_input2, ForwardB_mux_out, ID_EX_extended_out, ID_EX_ALUSrc);

forwarding_unit fu(ForwardA, ForwardB, ID_EX_readRegister1, ID_EX_readRegister2, EX_MEM_RegDstination, MEM_WB_RegDstination,
	EX_MEM_RegWrite, MEM_WB_RegWrite);
mux3way_32bit ForwardA_mux(alu_input1, ID_EX_readData1, regWriteData, EX_MEM_ALU_Result, ForwardA);
mux3way_32bit ForwardB_mux(ForwardB_mux_out, ID_EX_readData2, regWriteData, EX_MEM_ALU_Result, ForwardB);

always@(posedge clk)//EX/MEM pipeline register
begin 
	EX_MEM_updated_PC <= PC_branch_signal;
	EX_MEM_ALU_Result <= alu_Result;
	EX_MEM_ReadData2 <= ID_EX_readData2;
	EX_MEM_RegDstination <= RegDstination;
	EX_MEM_ALU_Zero <= 1'b0;
	EX_MEM_ALU_Zero <= Zero;

	EX_MEM_Branch <= ID_EX_Branch;
	EX_MEM_jump <= ID_EX_jump;
	EX_MEM_RegWrite <= ID_EX_RegWrite;
	EX_MEM_MemRead <= ID_EX_MemRead;
	EX_MEM_MemWrite <= ID_EX_MemWrite;
	EX_MEM_MemtoReg <= ID_EX_MemtoReg;
end

/*********************************************************************************/


//MEM Stage

and branch_CTRL(PCSrc, EX_MEM_ALU_Zero, EX_MEM_Branch);
mem32 data_memory(MemReadData, EX_MEM_ALU_Result, EX_MEM_ReadData2, EX_MEM_MemWrite, EX_MEM_MemRead, clk, 1'b1);

always@(posedge clk)//MEM/WB pipeline register
begin
	MEM_WB_MemReadData <= MemReadData;
	MEM_WB_ALU_Result <= EX_MEM_ALU_Result;
	MEM_WB_RegDstination <= EX_MEM_RegDstination;

	MEM_WB_jump <= EX_MEM_jump;
	MEM_WB_RegWrite <= EX_MEM_RegWrite;
	MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
end	


/*********************************************************************************/


//WB Stage
mux2way_32bit memory_to_register(regWriteData, MEM_WB_ALU_Result, MEM_WB_MemReadData, MEM_WB_MemtoReg);

endmodule

module test_mips_pipeline();
reg clk;
mips_pipeline mp(clk);

initial begin
	clk = 0;
end
always
	begin
	#100 clk <= ~clk;
	end
endmodule 