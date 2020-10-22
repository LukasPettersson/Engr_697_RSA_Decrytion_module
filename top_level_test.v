`include "parameter.v"
module top_level_test();

	reg i_Rx_Serial;
	reg r_Clock;
	reg clk;
	reg reset;
	reg startInput;
	reg startCompute;
	reg getResults;
	reg [`DATA_WIDTH - 1 : 0] m_input;
	reg [`DATA_WIDTH - 1 : 0] e_input;
	wire [3 : 0] state;
	wire [4 : 0] exp_state;	//	for MonExp
	wire [`DATA_WIDTH - 1 : 0] res_out;
   wire [`DATA_WIDTH - 1 : 0] totalTemp;
	wire uartFlag;
	parameter c_CLOCK_PERIOD_NS = 100; 
	parameter c_CLKS_PER_BIT    = 87; // C_ClockS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
	parameter c_BIT_PERIOD      = 8600;
	integer i,j,k;
	reg [7:0] placeholder;
	always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;
	 
	 

	
	top_level dut(
						.i_Rx_Serial(i_Rx_Serial),
						.r_Clock(r_Clock),
						.clk(clk),
						.reset(reset),
						.startInput(startInput),
						.startCompute(startCompute),
						.getResults(getResults),
						.m_input(m_input),
						.e_input(e_input),
						.state(state),
						.exp_state(exp_state),
						.res_out(res_out),
						.uartFlag(uartFlag),
						.totalTemp(totalTemp)
					);
	
		
	
	
	initial begin

		i_Rx_Serial = 0;
		r_Clock = 0;
		clk = 0;
		reset = 0;
		startInput = 0;
		startCompute = 0;
		getResults = 0;
		placeholder = $random;
		$display("random number: %h",placeholder);
		
	end
	
	initial begin

		@(posedge r_Clock);
		/*	UART_WRITE_BYTE(8'hab);
			UART_WRITE_BYTE(8'hbc);
			UART_WRITE_BYTE(8'hde);
			UART_WRITE_BYTE(8'hef);*/
			///write data
			for (j = 0; j < 32; j = j + 1 ) begin
				for (i = 0; i < 4; i = i + 1 )
				begin
					UART_WRITE_BYTE(placeholder);
					placeholder = $random;

				end
			end	
			//write zeros
			for (k = 0; k < 15; k = k + 1 )
			begin
				UART_WRITE_BYTE(8'b0);

			end

		@(posedge r_Clock);
		
		#10000;
		$stop;
	end
	 
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

