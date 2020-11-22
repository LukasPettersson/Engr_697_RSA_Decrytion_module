module n0prime_new_tb();



reg [1024:0] p,q;
wire [31:0] t,qinv,real_output;
reg start, clk;
wire done;

  n0prime dut(
              .p(p),
              .q(q),
              .t(t),
              .qinv(qinv),
              .start(start),
              .clk(clk),
              .real_output(real_output),
              .done(done));

  always
    #5 clk = ~clk;


  initial begin
    clk <=0;
    //p has to be smaller than q to get the right answer
    //n = 110620781787982559320879672277187232847059370855697531032471456562776629662302244635541635743974443111884235645205863300149086076806673694355442778484112581750287392626037519520354184007761932200792383173427168395884973735814267160431334221012878580946600314337283120169876076782148446769399989029866652585707
    q <= 1025'd120438868727477310344120263029552552376337511996484512694347091974201763457850399669200822201471306702340516169733075299282219826573393614803261386878077831699751555200378540743659859996901651704593571074021593191781955291789478910485229539557955555100432691694387132173723677692188500922648867639674282419443;
    p <= 1025'd4294967296;
    start <= 1;
    #10
    start <= 0;
  end


endmodule
