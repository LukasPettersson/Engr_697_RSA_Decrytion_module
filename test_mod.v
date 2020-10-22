module test_mod;
	
	
	
	reg clk;
	reg [31:0] reg1,reg2;
	wire [31:0] t;	

always  
	#5 clk = ~clk;
	

	mod dut(.clk(clk), .t(t), .reg1(reg1), .reg2(reg2));

initial begin
reg1 <= 32'h12345678;
reg2 <= 32'h00012311;

clk <= 0;

	
end	

endmodule

