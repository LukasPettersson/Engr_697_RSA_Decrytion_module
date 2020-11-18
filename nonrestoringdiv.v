module nonrestoringdiv(
	input clk,
	input  [511 : 0] Q, // Q is quotient, but since it's also an input, we're gonna use another variable for quotient
	input  [511 : 0] M, // M is divisor
	input  [511 : 0] A, // A is accumulator and also remainder, same deal as Q
	output [511 : 0] Q_out, //Quotient
	output [511 : 0] R //Remainder
	);

reg [511 : 0] qReg, mReg, aReg;
reg flag = 1'b1;
reg [511 : 0] count = 511'd512;
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

		if(count > 0) //while(count)
			begin
			aReg = {aReg[510 : 0] , qReg[511]};

			if(flag == 1'b1) begin aReg = aReg - mReg; end
			else begin aReg = aReg + mReg; end

			if(aReg[511] == 1'b1)
				begin
					qReg = {qReg[510 : 0], 1'b0};
					flag = 1'b0;
				end
				else
				begin
					qReg = {qReg[510 : 0], 1'b1};
					flag = 1'b1;
				end
				count = count - 1;
			end //end if count
			else
			begin
			if(aReg[511] == 1'b1) begin
				aReg = aReg + mReg;
				mReg = mReg;
				qReg = qReg;
			end
			else begin
				qReg = qReg;
				aReg = aReg;
				mReg = mReg;
			end
			end

	end //end of posedge clk



endmodule
