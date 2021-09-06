module LCD_WATCH_ampm(HOUR,HOUR_AMPM10,HOUR_AMPM1);

input [6:0]HOUR;
output [3:0]HOUR_AMPM10,HOUR_AMPM1;

reg[3:0] HOUR_AMPM10,HOUR_AMPM1;
wire[3:0] H10,H1;


always @(*)
begin
			if( ( (H10==1)&&(H1>=3) ) || ( (H10==2)&&(H1>=2) )  )  //13 ~ 19 + 22~23
				begin
					HOUR_AMPM10 = H10-1;
					HOUR_AMPM1 = H1-2; 
				end
			else if( (H10==2)&& (H1==0) )  //20 -> 8
				begin
					HOUR_AMPM10 = 0;
					HOUR_AMPM1 = 8; 				
				end
			else if( (H10==2)&& (H1==1) )   // 21 -> 9
				begin
					HOUR_AMPM10 = 0;
					HOUR_AMPM1 = 9; 				
				end			
			else       //0~12
				begin
					HOUR_AMPM10 = H10;
					HOUR_AMPM1 = H1; 				
				end
		
end	

 WT_SEP_H H_SEP(HOUR,H10,H1); // H 두자리를 H10과 H1 로 나눔

endmodule