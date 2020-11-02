module r512(
			input  [511:0] q,p,d,
			output reg [511:0] t,qinv,m,h,constant_t,
			input clk, start
);


			wire [511:0] b;
			wire [511:0] rem;
			reg [511:0] quot;
			reg [511:0] temp1;
			reg [511:0] temp2;
			reg [511:0] b2;
			reg [511:0] b1;
			reg [1:0]state;
			wire [511:0] divRem, hRem, d1Rem, d2Rem;
			wire divDone, hDone, d1Done, d2Done;
			reg divStart, hStart, onFlag;
			
			reg [511:0] m1,m2,d1,d2;
		   reg [511:0] e,f;
		   wire [511:0] x,y;
		   reg [511:0] t_holder;
	    	wire [511:0] n_prime;
			
					 assign n_prime = p * q;
                assign x = p-1;
                assign y = q-1;
			
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
												.start(hStart),
												.clk(clk),
												.dividend(h),
												.divisor(p),
												.outputcount(),
												.remainder(divRem),
												.done(hDone)
											);
											
			divide_by_subtraction dbs_d1(
												.start(onFlag),
												.clk(clk),
												.dividend(),
												.divisor(),
												.outputcount(),
												.remainder(),
												.done(d1Done)
											);
											
			divide_by_subtraction dbs_d2(
												.start(onFlag),
												.clk(clk),
												.dividend(),
												.divisor(),
												.outputcount(),
												.remainder(),
												.done(d2Done)
											);
											
											
			assign b = b2-quot*b1;
			
			initial begin
				divStart <= 1'b0;
				hStart <= 1'b0;
				onFlag <= 1'b1;
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
						if(t>p)
							qinv<=b1;
							hStart <= 1'b1;
						else
							qinv<=t;
							hStart <= 1'b1;
                    end	
			    end

           always@(posedge clk)
           begin // x = p - 1 y = q - 1
    //       d1 <= d % x; // 1024 mod 88 = 56
      //     d2 <= d % y; // 1024 mod 52 = 36
           e <= 1'b1 << d1;// 2^56
           f <= 1'b1 << d2; //2^36
           m1 <=  e % p; // 2
           m2 <= f % q;

           h <= (qinv *(m1-m2));   // this is only true if m1 > m2. Because " a mod b != -a mod b "
			  if(hDone)
			  begin
           m <= m2 + (h*q);
			  end
			  
			  //for t
			//  t_holder <= m * m;
			// constant_t <= t_holder % n_prime;
			// t_holder <= m % n_prime;
			// constant_t <= t_holder * t_holder;
				
				
           end


endmodule 