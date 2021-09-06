module PIEZO_reality(RESETN,CLK_1MHZ,A,T,SONG );

input RESETN,CLK_1MHZ,A,T;

output SONG;

wire SONG;

reg BUFF;
reg [31:0] freq;
reg [31:0] CNT_SOUND;

integer CLK_COUNT;
integer scale;


assign SONG = BUFF;


always @( posedge CLK_1MHZ)
begin
	case(scale)
		0: freq = 1012;	 //시  1.5초
		1:	freq = 1516;	 //미  0.5초
		2:	freq = 955;		 //높은 도 //0.5초
		3: freq = 1012;	 //시 1초
		4: freq = 1136;	 //라 0.5초
		5: freq = 1275;	 //솔 0.5초
		6: freq = 1012;	 //시 1초
		7: freq = 0;	    //쉼 0.5초
		8: freq = 1607;	 //레# 0.5초
		9: freq = 955;		 //높은 도 0.5초	 
		10: freq = 1012;	 //시 1초
		11: freq = 1136;	 //라 0.5초
		12: freq = 1275;	 //솔 0.5초
		13: freq = 1012;	 //시 2초
		14: freq = 716;	 //높은 파 1.5초
		15: freq = 758;	 //높은 미 0.5초
		16: freq = 1012;	 //시  2초
		17: freq = 0;	 	 //쉼  0.5초
		18: freq = 1516;	 //미  0.5초
		19: freq = 1431;	 //파  0.5초
		20: freq = 1275;	 //솔  0.5초
		21: freq = 1012;	 //시  0.5초
		22: freq = 1136;	 //라  1초
		23: freq = 1204;	 //솔#  0.5초
		24: freq = 1136;	 //라  1초
		25: freq = 0;	 //쉼 0.5초
		26: freq = 1516;	 //미 0.5초
		27: freq = 758;	 //높은 미 0.5초
		28: freq = 851;	 //높은 레 1초
		29: freq = 902;	 //높은 도# 0.5초
		30: freq = 851;	 //높은 레 1초
		31: freq = 0;	 //쉼 0.5초
		32: freq = 1275;	 //솔 0.5초
		33: freq = 851;	 //높은 레 0.5초
		34: freq = 955;	 //높은 도 1초
		35: freq = 1012;	 // 시 0.5초
		36: freq = 955;	 //높은 도 1.5초
		37: freq = 1012;	 // 시 0.5초
		38: freq = 1136;	 //라 2초
		39: freq = 0;	 	 //쉼 1초
		40: freq = 1012;	 //시  1.5초
		41: freq = 1516;	 //미  0.5초
		42: freq = 955;	 //높은 도 //0.5초
		43: freq = 1012;	 //시 1초
		44: freq = 1136;	 //라 0.5초
		45: freq = 1275;	 //솔 0.5초
		46: freq = 1012;	 //시 1초
		47: freq = 0;	    //쉼 0.5초
		48: freq = 1607;	 //레# 0.5초
		49: freq = 955;	//높은 도 0.5초	 
		50: freq = 1012;	 //시 1초
		51: freq = 1136;	 //라 0.5초
		52: freq = 1275;	 //솔 0.5초
		53: freq = 1012;	 //시 2초
		54: freq = 716;	 //높은 파 1.5초
		55: freq = 758;	 //높은 미 0.5초
		56: freq = 1012;	 //시  2초
		57: freq = 0;	 	 //쉼  0.5초
		58: freq = 1516;	 //미  0.5초
		59: freq = 1431;	 //파  0.5초
		60: freq = 1275;	 //솔  0.5초
		61: freq = 1012;	 //시  0.5초
		62: freq = 1136;	 //라  1초
		63: freq = 1204;	 //솔#  0.5초
		64: freq = 1136;	 //라  1초
		65: freq = 0;	 //쉼 0.5초
		66: freq = 1516;	 //미 0.5초
		67: freq = 758;	 //높은 미 0.5초
		68: freq = 851;	 //높은 레 1초
		69: freq = 902;	 //높은 도# 0.5초
		70: freq = 851;	 //높은 레 1초
		71: freq = 0;	 //쉼 0.5초
		72: freq = 1275;	 //솔 0.5초
		73: freq = 851;	 //높은 레 0.5초
		74: freq = 955;	 //높은 도 1초
		75: freq = 1012;	 //시 0.5초
		76: freq = 1136;	 //라 1.5초
		77: freq = 1275;	 //솔 0.5초
		78: freq = 1275;	 //솔 2초
		79: freq = 0;      // 쉼 1초
		
		default: freq = 0;
	endcase
