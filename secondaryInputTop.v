`define DATA_WIDTH 32 //used
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH) //used. 32
`define DATA_LENGTH 1024

module secondaryInputTop( input start, clk,
                          input [`DATA_LENGTH - 1 : 0] n,
                          output [`DATA_WIDTH - 1 : 0] n0p,
                          output reg [`DATA_WIDTH - 1 : 0] r, t,
                            output reg done,
                          output reg startTransfer);



/*

t:
*/
reg startCompute;
reg n0prime_flag, r_t_flag;
reg [`DATA_LENGTH - 1 : 0] r_reg, t_reg;
wire [`DATA_LENGTH - 1 : 0] r_wire, t_wire;
reg [2:0] state;
reg [6:0] count;
constant_r_t_new_new rt0(   .clk(clk),
                        .M_r(n), // M is divisor this is n
                        .start(start),
                        .R_r(r_wire), //Remainder for r
                        .R_t(t_wire), //Remainder for t
                        .done(r_t_done)); //done flag triggers when t is done
//which one is right output?
n0prime n0(   .n(n),
              .n0prime(n0p),
              .start(startCompute),
              .clk(clk),
              .done(n0prime_done));

initial begin
		r_t_flag = 0;
		n0prime_flag = 0;
		count = 0;
		startTransfer = 0;
		state = 4;
    done = 0;
end

//janky?
always@ (posedge clk) begin
  if(n0prime_done) begin
    n0prime_flag = 1;
  end
end
always@ (posedge clk) begin
  if(r_t_done) begin
    r_t_flag = 1;
  end
end
always@ (posedge clk) begin

	if (start) begin
		state = 0;
	end
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

  2: begin
    t_reg = t_wire;
    r_reg = r_wire;
    startTransfer = 1;
    state = 3;
  end

  3: begin
        if(count <= `DATA_WIDTH) begin
          r = r_reg[(`DATA_LENGTH - 1) : (`DATA_LENGTH - `DATA_WIDTH )];    // r = r_reg[1023 : 992]

          r_reg = {r_reg[(`DATA_LENGTH - 1) - (`DATA_WIDTH - 1) - 1 : 0],32'b0}; //r_reg {r_reg[991 : 0], 32'b0}

          t = t_reg[(`DATA_LENGTH - 1) : (`DATA_LENGTH - `DATA_WIDTH )];
          t_reg = {t_reg[(`DATA_LENGTH - 1) - (`DATA_WIDTH - 1) - 1 : 0],32'b0};
          count = count +1;
        end
        else begin
          done = 1;
          state = 4;
        end
      end
		4:begin //idle state
		  done = 0;
		end
  endcase
end
endmodule
