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
n_input = 32'h0E8780E1;
m_input = 32'h8FC30498;
e_input = 32'h534ab101;
#100
n_input = 32'h56964486;
m_input = 32'hE410C074;
e_input = 32'hf39317ac;
#100
n_input = 32'hAFCE0635;
m_input = 32'h43EB5576;
e_input = 32'h3f24e294;
#100
n_input = 32'h0C11CD2B;
m_input = 32'h49CD89DA;
e_input = 32'h9d19cc11;
#100
n_input = 32'hEF8EEBE5;
m_input = 32'h5437D60D;
e_input = 32'hda1c7f67;
#100
n_input = 32'hD1A48D93;
m_input = 32'h558ABFE9;
e_input = 32'h5ffc14d7;
#100
n_input = 32'hDE96786E;
m_input = 32'h2AFE4167;
e_input = 32'hf6fab0a1;
#100
n_input = 32'h6BBF7557;
m_input = 32'hA6584229;
e_input = 32'ha6890298;
#100
n_input = 32'hF8E571AD;
m_input = 32'hE6676168;
e_input = 32'hdf36a80e;
#100
n_input = 32'h9E7D555C;
m_input = 32'hC9E76D68;
e_input = 32'h4f64499b;
#100
n_input = 32'hD1C8EEF4;
m_input = 32'h1D8BC7D4;
e_input = 32'hf9060b0a;
#100
n_input = 32'h196C0889;
m_input = 32'h0F1C6D2E;
e_input = 32'hb9ae3b75;
#100
n_input = 32'h3E1B6B6E;
m_input = 32'hD6A55D07;
e_input = 32'h98ba69b6;
#100
n_input = 32'h46CE4CE8;
m_input = 32'hF52F5C71;
e_input = 32'hee95fa80;
#100
n_input = 32'hAD3C39D5;
m_input = 32'h2C4E4A6D;
e_input = 32'h2a7b4ba5;
#100
n_input = 32'h19DBB74F;
m_input = 32'h4A7736FF;
e_input = 32'hae122e62;
#100
n_input = 32'h46D47835;
m_input = 32'hBFD71213;
e_input = 32'ha695c81c;
#100
n_input = 32'h3C12800D;
m_input = 32'h2165C63D;
e_input = 32'h819c6e1f;
#100
n_input = 32'hB75166C2;
m_input = 32'h9A91A3A5;
e_input = 32'h830b523a;
#100
n_input = 32'h703A5407;
m_input = 32'hEC65AB4A;
e_input = 32'h51969c1d;
#100
n_input = 32'hB6F61CD8;
m_input = 32'hA1237E06;
e_input = 32'h50957568;
#100
n_input = 32'hB2CA6F16;
m_input = 32'h295EC227;
e_input = 32'h9e3dfac7;
#100
n_input = 32'h0058B7E0;
m_input = 32'h5CDC7392;
e_input = 32'h024e42b6;
#100
n_input = 32'hAA5679E6;
m_input = 32'hE95FBE79;
e_input = 32'h94aadfed;
#100
n_input = 32'hD8319257;
m_input = 32'h31A4194B;
e_input = 32'hff2abd80;
#100
n_input = 32'h4FFD0F4F;
m_input = 32'hFF2DB9FE;
e_input = 32'h3d0bdb98;
#100
n_input = 32'h53B6A637;
m_input = 32'h35785515;
e_input = 32'h50dce35a;
#100
n_input = 32'hC7E62761;
m_input = 32'h1E3C8302;
e_input = 32'h24ac698e;
#100
n_input = 32'hD826ED1D;
m_input = 32'h1BC20F28;
e_input = 32'h844cf2b5;
#100
n_input = 32'h6673FB40;
m_input = 32'h2145DF60;
e_input = 32'hcc26fa23;
#100
n_input = 32'h87B13E53;
m_input = 32'h94E02C30;
e_input = 32'hd4717666;
#100
n_input = 32'h57BB7202;
m_input = 32'h39603975;
e_input = 32'h1af752a3;
#100;
end

endmodule
