module n0prime_test;


reg [31:0] p,q;
wire [31:0] qinv, t;
reg clk,start;

 
n0prime dut(.q(q), .p(p), .t(t), .qinv(qinv), .clk(clk), .start(start));

/*

module n0prime(
			input  [31:0] q,p,
			output reg [31:0] qinv,
			input clk, start

*/

initial begin
	clk = 1'b1;
	start = 1'b0;
	p = 32'b0;
	q = 32'b0;
	
end

always begin
	#5 clk = ~clk;
	
end

initial
	begin
		$display("32'h0020 mod 32'h0016=%d",32'h0020 % 32'h0016);
		start = 1;
		//these need to be prime numbers
		p = 32'h1EEF;  //7919
		q = 32'h189D;  	//6301
		
		repeat(2)@(posedge clk);
		start = 0;
		#100000


		$finish;
	 end

endmodule