end

always @(negedge RESETN or posedge CLK_1MHZ)
begin
	if(RESETN==1'b0)
		begin
				scale = 0;
				BUFF = 0;
				CNT_SOUND = 0;
				CLK_COUNT = 0;
		end
	else
		begin
			if(A==1 || T==1)        //노래 틀 도래미파솔라시도
				begin
					if( scale == 1|| scale == 2|| scale == 4|| scale == 5 || scale == 7 ||
						 scale == 8|| scale == 9|| scale == 11|| scale == 12|| scale == 15||
						 scale == 17|| scale == 18|| scale == 19|| scale == 20|| scale == 21||
						 scale ==23|| scale ==25|| scale == 26|| scale == 27|| scale == 29||
						 scale ==31|| scale ==32|| scale ==33|| scale ==35 || scale ==37 ||
						 scale ==41|| scale ==42|| scale == 44|| scale == 45|| scale == 47||
						 scale == 48|| scale == 49|| scale == 51|| scale == 52|| scale == 55||
						 scale ==57|| scale ==58|| scale == 59|| scale == 60|| scale == 61||
						 scale ==63|| scale ==65|| scale == 66|| scale == 67|| scale == 69||
						 scale ==71|| scale ==72|| scale == 73|| scale == 75 )
						 begin
								if( (CLK_COUNT < 250000) )        // 0.5초 이하
									begin
										if(CNT_SOUND >= freq)  // freq 보다 크다
											begin
												CNT_SOUND = 0;  // 0으로 초기화
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq보다 작다
											begin
												CNT_SOUND =CNT_SOUND +1; // 1씩 증가
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //0.5초 이상
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;	
										scale = scale + 1;
									end
						end
					else if(scale == 3|| scale == 6|| scale ==10|| scale ==22 || scale ==24 ||
						 scale ==28|| scale ==30|| scale == 34|| scale == 39|| scale == 43||
						 scale == 46|| scale == 50|| scale == 62|| scale == 64|| scale == 70||
						 scale ==74|| scale ==77|| scale == 79)
							begin
								if( (CLK_COUNT < 500000) )        // 1초 이하
									begin
										if(CNT_SOUND >= freq)  // freq 보다 크다
											begin
												CNT_SOUND = 0;  // 0으로 초기화
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq보다 작다
											begin
												CNT_SOUND =CNT_SOUND +1; // 1씩 증가
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //1초 이상
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;
										scale = scale + 1;
									end
							end	
					
					
					else if(scale == 0|| scale ==14|| scale ==36|| scale ==40 || scale ==54 ||
						 scale ==76)
						 begin
								if( (CLK_COUNT < 750000) )        // 1.5초 이하
									begin
										if(CNT_SOUND >= freq)  // freq 보다 크다
											begin
												CNT_SOUND = 0;  // 0으로 초기화
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq보다 작다
											begin
												CNT_SOUND =CNT_SOUND +1; // 1씩 증가
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //1.5초 이상
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;	
										scale = scale + 1;
									end
							end
					
					else if(scale == 13|| scale ==16|| scale ==38|| scale ==53 || scale ==56 ||
						 scale ==78)
						 begin
								if( (CLK_COUNT < 1500000) )        // 2초 이하
									begin
										if(CNT_SOUND >= freq)  // freq 보다 크다
											begin
												CNT_SOUND = 0;  // 0으로 초기화
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq보다 작다
											begin
												CNT_SOUND =CNT_SOUND +1; // 1씩 증가
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //2초 이상
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;	
										scale = scale + 1;
									end
						 end
					
				
					else      //scale 은 80 이상일때 
						begin
							scale = 80;
							BUFF  = 0;
							CNT_SOUND = 0;
							CLK_COUNT = 0;
						end
			end
			else // A||T = 0 
				begin
					scale = 0;
					BUFF  = 0;
					CNT_SOUND = 0;
					CLK_COUNT = 0;
				end
		end
end










endmodule