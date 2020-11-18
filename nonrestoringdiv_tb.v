module nonrestoringdiv_tb();



reg clk;
reg  [31 : 0] Q; // Q is quotient, but since it's also an reg, we're gonna use another variable for quotient
reg  [31 : 0] M; // M is divisor
reg  [31 : 0] A; // A is accumulator and also remainder, same deal as Q
wire [31 : 0] Q_out; //Quotient
wire [31 : 0] R; //Remainder

initial begin
	clk = 0;
	Q = 32'd61; //Dividend
	A = 32'b0000;
	M = 32'd2; //Divisor
end

always #25 clk = ~clk;




 nonrestoringdiv dut(
	.clk(clk),
	.Q(Q), // Q is quotient, but since it's also an reg, we're gonna use another variable for quotient
	.M(M), // M is divisor
	.A(A), // A is accumulator and also remainder, same deal as Q
	.Q_out(Q_out), //Quotient
	.R(R) //Remainder
	);

endmodule