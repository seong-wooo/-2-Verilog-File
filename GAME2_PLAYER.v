module game_2player(RESETN,CLK,P_1,P_2,
COUNT,COUNT_DOWN,P1_100,P1_10,P1_1,P2_100,P2_10,P2_1,
LOCATION,OPTION,SCREEN,P_1_2); 

input RESETN,CLK;
input [1:0]P_1,P_2,P_1_2;
input [3:0]COUNT;
input [3:0]OPTION;


output [2:0]COUNT_DOWN;
output [3:0] P1_100,P1_10,P1_1,P2_100,P2_10,P2_1;
output [2:0]LOCATION;
output [2:0]SCREEN;

reg [6:0]P_1_COUNT,P_2_COUNT;
reg [2:0]LOCATION;
reg [2:0] SCREEN ;
reg [31:0]COUNT1,COUNT2;


wire [1:0]P_1,P_2;
wire [1:0]P_1_EN,P_2_EN  ;
wire [3:0] P1_100,P1_10,P1_1,P2_100,P2_10,P2_1;
wire [7:0]SUB_COUNT ;
wire CLK,RESETN;
wire [2:0]COUNT_DOWN; 

assign SUB_COUNT = P_1_COUNT - P_2_COUNT + 127;

always @(negedge RESETN or posedge CLK)
begin
	if(RESETN == 1'b0) 
		P_1_COUNT = 0;
	else
		begin
			if( COUNT1 == 0)
				P_1_COUNT = 0;
			
			else if( P_1_EN[0] || P_1_EN[1] )
				P_1_COUNT = P_1_COUNT + 1 ;
			else   
				P_1_COUNT = P_1_COUNT;
		end
end


always @(negedge RESETN or posedge CLK)
begin
	if(RESETN == 1'b0) 
		P_2_COUNT = 0;
	else
		begin
			if( COUNT1 == 0)
				P_2_COUNT = 0;
			
			else if( P_2_EN[0] || P_2_EN[1] )
				P_2_COUNT = P_2_COUNT + 1 ;
			else   
				P_2_COUNT = P_2_COUNT;
		end
end


always @(negedge RESETN or posedge CLK)
begin	
	if(RESETN==1'b0)
		begin			
			COUNT1 = 0;
			SCREEN = 3'b001;
			LOCATION = 3'b011;
		end
		
	else if(OPTION != 4'b0111)	     //옵션 선택이 안되면 그냥 변화없는거
		begin			
			COUNT1 = 0;
			SCREEN = 3'b001;
			LOCATION = 3'b011;
		end

			
	else 
		begin
			if(SCREEN == 3'b100) // GAME OVER
				begin
					if( P_1[1] && P_1[0] && P_1_2[1] && P_1_2[0] ) //버튼 4개 다 누르면       
					begin
						COUNT1 = 0;    //COUNT1 리셋 
						SCREEN = 3'b001; // 스크린 3 2 1로 
						LOCATION = 3'b011; // 위치 3 
					end
				end
			
			else if( SCREEN == 3'b001 ) // 3 2 1 시간
				begin
						if(COUNT2 <= 3000)  // 3 2 1 3초 유지
							COUNT2 = COUNT2 +1 ;
						
						else  
							begin
								COUNT2 = 0; //3초 후 
								SCREEN = 3'b010; // 스크린 게임중으로 
								LOCATION = 3'b011;  // 위치 3
							end								
				end
				
			else if( SCREEN == 3'b010 )         //게임중
				begin
					COUNT1 = 1;
					if(P_1_COUNT == 7'b0111111 || P_2_COUNT == 7'b0111111 )  // 카운트 127 된다? 
						begin
							LOCATION = 3'b011;     //위치 리셋
							SCREEN = 3'b100;		  // 스크린 게임 오버로  
							COUNT1= 0;
						end
						
					else
						begin
							if( SUB_COUNT < 120 || SUB_COUNT > 134  )   // 뺀게 절댓값이 8이상 즉 8번이상 차이날때 
 								begin
									LOCATION = 3'b011;                    
									SCREEN = 3'b100;      //GAME OVER
								end
							else if( SUB_COUNT == 120)
									LOCATION = 3'b000;		
							else if( SUB_COUNT == 122 || SUB_COUNT == 121)
									LOCATION = 3'b000;					
							
							else if( SUB_COUNT == 124 || SUB_COUNT == 123)
									LOCATION = 3'b001;					
							
							else if( SUB_COUNT == 126 || SUB_COUNT == 125)
									LOCATION = 3'b010;					
							
							else if( SUB_COUNT == 0 )	
									LOCATION = 3'b011;					
							
							else if( SUB_COUNT == 128 || SUB_COUNT == 129)
									LOCATION = 3'b100;					
							
							else if( SUB_COUNT == 130 || SUB_COUNT == 131)
									LOCATION = 3'b101;					
							
							else if( SUB_COUNT == 132 || SUB_COUNT == 133)
									LOCATION = 3'b110;	
							else if( SUB_COUNT == 134)
								LOCATION = 3'b110;
							else 
									LOCATION = 3'b011;
					end
				end
			else //스크린이 1 2 3 중에 아무것도아니다  -> 그럴일 없긴함
				begin
					COUNT1 = 0;
					SCREEN = 3'b001;
					LOCATION = 3'b011;
				end
		end
end
				
			

COUNTDOWN_game2 COUNTDOWN(COUNT2,COUNT_DOWN,CLK,RESETN);
oneshot p_1_0_ENABLE(CLK,P_1[0],P_1_EN[0]);
oneshot p_1_1_ENABLE(CLK,P_1[1],P_1_EN[1]);
oneshot p_2_0_ENABLE(CLK,P_2[0],P_2_EN[0]);
oneshot p_2_1_ENABLE(CLK,P_2[1],P_2_EN[1]);
WT_SEP_PLAYER P1(P_1_COUNT,P1_100,P1_10,P1_1);
WT_SEP_PLAYER P2(P_2_COUNT,P2_100,P2_10,P2_1);

endmodule