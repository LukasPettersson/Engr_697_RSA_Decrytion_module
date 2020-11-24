//`include "_parameter.v"

// Parameters for reference
`define DATA_WIDTH 32
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH)
`define TOTAL_BITS `DATA_WIDTH * `TOTAL_ADDR
`define DATA_WIDTH32 32
`define ADDR_WIDTH32 7
`define TOTAL_ADDR32 (2 ** `ADDR_WIDTH32)
`define DATA_LENGTH 1024

module MonPro
(
	input clk,
	input reset,
	input startInput, // FPGA input to start inputs in initialize state
	input getResult, //FPGA input to get results
	input [`DATA_WIDTH - 1 : 0] m_input,
	input [`DATA_WIDTH - 1 : 0] e_input,
	input [`DATA_WIDTH - 1 : 0] n_input,
	output reg [3 : 0] state,
	output reg [4 : 0] exp_state,	//	for MonExp
	output reg [`DATA_WIDTH - 1 : 0] res_out
);

integer i,j,k,k_e1,k_e2;

//Variable initializations
reg start_secondary;
wire startTransfer;
//input
reg [`DATA_WIDTH - 1 : 0] m [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] e [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] n [`TOTAL_ADDR - 1 : 0];
reg [`DATA_LENGTH - 1 : 0] n_full;

//secondary constants
reg [`DATA_WIDTH - 1 : 0] n0prime;
reg [`DATA_WIDTH - 1 : 0] r [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] t [`DATA_WIDTH - 1 : 0];

//used in monpro algorithm
reg [`DATA_WIDTH - 1 : 0] m_bar [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] c_bar [`DATA_WIDTH - 1 : 0];
reg [5 : 0] count_input = 6'd0;


// multiply add block components
reg [`DATA_WIDTH - 1 : 0] carry; // "z" in example code, seemed simpler to call it carry bc it's assigned the carry bit
reg [`DATA_WIDTH - 1 : 0] v [`DATA_WIDTH + 1 : 0];
reg [`DATA_WIDTH - 1 : 0] m_multiply_add;


//States for multiply add block component
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
//States for MonPro
parameter INIT_STATE = 0, LOAD_M_E_N = 1, LOAD_N = 2, COMPUTE_SECONDARY_INPUTS = 3, WAIT_COMPUTE_SECONDARY_INPUTS = 4,CATCH_SECONDARY_INPUTS = 5, CALC_M_BAR = 6;
parameter GET_K_E = 7, BIGLOOP = 8, CALC_C_BAR_M_BAR = 9, CALC_C_BAR_1 = 10, COMPLETE = 11, OUTPUT_RESULT = 12, TERMINAL = 13;

//multiply add block components
reg [`DATA_WIDTH - 1 : 0] x0;
reg [`DATA_WIDTH - 1 : 0] y0;
reg [`DATA_WIDTH - 1 : 0] z0;
reg [`DATA_WIDTH - 1 : 0] last_c0;
wire [`DATA_WIDTH - 1 : 0] s0;
wire [`DATA_WIDTH - 1 : 0] c0;

//secondary constant components if necessary


// Instantiations

MultiplyAdd m0 (.clk(clk),.x(x0),.y(y0),.z(z0),.cin(last_c0),.s(s0),.cout(c0));
secondaryInputTop sip0 (.start(start_secondary), .clk(clk), .n(n_full), .n0p(n0p_out), .r(r_out), .t(t_out), .done(secondary_input_done), .startTransfer(startTransfer));

initial begin

	for(i = 0; i < `TOTAL_ADDR + 2; i = i + 1) begin
		v[i] = 32'h00000000;
	end
	for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
		m[i] = 32'h00000000;
		e[i] = 32'h00000000;
	end
	res_out = 32'h00000000;

	carry = 32'h00000000;	// initial C = 0
	i = 0;
	j = 0;
	k = 0;
	state = S0;
	exp_state = INIT_STATE;
	k_e1 = `TOTAL_ADDR - 1;
	k_e2 = `DATA_WIDTH - 1;
end


