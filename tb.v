`timescale 1ns/1ps

module tb;

reg enIn, enOut;
reg clk;
reg [31:0] n,d,c;
wire [31:0] m;
wire [31:0] primeNum, privateKey, cipher;
integer i;
wire [4:0] countOut, countIn;

storeNumbers dut(.n(n),.d(d),.c(c),.clk(clk), .primeNumOut(primeNum), .privateKeyOut(privateKey), .cipherOut(cipher), .enIn(enIn), .enOut(enOut), .countOut(countOut), .countIn(countIn));

always  
	#5 clk = ~clk;
	
initial begin
	clk = 0;
	
end

	//input
	initial begin
			enIn <= 1'b1;
			enOut <= 1'b0;
			#5
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			#10
			n <= 32'hffffffff;
			d <= 32'hffffffff;
			c <= 32'hffffffff;
			#10
			n <= 32'h00000000;
			d <= 32'h00000000;
			c <= 32'h00000000;
			
			

	end
	//output
	initial begin
		
	#335
	enIn <= 1'b0;
	enOut <= 1'b1;
	end
endmodule

