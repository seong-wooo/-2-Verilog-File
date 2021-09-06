module LCD_WATCH(
RESETN,CLK,CLK_1MHZ,LCD_E,LCD_RS,LCD_RW,LCD_DATA,
COUNT_U,COUNT_D,COUNT,U,D,COUNT,
OPTION,SW_A,SONG,ALR_ONOFF,SW_T,W_SELECT,P_1,P_1_2,P_2,SW_S);



	

input RESETN,CLK,CLK_1MHZ;
input COUNT_U,COUNT_D,U,D;
input [3:0]OPTION;
input SW_A,SW_T,SW_S;
input W_SELECT;
input [1:0]P_1;
input [1:0]P_1_2,P_2;

output LCD_E,LCD_RS,LCD_RW;
output [7:0] LCD_DATA;
output [3:0] COUNT;
output SONG;
output ALR_ONOFF;

wire SONG;
wire LCD_E;
wire [7:0]DATA;
wire [7:0]DATAG;
wire[3:0] H10,H1,M10,M1,S10,S1; // 시 분 초
wire[3:0] H_A10,H_A1,M_A10,M_A1;     //옵션 1
wire[3:0] M_T10,M_T1,S_T10,S_T1;     //옵션 2
wire[3:0] HOUR_W10,HOUR_W1;         //옵션 4
wire[3:0] MIN_S10,MIN_S1,SEC_S10,SEC_S1;  //옵션 8
wire [3:0]y10,y1,m10,m1,d10,d1; //연 달 일
wire RESETN,CLK;
wire COUNT_U,COUNT_D,U,D;
wire [3:0] COUNT;
wire s;
wire [6:0] HOUR_A,MIN_A;
wire [6:0] MIN_T,SEC_T;
wire W_SELECT;
wire [2:0]W_COUNT;
wire [3:0] HOUR_AMPM10,HOUR_AMPM1;
wire [1:0]P_1;
wire [1:0]P_1_2,P_2;
wire [3:0]OPTION;
wire [2:0]STATE3;
wire [3:0]G10,G1,P10,P1;
wire [3:0]LEVEL;
wire [31:0]COUNT1,COUNT2;
wire [3:0]COUNT_DOWN;
wire A,T;
wire [2:0]COUNT_DOWN_2;
wire [3:0]P1_100,P1_10,P1_1,P2_100,P2_10,P2_1;
wire [2:0]LOCATION;
wire [2:0]SCREEN;
wire SW_A,SW_T,SW_S;


reg [9:0] CNT1;
reg LCD_RS,LCD_RW;
reg [7:0] LCD_DATA;
reg [2:0] STATE;
reg CLK_100HZ;
reg [6:0] HOUR,MIN,SEC;
reg [3:0] NUM;
reg [3:0] NUMG;
reg U_EN ,D_EN,U_LAST,D_LAST;
reg [7:0] DATA1;


parameter DELAY =3'b000,
          FUNCTION_SET =3'b001,
          ENTRY_MODE =3'b010,
          DISP_ONOFF =3'b011,
          LINE1 =3'b100,
          LINE2 =3'b101;

integer CNT2;
integer CNT_100HZ;


always @(posedge CLK) 
begin
	U_LAST <= U;
	U_EN <= U & ~U_LAST;
	D_LAST <= D;
	D_EN <= D & ~D_LAST;
end




always @(negedge RESETN or posedge CLK)
begin
   if(~RESETN)
      CNT1 = 0;
   else
      begin
         if(CNT1>=999) //1초마다 CNT1 리셋
            CNT1 = 0;
         else
            CNT1 = CNT1+1;
      end
end

