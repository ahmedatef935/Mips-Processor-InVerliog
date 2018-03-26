module mux3way_32bit(mux_out, mux_in1, mux_in2, mux_in3, mux_sel);

input [31:0] mux_in1, mux_in2, mux_in3;
output reg [31:0] mux_out;
input [1:0] mux_sel;

always@(mux_in1 or mux_in2 or mux_in3 or mux_sel)
begin
	case(mux_sel)
	2'b00: mux_out = mux_in1;	
	2'b01: mux_out = mux_in2;
	2'b10: mux_out = mux_in3;
	default: mux_out = 32'dx;
	endcase 
end

endmodule
