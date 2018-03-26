module sign_extend (extended_out, instruction_0_15); 
	output wire [31:0] extended_out;
	input [15:0] instruction_0_15;
	
	//assign extended_out[31:0] = { {16{instruction_0_15[15]}}, instruction_0_15[15:0] }; the two ways work
	assign extended_out = $signed(instruction_0_15);	   
	
endmodule
module Test_sign_extend();		 
	wire signed [31:0] extended_out;
	reg [15:0] instruction_0_15;
	sign_extend s(extended_out, instruction_0_15); 
	initial 
		begin
			$monitor("input = %b\noutput = %b\n*****\n", instruction_0_15, extended_out);
			#5
			instruction_0_15 =  16'b0000000000000110;	
			#5
			instruction_0_15 =  16'b1100000000001101;	  
		end
		
endmodule
