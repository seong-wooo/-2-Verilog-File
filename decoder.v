module WT_DECODER(BCD,BUFF);

input [3:0]BCD;
output [7:0]BUFF;

reg[7:0]BUFF;

always @(BCD)
begin 
	 case(BCD)
		4'b0000: BUFF =8'b00110000;
		4'b0001: BUFF =8'b00110001;
		4'b0010: BUFF =8'b00110010;
		4'b0011: BUFF =8'b00110011;
		4'b0100: BUFF =8'b00110100;
		4'b0101: BUFF =8'b00110101;
		4'b0110: BUFF =8'b00110110;
		4'b0111: BUFF =8'b00110111;
		4'b1000: BUFF =8'b00111000;
		4'b1001: BUFF =8'b00111001;
		
		4'b1011: BUFF =8'b01000111;         //11 G
		4'b1100: BUFF =8'b01001111;       // 12 O
		4'b1101: BUFF =8'b00111010;       // 13 :
		4'b1110: BUFF =8'b00100000;       // 14
		
		default: BUFF =8'b00100000;		//10
		endcase
	end

endmodule