module reg_file(readData1,
readData2,
readRegister1,
readRegister2,
writeRegister,
writeData, 
regWriteCtrl,
clk);

output reg [31:0] readData1, readData2;
input [4:0] readRegister1, readRegister2, writeRegister;
input [31:0] writeData;
input clk, regWriteCtrl;

reg [31:0] reg_file_Array [31:0];

initial 
	begin
$readmemb("C:\\Users\\Ibrahim\\Desktop\\pipeline\\reg_file.txt", reg_file_Array);
	end
always@(readRegister1 or reg_file_Array[readRegister1])
	begin
		readData1 = reg_file_Array[readRegister1];
	end

always@(readRegister2 or reg_file_Array[readRegister2])
	begin
		readData2 = reg_file_Array[readRegister2];
	end

always@(negedge clk)//write data
	begin
		if(regWriteCtrl)
			reg_file_Array[writeRegister] <= writeData;
	end

endmodule


module testregfile();

wire [31:0] readData1, readData2;
reg [4:0] readRegister1, readRegister2, writeRegister;
reg [31:0] writeData;
reg clk, regWriteCtrl;

reg_file rf(readData1, readData2, readRegister1, readRegister2, writeRegister, writeData, 
regWriteCtrl, clk);
initial begin
	clk = 0;
	regWriteCtrl = 0;
	readRegister1 = 0;
	readRegister2 = 1;
	writeRegister = 5;
	writeData = 32'hffffffff;
	end

always
	begin
	#100 clk <= ~clk;
	end

always
	begin
		#300 regWriteCtrl = 1;
		readRegister1 = 5;
	end
endmodule 