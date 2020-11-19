module n0prime(
							input [7:0] p,q,
							output reg [7:0] t,qinv
							input start,
							output done);
	/*
		n0prime = -n^-1mod(2^w)
	*/

reg [7:0] temp1, temp2;
reg [7:0] b1, b2;
reg [7:0] b;
reg state = 4;
reg divStart, divDone;
nonrestoringdiv div(
										.clk(clk),
										.Q(temp1),
										.M(temp2),
										.A(0),
										.start(divStart),
										.Q_out(Q_out),
										.R(rem),
										.done(divDone)
										);

always@ (posedge clk) begin
	if(start)
		state = 0;
end

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
					if(divDone == 1)
						begin
							b = b2 - Q_out*b1;
							if(rem >> 1 && rem <<1)
								begin
									temp1 = temp2;
									temp2 = rem;
									b2 = b1;
									b1 = b;
									state = 1;
								else
									state = 3;
								end
						end
				end
				3:begin
				begin
					t<=b1+p;
					if(t>p)
						qinv<=b1;
					else
						qinv<=t;
									end
					end
					4:begin //idle state
					end

		endcase
end
