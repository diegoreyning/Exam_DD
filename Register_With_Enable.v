/******************************************************************
* Description
*	This is a Flip Flop Register that can be parameterized in its bit-width.
*	1.0
* Author:
*	Diego Eduardo Reyna Cruz
* Date:
*	14/07/2020
******************************************************************/
module Register_With_Enable
#(
	parameter WORD_LENGTH = 8
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	input [WORD_LENGTH-1:0] Data_Input,

	// Output Ports
	output [WORD_LENGTH-1:0] Data_Output
);

reg  [WORD_LENGTH-1:0] Data_reg;

always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) 
		Data_reg <= {WORD_LENGTH{1'b0}};
	else 
		if(enable == 1'b1)
			Data_reg <= Data_Input;
end

assign Data_Output = Data_reg;

endmodule 