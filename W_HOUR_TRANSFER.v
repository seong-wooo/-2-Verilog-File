module HOUR_W_TRANSFER(HOUR_W,HOUR,W_COUNT);

input [6:0]HOUR;
input [2:0]W_COUNT;

output [6:0]HOUR_W ;
reg [6:0]HOUR_W ;


always @(*)
begin
	if(W_COUNT == 0)  //  시드니
		begin
			if(HOUR < 22)         //21시까지 
				HOUR_W = HOUR + 2;    //23 까지 가능
			else if(HOUR == 23)      // 23시  -> 1시
				HOUR_W = 1;
			else                  //22시 -> 0시 
				HOUR_W =0;
		end	
	else if(W_COUNT == 3'b001) //베이징
		begin
			if(HOUR >= 1 )  //1시 까지
				HOUR_W = HOUR - 1;
			else    // 0시 -> 11시
				HOUR_W = 23;
		end
		
	else if(W_COUNT == 3'b010) //뉴욕
		begin
			if(HOUR >= 14 )  //14시 까지
				HOUR_W = HOUR - 14;
			else                 // 13 -> 23      12 -> 22    11 -> 21  . .  9 -> 19 ..1 ->11  0 - > 10 
				HOUR_W = HOUR + 10;
		end
	else  // 런던
		begin		
				if(HOUR >= 9 )  //9시 까지
				HOUR_W = HOUR - 9;
			else                 // 8 -> 23    7-> 22    0 -> 15  
			HOUR_W = HOUR + 15;
		end
end

endmodule
	