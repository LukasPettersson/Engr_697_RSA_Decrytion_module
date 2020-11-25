module constant_r_t_double( 
	input clk,
	input  [4096 : 0] M_r, // M is divisor
	input start,
	output [4096 : 0] R_r, //Remainder
	output [4095 : 0] R_t, //Remainder
	output reg done
	);

/**************************************************************************************************/
/****** Provided doc has screenshots of results with proof based on big number calculations  ******/
/****** https://docs.google.com/document/d/1Jo82BKLWtnUedrWtl--ApAaL4YTivSimc5x1Ljk8CsQ/edit ******/
/**************************************************************************************************/

/****** Stuff for r ******/
reg [4096 : 0] q_r_Reg, m_r_Reg, a_r_Reg = 4097'b0;
reg flag_r;
reg [4096 : 0] count_r;
reg [24 : 0] div_const = 24'd4096; 


/****** Stuff for t ******/

reg [8192 : 0] q_t_Reg, m_t_Reg, a_t_Reg = 8193'b0;
reg flag_t;
reg [8192 : 0] count_t;


/****** Stuff for both ******/
reg [1:0] state = 2'b0;

/****** Beginning of crap ******/

assign R_r = a_r_Reg;     //Remainder for r
assign R_t = a_t_Reg;
always @ (posedge clk)
	begin
		case(state)
			2'b00:
			begin
			done = 0;	
			if(start)
			begin
				q_r_Reg = 1'b1 << div_const;
				m_r_Reg = M_r;
				a_r_Reg = 4097'b0;
				count_r = 4096'd4097;
				state = 2'b01;
				flag_r = 1;

			end
			end
			2'b01:
			if(count_r > 0) //while(count_r)
				begin
				a_r_Reg = {a_r_Reg[4095 : 0] , q_r_Reg[4096]};

				if(flag_r == 1'b1) begin a_r_Reg = a_r_Reg - m_r_Reg; end
				else begin a_r_Reg = a_r_Reg + m_r_Reg; end

				if(a_r_Reg[4096] == 1'b1)
					begin
						q_r_Reg = {q_r_Reg[4095 : 0], 1'b0};
						flag_r = 1'b0;
					end
					else
					begin
						q_r_Reg = {q_r_Reg[4095 : 0], 1'b1};
						flag_r = 1'b1;
					end
					count_r = count_r - 1;
				end //end if count_r
				else
				begin
				if(a_r_Reg[4096] == 1'b1) begin
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
			begin
				q_t_Reg = a_r_Reg * a_r_Reg;
				m_t_Reg = M_r; //n
				a_t_Reg = 8193'b0; //0
				count_t = 8193'd8193;
				state = 2'b11;
				flag_t = 1;
			end
			2'b11:
				if(count_t > 0) //while(count_t)
				begin
				a_t_Reg = {a_t_Reg[8191 : 0] , q_t_Reg[8192]};

				if(flag_t == 1'b1) begin a_t_Reg = a_t_Reg - m_t_Reg; end
				else begin a_t_Reg = a_t_Reg + m_t_Reg; end

				if(a_t_Reg[8192] == 1'b1)
					begin
						q_t_Reg = {q_t_Reg[8191 : 0], 1'b0};
						flag_t = 1'b0;
					end
					else
					begin
						q_t_Reg = {q_t_Reg[8191 : 0], 1'b1};
						flag_t = 1'b1;
					end
					count_t = count_t - 1;
				end //end if count_t
				else
				begin
				if(a_t_Reg[8192] == 1'b1) begin
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