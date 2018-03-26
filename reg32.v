module reg32 (clk, reset, d_in, d_out);

input clk, reset;
input [31:0] d_in;
output [31:0] d_out;
reg [31:0]	d_out;

always @(posedge clk)
	begin
		if (reset) d_out <= 0;
		else d_out <= d_in;
	end
endmodule


module testreg32();

reg clk, reset;
reg	[31:0]	d_in;
wire [31:0] d_out;
reg32 r(clk, reset, d_in, d_out);

initial begin
		clk = 0;
		reset = 0;
		d_in = 32'hffffffff;
	end
always
	begin	
		#100 clk = ~clk;
	end
	

endmodule 