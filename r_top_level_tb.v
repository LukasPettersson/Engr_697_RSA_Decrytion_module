`include "parameter.v"

module r_top_level_tb();

reg [`DATA_WIDTH -1 :0] q,p;
wire [`DATA_WIDTH -1 :0] m, pTest;

reg clk, start;


integer i;

r_top_level dut(
				.q(q), //32 bit
				.p(p),	//32-bit
				.m(m), //wire 32
				.clk(clk),	 //bit
				.pTest(pTest)
				);

always 
	#5 clk = ~clk;


initial begin
	clk =0;
	start = 0;
	i = 0;
end


initial begin
	
	for( i=0; i<16; i = i+1) begin
		#5;
		
		q = $random;
		p = $random;
		
		#5;
	end
	#1000;
	
	

end

endmodule
