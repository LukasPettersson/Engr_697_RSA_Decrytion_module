module nonrestoringdiv(
	input clk,
	input  [1024 : 0] Q, // Q is quotient, but since it's also an input, we're gonna use another variable for quotient
	input  [1024 : 0] M, // M is divisor
	input start,
	output [1024 : 0] Q_out, //Quotient
	output [1024 : 0] R, //Remainder
	output reg done);

reg [1024 : 0] qReg, mReg;
reg [1024 : 0] aReg = 1025'b0;
reg flag;
reg [1024 : 0] count;
reg state = 0;

/*
initial begin
	qReg = Q;
	mReg = M;
	aReg = A;
	flag = 1;
end
*/
assign Q_out = qReg;
assign R = aReg;
always @ (posedge clk)
	begin
		case(state)
			0: begin
			done = 0;
			if(start)
				begin
					qReg = Q;
					mReg = M;
					aReg = 1025'b0;
					done = 0;
					count = 1025'd1025;
					state = 1;
					flag = 1;
				end
			end
			1:
			if(count > 0) //while(count)
				begin
				aReg = {aReg[1023 : 0], qReg[1024]};

				if(flag == 1'b1) begin aReg = aReg - mReg; end
				else begin aReg = aReg + mReg; end

				if(aReg[1024] == 1'b1)
					begin
						qReg = {qReg[1023 : 0], 1'b0};
						flag = 1'b0;
					end
					else
					begin
						qReg = {qReg[1023 : 0], 1'b1};
						flag = 1'b1;
					end
					count = count - 1;
				end //end if count
				else
				begin
				if(aReg[1024] == 1'b1) begin
					aReg = aReg + mReg;
					mReg = mReg;
					qReg = qReg;
				end
				else begin
					qReg = qReg;
					aReg = aReg;
					mReg = mReg;

				end
				done = 1;
				state = 0;
				end
		endcase
	end

endmodule
