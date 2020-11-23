module constant_r_t_new(
	input clk,
	input  [1024 : 0] Q_r, // Q_r is quotient, but since it's also an input, we're gonna use another variable for quotient
	input  [1024 : 0] M_r, // M is divisor
	input  [1024 : 0] A_r, // A is accumulator and also remainder, same deal as Q_r
	input start,
	output [1024 : 0] R_r, //Remainder
	input  [2047 : 0] M_t, // M_t is divisor
	input  [2047 : 0] A_t, // A_t is accumulator and also remainder, same deal as Q_t
	output [1023 : 0] R_t, //Remainder
	output reg done
	);


/**************************************************************************************************/
/****** Provided doc has screenshots of results with proof based on big number calculations  ******/
/****** https://docs.google.com/document/d/1Jo82BKLWtnUedrWtl--ApAaL4YTivSimc5x1Ljk8CsQ/edit ******/
/**************************************************************************************************/

/****** Stuff for r ******/
reg [1024 : 0] q_r_Reg, m_r_Reg, a_r_Reg;
reg flag_r;
reg [1024 : 0] count_r;


/****** Stuff for t ******/

reg [2047 : 0] q_t_Reg, m_t_Reg, a_t_Reg;
reg flag_t;
reg [2047 : 0] count_t;


/****** Stuff for both ******/
reg [1:0] state = 2'b0;

/****** Beginning of crap ******/

assign R_r = a_r_Reg;     //Remainder for r
assign R_t = a_t_Reg;
always @ (posedge clk)
	begin
		case(state)
			2'b00:
			if(start)
			begin
				q_r_Reg = Q_r;
				m_r_Reg = M_r;
				a_r_Reg = A_r;
				done = 0;
				count_r = 1024'd1025;
				state = 2'b01;
				flag_r = 1;

			end
			2'b01:
			if(count_r > 0) //while(count_r)
				begin
				a_r_Reg = {a_r_Reg[1023 : 0] , q_r_Reg[1024]};

				if(flag_r == 1'b1) begin a_r_Reg = a_r_Reg - m_r_Reg; end
				else begin a_r_Reg = a_r_Reg + m_r_Reg; end

				if(a_r_Reg[1024] == 1'b1)
					begin
						q_r_Reg = {q_r_Reg[1023 : 0], 1'b0};
						flag_r = 1'b0;
					end
					else
					begin
						q_r_Reg = {q_r_Reg[1023 : 0], 1'b1};
						flag_r = 1'b1;
					end
					count_r = count_r - 1;
				end //end if count_r
				else
				begin
				if(a_r_Reg[1024] == 1'b1) begin
					a_r_Reg = a_r_Reg + m_r_Reg;
					m_r_Reg = m_r_Reg;
					q_r_Reg = q_r_Reg;
				end
				else begin
					q_r_Reg = q_r_Reg;
					a_r_Reg = a_r_Reg;
					m_r_Reg = m_r_Reg;

				end
				state = 2'b10; // Continue to state 2 where starting t mod n process
				end
			2'b10: 
			if(start) begin
				q_t_Reg = a_r_Reg * a_r_Reg;
				m_t_Reg = M_t; //n
				a_t_Reg = A_t; //0
				count_t = 2048'd2048;
				state = 2'b11;
				flag_t = 1;
				end
			2'b11:
				if(count_t > 0) //while(count_t)
				begin
				a_t_Reg = {a_t_Reg[2046 : 0] , q_t_Reg[2047]};

				if(flag_t == 1'b1) begin a_t_Reg = a_t_Reg - m_t_Reg; end
				else begin a_t_Reg = a_t_Reg + m_t_Reg; end

				if(a_t_Reg[2047] == 1'b1)
					begin
						q_t_Reg = {q_t_Reg[2046 : 0], 1'b0};
						flag_t = 1'b0;
					end
					else
					begin
						q_t_Reg = {q_t_Reg[2046 : 0], 1'b1};
						flag_t = 1'b1;
					end
					count_t = count_t - 1;
				end //end if count_t
				else
				begin
				if(a_t_Reg[2047] == 1'b1) begin
					a_t_Reg = a_t_Reg + m_t_Reg;
					m_t_Reg = m_t_Reg;
					q_t_Reg = q_t_Reg;
				end
				else begin
					q_t_Reg = q_t_Reg;
					a_t_Reg = a_t_Reg;
					m_t_Reg = m_t_Reg;

				end
				done = 1;
				state = 0;
				end


		endcase
	end

	endmodule