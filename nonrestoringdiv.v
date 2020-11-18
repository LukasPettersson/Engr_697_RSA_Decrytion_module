module nonrestoringdiv(
	input clk,
	input  [31 : 0] Q, // Q is quotient, but since it's also an input, we're gonna use another variable for quotient
	input  [31 : 0] M, // M is divisor
	input  [31 : 0] A, // A is accumulator and also remainder, same deal as Q
	output [31 : 0] Q_out, //Quotient
	output [31 : 0] R //Remainder
	);

reg [31 : 0] qReg, mReg, aReg;
reg flag = 1'b1;
reg [31 : 0] count = 32'd32;
integer i = 0;
/*
initial begin
	qReg = Q;
	mReg = M;
	aReg = A;
	flag = 1;
end */

assign Q_out = qReg;
assign R = aReg;

// TODO: Fix bits of count register for optimization, doesn't have to be 32.

always @ (posedge clk)
	begin
		if(i == 0)
			begin
				qReg = Q;
				mReg = M;
				aReg = A;
				i = 1;
			end

		if(count > 4'd32) //while(count)
			begin
			aReg = {aReg[30 : 0] , qReg[31]};

			if(flag == 1'b1) begin aReg = aReg - mReg; end
			else begin aReg = aReg + mReg; end

			if(aReg[31] == 1'b1)
				begin
					qReg = {qReg[30 : 0], 1'b0};
					flag = 1'b0;
				end
				else 
				begin
					qReg = {qReg[30 : 0], 1'b1};
					flag = 1'b1;
				end
				count = count - 1;
			end //end if count
			else 
			begin
				qReg = qReg;
				aReg = aReg;
				mReg = mReg;
			end

	end //end of posedge clk



endmodule 