module nonrestoringdiv_tb();

reg clk;
reg start;
reg  [1024 : 0] Q; // Q is quotient, but since it's also an reg, we're gonna use another variable for quotient
reg  [1024 : 0] M; // M is divisor
wire [1024 : 0] Q_out; //Quotient
wire [1024 : 0] R; //Remainder
wire done;
//512 bit max
//13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084095

initial begin
	clk = 0;
	Q = 1025'd13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858181546824682753882811946569946433649006084095; //Dividend
	M = 1025'd56482457212336265846843516806813506813508168304698446384098494698465413057468478409807870604; //Divisor
	#50
	start = 1;
	#50
	start = 0;
end

always #25 clk = ~clk;

 nonrestoringdiv dut(
		.clk(clk),
		.Q(Q), // Q is quotient, but since it's also an reg, we're gonna use another variable for quotient
		.M(M), // M is divisor
		.Q_out(Q_out), //Quotient
		.R(R), //Remainder
		.start(start),
		.done(done)
	);

endmodule
