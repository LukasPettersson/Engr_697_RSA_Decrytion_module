module n0prime(
							input [2047:0] p,q,
							output reg [2047:0] t,qinv,
							input start, clk,
							output done);
	/*
		n0prime = -n^-1mod(2^w)
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	  p has to be smaller than q to get the right answer

		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	*/

reg [2047:0] temp1, temp2;
reg [2047:0] b1, b2;
wire [2047:0] b;
reg [2:0] state = 5;
reg divStart;
wire divDone;
wire [2047:0] Q_out, rem;


nonrestoringdiv div(
										.clk(clk),
										.Q(temp1),
										.M(temp2),
										.A(2048'b0),
										.start(divStart),
										.Q_out(Q_out),
										.R(rem),
										.done(divDone)
									);

always@ (posedge clk) begin
if(start)
		state = 0;
end
assign b = b2 - Q_out*b1;
always@ (posedge clk) begin
		case(state)
			0: begin //start state
					temp1=p;
					temp2=q;
					b2=0;
					b1=1;
					state = 1;
				end
			1:
				begin		//start division state
					divStart = 1;
					state = 2;
				end
			2:
				begin			//wait for division to end, and check if we have to do the div again
					divStart = 0;
					if(divDone == 1)
						begin
							state = 3;
						end
				end
			3:
				begin

					if(rem >> 1 && rem <<1) // what does this check?
						begin
							temp1 = temp2;
							temp2 = rem;
							b2 = b1;
							b1 = b;

							state = 1;
						end
						else begin
							temp1 = temp2;
							temp2 = rem;
							b2 = b1;
							b1 = b;

							state = 4;
						end
				end
			4:
				begin
					begin
						t<=b1+p;
						if(t>p)
							qinv<=b1;
						else
							qinv<=t;
						end
				end
			5:
				begin //idle state
				end

		endcase
end
endmodule
