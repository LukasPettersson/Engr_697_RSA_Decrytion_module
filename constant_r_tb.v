`timescale 1ps / 1ps
module constant_r_tb();
reg [31:0] p,q,d;
reg start,clk;
wire [31:0] t,qinv,m,h,constant_t;



constant_r r0 ( .q(q), .p(p),.d(d),.t(t), .qinv(qinv), .m(m), .h(h), .constant_t(constant_t), .clk(clk), .start(start));

//second_r r0 (.q(q),.p(p),.t(t),.qinv(qinv),.m(m),.h(h), .clk(clk),.start(start),.r(r))
 
initial
 begin
    clk = 1; forever #5 clk = ~clk;
	 end

	 
initial
 begin
 start =1;
 q = 32'h59;
 p = 32'h35;
 d = 32'h00000400;
repeat(2)@(posedge clk);
start = 0;
 #100000;

 end
 endmodule 