`include "parameter.v"

/* Parameters for reference
`define DATA_WIDTH 32 
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH) 
`define TOTAL_BITS `DATA_WIDTH * `TOTAL_ADDR
`define DATA_WIDTH32 32
`define ADDR_WIDTH32 7
`define TOTAL_ADDR32 (2 ** `ADDR_WIDTH32)
*/

/* Template for Multiply Add Block

case (state)
	S0:
	begin
	end
	S1:
	begin
	end
	S2:
	begin
	end
	S3:
	begin
	end
	S4:
	begin
	end
	S5:
	begin
	end
	S6:
	begin
	end
	S7:
	begin
	end

endcase


*/
module MonPro
(
	input clk,
	input reset,
	input startInput, // FPGA input to start inputs in initialize state 
	input startCompute, // FPGA input to start computing in a wait_compute state
	input getResult, //FPGA input to get results
	input [`DATA_WIDTH - 1 : 0] m_input,	
	input [`DATA_WIDTH - 1 : 0] e_input, 
	output reg [3 : 0] state,
	output reg [4 : 0] exp_state,	//	for MonExp
	output reg [`DATA_WIDTH - 1 : 0] res_out
);

integer i,j,k,k_e1,k_e2;

//Variable initializations

//input
reg [`DATA_WIDTH - 1 : 0] m [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] e [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] n [`DATA_WIDTH - 1 : 0];

//secondary constants
reg [`DATA_WIDTH - 1 : 0] nprime0;
reg [`DATA_WIDTH - 1 : 0] r [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] t [`DATA_WIDTH - 1 : 0];

//used in monpro algorithm
reg [`DATA_WIDTH - 1 : 0] m_bar [`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] c_bar [`DATA_WIDTH - 1 : 0];

// multiply add block components
reg [`DATA_WIDTH - 1 : 0] carry; // "z" in example code, seemed simpler to call it carry bc it's assigned the carry bit
reg [`DATA_WIDTH - 1 : 0] v [`DATA_WIDTH + 1 : 0];
reg [`DATA_WIDTH - 1 : 0] m_multiply_add;


//States for multiply add block component
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
//States for MonPro
parameter INIT_STATE = 0, LOAD_M_E = 1, LOAD_N = 2, WAIT_COMPUTE = 3, CALC_M_BAR = 4;
parameter GET_K_E = 5, BIGLOOP = 6, CALC_C_BAR_M_BAR = 7, CALC_C_BAR_1 = 8, COMPLETE = 9, OUTPUT_RESULT = 10, TERMINAL = 11;

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

		/* ***
Insert instantiations of other pieces here

		*** */
		
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
				exp_state = LOAD_M_E;
			end
			
		end
		LOAD_M_E:  
		begin
		// take in message and private key, store in buffers.
		
		
		end
		LOAD_N:
		begin
		end
		WAIT_COMPUTE:
		begin
		end
		CALC_M_BAR:
		begin
		end
		GET_K_E:
		begin
		end
		BIGLOOP:
		begin
		end
		CALC_C_BAR_M_BAR:
		begin
		end
		CALC_C_BAR_1: 
		COMPLETE:
		begin
		end
		OUTPUT_RESULT:
		begin
		end
		TERMINAL:
		begin
		end
	
	endcase
	end

end //end of always block


endmodule 