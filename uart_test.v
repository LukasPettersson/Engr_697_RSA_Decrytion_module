module uart_test();

   reg        i_Rx_Serial;
   wire   	 out_serial;
	reg r_Clock = 0;
	parameter c_CLOCK_PERIOD_NS = 100; 
	parameter c_CLKS_PER_BIT    = 87; // C_ClockS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
	parameter c_BIT_PERIOD      = 8600;
	wire [7:0] o_Rx_Byte;	
	wire uartFlag;
	always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

	 
  
	 uart_rx dut(.i_Clock(r_Clock), .i_Rx_Serial(i_Rx_Serial), .out_serial(out_serial), .fullout(o_Rx_Byte), .uartFlag(uartFlag));
	 
	 initial begin
		@(posedge r_Clock);
			UART_WRITE_BYTE(8'hab);
		@(posedge r_Clock);
		
	 end
	 
	 // Takes in input byte and serializes it 
  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
	 
    begin
       
      // Send Start Bit
      i_Rx_Serial <= 1'b0;
      #(c_BIT_PERIOD);
      #1000;
       
       
      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          i_Rx_Serial <= i_Data[ii];
			 
          #(c_BIT_PERIOD);
        end
       
      // Send Stop Bit
      i_Rx_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE
endmodule
