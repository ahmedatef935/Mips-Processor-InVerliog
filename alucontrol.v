module ALUcontrol(funct,ALUOp,ALUOpInput);
input [5:0] funct;
input [1:0] ALUOp;
output reg [3:0] ALUOpInput;
wire [7:0] ALUOpfunct;

assign ALUOpfunct={ALUOp,funct};

always@(ALUOpfunct)
begin
casex(ALUOpfunct)
8'b00xxxxxx:ALUOpInput=4'b0010;
8'b01xxxxxx:ALUOpInput=4'b0110;
8'b10100000:ALUOpInput=4'b0010;
8'b10100010:ALUOpInput=4'b0110;
8'b10100100:ALUOpInput=4'b0000;
8'b10100101:ALUOpInput=4'b0001;
8'b10101010:ALUOpInput=4'b0111;
endcase
end
endmodule


module tbALUcontrol;
reg [5:0] funct;
reg [1:0] ALUOp;
wire [3:0] ALUOpInput;
ALUcontrol aluc1(funct,ALUOp,ALUOpInput);
initial
begin
$monitor($time,,,"%b %b %b",ALUOp,funct,ALUOpInput);
ALUOp=2'b00;
#5 ALUOp=2'b00;funct=6'b111111;
#5 ALUOp=2'b00;funct=6'b111111;
#5 ALUOp=2'b10;funct=6'b100000;
#5 ALUOp=2'b10;funct=6'b100010;
#5 ALUOp=2'b10;funct=6'b100101;
#5 ALUOp=2'b10;funct=6'b101010;
#5 ALUOp=2'b01;funct=6'b100001;
end
endmodule
