`include "parameter.v"

module top_level(
	input i_Rx_Serial,
	input r_Clock,
	input clk,
	input reset,
	input startInput,
	input startCompute,
	input getResults,
	input [`DATA_WIDTH - 1 : 0] m_input,
	input [`DATA_WIDTH - 1 : 0] e_input,
	output wire [3 : 0] state,
	output wire [4 : 0] exp_state,	//	for MonExp
	output wire [`DATA_WIDTH - 1 : 0] res_out,
	output wire uartFlag,
	output reg[`DATA_WIDTH - 1 : 0] totalTemp
);



//uart stuff
//reg        i_Rx_Serial_out;
wire  	 out_serial;
wire [7:0] o_Rx_Byte;
//wire uartFlag;
reg [7 : 0] tempInputs [3 : 0];
//reg [`DATA_WIDTH - 1 : 0] tempInputs;


reg [`DATA_WIDTH - 1 : 0] m[`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] p[`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] q[`DATA_WIDTH - 1 : 0];
reg [`DATA_WIDTH - 1 : 0] e[`DATA_WIDTH - 1 : 0];
//order of the uart transmition is m -> p -> q -> e
//sends 8 x 64 data
reg [`DATA_WIDTH - 1 : 0] n[`DATA_WIDTH - 1 : 0];
//assign n = p*q;

integer i=0,k;
parameter M = 0, P = 1, Q = 2, E = 3;
reg [1:0] variable;

reg depositFlag;
//write a proper test bench to make sure that this works
//this takes in values from the uart and stores them into an intermetdiate buffer tempInputs
//UPDATE: THIS NEEDS TO BE VERIFIED, THIS COMPILES BUT HAS NOT BEEN TESTED


initial begin
	tempInputs[0] = 8'b0;
	tempInputs[1] = 8'b0;
	tempInputs[2] = 8'b0;
	tempInputs[3] = 8'b0;
	variable = 2'b00;
	depositFlag = 1'b0;
end
always@ (posedge r_Clock) begin
	
	
	if(uartFlag) begin	
		i = i + 1;
		//depositFlag <= 1'b0;
		
			if( i==1) begin
				tempInputs[0] <= o_Rx_Byte;
			//	totalTemp <= o_Rx_Byte;

			end
			
			else if(i == 2) begin
				tempInputs[1] <= o_Rx_Byte;

			end	

			else if(i == 3) begin
				tempInputs[2] <= o_Rx_Byte;

			end
			
			else if(i == 4) begin
				tempInputs[3] <= o_Rx_Byte;
				depositFlag <= 1'b1;
				i = 0;
			end
			
			else begin
				i = 0;
			end
		
		end //end uart flag if statement
		
		if(depositFlag) begin
			depositFlag <= 1'b0;
		
						case(variable)
					M:begin
						m[k] <= {tempInputs[0],tempInputs[1],tempInputs[2],tempInputs[3]};
						k = k+1;
						totalTemp <= {tempInputs[0],tempInputs[1],tempInputs[2],tempInputs[3]};
							
						if(k > (`DATA_WIDTH - 1))begin
							variable <= P;
							k = 0;
						end
					end
					
					P:begin
						p[k] <= {tempInputs[0],tempInputs[1],tempInputs[2],tempInputs[3]};
						k = k+1;
							
						if(k > (`DATA_WIDTH - 1))begin
							variable <= Q;
							k = 0;
						end
					end
					
					Q:begin
						q[k] <= {tempInputs[0],tempInputs[1],tempInputs[2],tempInputs[3]};
						k = k+1;
							
						if(k > (`DATA_WIDTH - 1))begin
							variable <= E;
							k = 0;
						end
					end
					
					E:begin
						e[k] <= {tempInputs[0],tempInputs[1],tempInputs[2],tempInputs[3]};
						k = k+1;
							
						if(k > (`DATA_WIDTH - 1))begin
							variable <= M;
							k = 0;
						end
					end
					default: begin
						
					end
					
				endcase
		end
	
end


uart_rx uart(
					.i_Clock(r_Clock), 
					.i_Rx_Serial(i_Rx_Serial), 
					.out_serial(out_serial), 
					.fullout(o_Rx_Byte),
					.uartFlag(uartFlag)
				);
/*
MonPro montgomery(
						.clk(clk), 
						.reset(reset), 
						.startInput(startInput), 
						.startCompute(startCompute), 
						.getResult(getResult), 
						.m_input(m_input), 
						.e_input(e_input), 
						.state(state),
						.exp_state(exp_state),
						.res_out(res_out)
						);*/

endmodule