always @ (posedge clk or posedge reset)
begin
	if (reset) begin
		for(i = 0; i < `TOTAL_ADDR + 2; i = i + 1) begin
			v[i] = 32'h00000000;
		end
		for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
			m[i] = 32'h00000000;
			e[i] = 32'h00000000;
		end

		res_out = 32'h00000000;
		carry = 32'h00000000;	// initial C = 0
		i = 0;
		j = 0;
		k = 0;
		state = S0;
		exp_state = INIT_STATE;
		k_e1 = `TOTAL_ADDR - 1;
		k_e2 = `DATA_WIDTH - 1;
	end //end of if reset
	else begin
	case (exp_state)

		INIT_STATE:
		begin
		//waiting for the fpga start flag
			if(startInput) begin
				exp_state = LOAD_M_E_N;
			end
		end

		LOAD_M_E_N:
		begin
		// take in message and private key and n, store in buffers.
			if(count_input < `DATA_WIDTH) begin //if i < 32
				m[count_input] = m_input;
				e[count_input] = e_input;
				n[count_input] = n_input;
				n_full = {n_full[991:0],n_input};
				count_input = count_input + 1;
			end
			else begin
				exp_state = COMPUTE_SECONDARY_INPUTS;
			end
		end

		COMPUTE_SECONDARY_INPUTS:
		begin
			if(startTransfer) begin
				count_input = 0;
				exp_state = CATCH_SECONDARY_INPUTS;
			end
		end

		CATCH_SECONDARY_INPUTS:
		begin
			if(!secondary_input_done) begin
				r[count_input] <= r_out;
				t[count_input] <= t_out;
				n0prime <= n0p_out;
				count_input <= count_input + 1;
			end
			else begin
				exp_state <= CALC_M_BAR;
			end
		end

		CALC_M_BAR:
		begin
			case(state)
				S0: begin
					if(k == 0) begin
						x0 <= m[i];
						y0 <= t[j];
						z0 <= v[j];
						last_c0 <= carry;
						k = 1;
					end //end if
					else if(k ==1) begin
						v[j] <= s0;
						carry <= c0;
						j = j + 1;
						if(j == `TOTAL_ADDR) begin //TOTAL_ADDR = 32-bit
							j = 0;
							state = S1;
						end
						k = 0;
					end //end else if
				end //end of S0
				S1: begin
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end //if(k == 0)
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						v[`TOTAL_ADDR + 1] <= c0;
						state = S2;
						k = 0;
					end //else if
				end // end S1
				S2:
				begin
					if(k == 0) begin
						x0 <=v[0];
						y0 <= n0prime;
						z0 <= 32'h0;
						last_c0 <= 32'h0;
						k = 1;
					end //end if(k == 0)
					else if(k == 1) begin
						m_multiply_add <= s0;
						state = S3;
						k = 0;
					end // end if if(k == 1)
				end//end S2
				S3:
				begin
					if(j == 0) begin
						if(k == 0) begin
							x0 <= m_multiply_add;
							y0 <= n[0];
							z0 <= v[0];
							last_c0 <= 32'h0;
							k = 1;
						end
						else if(k == 1) begin
							carry <= c0;
							j = j + 1;
							k = 0;
						end //if(k == 1)
						else begin
							if(k == 0) begin
								x0 <= m_multiply_add;
								y0 <= n[j];
								z0 <= v[j];
								last_c0 <= carry;
								k = 1;
							end
							else if(k == 1) begin
								v[j - 1] <= s0;
								carry <= c0;
								j = j + 1;
								if(j == `TOTAL_ADDR) begin //TOTAL_ADDR = 32
									j = 0;
									state = S4;
								end
								k = 0;
							end //if(k == 1)
						end //else
					end //if j == 0
				end //end S3
				S4:
				begin
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR - 1] <= s0;
						carry <= c0;
						state = S5;
						k = 0;
					end
				end //end S4
				S5:
				begin
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR + 1];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						i = i + 1;
						state = S0;
						if(i >= `TOTAL_ADDR) begin	// end
							state = S6;
							i = 0;
						end
						k = 0;
					end
				end //end S5
				S6:
				begin
					$display("Exp_state=ES0\tIn State S6!");
					// prepaer end state, update output, and set all to default
					// store into m_bar and c_bar
					for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
						m_bar[i] = v[i];
					end
					for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
						c_bar[i] = r[i];
					end
					for(i = 0; i < `TOTAL_ADDR + 2; i = i + 1) begin
						v[i] = 32'h0;
					end
					carry = 32'h0;
					i = 0;
					j = 0;
					k = 0;
					state = S7;
				end //end S6
				S7:
				begin
						exp_state = GET_K_E;	// go to next state
						state = S0;
				end //end S7
			endcase
		end //end CALC_M_BAR

		GET_K_E:
		begin
			if(e[k_e1][k_e2] == 1) begin
				$display("e[%d][%d] = %d", k_e1, k_e2, e[k_e1][k_e2]);
				exp_state = BIGLOOP;
			end
			else begin
				if(k_e2 == 0) begin
					k_e1 = k_e1 - 1;
					k_e2 = `DATA_WIDTH - 1;
				end
				else begin
					k_e2 = k_e2 - 1;
				end
			end
		end // end GET_K_E

		BIGLOOP:
		begin
			case(state)
				S0:
				begin
					if(k == 0) begin	// first clock: initial input
						// initial a new multiplier computation
						x0 <= c_bar[i];
						y0 <= c_bar[j];
						z0 <= v[j];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin	// second clock: store output
						// store the output of multiplier
						v[j] <= s0;
						carry <= c0;
						j = j + 1;
						if(j == `TOTAL_ADDR) begin	// loop end
							j = 0;
							state = S1;
						end
						k = 0;
					end
				end // end S0
				S1:
				begin
					if(k == 0) begin	// first clock: initial input
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						v[`TOTAL_ADDR + 1] <= c0;
						state = S2;
						k = 0;
					end
				end // end S1
				S2:
				begin
					if(k == 0) begin	// first clock: initial input
						x0 <= v[0];
						y0 <= n0prime;
						z0 <= 32'h0;
						last_c0 <= 32'h0;
						k = 1;
					end
					else if(k == 1) begin
						m_multiply_add <= s0;
						state = S3;
						k = 0;
					end
				end //end S2
				S3:
				begin
					if(j == 0) begin
						if(k == 0) begin	// first clock: initial input
							x0 <= m_multiply_add;
							y0 <= n[0];
							z0 <= v[0];
							last_c0 <= 32'h0;
							k = 1;
						end
						else if(k == 1) begin
							carry <= c0;
							j = j + 1;
							k = 0;
						end
					end
					else begin
						if(k == 0) begin
							x0 <= m_multiply_add;
							y0 <= n[j];
							z0 <= v[j];
							last_c0 <= carry;
							k = 1;
						end
						else if(k == 1) begin
							v[j - 1] <= s0;
							carry <= c0;
							j = j + 1;
							if(j == `TOTAL_ADDR) begin
								j = 0;
								state = S4;
							end
							k = 0;
						end
					end
				end // end S3
				S4:
				begin
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR - 1] <= s0;
						carry <= c0;
						state = S5;
						k = 0;
					end
				end //end S4
				S5:
				begin
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR + 1];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						i = i + 1;
						state = S0;
						if(i >= `TOTAL_ADDR) begin	// end
							state = S6;
							i = 0;
						end
						k = 0;
					end
				end // end S5

				S6: begin
					$display("Exp_state=ES2\tIn State S6!");
					// prepaer end state, update output, and set all to default
					// store into m_bar and c_bar
					for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
						c_bar[i] = v[i];
					end
					for(i = 0; i < `TOTAL_ADDR + 2; i = i + 1) begin
						v[i] = 32'h0;
					end
					carry = 32'h0;
					i = 0;
					j = 0;
					k = 0;
					state = S7;
				end // end S6
				S7:
				begin
					$display("k_e1: %d, k_e2: %d", k_e1, k_e2);
					if(e[k_e1][k_e2] == 1) begin
						exp_state = CALC_C_BAR_M_BAR;	// go to c_bar = MonPro(c_bar, m_bar)
					end
					else begin
						if(k_e1 <= 0 && k_e2 <= 0)
							exp_state = CALC_C_BAR_1;
						else if(k_e2 == 0) begin	// down 1 of e
							k_e1 = k_e1 - 1;
							k_e2 = `DATA_WIDTH - 1;
						end
						else
							k_e2 = k_e2 - 1;
					end
					state = S0;
				end // end S7
			endcase
		end // end BIGLOOP

		CALC_C_BAR_M_BAR:
		begin
			case (state)	// c_bar = MonPro(c_bar, c_bar)
				S0:
				begin	// vector(v) = x[0] * y + prev[vector(v)] + z
					if(k == 0) begin	// first clock: initial input
						// initial a new multiplier computation
						x0 <= c_bar[i];
						y0 <= m_bar[j];
						z0 <= v[j];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin	// second clock: store output
						// store the output of multiplier
						v[j] <= s0;
						carry <= c0;
						j = j + 1;
						if(j == `TOTAL_ADDR) begin	// loop end
							j = 0;
							state = 1;
						end
						k = 0;
					end
				end

				S1:
				begin // (C, S) = v[s] + C, v[s] = S, v[s + 1] = C
					if(k == 0) begin	// first clock: initial input
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						v[`TOTAL_ADDR + 1] <= c0;
						state = S2;
						k = 0;
					end
				end

				S2:
				begin // m = (v[0] * n0_prime) mod 2^w
					if(k == 0) begin	// first clock: initial input
						x0 <= v[0];
						y0 <= n0prime;
						z0 <= 32'h0;
						last_c0 <= 32'h0;
						k = 1;
					end
					else if(k == 1) begin
						m_multiply_add <= s0;
						state = S3;
						k = 0;
					end
				end

				S3:
				begin // vector(v) = (m * vector(n) + vector(v)) >> WIDTH
				// (C, S) = v[0] + m * n[0]
					if(j == 0) begin
						if(k == 0) begin	// first clock: initial input
							x0 <= m_multiply_add;
							y0 <= n[0];
							z0 <= v[0];
							last_c0 <= 32'h0;
							k = 1;
						end
						else if(k == 1) begin
							carry <= c0;
							j = j + 1;
							k = 0;
						end
					end
					else begin
						if(k == 0) begin
							x0 <= m_multiply_add;
							y0 <= n[j];
							z0 <= v[j];
							last_c0 <= carry;
							k = 1;
						end
						else if(k == 1) begin
							v[j - 1] <= s0;
							carry <= c0;
							j = j + 1;
							if(j == `TOTAL_ADDR) begin
								j = 0;
								state = S4;
							end
							k = 0;
						end
					end
				end

				S4:
				begin //	(C, S) = v[s] + C, v[s - 1] = S
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR - 1] <= s0;
						carry <= c0;
						state = S5;
						k = 0;
					end
				end

				S5:
				begin // v[s] = v[s + 1] + C
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR + 1];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						i = i + 1;
						state = S0;
						if(i >= `TOTAL_ADDR) begin	// end
							state = S6;
							i = 0;
						end
						k = 0;
					end
				end

				S6:
				begin
					$display("Exp_state=ES3\tIn State S6!");
					// prepaer end state, update output, and set all to default
					// store into m_bar and c_bar
					for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
						c_bar[i] = v[i];
					end
					for(i = 0; i < `TOTAL_ADDR + 2; i = i + 1) begin
						v[i] = 32'h0;
					end
					carry = 32'h0;
					i = 0;
					j = 0;
					k = 0;
					state = S7;
				end

				S7:
				begin
					if(k_e1 <= 0 && k_e2 <= 0) begin
						exp_state = CALC_C_BAR_1;
						state = S0;
					end
					else begin
						if(k_e2 == 0) begin	// down 1 of e
							k_e1 = k_e1 - 1;
							k_e2 = `DATA_WIDTH - 1;
						end
						else
							k_e2 = k_e2 - 1;
						exp_state = BIGLOOP;
						state = S0;
					end
				end
			endcase
		end //end CALC_C_BAR_M_BAR

		CALC_C_BAR_1: // c = MonPro(1, c_bar)
		begin
			case (state)	// c_bar = MonPro(c_bar, c_bar)
				S0:
				begin	// vector(v) = x[0] * y + prev[vector(v)] + z
					if(i == 0) begin
						if(k == 0) begin	// first clock: initial input
							// initial a new multiplier computation
							x0 <= 32'h00000001;
							y0 <= c_bar[j];
							z0 <= v[j];
							last_c0 <= carry;
							k = 1;
						end
						else if(k == 1) begin	// second clock: store output
							// store the output of multiplier
							v[j] <= s0;
							carry <= c0;
							j = j + 1;
							if(j == `TOTAL_ADDR) begin	// loop end
								j = 0;
								state = S1;
							end
							k = 0;
						end
					end
					else begin
						if(k == 0) begin	// first clock: initial input
							// initial a new multiplier computation
							x0 <= 32'h0;
							y0 <= c_bar[j];
							z0 <= v[j];
							last_c0 <= carry;
							k = 1;
						end
						else if(k == 1) begin	// second clock: store output
							// store the output of multiplier
							v[j] <= s0;
							carry <= c0;
							j = j + 1;
							if(j == `TOTAL_ADDR) begin	// loop end
								j = 0;
								state = S1;
							end
							k = 0;
						end
					end
				end

				S1:
				begin // (C, S) = v[s] + C, v[s] = S, v[s + 1] = C
					if(k == 0) begin	// first clock: initial input
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						v[`TOTAL_ADDR + 1] <= c0;
						state = S2;
						k = 0;
					end
				end

				S2:
				begin // m = (v[0] * n0_prime) mod 2^w
					if(k == 0) begin	// first clock: initial input
						x0 <= v[0];
						y0 <= n0prime;
						z0 <= 32'h0;
						last_c0 <= 32'h0;
						k = 1;
					end
					else if(k == 1) begin
						m_multiply_add <= s0;
						state = S3;
						k = 0;
					end
				end

				S3:
				begin // vector(v) = (m * vector(n) + vector(v)) >> WIDTH
				// (C, S) = v[0] + m * n[0]
					if(j == 0) begin
						if(k == 0) begin	// first clock: initial input
							x0 <= m_multiply_add;
							y0 <= n[0];
							z0 <= v[0];
							last_c0 <= 32'h0;
							k = 1;
						end
						else if(k == 1) begin
							carry <= c0;
							j = j + 1;
							k = 0;
						end
					end
					else begin
						if(k == 0) begin
							x0 <= m_multiply_add;
							y0 <= n[j];
							z0 <= v[j];
							last_c0 <= carry;
							k = 1;
						end
						else if(k == 1) begin
							v[j - 1] <= s0;
							carry <= c0;
							j = j + 1;
							if(j == `TOTAL_ADDR) begin
								j = 0;
								state = S4;
							end
							k = 0;
						end
					end
				end

				S4:
				begin //	(C, S) = v[s] + C, v[s - 1] = S
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR - 1] <= s0;
						carry <= c0;
						state = S5;
						k = 0;
					end
				end

				S5:
				begin // v[s] = v[s + 1] + C
					if(k == 0) begin
						x0 <= 32'h0;
						y0 <= 32'h0;
						z0 <= v[`TOTAL_ADDR + 1];
						last_c0 <= carry;
						k = 1;
					end
					else if(k == 1) begin
						v[`TOTAL_ADDR] <= s0;
						i = i + 1;
						state = S0;
						if(i >= `TOTAL_ADDR) begin	// end
							state = S6;
							i = 0;
						end
						k = 0;
					end
				end

				S6:
				begin
					$display("Exp_state=ES4\tIn State S6!");
					// prepare end state, update output, and set all to default
					// store into m_bar and c_bar
					for(i = 0; i < `TOTAL_ADDR; i = i + 1) begin
						c_bar[i] = v[i];
					end
					for(i = 0; i < `TOTAL_ADDR + 2; i = i + 1) begin
						v[i] = 0;
					end
					carry = 32'h0;
					i = 0;
					j = 0;
					k = 0;
					state = S7;
				end

				S7:
				begin
					exp_state = OUTPUT_RESULT;	// end state of exp!
					state = S0;
				end
			endcase
		end // end CALC_C_BAR_1:
		/*
		COMPLETE:
		begin
		end
		*/
		OUTPUT_RESULT:
		begin
			if(i < `TOTAL_ADDR) begin
				res_out = c_bar[i];
				i = i + 1;
			end
			else begin
				exp_state = TERMINAL;
				i = 0;
				res_out = 32'h0;
			end
		end
		TERMINAL:
		begin
			res_out = 32'h0;
		end
	endcase
end

end //end of always block


endmodule
