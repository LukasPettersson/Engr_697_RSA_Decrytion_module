// Project F: Division (with fixed-point support)
// (C)2020 Will Green, Open source hardware released under the MIT License

module div #(
    parameter WIDTH=4,  // width of number in bits
    parameter FBITS=0   // fractional bits
    ) (
    input wire clk,
    input wire start,          // start signal
    input wire [WIDTH-1:0] x,  // dividend
    input wire [WIDTH-1:0] y,  // divisor
    output reg     [WIDTH-1:0] q,  // quotient
    output reg     [WIDTH-1:0] r,  // remainder
    output reg     done,           // done signal
    output reg     dbz,            // divide by zero flag
    output reg    ovf             // overflow flag (fixed-point)
    );

    // avoid negative vector width when fractional bits are not used
    localparam FBITSW = (FBITS) ? FBITS : 1;

    reg [WIDTH-1:0] y1;            // copy of divisor
    reg [WIDTH-1:0] q1, q1_next;   // intermediate quotient
    reg [WIDTH-1:0] ac, ac_next;   // accumulator
    reg [3-1:0] i;   // dividend bit counter

    always begin
        if (ac >= y1) begin
            ac_next = ac - y1;
            {ac_next, q1_next} = {ac_next[WIDTH-2:0], q1, 1'b1};
        end else begin
            {ac_next, q1_next} = {ac, q1} << 1;
        end
    end

    always @(posedge clk) begin
        if (start) begin
            ovf <= 0;
            q <= 0;
            r <= 0;
            i <= 0;
            if (y == 0) begin  // catch divide by zero
                dbz <= 1;
                done <= 1;
            end else begin
                dbz <= 0;
                done <= 0;
                y1 <= y;
                {ac, q1} <= {{WIDTH-1{1'b0}}, x, 1'b0};
            end
        end else if (!done) begin
            if (i == WIDTH-1) begin  // done
                done <= 1;
                if (FBITS != 0 && q1_next[WIDTH-1:WIDTH-FBITSW]) begin  // catch overflow
                    ovf <= 1;
                    q <= 0;
                    r <= 0;
                end else begin
                    q <= q1_next << FBITS;  // fixed-point correction
                    r <= ac_next >> 1;      // undo final shift
                end
            end else begin  // next iteration
                i <= i + 1;
                ac <= ac_next;
                q1 <= q1_next;
            end
        end
    end
endmodule