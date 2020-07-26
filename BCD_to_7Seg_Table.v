/******************************************************************
* Description
*	This is a BCD to 7 segments implemented with a table
*	1.0
* Author:
*	Diego Eduardo Reyna Cruz
* Date:
*	07/07/2020
******************************************************************/
module BCD_to_7Seg_Table(
	// Input Ports
	input [3:0] bcd,
	
	// Output Ports
   output a,b,c,d,e,f,g // segments[6]-> a, segments[0]->g
);	 

reg [6:0] segments; // abcdefg

always@(*) begin
	case(bcd)
		4'b0000: segments = 'b1000000; //0
		4'b0001: segments = 'b1111001; //1
		4'b0010: segments = 'b0100100; //2
		4'b0011: segments = 'b0110000; //3
		4'b0100: segments = 'b0011001; //4
		4'b0101: segments = 'b0010010; //5
		4'b0110: segments = 'b0000010; //6
		4'b0111: segments = 'b1111000; //7
		4'b1000: segments = 'b0000000; //8
		4'b1001: segments = 'b0011000; //9
		4'b1010: segments = 'b0001000; //A
		4'b1011: segments = 'b0000011; //B
		4'b1100: segments = 'b1000110; //C
		4'b1101: segments = 'b0100001; //F
		4'b1110: segments = 'b0000110; //E
		4'b1111: segments = 'b0001110; //F
		default: segments = 'b1111111;
	endcase
end

assign a = segments[0];
assign b = segments[1];
assign c = segments[2];
assign d = segments[3];
assign e = segments[4];
assign f = segments[5];
assign g = segments[6];
					
endmodule 