module shiftIn(	  data, 
							clk, 
					outputReg
						);
						
input clk;
input [7:0] data;
reg [5:0] count;
output reg [511:0] outputReg;

initial begin
	outputReg <= 512'b0;
	count <= 6'b0;
end
always @ (posedge clk)
	if(count < 6'b1000000) begin
		outputReg <= {data, outputReg[511:8]};
		count <= count + 1'b1;
	end
	else
		outputReg <= outputReg; 
	

endmodule
