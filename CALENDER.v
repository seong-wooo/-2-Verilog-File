module calender(
RESETN,CLK,HOUR,MIN,SEC,CNT1,U,D,COUNT,y10,y1,m10,m1,d10,d1,OPTION);

input [3:0]OPTION;
input RESETN,CLK;
input [6:0]HOUR,MIN,SEC;
input U,D;
input [3:0]COUNT;
input [9:0]CNT1;

output [3:0]y10,y1,m10,m1,d10,d1;

reg U_EN ,D_EN,U_LAST,D_LAST ;
reg[6:0] YEAR,MONTH,DAY;

wire[3:0]d1,d10,m1,m10,y1,y10;


always @(posedge CLK) 
begin
	U_LAST <= U;
	U_EN <= U & ~U_LAST;
	D_LAST <= D;
	D_EN <= D & ~D_LAST;
end

always @(negedge RESETN or posedge CLK)
begin
   if(RESETN==1'b0)
      DAY = 15;
   else
      begin
           if( ((CNT1 == 999) && (SEC == 59)&& (MIN==59)&&(HOUR == 23)) || ((U_EN&&COUNT==4'b0001)&&OPTION==4'b0011) ) // HOUR =24 일때 DAY +1 
              begin
							if(MONTH == 2)
								begin
									if(DAY==28)
											DAY=1;
										else
											DAY = DAY + 1; // DAY 24시간에 1번씩 증가
								end
							else if(MONTH == 4 || MONTH == 6 || MONTH == 9 || MONTH == 11 )
								begin		
										if(DAY==30)
											DAY=1;
										else
											DAY = DAY + 1; // DAY 24시간에 1번씩 증가
								end
							else
								begin		
										if(DAY==31)
											DAY=1;
										else
											DAY = DAY + 1; // DAY 24시간에 1번씩 증가
								end
					end
					
			  else if( (D_EN&&COUNT==4'b0001)&&OPTION==4'b0011 )
				  begin
							if(MONTH == 3)
								begin
									if(DAY==1)
											DAY=28;
										else
											DAY = DAY - 1; // DAY 24시간에 1번씩 증가
								end
							else if(MONTH == 5 || MONTH == 7 || MONTH == 10 || MONTH == 12 )
								begin		
										if(DAY==1)
											DAY=30;
										else
											DAY = DAY - 1; // DAY 24시간에 1번씩 증가
								end
							else
								begin		
										if(DAY==1)
											DAY=31;
										else
											DAY = DAY - 1; // DAY 24시간에 1번씩 증가
								end
				  end
			  else
					DAY =DAY;

      end
end
         
always @(negedge RESETN or posedge CLK)
begin
   if(RESETN==1'b0)
      MONTH = 12;
   else
      begin
           if( ( (CNT1 == 999) && (SEC == 59)&& (MIN==59)&&(HOUR == 23) && DAY == 31) ||  ( (U_EN&&COUNT==4'b0010)&&OPTION==4'b0011)  ) // HOUR =24 ,DAY=31일때 MONTH +1 
              begin    
						if(MONTH==12)
							MONTH=1;
						else
							MONTH = MONTH + 1; 
					end
			  else if((D_EN&&COUNT==4'b0010)&&OPTION==4'b0011)
				  begin
						if(MONTH == 1)
							MONTH =12;
						else
							MONTH = MONTH -1;
				  end
				else
					MONTH =MONTH;
      end
end

always @(negedge RESETN or posedge CLK )
begin
   if(RESETN==1'b0)
      YEAR = 20;
   else
      begin
           if( ((CNT1 == 999) && (SEC == 59)&& (MIN==59)&&(HOUR == 23)&& DAY == 31 && MONTH==12) || ((U_EN&&COUNT==4'b0011)&&OPTION==4'b0011) ) // HOUR =24 ,DAY=31 ,MONTH 12일때 년도 +! 
              begin    
						if(YEAR==99)
							YEAR=1;
						else
							YEAR = YEAR + 1; 
					end
				else if((D_EN&&COUNT==4'b0011)&&OPTION==4'b0011)
					begin
						if(YEAR==1)
							YEAR = 99;
						else
							YEAR = YEAR - 1;
					end
				else
					YEAR = YEAR;
      end
end

WT_SEP_Y Y_SEP(YEAR,y10,y1); 
WT_SEP_M M_SEP(MONTH,m10,m1);
WT_SEP_D D_SEP(DAY,d10,d1);



endmodule