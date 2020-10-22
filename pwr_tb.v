module pwr_tb();
	reg [31:0] p,q,c,d;
	reg start,clk;
	wire [31:0] t,qinv,m,h;

	pwr u1 ( .p(p), .q(q), .c(c),  .d(d), .t(t), .qinv(qinv), .m(m), .h(h), .clk(clk), .start(start));
	 
	initial
	 begin
		 clk = 1;
		 
		 forever #5 clk = ~clk;
		 
		  
	  end


	initial
	 begin
		$display("32'h0020 mod 32'h0016=%d",32'h0020 % 32'h0016);
		 start =1;
			p = 32'h3B; 	//59
			q = 32'h61;	//97
			c = 32'h2; 
			d = 32'h400; 
			repeat(2)@(posedge clk);
			start = 0;
			#100000


			$finish;
	end
endmodule

