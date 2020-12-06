`define DATA_WIDTH 32 //used
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH) //used. 32
`define DATA_LENGTH 1024
`define T_DATA (`DATA_LENGTH * 2)

module constant_r_t_new_new(
	input clk,
	input  [`DATA_LENGTH - 1 : 0] M_r, // M is divisor
	input start,
	output reg [`DATA_LENGTH - 1 : 0] R_r, //Remainder
	output reg [`DATA_LENGTH - 1 : 0] R_t, //Remainder
	output reg done
	);

/**************************************************************************************************/
/****** Provided doc has screenshots of results with proof based on big number calculations  ******/
/****** https://docs.google.com/document/d/1Jo82BKLWtnUedrWtl--ApAaL4YTivSimc5x1Ljk8CsQ/edit ******/
/**************************************************************************************************/

/****** Stuff for r ******/
reg [`DATA_LENGTH : 0] q_r_Reg, m_r_Reg, q_t0, q_t1, a_r_Reg = 1025'b0;
reg flag_r;
reg [11 : 0] count_r;
reg [12 : 0] div_const = 12'd1024; //Need to change to scale up


/****** Stuff for t ******/

reg [`T_DATA - 1 : 0] q_t_Reg;

/****** Stuff for both ******/
reg [2:0] state = 3'b0;
reg [1:0] karatsuba_state = 2'b0;
parameter INIT_R = 0, DIV_R = 1, INIT_T = 2, CHECK_T_SIZE = 3, DIV_SMALL_T = 4, KARATSUBA_LIKE = 5;
parameter KARATSUBA_0 = 0, KARATSUBA_1 = 1, KARATSUBA_2 = 2;
/****** Beginning of crap ******/

//assign R_r = a_r_Reg;     //Remainder for r
//assign R_t = a_t_Reg;
always @ (posedge clk)
	begin
	//$display("State: %d, Karatsuba State: %d\n R_r: %h,\n q_t: %b", state, karatsuba_state, R_r, q_t_Reg);
		case(state)

			INIT_R:
			begin
			done = 0;
			if(start)
			begin
				q_r_Reg = 1'b1 << div_const;
				m_r_Reg = M_r;
				a_r_Reg = 1025'b0;
				count_r = 12'd1025;
				state = DIV_R;
				flag_r = 1;
				q_t_Reg = 2048'b0;

			end
			end

			DIV_R:
			if(count_r > 0) //while(count_r)
				begin
				a_r_Reg = {a_r_Reg[`DATA_LENGTH - 1 : 0] , q_r_Reg[`DATA_LENGTH]};

				if(flag_r == 1'b1) begin a_r_Reg = a_r_Reg - m_r_Reg; end
				else begin a_r_Reg = a_r_Reg + m_r_Reg; end

				if(a_r_Reg[`DATA_LENGTH] == 1'b1)
					begin
						q_r_Reg = {q_r_Reg[`DATA_LENGTH - 1 : 0], 1'b0};
						flag_r = 1'b0;
					end
					else
					begin
						q_r_Reg = {q_r_Reg[`DATA_LENGTH - 1 : 0], 1'b1};
						flag_r = 1'b1;
					end
					count_r = count_r - 1;
				end //end if count_r
				else
				begin
				if(a_r_Reg[`DATA_LENGTH] == 1'b1) begin
					R_r = a_r_Reg + m_r_Reg;
					m_r_Reg = m_r_Reg;
					q_r_Reg = q_r_Reg;
				end
				else begin
					q_r_Reg = q_r_Reg;
					R_r = a_r_Reg;
					m_r_Reg = m_r_Reg;

				end
				state = INIT_T; // Continue to state 2 where starting t mod n process
				end

			INIT_T:
			begin
				q_t_Reg = R_r * R_r;
				state = CHECK_T_SIZE;
			end

			CHECK_T_SIZE:
			begin
				q_t0 = 1025'b0;
				q_t1 = 1025'b0;
				if(q_t_Reg < (1'b1 << div_const))
					begin
						q_r_Reg = q_t_Reg[1024 : 0];
						m_r_Reg = M_r;
						a_r_Reg = 1025'b0;
						count_r = 12'd1025;
						state = DIV_SMALL_T;
						flag_r = 1;
					end
					else 
					begin // Split q_t, q_t0 mod n + (q_t1 mod n) * r, 
						q_t1 = q_t_Reg[2047 : 1024];
						q_t0 = q_t_Reg[1023 : 0];
						a_r_Reg = 1025'b0;
						count_r = 12'd1025;
						state = KARATSUBA_LIKE;
						flag_r = 1;
					end
					end

			DIV_SMALL_T: //end after this
			begin
				if(count_r > 0) //while(count_r)
				begin
				a_r_Reg = {a_r_Reg[`DATA_LENGTH - 1 : 0] , q_r_Reg[`DATA_LENGTH]};

				if(flag_r == 1'b1) begin a_r_Reg = a_r_Reg - m_r_Reg; end
				else begin a_r_Reg = a_r_Reg + m_r_Reg; end

				if(a_r_Reg[`DATA_LENGTH] == 1'b1)
					begin
						q_r_Reg = {q_r_Reg[`DATA_LENGTH - 1 : 0], 1'b0};
						flag_r = 1'b0;
					end
					else
					begin
						q_r_Reg = {q_r_Reg[`DATA_LENGTH - 1 : 0], 1'b1};
						flag_r = 1'b1;
					end
					count_r = count_r - 1;
				end //end if count_r
				else
				begin
				if(a_r_Reg[`DATA_LENGTH] == 1'b1) begin
					R_t = a_r_Reg + m_r_Reg;
					m_r_Reg = m_r_Reg;
					q_r_Reg = q_r_Reg;
				end
				else begin
					q_r_Reg = q_r_Reg;
					R_t = a_r_Reg;
					m_r_Reg = m_r_Reg;

				end
				state = INIT_R;
				done = 1;
			end
			end

			KARATSUBA_LIKE:
			begin
				case(karatsuba_state)

					KARATSUBA_0:
					begin
						if(count_r > 0) //while(count_r)
						begin
						a_r_Reg = {a_r_Reg[`DATA_LENGTH - 1 : 0] , q_t0[`DATA_LENGTH]};

						if(flag_r == 1'b1) begin a_r_Reg = a_r_Reg - m_r_Reg; end
						else begin a_r_Reg = a_r_Reg + m_r_Reg; end

						if(a_r_Reg[`DATA_LENGTH] == 1'b1)
							begin
								q_t0 = {q_t0[`DATA_LENGTH - 1 : 0], 1'b0};
								flag_r = 1'b0;
							end
							else
							begin
								q_t0 = {q_t0[`DATA_LENGTH - 1 : 0], 1'b1};
								flag_r = 1'b1;
							end
							count_r = count_r - 1;
						end //end if count_r
						else
						begin
						if(a_r_Reg[`DATA_LENGTH] == 1'b1) begin
							q_t0 = a_r_Reg + m_r_Reg;
						end
						else begin
							q_t0 = a_r_Reg;
						end
						karatsuba_state = KARATSUBA_1;
					end
					end
					KARATSUBA_1:
					begin
						a_r_Reg = 1025'b0;
						count_r = 12'd1025;
						karatsuba_state = KARATSUBA_2;
						flag_r = 1;
					end

					KARATSUBA_2:
					begin
						if(count_r > 0) //while(count_r)
							begin
							a_r_Reg = {a_r_Reg[`DATA_LENGTH - 1 : 0] , q_t1[`DATA_LENGTH]};

							if(flag_r == 1'b1) begin a_r_Reg = a_r_Reg - m_r_Reg; end
							else begin a_r_Reg = a_r_Reg + m_r_Reg; end

							if(a_r_Reg[`DATA_LENGTH] == 1'b1)
								begin
									q_t1 = {q_t1[`DATA_LENGTH - 1 : 0], 1'b0};
									flag_r = 1'b0;
								end
								else
								begin
									q_t1 = {q_t1[`DATA_LENGTH - 1 : 0], 1'b1};
									flag_r = 1'b1;
								end
								count_r = count_r - 1;
							end //end if count_r
							else
							begin
							if(a_r_Reg[`DATA_LENGTH] == 1'b1) begin
								q_t1 = a_r_Reg + m_r_Reg;
							end
						else begin
								q_t1 = a_r_Reg;
						end

						q_t_Reg = (q_t1 * R_r) + q_t0;
						state = CHECK_T_SIZE;
						karatsuba_state = KARATSUBA_0;
						$display("q_t_Reg: %b", q_t_Reg);
					end
					end
				endcase

			end

		endcase
	end

	endmodule
