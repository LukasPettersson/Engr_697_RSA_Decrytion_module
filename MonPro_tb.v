`define DATA_WIDTH 32 //used
`define ADDR_WIDTH 5
`define TOTAL_ADDR (2 ** `ADDR_WIDTH) //used. 32
`define DATA_LENGTH 1024


module MonPro_tb();

reg clk,reset, startInput, getResults;
reg [3:0] state;
reg [4:0] exp_state;
wire [31 : 0] res_out;
reg [`DATA_WIDTH - 1 : 0] m_input, e_input, n_input;

MonPro mp(.clk(clk),
          .reset(),
          .startInput(startInput),
          .getResult(),
          .m_input(m_input), //cipher text
          .e_input(e_input), // private key
          .n_input(n_input), // n
          .state(),
          .exp_state(),
          .res_out(res_out));

/* original message
1001111010011110001100111010000111100001110001010111111001011011000111010111100101100000001011111100010001011010111010100011110101111000010110001010001000010111010100101111010000110101101111111101110011100001110101001110011001101110000011011101110100011111001000010100100000011110110110101110101100001110111011011001000001111101000110000110110011000001000101011000001111000100100001010010000111101010010111100001101000011011101000110011000110110100111000100010010001001100011101011111100111011011110110101111001111111011111100000101101111101101100100010110011100011100101101111000101001100010011011011110111101100011001000110101100100100010100001111010001000000011010010010110011111001011111101110111010011000110011000111011011011000100100010010101011100110110001001001111000011001100000000010101100001001001101001010101010010000000100000110101000101101011000001000110001110111110101011010001001011100011011111101111000000010110011111101010100010011110111111110011111001111000111010110000011010001010110100100001100111101100
*/

/* encrypted message

*/
always
  #50 clk = ~clk;


initial
begin
  clk = 0;
  #50
  startInput = 1;
  #100
    n_input = 32'h1B82DFBB;
    m_input = 32'h7D25FCB0;
    e_input = 32'h91D3CDF1;
    #100
    n_input = 32'hEAA06C6A;
    m_input = 32'h5B32DD70;
    e_input = 32'h6E746411;
    #100
    n_input = 32'h485144D5;
    m_input = 32'h698CF89E;
    e_input = 32'h0E02CC43;
    #100
    n_input = 32'h9DBCDF39;
    m_input = 32'hEB961218;
    e_input = 32'h24E30DAB;
    #100
    n_input = 32'hA0E1708F;
    m_input = 32'hF55FA975;
    e_input = 32'h676F5661;
    #100
    n_input = 32'h2AA84A58;
    m_input = 32'h1F31E0A0;
    e_input = 32'h98E325A1;
    #100
    n_input = 32'h194537FA;
    m_input = 32'hA214EB07;
    e_input = 32'h1B826D78;
    #100
    n_input = 32'hBEC76F3B;
    m_input = 32'hBF68A172;
    e_input = 32'hB1F84CB8;
    #100
    n_input = 32'hEDC15519;
    m_input = 32'h6968F483;
    e_input = 32'h33D1502F;
    #100
    n_input = 32'h1EEBBF94;
    m_input = 32'hE99E8ECD;
    e_input = 32'h1A2792E5;
    #100
    n_input = 32'hB0A1D6F8;
    m_input = 32'h1A7DA8B5;
    e_input = 32'hCB990C60;
    #100
    n_input = 32'h107E0B5C;
    m_input = 32'h89F21701;
    e_input = 32'h63B39623;
    #100
    n_input = 32'h0BBFD50C;
    m_input = 32'h6D337265;
    e_input = 32'h0208778D;
    #100
    n_input = 32'h91870510;
    m_input = 32'h2A7E6DA7;
    e_input = 32'hB2412AB8;
    #100
    n_input = 32'hD5098490;
    m_input = 32'h4CA11557;
    e_input = 32'h76A6A346;
    #100
    n_input = 32'h923CB920;
    m_input = 32'h7B919499;
    e_input = 32'hA10C5A7F;
    #100
    n_input = 32'h526BC68D;
    m_input = 32'h900A8714;
    e_input = 32'h984596B0;
    #100
    n_input = 32'h6070683D;
    m_input = 32'hD34D7046;
    e_input = 32'h73FBB168;
    #100
    n_input = 32'hCF9FA006;
    m_input = 32'h6DE249AE;
    e_input = 32'h8FF57649;
    #100
    n_input = 32'h85F91AA3;
    m_input = 32'h292E2C05;
    e_input = 32'hEE6B160D;
    #100
    n_input = 32'h65725D12;
    m_input = 32'h28B2F24E;
    e_input = 32'h8494363B;
    #100
    n_input = 32'h8F80B523;
    m_input = 32'h7E98A4A4;
    e_input = 32'h71E735F0;
    #100
    n_input = 32'hB53985FF;
    m_input = 32'h54696BF2;
    e_input = 32'h7BBF1E91;
    #100
    n_input = 32'hF81A6B21;
    m_input = 32'h5A149215;
    e_input = 32'h40AF8429;
    #100
    n_input = 32'hF59B468B;
    m_input = 32'h129BB8FE;
    e_input = 32'h2D957459;
    #100
    n_input = 32'hE0BCE97A;
    m_input = 32'hBF673552;
    e_input = 32'h9CAC839E;
    #100
    n_input = 32'hFEE50B2C;
    m_input = 32'h365DEB1F;
    e_input = 32'h530CB570;
    #100
    n_input = 32'h959ACF90;
    m_input = 32'h9FA29B9A;
    e_input = 32'h81E075FA;
    #100
    n_input = 32'hAF5A7C08;
    m_input = 32'h43CD9E34;
    e_input = 32'h4EC3FC43;
    #100
    n_input = 32'h08220E61;
    m_input = 32'h19EA4B42;
    e_input = 32'hD1108965;
    #100
    n_input = 32'h0AE6D414;
    m_input = 32'h449EBD11;
    e_input = 32'h95E4CD4B;
    #100
    n_input = 32'h8732E542;
    m_input = 32'h254A8D1A;
    e_input = 32'h0B738D25;
    #100;
end

endmodule
