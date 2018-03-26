module mux2way_32bit(mux_out, mux_in1, mux_in2, mux_sel);

input [31:0] mux_in1, mux_in2;
output reg [31:0] mux_out;
input mux_sel;

always@(mux_in1 or mux_in2 or mux_sel)
begin
	case(mux_sel)
	1'b0: mux_out = mux_in1;	
	1'b1: mux_out = mux_in2;
	endcase 
end

endmodule
