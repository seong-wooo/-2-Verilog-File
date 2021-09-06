module HOUR_W_TRANSFER(HOUR_W,HOUR,W_COUNT);

input [6:0]HOUR;
input [2:0]W_COUNT;

output [6:0]HOUR_W ;
reg [6:0]HOUR_W ;


always @(*)
begin
	if(W_COUNT == 0)  //  �õ��
		begin
			if(HOUR < 22)         //21�ñ��� 
				HOUR_W = HOUR + 2;    //23 ���� ����
			else if(HOUR == 23)      // 23��  -> 1��
				HOUR_W = 1;
			else                  //22�� -> 0�� 
				HOUR_W =0;
		end	
	else if(W_COUNT == 3'b001) //����¡
		begin
			if(HOUR >= 1 )  //1�� ����
				HOUR_W = HOUR - 1;
			else    // 0�� -> 11��
				HOUR_W = 23;
		end
		
	else if(W_COUNT == 3'b010) //����
		begin
			if(HOUR >= 14 )  //14�� ����
				HOUR_W = HOUR - 14;
			else                 // 13 -> 23      12 -> 22    11 -> 21  . .  9 -> 19 ..1 ->11  0 - > 10 
				HOUR_W = HOUR + 10;
		end
	else  // ����
		begin		
				if(HOUR >= 9 )  //9�� ����
				HOUR_W = HOUR - 9;
			else                 // 8 -> 23    7-> 22    0 -> 15  
			HOUR_W = HOUR + 15;
		end
end

endmodule
	