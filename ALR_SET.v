module ALARM_SET (RESETN,CLK,HOUR_A,MIN_A,U,D,COUNT,OPTION);

input RESETN,CLK;
input U,D;
input [3:0]COUNT;
input [3:0]OPTION;

output [6:0]HOUR_A,MIN_A;

reg U_EN ,D_EN,U_LAST,D_LAST;
reg[6:0] HOUR_A,MIN_A;

always @(posedge CLK) 
begin
	U_LAST <= U;
	U_EN <= U & ~U_LAST;
	D_LAST <= D;
	D_EN <= D & ~D_LAST;
end


always @(negedge RESETN or posedge CLK )
begin
   if(RESETN==1'b0)
		begin
			HOUR_A = 0;
			MIN_A = 0;
		end
   else
		begin		
				if( (U_EN&&COUNT==4'b0010)&&OPTION==4'b0001 ) 
						begin
							if(HOUR_A >= 24) 
								HOUR_A=0;
							else
								HOUR_A = HOUR_A + 1; 			
							end
				else if( (D_EN&&COUNT==4'b0010)&&OPTION==4'b0001 )
						begin
							if(HOUR_A == 0)
								HOUR_A = 23;
							else
								HOUR_A = HOUR_A - 1;   
						end
				
				else if( (U_EN&&COUNT==4'b0001)&&OPTION==4'b0001 ) // 
						begin
							if(MIN_A >= 59) 
								MIN_A=0;
							else
								MIN_A = MIN_A + 1; 			
							end
				else if((D_EN&&COUNT==4'b0001)&&OPTION==4'b0001)
						begin
							if(MIN_A == 0)
								MIN_A = 59;
							else
								MIN_A = MIN_A - 1;  
						end
				else
					begin
						HOUR_A = HOUR_A;
						MIN_A = MIN_A;
					end
		end				
end
 
endmodule