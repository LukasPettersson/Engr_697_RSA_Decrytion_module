module secondaryInputTop( input start, clk,
                          input [1023:0] n,
                          output [31:0] n0p,
                          output [1023:0] r, t);



/*

t:
*/
reg startCompute, clk;
reg n0prime_flag,r_t_flag;

/* placeholder for when the r/t module is done
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

  */

  constant_r_t rt0( .start(startCompute),
                    .clk(clk),
                    .done(r_t_done),
                    .Q_r(),
                    .M_r(),
                    .A_r(),
                    .R_r(),
                    .M_t(),
                    .A_t(),
                    .R_t());
//which one is right output?
n0prime n0(   .n(n),
              .n0prime(n0p),
              .start(startCompute),
              .clk(clk)
              .done(n0prime_done));

always(@posedge clk) begin
  if(start) begin
    r_t_flag = 0;
    n0prime_flag = 0;
    state = 0;
  end
end
//janky?
always (@posedge clk) begin
  if(n0prime_done) begin
    n0prime_flag = 1;
  end
end
always (@posedge clk) begin
  if(r_t_done) begin
    r_t_flag = 1;
  end
end
always (@posedge clk) begin

  case(state)
  0: begin
    startCompute = 1;
    state = 1;
  end
  1:begin
    startCompute = 0;
    if(n0prime_flag && r_t_flag) begin
      state = 2;
    end
  end
  2: //output all the values from the submodules into the top modules
  3:
  4:

  endcase
end
endmodule
