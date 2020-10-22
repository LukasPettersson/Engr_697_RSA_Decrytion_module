/*
we need both a start input bit  a start output bit
*/
module storeNumbers(
		n,
		d,
		c,
		clk,
		primeNumOut,
		privateKeyOut,
		cipherOut,
		enIn,
		enOut,
		countOut, 	// temp
		countIn		//temp
	);
	
	input [31:0] n; //product of prime numbers
	input [31:0] d; //private key
	input [31:0] c; //cipher text
	input clk;
	input enIn, enOut;

	output reg [4:0] countIn, countOut;
	
	reg [31:0] primeNum [31:0];
	reg [31:0] privateKey [31:0];
	reg [31:0] cipher [31:0];
	//output reg [31:0] pnum, pkey, cip;
	
	output reg [31:0] primeNumOut;
	output reg [31:0] privateKeyOut;
	output reg [31:0] cipherOut;	
	
	initial begin
		countIn = 5'b0;
		countOut = 5'b0;
	end
	
	//this is used to input values into the registers
	always @(posedge clk)begin
		//store new values into 32x32 regs'
		if((countIn < 5'b11111) && (enIn == 1'b1)) begin //2^5 = 32
				primeNum[countIn] <= n;
				privateKey[countIn] <= d;
				cipher[countIn] <= c;
		
				//incerement count
				countIn <= countIn + 5'b00001;
		end
		else begin
				countIn <= 5'b00000;
		end
			
	end
	
	//this is used to output from the registers
	always @(posedge clk) begin
		
		if((countOut < 5'b11111) && (enOut == 1'b1)) begin
			primeNumOut <= primeNum[countOut];
			privateKeyOut <= privateKey[countOut];
			cipherOut <= cipher[countOut];
			
			//incerement count
			countOut <= countOut + 5'b00001;
		end
		else begin
				countOut <= 5'b00000;
		end
	end
	
endmodule
