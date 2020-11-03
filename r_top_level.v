module r_top_level(
				input [31:0] q,
				input [31:0] p,
				output wire [31:0] m,
				input clk
);

reg [511:0] qOut;
reg [511:0] pOut;
reg inputDone;
reg [4:0] count;

initial begin
	inputDone <= 1'b0;
	count <= 0;
end


always @ (posedge clk) begin
	
	
	if(count <= 5'b10000) begin
		qOut <= {q, qOut[511:32]};
		pOut <= {p, pOut[511:32]};
		count <= count + 1'b1;
	end
	else begin
		qOut <= qOut;
		pOut <= pOut; 
		inputDone <= 1'b1;
	end
end

r512 r(
				.q(qOut),
				.p(pOut),
				.m(qinv),
				.clk(clk),
				.start(inputDone)
);

endmodule