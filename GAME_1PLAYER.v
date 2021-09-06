module game1_1player(RESETN,CLK,
P_1,STATE_GAME,STATE3,G10,G1,P10,P1,LEVEL,COUNT1,COUNT2,COUNT_DOWN,P_1_2); //STATE_GAME은 메인 모듈의 OPTION


input RESETN,CLK;
input [1:0]P_1,P_1_2;
input [3:0]STATE_GAME; //0110
output [3:0] G10,G1,P10,P1;
output [2:0]STATE3;
output [3:0] LEVEL; 
output [31:0]COUNT1,COUNT2;
output [3:0]COUNT_DOWN;

wire [3:0]COUNT_DOWN;
wire [2:0]STATE3 ; //스크린 
wire[3:0] G10,G1,P10,P1;
wire [7:0] DATA;
wire CLK,RESETN;

reg [6:0] LEVEL_COUNT;
reg LEVEL_CLEAR;
reg ALL_CLEAR;
reg LEVEL_FAIL;
reg [1:0]P_1_EN ,P_1_LAST;
reg [6:0]P_1_COUNT;
reg [3:0] LEVEL;
reg [31:0]COUNT1;
reg [31:0]COUNT2;



assign STATE3 = {ALL_CLEAR,LEVEL_FAIL,LEVEL_CLEAR};       //하다가 코드 실패하면 STATE3 3비트로 나눠서 간단하게 구현하기



always @(*)
begin
	if(LEVEL <= 5)
	LEVEL_COUNT = 10*LEVEL;
	else
	LEVEL_COUNT = 0;
end
	

// 버튼 원샷
always @(posedge CLK) 
begin
	P_1_LAST[1] <= P_1[1];
	P_1_EN[1] <= P_1[1] & ~P_1_LAST[1];
	P_1_LAST[0] <= P_1[0];
	P_1_EN[0] <= P_1[0] & ~P_1_LAST[0];
end

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
	if(RESETN==1'b0)
		begin			
			LEVEL_CLEAR = 1;     //초기 3 2 1 화면
			LEVEL_FAIL = 0;             
			COUNT1 = 0;
			LEVEL = 1;	         //초기 레벨 1
			ALL_CLEAR = 0;
		end
		
	else if(STATE_GAME != 4'b0110)	  //옵션이 0110 이 아니라면
		begin			 
			LEVEL_CLEAR = 1;             // 그냥 놔두기
			LEVEL_FAIL = 0;
			COUNT1 = 0;
			LEVEL = 1;	
			ALL_CLEAR = 0;
		end

			
	else                          //옵션이  0110이라면
		begin
			if(ALL_CLEAR ==1)         //만약 다깼을 때 
				begin
					if(P_1[1] && P_1[0]&&P_1_2[0]&&P_1_2[1])	// 다 꺴을 때 P_1[1] P_[0],P_1_2[0],P_1_2[1] 4개버튼 다 누르면 다시 돌아감
					begin
						ALL_CLEAR  = 0; 
						LEVEL_CLEAR = 1;         //3 2 1 화면으로 돌아가
					end
					else 
						begin
							ALL_CLEAR  = 1; 
							LEVEL_CLEAR = 0;
							LEVEL_FAIL = 0;
						end
				end
			
			else 
			begin
				if(LEVEL_FAIL == 1)            // ALLCLEAR == 0 상태 LEVEL_CLEAR  = 1 ; , LEVEL_FAIL  = 0;
					begin
						if(P_1[1] && P_1[0]&&P_1_2[0]&&P_1_2[1])            // fail 화면 일때 버튼 두개 눌리면 게임 다시 실행
							begin
								LEVEL_FAIL = 0;					
								LEVEL_CLEAR = 1;         	  
							end
					end
						
				else  // ALL_CLEAR = 0 LEVEL FAIL = 0 LEVEL CLEAR = 1  
					begin
						if( (LEVEL_CLEAR==1) && (COUNT2 <= 3000) ) // 클리어일 때 3초 유지
								COUNT2 = COUNT2 +1 ;
						else if( (LEVEL_CLEAR==1) && (COUNT2 > 3000)  ) // 3초 이후 LEVEL_CLEAR 도 0이된다
											begin
												COUNT2 = 0;
												LEVEL_CLEAR = 0;
											end
								
						else	  // 올클 , 렙클, 렙페일 다 0일 때 		  	
							begin
										if(LEVEL <=5)   // LEVEL 5 이하 이면
										begin
														if( (COUNT1 <= 5000) && ( LEVEL_COUNT >  P_1_COUNT ) )  //5초보다 작을 때 개수 못넘어갔다면
															begin
																LEVEL_CLEAR = 0;  
																LEVEL_FAIL = 0;
																LEVEL = LEVEL;                               //모두 다 그대로
 																COUNT1 = COUNT1 + 1;  //5초전 못넘어간경우
															end
														else if( (COUNT1 <= 5000)  && ( LEVEL_COUNT  <=  P_1_COUNT ) )     //5초전에 넘어가면
															begin
																if(LEVEL == 5)
																	LEVEL_CLEAR = 0;     
																else
																	LEVEL_CLEAR = 1;// 3 2 1 뜨고 
																LEVEL_FAIL = 0;
																LEVEL = LEVEL + 1;      // 레벨 업
																COUNT1 = 0;  //5초전에 넘어간경우
															end
														else 
															begin  
																LEVEL_CLEAR = 0;
																LEVEL_FAIL = 1;         //FAIL 뜬다 실패 ~
																LEVEL = 1 ; 
																COUNT1 = 0;   //5초 후  못넘어간경우
															end
										end
															
										else   //LEVEL 6이상
											begin
												LEVEL = 1;
												LEVEL_CLEAR = 0;
												LEVEL_FAIL = 0;
												COUNT1 = 0;
												ALL_CLEAR = 1;
											end
								
							end	
										
			end
		end
	end
end
	

COUNTDOWN count_down(COUNT1,COUNT_DOWN,CLK,RESETN);
WT_SEP_Y count_G_SEP(LEVEL_COUNT,G10,G1); //
WT_SEP_Y count_p_SEP(P_1_COUNT,P10,P1);

endmodule