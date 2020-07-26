/******************************************************************
* Description
*	This is a Clock Divider that can divide a reference clock into a target frequency
*	1.0
* Author:
*	Diego Eduardo Reyna Cruz
* Date:
*	05/07/2020
******************************************************************/
module Clock_Divider
#(
	// Parameter Declarations
	parameter FREQUENCY = 1,
	parameter REFERENCE_CLOCK = 50000000
)

(
	// Input Ports
	input clk_FPGA,
	input reset,
	
	// Output Ports
	output clock_signal
);

localparam MAXIMUM_VALUE = MaxValue(FREQUENCY, REFERENCE_CLOCK); //Frecuencia deseada con ciclo de trabajo de 50%
localparam NBITS = CeilLog2(MAXIMUM_VALUE);

reg MaxValue_Bit = 0;
reg [NBITS: 0] Count_logic;

always @(posedge clk_FPGA or negedge reset) 
begin
	if (reset == 1'b0)
		Count_logic <= {NBITS{1'b0}};
	else begin
		if(Count_logic == MAXIMUM_VALUE - 1) begin
			Count_logic <= 0;
			MaxValue_Bit <= !MaxValue_Bit; //Hace el toggle
		end
		else
			Count_logic <= Count_logic + 1'b1;
	end
end

		
assign clock_signal = MaxValue_Bit;

/*--------------------------------------------------------------------*/   
 /*Log Function*/
     function integer CeilLog2;
       input integer data;
       integer i,result;
       begin
          for(i=0; 2**i < data; i=i+1)
             result = i + 1;
          CeilLog2 = result;
       end
    endfunction

/*--------------------------------------------------------------------*/
 
 /*MaxValue Function*/
     function integer MaxValue;
       input integer f, clock;
       integer i, result;
       begin
			 result = clock / f; //Porcentaje de disminución de la frecuencia
          MaxValue = result / 2; //Valor máximo de switcheo
       end
    endfunction


/*--------------------------------------------------------------------*/
 
endmodule 