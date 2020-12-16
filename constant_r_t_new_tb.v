module constant_r_t_new_tb();

reg clk, start;
reg [1023 : 0] M_r;
wire [1023 : 0] R_r;
wire [1023 : 0] R_t;
wire done;



always #25 clk = ~clk;


initial begin
	clk = 0;
	M_r = 1024'h57BB720287B13E536673FB40D826ED1DC7E6276153B6A6374FFD0F4FD8319257AA5679E60058B7E0B2CA6F16B6F61CD8703A5407B75166C23C12800D46D4783519DBB74FAD3C39D546CE4CE83E1B6B6E196C0889D1C8EEF49E7D555CF8E571AD6BBF7557DE96786ED1A48D93EF8EEBE50C11CD2BAFCE0635569644860E8780E1; //Divisor
	#50
	start = 1;
	#50
	start = 0;
end




constant_r_t_new dut(
	.clk(clk),
	.M_r(M_r), // M is divisor
	.start(start),
	.R_r(R_r), //Remainder
	.R_t(R_t), //Remainder
	.done(done)
	);

endmodule
