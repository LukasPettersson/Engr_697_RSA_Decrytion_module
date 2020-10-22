module divide_by_subtraction_test();
	

	reg [31:0] dividend,divisor;
	reg clk;
	wire [31:0] count, remainder, quotient;
	wire state;
	
	
	divide_by_subtraction dut(.clk(clk), .dividend(dividend), .divisor(divisor), .outputcount(count), .remainder(remainder), .state(state));
	
	always
		#5 clk = ~clk;
	
	initial begin
		clk = 0;
		dividend <= 32'd32;
		divisor <= 32'd4;
		
	end
	
endmodule
