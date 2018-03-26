module forwarding_unit(ForwardA, ForwardB, ID_EX_RegisterRs, ID_EX_RegisterRt, EX_MEM_RegisterRd, MEM_WB_RegisterRd,
	EX_MEM_RegWrite, MEM_WB_RegWrite);

input wire [4:0] ID_EX_RegisterRs, ID_EX_RegisterRt, EX_MEM_RegisterRd, MEM_WB_RegisterRd;
input wire EX_MEM_RegWrite, MEM_WB_RegWrite;
output reg [1:0] ForwardA, ForwardB;


always@(ID_EX_RegisterRs or ID_EX_RegisterRt or EX_MEM_RegisterRd or MEM_WB_RegisterRd or
	EX_MEM_RegWrite or MEM_WB_RegWrite)
begin

//ForwardA

//EX hazard
if(EX_MEM_RegWrite && EX_MEM_RegisterRd != 5'd0 && EX_MEM_RegisterRd == ID_EX_RegisterRs)
	ForwardA = 2'b10;

//MEM hazard
else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 5'd0)
&& (EX_MEM_RegWrite  && (EX_MEM_RegisterRd != 5'd0) && (EX_MEM_RegisterRd != ID_EX_RegisterRs)) 
&& (MEM_WB_RegisterRd == ID_EX_RegisterRs))
	ForwardA = 2'b01;

else 
	ForwardA = 2'b00;

//ForwardB

//EX hazard
if(EX_MEM_RegWrite && EX_MEM_RegisterRd != 5'd0 && EX_MEM_RegisterRd == ID_EX_RegisterRt)
	ForwardB = 2'b10;


//MEM hazard
else if (MEM_WB_RegWrite 
&& (MEM_WB_RegisterRd != 5'd0)
&& (EX_MEM_RegWrite  && (EX_MEM_RegisterRd != 5'd0) && (EX_MEM_RegisterRd != ID_EX_RegisterRt))
&& (MEM_WB_RegisterRd == ID_EX_RegisterRt))
	ForwardB = 2'b01;

else 
	ForwardB = 2'b00;

end

endmodule 
