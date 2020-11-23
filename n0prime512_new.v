module n0prime(
							input [1024:0] n,
							input start, clk,
							output[31:0] n0prime,
							output reg done);
	/*
		n0prime = -n^-1mod(2^w)
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	  p has to be smaller than q to get the right answer

		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	*/
reg [1024:0] t,qinv;
reg [1024:0] temp1, temp2;
reg [1024:0] w_const = 1024'h100000000;
reg [1024:0] b1, b2;
wire [1024:0] b;
reg [2:0] state = 5;
reg divStart;
wire divDone;
wire [1024:0] Q_out, rem;

assign n0prime = -qinv;

nonrestoringdiv div(
										.clk(clk),
										.Q(temp1),
										.M(temp2),
										.A(1025'b0),
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
					temp1=w_const;
					temp2=n;
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
						t = b1+w_const;
						if(t>w_const)
							qinv = b1[31:0];
						else
							qinv = t[31:0];
						end
						done = 1;
						state = 5;
				end
			5:
				begin //idle state
				done = 0;
				end

		endcase
end
endmodule
