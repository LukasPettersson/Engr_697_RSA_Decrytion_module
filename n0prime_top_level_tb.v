module n0prime_top_level_tb();


reg [31:0] q,p;
wire [31:0] qinv, t;

reg clk, start;


integer i;

n0prime_top_level dut(
				.q(q), //32 bit
				.p(p),	//32-bit
				.qinv(qinv), //wire 32
				.t(t), //wire 32
				.clk(clk),	 //bit

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





