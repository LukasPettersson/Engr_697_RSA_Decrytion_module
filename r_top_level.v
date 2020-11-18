`include "parameter.v"

module r_top_level(
				input [`DATA_WIDTH -1 :0] q,
				input [`DATA_WIDTH -1 :0] p,
				output wire [`DATA_WIDTH -1 :0] m,
				input clk,
				output reg [`DATA_WIDTH -1 :0] pTest
);

reg [`MAX_DATA - 1 :0] qOut;
reg [`MAX_DATA - 1 :0] pOut;
reg inputDone;
reg [4:0] count;
integer i;
initial begin
	inputDone <= 1'b0;
	count <= 0;
end


always @ (posedge clk) begin
	
	
	if(count < 5'b10000) begin
		qOut <= {q, qOut[`MAX_DATA - 1 :`DATA_WIDTH]};
		pOut <= {p, pOut[`MAX_DATA - 1 :`DATA_WIDTH]};
		count <= count + 1'b1;
		if(count == 5'b10000) begin inputDone <= 1'b1; end
	end
	else begin
		qOut <= qOut;
		pOut <= pOut; 
	//	inputDone <= 1'b1;
		pTest <= pOut[`DATA_WIDTH - 1 : 0];
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