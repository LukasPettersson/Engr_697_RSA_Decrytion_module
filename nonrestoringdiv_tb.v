module nonrestoringdiv_tb();



reg clk;
reg start;
reg  [511 : 0] Q; // Q is quotient, but since it's also an reg, we're gonna use another variable for quotient
reg  [511 : 0] M; // M is divisor
reg  [511 : 0] A; // A is accumulator and also remainder, same deal as Q
wire [511 : 0] Q_out; //Quotient
wire [511 : 0] R; //Remainder
wire done;
//512 bit max
//13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084095

initial begin
	clk = 0;
	Q = 512'd13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858181546824682753882811946569946433649006084095; //Dividend
	A = 512'd0;
	M = 512'd56482457212336265846843516806813506813508168304698446384098494698465413057468478409807870604; //Divisor
	#50
	start = 1;
end

always #25 clk = ~clk;




 nonrestoringdiv dut(
	.clk(clk),
	.Q(Q), // Q is quotient, but since it's also an reg, we're gonna use another variable for quotient
	.M(M), // M is divisor
	.A(A), // A is accumulator and also remainder, same deal as Q
	.Q_out(Q_out), //Quotient
	.R(R), //Remainder
	.start(start),
	.done(done)
	);

endmodule
