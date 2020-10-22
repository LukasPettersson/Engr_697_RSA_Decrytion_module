// Project F: Division Test Bench
// (C)2020 Will Green, Open source hardware released under the MIT License

module div_tb();

    parameter CLK_PERIOD = 10;
    parameter WIDTH = 4;

    reg clk;
    reg start;            // start signal
    reg [WIDTH-1:0] x;    // dividend
    reg [WIDTH-1:0] y;    // divisor
    wire [WIDTH-1:0] q;    // quotient
    wire [WIDTH-1:0] r;    // remainder
    wire done;             // done signal
    wire dbz;              // divide by zero flag

    div div_inst (.clk(clk), .start(start), .x(x), .y(y), .q(q), .r(r), .done(done), .dbz(dbz));
	 /*
	  (
    input wire clk,
    input wire start,          // start signal
    input wire [WIDTH-1:0] x,  // dividend
    input wire [WIDTH-1:0] y,  // divisor
    output     [WIDTH-1:0] q,  // quotient
    output     [WIDTH-1:0] r,  // remainder
    output     done,           // done signal
    output     dbz             // divide by zero flag
    );
	 */
	 

    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
                clk = 1;

        #100    x = 4'b0111;
                y = 4'b0010;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
		  #10000
        /*
					x = 4'b0001;
                y = 4'b0001;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0010;
                y = 4'b0010;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0010;
                y = 4'b0001;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0000;
                y = 4'b0010;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0010;
                y = 4'b0000;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0011;
                y = 4'b0010;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b1111;
                y = 4'b0101;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b1111;
                y = 4'b0010;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0001;
                y = 4'b1111;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b0010;
                y = 4'b0100;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
                x = 4'b1101;
                y = 4'b0111;
                start = 1;
        #10     start = 0;
        #40     $display("\t%d:\t%d /%d =%d (r =%d) (DBZ=%b)", $time, x, y, q, r, dbz);
					*/
					
			$finish;
    end
endmodule
