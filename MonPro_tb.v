module MonPro_tb();


reg clk,reset, startInput, getResults;
reg [3:0] state;
reg [4:0] exp_state;
wire [31 : 0] res_out;
reg [31:0] m_input, e_input, n_input;
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
  n_input = 32'h8E12B6DB;
  m_input = 32'h08403477;
  e_input = 32'h89F79C82;
  #100
  n_input = 32'hDBF291EB;
  m_input = 32'h675152D8;
  e_input = 32'h17AF118B;
  #100
  n_input = 32'h99A93151;
  m_input = 32'h30B302A4;
  e_input = 32'h84F66C41;
  #100
  n_input = 32'hD5E10615;
  m_input = 32'h0A76E56A;
  e_input = 32'hB77CC5A6;
  #100
  n_input = 32'h45378A74;
  m_input = 32'h906EA444;
  e_input = 32'h84483279;
  #100
  n_input = 32'h361CE4E3;
  m_input = 32'hFAC20532;
  e_input = 32'h364F8AEA;
  #100
  n_input = 32'h0CBCB28F;
  m_input = 32'h121BE65E;
  e_input = 32'hFEE48456;
  #100
  n_input = 32'h7D5B3B66;
  m_input = 32'hA4E15371;
  e_input = 32'h99FAADCD;
  #100
  n_input = 32'h654AEDFD;
  m_input = 32'h2C3B3CAC;
  e_input = 32'h7B526F99;
  #100
  n_input = 32'h7F05533B;
  m_input = 32'h3FF86CE7;
  e_input = 32'h3BEFD4EB;
  #100
  n_input = 32'h9F3F5CFC;
  m_input = 32'h8EC3D09A;
  e_input = 32'h52737AFE;
  #100
  n_input = 32'h61294404;
  m_input = 32'h798F4AD5;
  e_input = 32'h4FF07DEF;
  #100
  n_input = 32'h5B0AEBF6;
  m_input = 32'h5DC45436;
  e_input = 32'hE8E5CB4D;
  #100
  n_input = 32'h0D2E35C8;
  m_input = 32'hFCB6C109;
  e_input = 32'h6F714FA3;
  #100
  n_input = 32'hE9626387;
  m_input = 32'h2530DC6C;
  e_input = 32'hE318BBE5;
  #100
  n_input = 32'hFF351DF2;
  m_input = 32'h20EECE39;
  e_input = 32'h46ADB37C;
  #100
  n_input = 32'h64020101;
  m_input = 32'h39B7089F;
  e_input = 32'hBF482FEE;
  #100
  n_input = 32'h60F280BB;
  m_input = 32'hB1D72D6E;
  e_input = 32'hFD3138EB;
  #100
  n_input = 32'hB1DC6DEA;
  m_input = 32'hA60ACEC4;
  e_input = 32'hF6F04D62;
  #100
  n_input = 32'h075F26DA;
  m_input = 32'h0B07329D;
  e_input = 32'hDF77709D;
  #100
  n_input = 32'hC0E7F6FF;
  m_input = 32'hC1405182;
  e_input = 32'hF8629F5E;
  #100
  n_input = 32'hC7D4638D;
  m_input = 32'h07FB0D2E;
  e_input = 32'hE2AFBE07;
  #100
  n_input = 32'hF0112DCA;
  m_input = 32'h716CDD1A;
  e_input = 32'hC80A0424;
  #100
  n_input = 32'h362730D1;
  m_input = 32'h9BC694B5;
  e_input = 32'hE7148AB4;
  #100
  n_input = 32'h1F86EB09;
  m_input = 32'h66B43080;
  e_input = 32'hA9DB904F;
  #100
  n_input = 32'h90D96B89;
  m_input = 32'h2B246478;
  e_input = 32'h19933719;
  #100
  n_input = 32'h9321D45C;
  m_input = 32'h71033735;
  e_input = 32'hC4A3933B;
  #100
  n_input = 32'h77ADC2C1;
  m_input = 32'h82097A88;
  e_input = 32'h4924E4B6;
  #100
  n_input = 32'h1E376702;
  m_input = 32'hC949C12A;
  e_input = 32'h13F02B30;
  #100
  n_input = 32'hD6D50ED2;
  m_input = 32'hF9D7401C;
  e_input = 32'hC3DA4D52;
  #100
  n_input = 32'hC8B82FF2;
  m_input = 32'h00EAC53A;
  e_input = 32'h436866DA;
  #100
  n_input = 32'hCD46362D;
  m_input = 32'h1A604F01;
  e_input = 32'h09F66C81;
  #100
end

endmodule
