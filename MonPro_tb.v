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
  n_input = 32'h8B9496E5;
  m_input = 32'h40C517E0;
  e_input = 32'h70A34C81;
  #100
  n_input = 32'h5F06287C;
  m_input = 32'h33D7DFA8;
  e_input = 32'hE96A880F;
  #100
  n_input = 32'h31988514;
  m_input = 32'h9C8138DB;
  e_input = 32'h1A3AC9AC;
  #100
  n_input = 32'hF96F9A0B;
  m_input = 32'h5A5BD24A;
  e_input = 32'hFCC2361D;
  #100
  n_input = 32'h098EC99C;
  m_input = 32'h6065E1BF;
  e_input = 32'h11A32BD2;
  #100
  n_input = 32'hCE60DEFE;
  m_input = 32'h54FD1EB2;
  e_input = 32'h80AF3A0D;
  #100
  n_input = 32'h7B044519;
  m_input = 32'h6584E390;
  e_input = 32'hD67CC6EC;
  #100
  n_input = 32'h197CBC98;
  m_input = 32'hBAD13444;
  e_input = 32'h2F861790;
  #100
  n_input = 32'h8C547944;
  m_input = 32'hC0CBA65C;
  e_input = 32'h4041F958;
  #100
  n_input = 32'h528B17F6;
  m_input = 32'hE0330C1F;
  e_input = 32'h86E4F2E4;
  #100
  n_input = 32'h024D981B;
  m_input = 32'h7D86FAE9;
  e_input = 32'hFA94C0AC;
  #100
  n_input = 32'h9397F02E;
  m_input = 32'h774F11DE;
  e_input = 32'h237FF23F;
  #100
  n_input = 32'h13F7DBF4;
  m_input = 32'h934EEE4C;
  e_input = 32'hC22961C4;
  #100
  n_input = 32'h65D03E3B;
  m_input = 32'h535D9137;
  e_input = 32'h5B34452B;
  #100
  n_input = 32'hE3DA97CB;
  m_input = 32'h548BB771;
  e_input = 32'h258792DC;
  #100
  n_input = 32'hE728F169;
  m_input = 32'hAD0870D2;
  e_input = 32'h0E8D403C;
  #100
  n_input = 32'hA0FA5221;
  m_input = 32'h9D96CACE;
  e_input = 32'h0526D7F5;
  #100
  n_input = 32'h6FB2A652;
  m_input = 32'h071BA67B;
  e_input = 32'h19E98570;
  #100
  n_input = 32'h4F8EA1A0;
  m_input = 32'hD7F0FCD3;
  e_input = 32'h6BE54085;
  #100
  n_input = 32'h5ABE53AE;
  m_input = 32'hEA259C4D;
  e_input = 32'hDB343E3F;
  #100
  n_input = 32'h12A3EAD3;
  m_input = 32'h3871602B;
  e_input = 32'h4B423036;
  #100
  n_input = 32'h8C4CB074;
  m_input = 32'h2F3CA59B;
  e_input = 32'h3873B1A6;
  #100
  n_input = 32'h1487CE4E;
  m_input = 32'h6014FC0D;
  e_input = 32'h4ABE6DF9;
  #100
  n_input = 32'h5BC6D48D;
  m_input = 32'h8B1A93AC;
  e_input = 32'hCD0E9EDA;
  #100
  n_input = 32'h2F604851;
  m_input = 32'h99080940;
  e_input = 32'hA933E578;
  #100
  n_input = 32'h2C34DF98;
  m_input = 32'h05CD8084;
  e_input = 32'h4F52AA4C;
  #100
  n_input = 32'h0AD14479;
  m_input = 32'hCE314CF5;
  e_input = 32'hBB14C283;
  #100
  n_input = 32'hC1526B25;
  m_input = 32'h203F8FDB;
  e_input = 32'h5BC6B5D4;
  #100
  n_input = 32'h0357F18C;
  m_input = 32'hB2E497FA;
  e_input = 32'h89B9DFED;
  #100
  n_input = 32'hD18C0F37;
  m_input = 32'h85C8FBC3;
  e_input = 32'h256CE6FC;
  #100
  n_input = 32'hA346920B;
  m_input = 32'hBD2E2F14;
  e_input = 32'h2C29A44B;
  #100
  n_input = 32'hA938A368;
  m_input = 32'h750B049F;
  e_input = 32'hA68B2BA8;
  #100;
end

endmodule
