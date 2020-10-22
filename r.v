module r(clk,go,out);

	input clk;
	reg [1023:0] ans;
	reg [1023:0] nReg;
	input go;
	output reg [31:0] out;
	initial begin
		nReg <= 1024'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	
	always @(posedge clk) begin
		
		ans <= (2**(1024)) % nReg;
		
		if(out == 1'b1) begin
			out <= ans[31:0];
		end
	end

endmodule
