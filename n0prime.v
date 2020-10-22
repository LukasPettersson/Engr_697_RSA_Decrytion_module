module n0prime(
			input  [31:0] q,p,
			output reg [31:0] qinv, t, 
			input clk, start
);


			wire [31:0] b;
			wire [31:0] rem;
			wire [31:0] quot;
			reg [31:0] temp1;
			reg [31:0] temp2;
			reg [31:0] b2;
			reg [31:0] b1;
			reg [1:0]state;
			
			assign quot = temp1/temp2;
			assign rem = temp1 % temp2;
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

endmodule
