module mod(clk,t,reg1,reg2);
	
	
	output reg [31:0] t;
	input clk;
	input [31:0] reg1, reg2;
	always @ (posedge clk)
	begin
		t <= reg1 % reg2; 
	
	end

endmodule
