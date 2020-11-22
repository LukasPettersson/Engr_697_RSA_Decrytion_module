module dbs_r(start, clk,dividend,divisor,outputcount,remainder,done);
	
	/*
	dividend 
	--------- = quotient
	divisor
	*/
	input start;
	input [1025:0] dividend;
	input [1023:0] divisor;
	reg [1025:0] dividendReg;
	reg [1023 :0] divisorReg;
	
	input clk;
	//reg [31:0] temp;
	reg state;
	output reg [1023:0] outputcount, remainder;
	reg [1023:0] quotient = 0;
	output reg done;
	integer i = 0;
	/*
	initial begin
		state = 1'b0;
		done = 1'b0;
	end*/
	
	
	always @( posedge clk )begin
		if(start) begin

			if(i == 0)
			begin
			state = 1'b0;
			done = 1'b0;
			i = 1;
			end

			if(state == 1'b0) begin
				dividendReg = dividend;
				divisorReg = divisor;
				state = state + 1'b1;
			end
			
			else if(dividendReg >= divisorReg) begin
				
				dividendReg = dividendReg - divisorReg;
				quotient  = quotient + 1'b1;
			end
			else begin

				remainder = dividendReg;
				outputcount = quotient;
				done = 1'b1;
			end

		end
	end
endmodule