always @(negedge RESETN or posedge CLK)
begin
   if(~RESETN)
      SEC = 0;
   else
      begin
         if( CNT1==999 || ( (U_EN&&COUNT==4'b0001)&&OPTION==4'b0000)   ) // 1초 지났을때
            begin
               if(SEC >= 59) // SEC이 59보다 크면 리셋
                  SEC=0;
               else
                  SEC = SEC + 1; // SEC 1초에 1번씩 증가
            end
			else if( (D_EN&&COUNT==4'b0001)&&OPTION==4'b0000 ) 
					begin
						if(SEC == 0)
							SEC = 59;
						else
							SEC = SEC - 1;   //D 이고 COUNT =1 이면 SEC-1
					end
			else
				SEC = SEC;
      end
end
         
always @(negedge RESETN or posedge CLK)
begin
   if(~RESETN)
      MIN=0;
   else 
      begin
         if( ((CNT1 == 999) && (SEC == 59))||((U_EN&&COUNT==4'b0010)&&OPTION==4'b0000 ))//60초 지났을 때
            begin
               if(MIN >=59) // MIN이 59보다 크면 리셋
                  MIN =0;
               else
                  MIN =MIN + 1; // MIN 60초에 1번씩 증가
            end
			else if(  (D_EN && COUNT==4'b0010)&&OPTION==4'b0000 ) 
				begin
					if(MIN == 0)
							MIN = 59;
					else						
							MIN=MIN- 1;   //D 이고 COUNT =2 이면 MIN-1
				end	
			else
				MIN =MIN;
      end
end

always @(negedge RESETN or posedge CLK)
begin
   if(~RESETN)
      HOUR=0;
   else 
      begin
         if( ((CNT1 == 999) && (SEC == 59)&& (MIN==59)) || ((U_EN&&COUNT==4'b0011)&&OPTION==4'b0000)    ) //60초 지났을 때
            begin
               if(HOUR >=24) // HOUR이 59보다 크면 리셋
                  HOUR =0;
               else
                  HOUR =HOUR + 1; //HOUR 60분에 1번씩 증가
            end
			else if( (D_EN&&COUNT==4'b0011)&&OPTION==4'b0000 ) 
				begin
					if(HOUR == 0)
							HOUR = 23;
					else						
							HOUR = HOUR- 1;   //D 이고 COUNT =3 이면 HOUR-1
				end	
			else	
				HOUR = HOUR;
      end
end


// 시간,분, 초 작동 구현




always @ (negedge RESETN or posedge CLK)
begin
   if (RESETN == 1'b0)
   begin
      CNT_100HZ=0;
      CLK_100HZ=1'b0;
   end
   
   else if( CNT_100HZ >=4)
   begin
      CNT_100HZ=0;
      CLK_100HZ= ~CLK_100HZ;
   end

   else
      CNT_100HZ = CNT_100HZ+1;
end

always @(negedge RESETN or posedge CLK_100HZ)
begin
   if(RESETN ==1'b0)
         STATE = DELAY;

      
   else
      begin
         case(STATE)
            DELAY:
               if(CNT2==70) STATE = FUNCTION_SET;   
            
            FUNCTION_SET:
               if(CNT2==30) STATE = DISP_ONOFF;
            
            DISP_ONOFF:
               if(CNT2==30) STATE = ENTRY_MODE;
                           
            ENTRY_MODE:
               if(CNT2==30) STATE = LINE1;    
            
            LINE1:      
               if(CNT2==20) STATE = LINE2;     
            
            LINE2:       
               if(CNT2==20) STATE = LINE1;
					
            default : STATE = DELAY;
         endcase
      end
end


always @(negedge RESETN or posedge CLK_100HZ)
begin
   if(RESETN ==1'b0)
      CNT2 = 0;
   
   else
      begin
         case(STATE)
         DELAY :
            if(CNT2 >=70) CNT2 =0;
            else CNT2 = CNT2 +1;
         
         FUNCTION_SET:
            if(CNT2 >=30) CNT2 =0;
            else CNT2 = CNT2 +1;

         DISP_ONOFF:
            if(CNT2 >=30) CNT2 =0;
            else CNT2 = CNT2 +1;

         ENTRY_MODE:
            if(CNT2 >=30) CNT2 =0;
            else CNT2 = CNT2 +1;               
               
         LINE1:
            if(CNT2 >=20) CNT2 =0;
            else CNT2 = CNT2 +1;   

         LINE2:
            if(CNT2 >=20) CNT2 =0;
            else CNT2 = CNT2 +1;   
      
         default : CNT2 = 0;
         
         endcase
      end
   end
   
always @(*)
begin
	if(OPTION ==4'b0000)
		begin
			if(STATE == LINE1)
				case(CNT2)
					2:	DATA1 = 8'b01001100; //L
					3: DATA1 = 8'b01000011; //C
					4: DATA1 = 8'b01000100; //D
					5: DATA1 = 8'b01011111; //_              
					6: DATA1 = 8'b01010111; //W
					7: DATA1 = 8'b01000001; //A                  
					8: DATA1 = 8'b01010100; //T
					9: DATA1 = 8'b01000011;//C               
					10:DATA1 = 8'b01001000;//H
					default: DATA1 = 8'b00100000;//                  				
				endcase
				
			else if(STATE == LINE2)
				case(CNT2)
					4: NUM =H10;
					5: NUM =H1;
					6: NUM = 13;
					7: NUM =M10;
					8: NUM =M1;
					9: NUM = 13;
					10: NUM =S10;
					11: NUM =S1;
					16: if(A==1)
							NUM =1;
						 else
							NUM = 0;
					default NUM=10;
				endcase
			else
				begin
					NUM =0;
					DATA1 = 8'b00100000;
				end
		end
		
	else if(OPTION ==4'b0001)
		begin
			if(STATE == LINE1)
					case(CNT2)
						2:	DATA1 = 8'b01001100; //L
                  3: DATA1 = 8'b01000011; //C
                  4: DATA1 = 8'b01000100; //D
                  5: DATA1 = 8'b01011111; //_              
                  6: DATA1 = 8'b01000001; //A
                  7: DATA1 = 8'b01001100; //L                  
                  8: DATA1 = 8'b01000001; //A
                  9: DATA1 = 8'b01010010;//R              
                  10:DATA1 = 8'b01001101;//M
                  default: DATA1 = 8'b00100000;//                  				
					endcase
			else if(STATE == LINE2)
					case(CNT2)
						4: NUM =H_A10;
						5: NUM =H_A1;
						6: NUM = 13;
						7: NUM =M_A10;
						8: NUM =M_A1;
						default NUM=10;
					endcase
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end		
		end
		
		
	else if(OPTION ==4'b0010)
		begin
			if(STATE == LINE1)
					case(CNT2)
						2:	DATA1 = 8'b01001100; //L
                  3: DATA1 = 8'b01000011; //C
                  4: DATA1 = 8'b01000100; //D
                  5: DATA1 = 8'b01011111; //_              
                  6: DATA1 = 8'b01010100; //T
                  7: DATA1 = 8'b01001001;  //I                  
                  8: DATA1 = 8'b01001101; //M
                  9: DATA1 = 8'b01000101;//E              
                  10:DATA1 = 8'b01010010;//R
                  default: DATA1 = 8'b00100000;//                  				
					endcase
			else if(STATE == LINE2)
					case(CNT2)
						4: NUM =M_T10;
						5: NUM =M_T1;	
						6: NUM = 13;	
						7: NUM =S_T10;
						8: NUM =S_T1;
						default NUM=10;
					endcase		
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end		
		end
		
		
	else if(OPTION ==4'b0011)
		begin
			if(STATE == LINE1)
					case(CNT2)
						2:	DATA1 = 8'b01001100; //L
                  3: DATA1 = 8'b01000011; //C
                  4: DATA1 = 8'b01000100; //D
                  5: DATA1 = 8'b01011111; //_              
                  6: DATA1 = 8'b01000011; //C
                  7: DATA1 = 8'b01000001; //A                  
                  8: DATA1 = 8'b01001100; //L
                  9: DATA1 = 8'b01000101;//E              
                  10:DATA1 = 8'b01001110;//N
                  11:DATA1 = 8'b01000100;//D
                  12:DATA1 = 8'b01000101;//E
                  13:DATA1 = 8'b01010010;//R
                  default: DATA1 = 8'b00100000;//                  				
					endcase
			else if(STATE == LINE2)
					case(CNT2)
						2: NUM =2;
						3: NUM =0;
						4: NUM =y10;
						5: NUM =y1;
						7: NUM =m10;
						8: NUM =m1;
						10: NUM =d10;
						11: NUM =d1;
						default NUM=10;
					endcase		
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end		
		end
		
	else if(OPTION ==4'b0100)
		begin
			if(STATE == LINE1)
					case(CNT2)
                  2:
                     begin
								if(W_COUNT == 0)
									DATA1 = 8'b01010011;           //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01000010;           //BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01001110;            //NEWYORK
								else 
									DATA1 = 8'b01001100;            //LONDON
                     end

                  3:
                     begin
								if(W_COUNT == 0)
									DATA1 = 8'b01011001;           //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01000101;           //BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01000101;           //NEWYORK
								else 
									DATA1 = 8'b01001111;           //LONDON
                     end


                  4:
                     begin
								if(W_COUNT == 0)
									DATA1 = 8'b01000100;           //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01001001;           //BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01010111;           //NEWYORK
								else 
									DATA1 = 8'b01001110;            //LONDON
                     end

                  5:
                     begin
								if(W_COUNT == 0)
									DATA1 = 8'b01001110;      		 //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01001010;           //BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01011001;           //NEWYORK
								else 
									DATA1 = 8'b01000100;      		 //LONDON
                     end
               
                  6:
                     begin
								if(W_COUNT == 0)
									DATA1 = 8'b01000101;          //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01001001;        	//BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01001111;         	//NEWYORK
								else
									DATA1 = 8'b01001111;           //LONDON
                     end

                  7:
                     begin
								if(W_COUNT == 0)
									DATA1 = 8'b01011001;				 //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01001110;            //BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01010010;         	//NEWYORK
								else 
									DATA1 = 8'b01001110;              //LONDON
                     end
                     
                  8:
                     begin    
								if(W_COUNT == 0)								
									DATA1 = 8'b00100000;          //SYDNEY
								else if(W_COUNT == 1)
									DATA1 = 8'b01000111;     		 //BEIJING
								else if(W_COUNT == 2)
									DATA1 = 8'b01001011;           //NEWYORK
								else 
									DATA1 = 8'b00100000;            //LONDON                 
                     end
                  default: DATA1 = 8'b00100000;//                  				
					endcase
			else if(STATE == LINE2)
					case(CNT2)
						4: NUM =HOUR_W10;
						5: NUM =HOUR_W1;
						6: NUM = 13;
						7: NUM =M10;
						8: NUM =M1;
						9: NUM = 13;
						10: NUM =S10;
						11: NUM =S1;
						default NUM=10;
					endcase		
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end		
		end
		
		else if(OPTION ==4'b0101)
		begin
				if(STATE == LINE1)
					case(CNT2)
						2:	DATA1 = 8'b01001100; //L
                  3: DATA1 = 8'b01000011; //C
                  4: DATA1 = 8'b01000100; //D
                  5: DATA1 = 8'b01011111; //_              
                  6: DATA1 = 8'b01010111; //W
                  7: DATA1 = 8'b01000001; //A                  
                  8: DATA1 = 8'b01010100; //T
                  9: DATA1 = 8'b01000011;//C               
                  10:DATA1 = 8'b01001000;//H
                  12:	if(HOUR >=12)
									DATA1 = 8'b01010000; //P
								else
									DATA1 = 8'b01000001; //A								
                  13:DATA1 = 8'b01001101; //M 
                  default: DATA1 = 8'b00100000;//                  				
					endcase
				else if(STATE == LINE2)
					case(CNT2)
						4: NUM =HOUR_AMPM10;
						5: NUM =HOUR_AMPM1;
						6: NUM = 13;
						7: NUM =M10;
						8: NUM =M1;
						9: NUM = 13;
						10: NUM =S10;
						11: NUM =S1;
						16: if(s==1)
								NUM =1;
							 else
								NUM = 0;
						default NUM=10;
					endcase
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end
		end
		
		else if(OPTION ==4'b0110)
		begin
				if(STATE == LINE1)
					case(CNT2)
						2:	if(STATE3 == 3'b000)
							DATA1 = 8'b01001100;         //L
							else if(STATE3 == 3'b001)
							DATA1 = 8'b01010010;			  //R
							else 
							DATA1 = 8'b00100000;
					   
						3: if(STATE3 == 3'b000)
							DATA1 = 8'b01000101;         // E
							else if(STATE3 == 3'b001)
							DATA1 = 8'b01000101;			  //E
							else if(STATE3 == 3'b100)
							DATA1 = 8'b01000011;		// C
							else 
							DATA1 = 8'b00100000;
							
                  4: 
							if(STATE3 == 3'b000)
							DATA1 = 8'b01010110;         // V
							else if(STATE3 == 3'b001)		  // A
							DATA1 = 8'b01000001;
							else if(STATE3 == 3'b100) //L
							DATA1 = 8'b01001100;
							else 
							DATA1 = 8'b00100000;
                 
				    	5: if(STATE3 == 3'b000)
							DATA1 = 8'b01000101;         // E
							else if(STATE3 == 3'b001)       // D
							DATA1 = 8'b01000100;
							else if(STATE3 == 3'b100)
							DATA1 = 8'b01000101;  //E
							else 
							DATA1 = 8'b00100000;
								
					   6: if(STATE3 == 3'b000)
							DATA1 = 8'b01001100;         // L
							else if(STATE3 == 3'b001)		  // Y
							DATA1 = 8'b01011001;
							else if(STATE3 == 3'b100)
							DATA1 = 8'b01000001;  //A
							else 
							DATA1 = 8'b00100000;
								
                  7: 	if(STATE3 == 3'b010)
								DATA1 = 8'b01000110;      //F
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01010010; //R
								else 
								DATA1 = 8'b00100000;     
								
                  8: 	if(STATE3 == 3'b000)
                        DATA1 = DATAG ;      // LEVEL
								else if(STATE3 == 3'b001)
								DATA1 = DATAG;     // 3 2 1
								else if(STATE3 == 3'b010)
								DATA1 = 8'b01000001;     //A
								else 
								DATA1 = 8'b00100000;
								
								
                  9:    if(STATE3 == 3'b010)
								DATA1 = 8'b01001001;    //I
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01010010; //R
								else 
								DATA1 = 8'b00100000;     
							
                  10:	if(STATE3 == 3'b000)
                        DATA1 = 8'b01010100;    // T
								else if(STATE3 == 3'b010)
								DATA1 = 8'b01001100;    //L
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01000101; //E
								else 
								DATA1 = 8'b00100000;
                  
						11:	
								if(STATE3 == 3'b000)
                        DATA1 = 8'b01001001;   // I
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01010000;    //P							
								else 
								DATA1 = 8'b00100000;
						
						12:	if(STATE3 == 3'b000)
                        DATA1 = 8'b01001101;         // M
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01001100;    //L
								else 
								DATA1 = 8'b00100000;
						13:	if(STATE3 == 3'b000)
                        DATA1 = 8'b01000101;      // E
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01000001;    //A
								else 
								DATA1 = 8'b00100000; //
						14:	if(STATE3 == 3'b000)
								DATA1 = DATAG;	
								else if(STATE3 == 3'b100)
								DATA1 = 8'b01011001;    //Y
								else 
								DATA1 = 8'b00100000;
						15:	if(STATE3 == 3'b100)
								DATA1 = 8'b00111111; //?
								else 
								DATA1 = 8'b00100000;
						
                  default: DATA1 = 8'b00100000;//                  				
					endcase
				else if(STATE == LINE2)
					case(CNT2)
						
                  1:		if(STATE3 == 3'b000)
                        NUM=11;  // G
								else 
								NUM=10; 
						2:
								if(STATE3 == 3'b000)
								NUM = 12;       // O
								else 
								NUM=10; 
								
						4:		if(STATE3 == 3'b000)
                        NUM = G10;
								else 
								NUM = 10;
						5:		if(STATE3 == 3'b000)
                        NUM = G1;
								else 
								NUM = 10;
						10:	if(STATE3 == 3'b000)
                        NUM = P10;        // P10	
								else 
								NUM=10;
						11:	if(STATE3 == 3'b000)
                        NUM = P1;        // P1	
								else 
								NUM=10;							
						default NUM=10;
					endcase
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end					
			end
	
	else if(OPTION ==4'b0111)
		begin
				if(STATE == LINE1)
					case(CNT2)
						2:	if(SCREEN == 3'b010)
							DATA1 = 8'b00110001;        //1
							else 
							DATA1 = 8'b00100000;
					   
						3: if(SCREEN == 3'b001)
                     DATA1 = 8'b01010010;			  //R         
							else if(SCREEN == 3'b010)
							DATA1 = 8'b01010000;			  //P
							else if(SCREEN == 3'b100)
							DATA1 = 8'b01000111;        //G
							else 
							DATA1 = 8'b00100000;
							
                  4: if(SCREEN == 3'b001)
                     DATA1 = 8'b01000101;			  //E
							else if(SCREEN == 3'b100)
							DATA1 = 8'b01000001;         //A
							else 
							DATA1 = 8'b00100000;
                 
				    	5: if(SCREEN == 3'b001)
                     DATA1 = 8'b01000001;		  // A 
							else if(SCREEN == 3'b010)
							DATA1 = 8'b01111100;       //l
							else if(SCREEN == 3'b100)
							DATA1 = 8'b01001101;         //M
							else 
							DATA1 = 8'b00100000;
								
					   6: if(SCREEN == 3'b001)
                     DATA1 = 8'b01000100;        // D
							else if(SCREEN == 3'b010)
							begin
								if(LOCATION == 3'b000)
										DATA1 = 8'b10111011;      // <<      
								else
										DATA1 = 8'b00100000;
							end
							else if(SCREEN == 3'b100)
							DATA1 = 8'b01000101;         //E
							else  
							DATA1 = 8'b00100000;
								
                  7: 	if(SCREEN == 3'b001)
                        DATA1 = 8'b01011001;         // Y
								else if(SCREEN == 3'b010)
							   begin
									if(LOCATION == 3'b001)
											DATA1 = 8'b10111011;      // <<      
									else
											DATA1 = 8'b00100000;
								end
								else if(SCREEN == 3'b100)
								DATA1 = 8'b00100000;
								else 
								DATA1 = 8'b00100000;     
								
                  8: 	if(SCREEN == 3'b010)
								begin
									if(LOCATION == 3'b010)
											DATA1 = 8'b10111011;      // <<      
									else
											DATA1 = 8'b00100000;
								end
								else if(SCREEN == 3'b100)
								DATA1 = 8'b01001111;         //O
								else 
								DATA1 = 8'b00100000;
								
								
                  9:  	if(SCREEN == 3'b001)
									begin
										if(COUNT_DOWN_2==3'b011)
										DATA1 = 8'b00110011;        //3 
										else if(COUNT_DOWN_2==3'b010)
										DATA1 = 8'b00110010;			//2								
										else if(COUNT_DOWN_2==3'b001)	
										DATA1 = 8'b00110001;		   //1						
										else 
										DATA1 = 8'b00100000;
									end						
								else if(SCREEN == 3'b010)
								begin
									if(LOCATION == 3'b011)
											DATA1 = 8'b01111100;      //   l   
									else
											DATA1 = 8'b00100000;
								end
								else if(SCREEN == 3'b100)
								DATA1 = 8'b01010110;            // V
								else 
								DATA1 = 8'b00100000;     
							
                  10:	if(SCREEN == 3'b010)
								begin
									if(LOCATION == 3'b100)
											DATA1 = 8'b10111100;      //   >>  
									else
											DATA1 = 8'b00100000;
								end
								else if(SCREEN == 3'b100)
								DATA1 = 8'b01000101;          //E
								else 
								DATA1 = 8'b00100000;
                  
						11:	if(SCREEN == 3'b010)
								begin
									if(LOCATION == 3'b101)
											DATA1 = 8'b10111100;      //   >>  
									else
											DATA1 = 8'b00100000;
								end
								else if(SCREEN == 3'b100)
								DATA1 = 8'b01010010;          //R						
								else 
								DATA1 = 8'b00100000;
						
						12:	if(SCREEN == 3'b010)
								begin
									if(LOCATION == 3'b110)
											DATA1 = 8'b10111100;      //   >>  
									else
											DATA1 = 8'b00100000;
								end
								else 
								DATA1 = 8'b00100000;
								
						13:	if(SCREEN == 3'b010)
								DATA1 = 8'b01111100;        // l
								else 
								DATA1 = 8'b00100000;
								
						15: 	if(SCREEN == 3'b010)
								DATA1 = 8'b00110010;        //2
								else
								DATA1 = 8'b00100000;
								
						16: 	if(SCREEN == 3'b010)
								DATA1 = 8'b01010000;			  //P
								else
								DATA1 = 8'b00100000;
						
                  default: DATA1 = 8'b00100000;//                  				
					endcase
				else if(STATE == LINE2)
					case(CNT2) 
						2:		if(SCREEN == 3'b010)
								NUM = P1_100; 
								else
								NUM = 10;
						
						3:   if(SCREEN == 3'b010)
								NUM = P1_10; 
								else
								NUM = 10; 
						
						4:		if(SCREEN == 3'b010)
								NUM = P1_1; 
								else
								NUM = 10;
								
						14:	if(SCREEN == 3'b010)
								NUM = P2_100; 
								else
								NUM = 10;
								
						15:	if(SCREEN == 3'b010)
								NUM = P2_10; 
								else
								NUM = 10;
								
						16:	if(SCREEN == 3'b010)
								NUM = P2_1; 
								else
								NUM = 10;
								
						default NUM=10;
					endcase
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end				
		end	
		else if(OPTION ==4'b1000)
		begin
			if(STATE == LINE1)
					case(CNT2)
						1: DATA1 = 8'b01010011;	//S
						2:	DATA1 = 8'b01010100; //T
                  3: DATA1 = 8'b01001111; //O
                  4: DATA1 = 8'b01010000; //P
                  5: DATA1 = 8'b01011111; //_              
                  6: DATA1 = 8'b01010111; //W
                  7: DATA1 = 8'b01000001; //A                  
                  8: DATA1 = 8'b01010100; //T
                  9: DATA1 = 8'b01000011;//C               
                  10:DATA1 = 8'b01001000;//H
                  default: DATA1 = 8'b00100000;//                  				
					endcase
			else if(STATE == LINE2)
					case(CNT2)
						4: NUM =MIN_S10;
						5: NUM =MIN_S1;
						6: NUM =13;
						7: NUM =SEC_S10;
						8: NUM =SEC_S1;
						default NUM=10;
					endcase
				else
					begin
						NUM =0;
						DATA1 = 8'b00100000;
					end		
		end	
			
		//마지막에 else 써야함
					
end


//게임에서 나온 숫자 -> DATA			
always @(*)
begin
	if (STATE == LINE1)  
		case(CNT2)
			8: 
				if(STATE3 == 3'b000)
					NUMG =LEVEL;
				else if(STATE3 == 3'b001)
					begin
						if( COUNT2 && COUNT2 <999)  
									NUMG = 3; 		//3					
						else if( COUNT2>=1000 && COUNT2 <1999)  
									NUMG = 2; 	//2					
						else if( COUNT2>=2000 && COUNT2 <2999)  
									NUMG = 1; //1
						else
							NUMG = 0;
					end  
			14: if(STATE3 == 3'b000)
					NUMG =COUNT_DOWN;

			default NUMG=0;
		endcase	
	
end
	
	
always @(negedge RESETN or posedge CLK_100HZ)
begin
   if(RESETN ==1'b0)
      begin
         LCD_RS =1'b1;
         LCD_RW =1'b1;
         LCD_DATA =8'b00000000;
      end
   else
      begin
         case(STATE)
            FUNCTION_SET :
               begin
                  LCD_RS = 1'b0;
                  LCD_RW = 1'b0;
                  LCD_DATA = 8'b00111100;
               end   

            DISP_ONOFF :
               begin
                  LCD_RS = 1'b0;
                  LCD_RW = 1'b0;
                  LCD_DATA = 8'b00001100;
               end      
               
            ENTRY_MODE :
               begin
                  LCD_RS = 1'b0;
                  LCD_RW = 1'b0;
                  LCD_DATA = 8'b00000110;
               end

            LINE1 :   
               begin
               
                  LCD_RW = 1'b0;
                  
                  case(CNT2)
                  0:
                     begin
                        LCD_RS = 1'b0;
                        LCD_DATA = 8'b10000000;
                     end

                  1:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  2:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  3:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end


                  4:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  5:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end
               
                  6:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  7:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end
                     
                  8:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  9:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  10:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end


                  11:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end


                  12:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end

                  13:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end
   
                  14:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end
   
                  15:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end
   
                  16:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA1;
                     end
                  
                  default:
                     begin
                        LCD_RS =1'b1;
                        LCD_DATA =8'b00100000;
                     end
                     
                  endcase
               end
   
               LINE2 :   
               begin
                  LCD_RW = 1'b0;
                  
                  case(CNT2)
                  0:
                     begin
                        LCD_RS = 1'b0;
                        LCD_DATA = 8'b11000000;
                     end

                  1:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end

                  2:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;                    
                        end

                  3:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end


                  4:
                     begin
                        LCD_RS = 1'b1;                 // H10
                        LCD_DATA = DATA;
                     end

                  5:
                     begin
                        LCD_RS = 1'b1;  // H1
                        LCD_DATA = DATA;
                     end
               
                  6:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA; // :
                     end

                  7:
                     begin
                        LCD_RS = 1'b1;                // M10
                        LCD_DATA = DATA;
                     end
                     
                  8:
                     begin
                        LCD_RS = 1'b1;                 // M1
                        LCD_DATA = DATA;
                     end

                  9:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = 8'b00100000;// VOID
                     end

                  10:
                     begin
                        LCD_RS = 1'b1;               // S10
                        LCD_DATA = DATA;
                     end


                  11:
                     begin
                        LCD_RS = 1'b1;                //S1
                        LCD_DATA = DATA;
                     end


                  12:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end

                  13:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end
   
                  14:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end
   
                  15:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end
   
                  16:
                     begin
                        LCD_RS = 1'b1;
                        LCD_DATA = DATA;
                     end
                  
                  default:
                     begin
                        LCD_RS =1'b1;
                        LCD_DATA =8'b00100000;
                     end
                  endcase
            end
                

         default :
            begin   
               LCD_RS =1'b1;
               LCD_RW =1'b1;
               LCD_DATA =8'b00000000;
            end      
         endcase
      end
end

assign LCD_E = CLK_100HZ;

WT_SEP_SM S_SEP(SEC,S10,S1); // S 두자리를 S10과 S1 로 나눔
WT_SEP_SM M_SEP(MIN,M10,M1); // M 두자리를 M10과 M1 로 나눔
WT_SEP_H H_SEP(HOUR,H10,H1); // H 두자리를 H10과 H1 로 나눔

PIEZO_reality_and_damedame song(RESETN,CLK_1MHZ,A,T,SONG );


up_down option(CLK,COUNT_U,COUNT_D, COUNT);
WT_DECODER S_DECODE(NUM,DATA);
WT_DECODER S_1_DECODE(NUMG,DATAG);

ARALM option1(RESETN,CLK,HOUR,MIN,U,D,COUNT,SW_A,M_A10,M_A1,H_A10,H_A1,ALR_ONOFF,A,OPTION);

TIEMR option2(RESETN,CLK,U,D,COUNT,SW_T,S_T10,S_T1,M_T10,M_T1,T,OPTION);

calender option3(RESETN,CLK,HOUR,MIN,SEC,CNT1,U,D,COUNT,y10,y1,m10,m1,d10,d1,OPTION);

WORLD_TIME option4(RESETN,CLK,HOUR,HOUR_W10,HOUR_W1,W_SELECT,W_COUNT);

LCD_WATCH_ampm option5(HOUR,HOUR_AMPM10,HOUR_AMPM1);

game1_1player option6(RESETN,CLK,P_1,OPTION,STATE3,G10,G1,P10,P1,LEVEL,COUNT1,COUNT2,COUNT_DOWN,P_1_2);

game_2player option7(RESETN,CLK,P_1_2,P_2,COUNT,COUNT_DOWN_2,P1_100,P1_10,P1_1,P2_100,P2_10,P2_1,LOCATION,OPTION,SCREEN,P_1); 

STOP_WATCH option8(RESETN,CLK,MIN_S10,MIN_S1,SEC_S10,SEC_S1,SW_S);
	

endmodule