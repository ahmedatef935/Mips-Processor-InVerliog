module hazrd_detection_unit(muxCtrl, PCWrite, IF_ID_Write,
ID_EX_MemRead, ID_EX_RegisterRt, IF_ID_RegisterRs, ID_EX_RegisterRt, IF_ID_RegisterRt);

output reg muxCtrl, PCWrite, IF_ID_Write;
input ID_EX_MemRead;
input [4:0] ID_EX_RegisterRt, IF_ID_RegisterRs, ID_EX_RegisterRt, IF_ID_RegisterRt;

initial begin
		PCWrite = 1'b1;
		IF_ID_Write = 1'b1;
		muxCtrl = 1'b1;
end

always @(ID_EX_MemRead or ID_EX_RegisterRt or IF_ID_RegisterRs or ID_EX_RegisterRt or IF_ID_RegisterRt)
begin
if (ID_EX_MemRead 
&& ((ID_EX_RegisterRt == IF_ID_RegisterRs) 
|| (ID_EX_RegisterRt == IF_ID_RegisterRt)))
	begin	
		PCWrite = 1'b0;
		IF_ID_Write = 1'b0;
		muxCtrl = 1'b0;
	end
else 
	begin
		PCWrite = 1'b1;
		IF_ID_Write = 1'b1;
		muxCtrl = 1'b1;
	end
end

endmodule
