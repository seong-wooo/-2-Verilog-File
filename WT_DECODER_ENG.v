module WT_DECODER_ENGLSIH(BCD,BUFF);

input [4:0]BCD;
output [7:0]BUFF;

reg[7:0]BUFF;

always @(BCD)
begin 
	 case(BCD)
		5'b00000: BUFF =8'b01000111;         // G
		5'b00001: BUFF =8'b01010100;         //T
		5'b00010: BUFF =8'b01010111;        //W
		5'b00011: BUFF = 8'b01001111;       //O
		5'b00100: BUFF =8'b01000010;     //B
		5'b00101: BUFF =8'b01101010;     //U
		5'b00110: BUFF = 8'b01000001;         // A
		5'b00111: BUFF =8'b01001100;         // L
		5'b01000: BUFF =8'b01001110; //N
		5'b01001: BUFF =8'b01001001;   //I
		5'b01010: BUFF =8'b01000011;      //C
		5'b01011: BUFF =8'b01001011;         //K
		
		default: BUFF =8'b00100000;
		endcase
	end

endmodule