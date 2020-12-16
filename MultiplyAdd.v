`define DATA_WIDTH 32 //used
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH) //used. 32 
`define DATA_LENGTH 1024

module MultiplyAdd
(
	input clk,
	input [`DATA_WIDTH - 1 : 0] x,
	input [`DATA_WIDTH - 1 : 0] y,
	input [`DATA_WIDTH - 1 : 0] z,
	input [`DATA_WIDTH - 1 : 0] cin,
	output [`DATA_WIDTH - 1 : 0] s,
	output [`DATA_WIDTH - 1 : 0] cout
);

wire [2 * `DATA_WIDTH - 1 : 0] result; 

assign result = x * y + z + cin;
assign s = result[`DATA_WIDTH - 1 : 0];
assign cout = result[2 * `DATA_WIDTH - 1 : `DATA_WIDTH];

endmodule 