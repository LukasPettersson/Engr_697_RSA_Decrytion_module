module secondaryInputTop_tb();

reg start, clk;
reg [1023:0] n;
wire [31:0] n0p;
wire [31:0] r, t;
wire done, startTransfer;
secondaryInputTop t0(.start(start),
                      .clk(clk),
                      .n(n),
                      .n0p(n0p),
                      .r(r),
                      .t(t),
                      .done(done),
                      .startTransfer(startTransfer));

always
  #50 clk = ~clk;

initial begin

  clk <= 0;
  n <= 1024'd120438868727477310344120263029552552376337511996484512694347091974201763457850399669200822201471306702340516169733075299282219826573393614803261386878077831699751555200378540743659859996901651704593571074021593191781955291789478910485229539557955555100432691694387132173723677692188500922648867639674282419443;
  #50
  start <= 1;
  #100
  start <=0;
end

endmodule
