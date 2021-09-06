module PIEZO_reality_and_damedame(RESETN,CLK_1MHZ,A,T,SONG );

input RESETN,CLK_1MHZ,A,T;

output SONG;

reg SONG;

reg BUFF,BUFF2;
reg [10:0] freq,freq2;
reg [31:0] CNT_SOUND,CNT_SOUND2;

integer CLK_COUNT,CLK_COUNT2;
integer scale,scale2;

always @(*)
begin
if(A&&~T)
	SONG = BUFF;
else if(~A&&T)
	SONG = BUFF2;	
else 
	SONG =0;
	
end

always @( posedge CLK_1MHZ)
begin
	case(scale)
		-2: freq = 0;
		-1: freq = 0;
		0: freq = 1012;	 //시
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
		14: freq = 675;	 //높은 파 1.5초
		15: freq = 758;	 //높은 미 0.5초
		16: freq = 1012;	 //시  2초
		17: freq = 0;	 	 //쉼  0.5초
		18: freq = 1516;	 //미  0.5초
		19: freq = 1351;	 //파  0.5초
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
		54: freq = 675;	 //높은 파 1.5초
		55: freq = 758;	 //높은 미 0.5초
		56: freq = 1012;	 //시  2초
		57: freq = 0;	 	 //쉼  0.5초
		58: freq = 1516;	 //미  0.5초
		59: freq = 1351;	 //파  0.5초
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
	
	
	case(scale2)
		-2: freq2 = 0;
		-1: freq2 = 0;	 
		0: freq2 = 955;	 //높은 도 0.25
		1: freq2 = 851;	 //높은 레 0.25
		2: freq2 = 955;	 // 높은 도 0.25
		3: freq2 = 758;	 //높은 미 0.25
		4: freq2 = 758;	 //높은 미 0.25
		5: freq2 = 758;	 //높은 미 0.25
		6: freq2 = 758;	 //높은 미 0.25		
		7: freq2 = 758;	 //높은 미 0.25
		8: freq2 = 0;	 //쉼 0.25
		8: freq2 = 0;	 //쉼 0.25
		9: freq2 = 955;	 // 높은 도 0.25
		10: freq2 = 955;	 // 높은 도 0.25
		11: freq2 = 1012;	//시  
		12: freq2 = 1012;	//시  
		13: freq2 = 1012;	//시  
		14: freq2 = 1012;	//시  
		15: freq2 = 955;	 // 높은 도 
		16: freq2 = 955;	 // 높은 도 
		17: freq2 = 851;	 //높은 레 
		18: freq2 = 851;	 //높은 레 
		19: freq2 = 1136;	 //라 0.25
		20: freq2 = 1275;	 //솔 0.25
		21: freq2 = 1275;	 //솔 
		22: freq2 = 1275;	 //솔 
		23: freq2 = 1275;	 //솔 
		24: freq2 = 1275;	 //솔 
		25: freq2 = 1275;	 //솔 
		26: freq2 = 1275;	 //솔 
		27: freq2 = 0;	 //쉼 1
		28: freq2 = 0;	 //쉼 1
		29: freq2 = 0;	 //쉼 1
		30: freq2 = 0;	 //쉼 1
		31: freq2 = 1275;	 //솔 0.25
		32: freq2 = 1431;	 //파  0.25
		33: freq2 = 1516;	 //미  0.25
		34: freq2 = 1431;	 //파  0.25
		35: freq2 = 1431;	 //파  1
		36: freq2 = 1431;	 //파  1
		37: freq2 = 1431;	 //파  1
		38: freq2 = 1431;	 //파  1
		39: freq2 = 0;	 //쉼 0.5
		40: freq2 = 0;	 //쉼 0.5
		41: freq2 = 1136;	 //라 0.5
		42: freq2 = 1136;	 //라 0.5
		43: freq2 = 1012;	//시  1
		44: freq2 = 1012;	//시  1
		45: freq2 = 1012;	//시  1
		46: freq2= 1012;	//시  1
		47: freq2= 758;	 //높은 미 0.25
		48: freq2 = 758;	 //높은 미 0.25
		49: freq2 = 1012;	//시  1
		50: freq2 = 1012;	//시  1
		51: freq2 = 851;	 //높은 레 
		52:	freq2 = 955;	 // 높은 도
		53:	freq2 = 955;	 // 높은 도
		54:	freq2 = 955;	 // 높은 도
		55:	freq2 = 955;	 // 높은 도
		56:	freq2 = 955;	 // 높은 도
		57:	freq2 = 955;	 // 높은 도
		58:	freq2 = 955;	 // 높은 도
		59:	freq2 = 0;	 //쉼 0.5
		60:	freq2 = 0;	 //쉼 0.5
		61:	freq2 = 0;	 //쉼 0.5
		62:	freq2 = 0;	 //쉼 0.5
		63:	freq2 = 955;	 // 높은 도
		64:	freq2 = 851;	 //높은 레
		65:	freq2 = 955;	 // 높은 도
		66:	freq2 = 758;	 //높은 미 0.25
		67:	freq2 = 758;	 //높은 미 0.25
		68:	freq2 = 758;	 //높은 미 0.25
		69:	freq2 = 758;	 //높은 미 0.25
		70:	freq2 = 758;	 //높은 미 0.25
		71:	freq2 = 0;	 //쉼 0.5
		72:	freq2 = 0;	 //쉼 0.5
		73:	freq2 = 1136;	 //라 0.5
		74:	freq2 = 1012;	//시  1
		75:	freq2 = 955;	 // 높은 도
		76:	freq2 = 955;	 // 높은 도
		77:	freq2 = 955;	 // 높은 도
		78:	freq2 = 955;	 // 높은 도
		79:	freq2 = 851;	 //높은 레
		80:	freq2 = 851;	 //높은 레
		81:	freq2 = 851;	 //높은 레
		82:	freq2 = 851;	 //높은 레
		83:	freq2 = 1275;	 //솔 0.25
		84:	freq2 = 1275;	 //솔 0.25
		85:	freq2 = 851;	 //높은 레
		86:	freq2 = 851;	 //높은 레
		87:	freq2 = 955;	 // 높은 도
		88:	freq2 = 955;	 // 높은 도
		89:	freq2 = 955;	 // 높은 도
		90:	freq2 = 955;	 // 높은 도
		91:	freq2 = 955;	 // 높은 도
		92:	freq2 = 955;	 // 높은 도
		93:	freq2 = 0;	 //쉼 0.5
		94:	freq2 = 0;	 //쉼 0.5
		95:	freq2= 0;	 //쉼 0.5
		96:	freq2= 0;	 //쉼 0.5
		97:	freq2 = 1516;	 //미  0.25
		98:	freq2 = 1431;	 //파  0.25
		99:	freq2 = 1275;	 //솔 0.25
	100:	freq2 = 1431;	 //파  0.25
	101:	freq2 = 955;	 // 높은 도
	102:	freq2 = 955;	 // 높은 도
	103:	freq2 = 955;	 // 높은 도
	104:	freq2 = 955;	 // 높은 도
	105:	freq2 = 955;	 // 높은 도
	106:	freq2 = 955;	 // 높은 도
	107:	freq2 = 0;	 //쉼 0.5
	108:	freq2 = 0;	 //쉼 0.5
	109:	freq2 = 0;	 //쉼 0.5
	110:	freq2 = 0;	 //쉼 0.5
	111:	freq2 = 0;	 //쉼 0.5
	112:	freq2 = 0;	 //쉼 0.5
	113:	freq2 = 1516;	 //미  
	114:	freq2= 1431;	 //파  
	115:	freq2 = 1275;	 //솔 0.25
	116:	freq2 = 1431;	 //파  0.25
	117:	freq2 = 851;	 //높은 레
	118:	freq2 = 851;	 //높은 레
	119:	freq2 = 851;	 //높은 레
	120:	freq2 = 851;	 //높은 레
	121:	freq2 = 851;	 //높은 레
	122:	freq2 = 851;	 //높은 레
	123:	freq2 = 0;	 //쉼 0.5
	124:	freq2 = 0;	 //쉼 0.5
	125:	freq2 = 0;	 //쉼 0.5
	126:	freq2 = 0;	 //쉼 0.5
	127:	freq2 = 851;	 //높은 레
	128:	freq2 = 955;	 // 높은 도
	129:	freq2 = 1012;	//시  1
	130:	freq2= 955;	 // 높은 도
	
	default: freq = 0;
	endcase		
			
