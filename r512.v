`include "parameter.v"

module r512(
			input  [`MAX_DATA - 1 :0] q,p,
			output reg [`MAX_DATA - 1 :0] m,
			input clk, start
);


			wire [`MAX_DATA - 1 :0] b;
			wire [`MAX_DATA - 1 :0] rem;
			reg [`MAX_DATA - 1 :0] quot, t,qinv,h;
			reg [`MAX_DATA - 1 :0] temp1;
			reg [`MAX_DATA - 1 :0] temp2;
			reg [`MAX_DATA - 1 :0] b2;
			reg [`MAX_DATA - 1 :0] b1;
			reg [1:0]state;
			wire [`MAX_DATA - 1 :0] divRem, hRem, d1Rem, d2Rem, m1Rem, m2Rem;
			wire divDone, hDone, d1Done, d2Done, m1Done, m2Done;
			reg divStart, hStart, m1Start, m2Start, onFlag;
			
			reg [`MAX_DATA - 1 :0] m1,m2,d1,d2;
		   reg [`MAX_DATA - 1 :0] e,f;
		   wire [`MAX_DATA - 1 :0] x,y;
		   reg [`MAX_DATA - 1 :0] t_holder;
			reg [9:0] d;
			
			assign x = p-1;
			assign y = q-1;
			assign b = b2-quot*b1;
			
			divide_by_subtraction dbs(
												.start(divStart),
												.clk(clk),
												.dividend(temp1),
												.divisor(temp2),
												.outputcount(qout),
												.remainder(divRem),
												.done(divDone)
											);
											
			divide_by_subtraction dbs_h(
												.start(hStart && m1Done && m2Done ),
												.clk(clk),
												.dividend(h),
												.divisor(p),
												.outputcount(),
												.remainder(hRem),
												.done(hDone)
											);
											
			divide_by_subtraction dbs_d1(
												.start(onFlag),
												.clk(clk),
												.dividend(d),
												.divisor(x),
												.outputcount(),
												.remainder(d1Rem),
												.done(d1Done)
											);
											
			divide_by_subtraction dbs_d2(
												.start(onFlag),
												.clk(clk),
												.dividend(d),
												.divisor(y),
												.outputcount(),
												.remainder(d2Rem),
												.done(d2Done)
											);
			divide_by_subtraction dbs_m1(
												.start(m1Start),
												.clk(clk),
												.dividend(e),
												.divisor(p),
												.outputcount(),
												.remainder(m1Rem),
												.done(m1Done)
											);
			divide_by_subtraction dbs_m2(
												.start(m2Start),
												.clk(clk),
												.dividend(f),
												.divisor(q),
												.outputcount(),
												.remainder(m2Rem),
												.done(m2Done)
											);
											

			
			initial begin
				divStart <= 1'b0;
				hStart <= 1'b0;
				m1Start <= 1'b0;
				m2Start <= 1'b0;
				onFlag <= 1'b1;
				d <= 10'h400;
			end
			
			//output here is qinv
			always@(posedge clk)
			begin
				if(start) begin
						state<=0;
							end
				
				else begin
					case(state)
						0:if(divDone) state<=1;
						1:if(divRem >>1 && divRem <<1 ) state<=1; else state<=2;
						2:if(start) state<=0;
					endcase
				end
			end
			
			always@(posedge clk)
				begin
				if(state==0)
					begin
						temp1<=p;
						temp2<=q;
						b2<=0;
						b1<=1;
						divStart <= 1'b1;
					end
					else if(state==1)
					begin
					  temp1<=temp2;
					  temp2<=divRem;
					  b2<=b1;
					  b1<=b;
					end
				else if(state==2)
					begin
					  t<=b1+p;
						if(t>p) begin
							qinv<=b1;
							hStart <= 1'b1;
							end
						else begin
							qinv<=t;
							hStart <= 1'b1;
                    end
						  end	
			    end

           always@(posedge clk)
           begin 

			  
			  if(d1Done && d2Done) begin
           e <= 1'b1 << d1;// 2^56
           f <= 1'b1 << d2; //2^36
				m1Start <= 1'b1;
				m2Start <= 1'b1;
				end

				if(m1Done && m2Done)
				begin
           h <= (qinv *(m1-m2));   // this is only true if m1 > m2. Because " a mod b != -a mod b "
				end
			  
			  if(hDone)
			  begin
           m <= m2 + (hRem*q);
			  end
			  
				
				
           end


endmodule 