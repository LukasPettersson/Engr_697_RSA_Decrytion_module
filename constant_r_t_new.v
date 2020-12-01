`define DATA_WIDTH 32 //used
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH) //used. 32
`define DATA_LENGTH 1024
`define T_DATA (`DATA_LENGTH * 2)

module constant_r_t_new(
	input clk,
	input  [`DATA_LENGTH - 1 : 0] M_r, // M is divisor
	input start,
	output [`DATA_LENGTH - 1 : 0] R_r, //Remainder
	output [`DATA_LENGTH - 1 : 0] R_t, //Remainder
	output reg done
	);

/**************************************************************************************************/
/****** Provided doc has screenshots of results with proof based on big number calculations  ******/
/****** https://docs.google.com/document/d/1Jo82BKLWtnUedrWtl--ApAaL4YTivSimc5x1Ljk8CsQ/edit ******/
/**************************************************************************************************/

/****** Stuff for r ******/
reg [`DATA_LENGTH : 0] q_r_Reg, m_r_Reg, a_r_Reg = 1025'b0;
reg flag_r;
reg [`DATA_LENGTH : 0] count_r;
reg [12 : 0] div_const = 12'd1024; //Need to change to scale up


/****** Stuff for t ******/

reg [`T_DATA - 1 : 0] q_t_Reg, m_t_Reg, a_t_Reg = 2048'b0;
reg flag_t;
reg [15 : 0] count_t;


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
				a_r_Reg = 1025'b0;
				count_r = 1024'd1025;
				state = 2'b01;
				flag_r = 1;

			end
			end
			2'b01:
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
				a_t_Reg = 2048'b0; //0
				count_t = 16'd2048;

				state = 2'b11;
				flag_t = 1;
			end
			2'b11:
				if(count_t > 0) //while(count_t)
				begin
				a_t_Reg = {a_t_Reg[`T_DATA - 2 : 0] , q_t_Reg[`T_DATA - 1]};

				if(flag_t == 1'b1) begin a_t_Reg = a_t_Reg - m_t_Reg; end
				else begin a_t_Reg = a_t_Reg + m_t_Reg; end

				if(a_t_Reg[`T_DATA - 1] == 1'b1)
					begin
						q_t_Reg = {q_t_Reg[`T_DATA - 2 : 0], 1'b0};
						flag_t = 1'b0;
					end
					else
					begin
						q_t_Reg = {q_t_Reg[`T_DATA - 2 : 0], 1'b1};
						flag_t = 1'b1;
					end
					count_t = count_t - 1;
				end //end if count_t
				else
				begin
				if(a_t_Reg[`T_DATA - 1] == 1'b1) begin
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
