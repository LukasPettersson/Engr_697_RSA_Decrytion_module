//32-bit runs good to get qinv
//two errors marked linked to division and power calculations
//

module n0prime512(
			input  [511:0] q,p,
			output reg [511:0] qinv, t, 
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
			wire [511:0] divRem;
			wire divDone;
			reg divStart;
			
			divide_by_subtraction dbs(
												.start(divStart),
												.clk(clk),
												.dividend(temp1),
												.divisor(temp2),
												.outputcount(qout),
												.remainder(divRem),
												.done(divDone)
											);
			
			
			
			/*
			^ ERROR HERE:
			Error (272006): In lpm_divide megafunction, LPM_WIDTHN must be less than or equals to 64
			note: we are looking into building a module that can handle large numbers through long divison
		
			*/
			//assign quot = temp1/temp2; 
			//assign rem = temp1 % temp2;
			
			assign b = b2-quot*b1;
			
			initial begin
				divStart <= 1'b0;
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
						else
							qinv<=t;
                    end	
			    end

	

	//not tested, failed in 32-bit mode 
	//ERROR: Error (10256): Verilog HDL error at pwr.v(80): exponentiation is not supported for specified operands, either exponent or base must be a constant.
	//note: We are using quartus for synthesis, suspect that to be the issue  
/*
			 always@(posedge clk)
           begin
			  
				  d1 <= d % x;
				  d2 <= d % y;
				  e <= (c**d1); //< --------Error
				  f <= (c**d2); //< --------Error
				  m1 <=  e % p;
				  m2 <= f % q;

				  h <= (qinv *(m1-m2)) % p;   // this is only true if m1 > m2. Because " a mod b != -a mod b "
				  m <= m2 + (h*q);  
           
			  end
			  
*/
endmodule
