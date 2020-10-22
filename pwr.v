`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SFSU
// Engineer: Dheeraj Mane
// 
// Create Date: 09/14/2020 10:16:56 AM
// Design Name: RSA Decryption
// Module Name: pwr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////





		module pwr(input  [31:0] q,p,c,d,           // Inputs:- p,q primes c- base d- exponent
               
			   output reg [31:0] t,qinv,m,h,           // outputs for inverse - t,qinv. outputs for exponentation- m, h 
			   input clk,start
				);
 
				wire [31:0] b;
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
    
                assign x = p-1;
                assign y = q-1;
             
					
					assign quot=temp1/temp2;
               assign rem=temp1 % temp2;
               assign b = b2-quot*b1;

			//output here is qinv
			//euclidian
			always@(posedge clk)
			
			if(start) 
				begin
					state<=0;
				end
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
				
				
				
			//the chinese remainder theorem
          
			 always@(posedge clk)
           begin
			  
				  d1 <= d % x;
				  d2 <= d % y;
				  e <= (c**d1);
				  f <= (c**d2); 
				  m1 <=  e % p;
				  m2 <= f % q;

				  h <= (qinv *(m1-m2)) % p;   // this is only true if m1 > m2. Because " a mod b != -a mod b "
				  m <= m2 + (h*q);  
           
			  end
			  
endmodule