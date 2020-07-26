/******************************************************************
* Description
*	This is an 2 to 1 behavioral multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Diego Eduardo Reyna Cruz
* Date:
*	26/06/2020
******************************************************************/
module Multiplexer2to1
#(
	parameter N_BITS = 8
)
(
	// Input Ports
	input Selector,
	input [N_BITS-1:0] Data_0,
	input [N_BITS-1:0] Data_1,
	
	// Output Ports
	output [N_BITS-1:0] Mux_Output

);


reg [N_BITS-1:0] Mux_Output_r;

always@(Selector, Data_1,Data_0) begin
	if (Selector)
		Mux_Output_r = Data_1;
	else 
		Mux_Output_r = Data_0;
end 

assign Mux_Output = Mux_Output_r;

endmodule 