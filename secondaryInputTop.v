module secondaryInputTop( input start, clk,
                          input [1023:0] n,
                          output [31:0] n0p,
                          output [1023:0] r, t);



/*

t:
*/
reg start, clk;
reg n0prime_flag,r_t_flag;

/* placeholder for when the r/t module is done
r_t rt0(


  );
  */
//which one is right output?
n0prime n0(   .n(n),
              .n0prime(n0p),
              .start(start),
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
    start = 1;
    state = 1;
  end
  1:begin
    start = 0;
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
