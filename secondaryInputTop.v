module secondaryInputTop( input start, clk,
                          input [1023:0] n,
                          output [31:0] n0p,
                          output [1023:0] r, t,
                          output reg done);



/*

t:
*/
reg startCompute;
reg n0prime_flag,r_t_flag;
reg [1:0] state;

constant_r_t_new rt0(   .clk(clk),
                        .M_r(n), // M is divisor this is n
                        .start(start),
                        .R_r(r), //Remainder for r
                        .R_t(t), //Remainder for t
                        .done(r_t_done)); //done flag triggers when t is done
//which one is right output?
n0prime n0(   .n(n),
              .n0prime(n0p),
              .start(startCompute),
              .clk(clk),
              .done(n0prime_done));

always@ (posedge clk) begin
  done = 0;
  if(start) begin
    r_t_flag = 0;
    n0prime_flag = 0;
    state = 0;
  end
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
    done = 1;
    state = 3;
  end

  3: begin //idle state
    done = 0;
  end
  endcase
end
endmodule
