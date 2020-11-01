module constant_r
(
				input  [31:0] q,p,d,           // Inputs:- p,q primes c- base d- exponent   
			   output reg [31:0] t,qinv,m,h,constant_t,           // outputs for inverse - t,qinv. outputs for exponentation- m, h 
			   input clk,start
);
 
				wire [31:0] b;
			//	wire [31:0] d = 32'h0000400;
				wire [31:0] rem;
				wire [31:0] quot;
				reg[31:0] temp1;
				reg[31:0] temp2;
				reg [31:0] b2;
				reg [31:0] b1;
				reg[1:0]state;
				
				reg [31:0] m1,m2,d1,d2;
                reg [63:0] e,f;
                wire [31:0] x,y;
					 reg [63:0] t_holder;
					 wire [63:0] n_prime;
				
					 assign n_prime = p * q;
                assign x = p-1;
                assign y = q-1;
             
			   assign quot=temp1/temp2;
               assign rem=temp1 % temp2;
               assign b = b2-quot*b1;


			always@(posedge clk)
             
				if(start) state<=0;
					else
					case(state)
						0:state<=1;
						1:if(rem >>1 && rem <<1 ) state<=1; else state<=2;
						2:if(start) state<=0;
					endcase

			always@(posedge clk)
				begin
				if(state==0)
					begin
					  temp1<=p;
					  temp2<=q;
                              b2<=0;
                              b1<=1;     
					end
				else if(state==1)
					begin
                              temp1<=temp2;
					  temp2<=rem;
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
		



          
          
           always@(posedge clk)
           begin // x = p - 1 y = q - 1
           d1 <= d % x; // 1024 mod 88 = 56
           d2 <= d % y; // 1024 mod 52 = 36
           e <= 1'b1 << d1;// 2^56
           f <= 1'b1 << d2; //2^36
           m1 <=  e % p; // 2
           m2 <= f % q;

           h <= (qinv *(m1-m2)) % p;   // this is only true if m1 > m2. Because " a mod b != -a mod b "
           m <= m2 + (h*q);
			  t_holder <= m * m;
			 constant_t <= t_holder % n_prime;
			// t_holder <= m % n_prime;
			// constant_t <= t_holder * t_holder;
				
				
           end
		
endmodule 