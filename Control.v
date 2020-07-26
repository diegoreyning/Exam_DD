/******************************************************************* 
* Name:
*	One_Shot.sv
* Description:
* 	This module realize a shot
* Inputs:
*	clk,reset,Start
* Outputs:
* 	Shot
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	22/02/2018 
*********************************************************************/
module Control
(
	// Input Ports
	input clk,
	input reset,
	input Start,

	// Output Ports
	output Shot
);

localparam INIT = 2'b00;
localparam IDLE = 2'b01;
localparam SET = 2'b10;
localparam READY = 2'b11;

reg [1:0] state;
reg Shot_reg;
wire Not_Start;

assign Not_Start = Start;
/*------------------------------------------------------------------------------------------*/
/*Asignacion de estado*/

always @(posedge clk or negedge reset)
begin
	if(reset == 1'b0) begin 
		state <= INIT;
	end
	else begin
		case(state)
		
		INIT:
				state <= IDLE;
				
		IDLE:
			if(Not_Start == 1'b1)
				state <= READY;
				
		SET:
			if(Not_Start == 1'b1)
				state <= READY;
		
		READY:
			if (Not_Start == 1'b0)
				state <= SET;	
				
		default:
				state <= INIT;

		endcase
		
	end
end//end always
/*------------------------------------------------------------------------------------------*/
/*Salida de control, proceso combintorio*/
always @(*) begin
	case(state)
		INIT: 
				Shot_reg = 1'b1;
		IDLE: 
				Shot_reg = 1'b0;

		SET: 
				Shot_reg = 1'b0;

		READY: 
				Shot_reg = 1'b1;
	default: 		
				Shot_reg = 1'b0;
				
	endcase
end

assign Shot = Shot_reg;

endmodule