end

always @(negedge RESETN or posedge CLK_1MHZ)
begin
	if(RESETN==1'b0)
		begin
				scale = -2;
				BUFF = 0;
				CNT_SOUND = 0;
				CLK_COUNT = 0;
		end
	else
		begin
			if(A)
				begin
					if( scale== -2 || scale == -1||
						 scale == 1|| scale == 2|| scale == 4|| scale == 5 || scale == 7 ||
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
								if( (CLK_COUNT < 300000) )        // 0.5초 이하
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
						 scale == 46|| scale == 50|| scale == 62|| scale == 64|| scale == 68 ||scale == 70||
						 scale ==74|| scale ==77|| scale == 79)
							begin
								if( (CLK_COUNT < 600000) )        // 1초 이하
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
								if( (CLK_COUNT < 900000) )        // 1.5초 이하
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
								if( (CLK_COUNT < 1200000) )        // 2초 이하
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
							scale = -2;
							BUFF  = 0;
							CNT_SOUND = 0;
							CLK_COUNT = 0;
						end
				end
				
				else 
					begin
							scale = -2;
							BUFF  = 0;
							CNT_SOUND = 0;
							CLK_COUNT = 0;
					end
			end
end


always @(negedge RESETN or posedge CLK_1MHZ)
begin
	if(RESETN==1'b0)
		begin
				scale2= -2;
				BUFF2 = 0;
				CNT_SOUND2 = 0;
				CLK_COUNT2 = 0;
		end
	else
		begin	
			
			if(T)
				begin
					if(scale2 < 131) 
						begin
							if( (CLK_COUNT2 < 250000) )        
											begin
												if(CNT_SOUND2 >= freq2)  // freq2 보다 크다
													begin
														CNT_SOUND2 = 0;  // 0으로 초기화
														BUFF2 = ~BUFF2;					
														CLK_COUNT2 = CLK_COUNT2+1; // 
													end				
												else  //freq2보다 작다
													begin
														CNT_SOUND2 =CNT_SOUND2 +1; // 1씩 증가
														CLK_COUNT2 = CLK_COUNT2+1;
													end
												end						
							else // 지정된 초 이상
								begin
									CLK_COUNT2 = 0;	
									CNT_SOUND2 = 0;	
									scale2 = scale2 + 1;
								end
						end
						
						
					else
						begin
							CLK_COUNT2 = 0;	
							CNT_SOUND2 = 0;	
							scale2 = -2;
						end
				end
				
				else
					begin
						scale2= -2;
						BUFF2 = 0;
						CNT_SOUND2 = 0;
						CLK_COUNT2 = 0;
					end
	  end
end

endmodule