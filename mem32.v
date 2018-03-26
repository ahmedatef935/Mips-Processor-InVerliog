module mem32(mem_OutputData,
mem_Address,
mem_WriteData,
mem_WriteCtrl,
mem_ReadCtrl, 
clk,
file_ID);

output reg [31:0] mem_OutputData;

input [31:0] mem_Address, mem_WriteData;
input mem_WriteCtrl, mem_ReadCtrl, clk, file_ID;
reg [31:0] mem_DataArray [255:0];

always@(file_ID) begin
if(file_ID == 0) //instruction memory
	$readmemb("C:\\Users\\Ibrahim\\Desktop\\pipeline\\inst_file_forward.txt", mem_DataArray);
else //data_memory
	$readmemb("C:\\Users\\Ibrahim\\Desktop\\pipeline\\data_file.txt", mem_DataArray);
end


always@(mem_Address or mem_DataArray[mem_Address])//read data
	begin
		if(mem_ReadCtrl == 1'b1)
			mem_OutputData = mem_DataArray[mem_Address];
	end


always@(posedge clk)//write data
	begin
		if(mem_WriteCtrl == 1'b1)
			mem_DataArray[mem_Address] <= mem_WriteData;
	end

endmodule

module testmem32();

reg mem_WriteCtrl, mem_ReadCtrl, clk, file_ID;
reg [31:0] mem_Address, mem_WriteData;
wire [31:0] mem_OutputData;

mem32 m(mem_OutputData, mem_Address, mem_WriteData, mem_WriteCtrl, mem_ReadCtrl, clk, file_ID);

initial begin
	clk = 0;
	file_ID = 0;
	mem_WriteCtrl = 0;
	mem_ReadCtrl = 1;
	mem_Address = 32'd0;
	mem_WriteData = 32'h00010001;
end
always
	begin
	#100 clk <= ~clk;
	mem_Address <= mem_Address + 1;
	end
endmodule
