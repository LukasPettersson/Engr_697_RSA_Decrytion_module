module n0prime_new_tb();



reg [511:0] p,q;
wire [511:0] t,qinv;
reg start, clk;
wire done;

  n0prime dut(
              .p(p),
              .q(q),
              .t(t),
              .qinv(qinv),
              .start(start),
              .clk(clk),
              .done(done));

  always
    #5 clk = ~clk;


  initial begin
    clk <=0;
    p <= 59;
    q <= 97;
    start <= 1;
    #10
    start <= 0;
  end


endmodule
