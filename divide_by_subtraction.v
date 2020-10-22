module divide_by_subtraction(start, clk,dividend,divisor,outputcount,remainder,done);
	
	/*
	dividend 
	--------- = quotient
	divisor
	*/
	input start;
	input [511:0] dividend;
	input [511:0] divisor;
	reg [511:0] dividendReg, divisorReg;
	
	input clk;
	//reg [31:0] temp;
	reg state;
	output reg [511:0] outputcount, remainder;
	reg [511:0] quotient = 0;
	output reg done;
	
	initial begin
		state = 1'b0;
		done <= 1'b0;
	end
	
	
	always @( posedge clk )begin
		if(start) begin
			if(state == 1'b0) begin
				dividendReg <= dividend;
				divisorReg <= divisor;
				state <= state + 1'b1;
			end
			
			else if(dividendReg >= divisorReg) begin
				
				dividendReg <= dividendReg - divisorReg;
				quotient  = quotient + 1'b1;
			end
			else begin

				remainder <= dividendReg;
				outputcount <= quotient;
				done <= 1'b1;
			end

		end
	end
endmodule
