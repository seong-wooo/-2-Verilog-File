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
		0: freq = 1012;	 //��  1.5��
		1:	freq = 1516;	 //��  0.5��
		2:	freq = 955;		 //���� �� //0.5��
		3: freq = 1012;	 //�� 1��
		4: freq = 1136;	 //�� 0.5��
		5: freq = 1275;	 //�� 0.5��
		6: freq = 1012;	 //�� 1��
		7: freq = 0;	    //�� 0.5��
		8: freq = 1607;	 //��# 0.5��
		9: freq = 955;		 //���� �� 0.5��	 
		10: freq = 1012;	 //�� 1��
		11: freq = 1136;	 //�� 0.5��
		12: freq = 1275;	 //�� 0.5��
		13: freq = 1012;	 //�� 2��
		14: freq = 716;	 //���� �� 1.5��
		15: freq = 758;	 //���� �� 0.5��
		16: freq = 1012;	 //��  2��
		17: freq = 0;	 	 //��  0.5��
		18: freq = 1516;	 //��  0.5��
		19: freq = 1431;	 //��  0.5��
		20: freq = 1275;	 //��  0.5��
		21: freq = 1012;	 //��  0.5��
		22: freq = 1136;	 //��  1��
		23: freq = 1204;	 //��#  0.5��
		24: freq = 1136;	 //��  1��
		25: freq = 0;	 //�� 0.5��
		26: freq = 1516;	 //�� 0.5��
		27: freq = 758;	 //���� �� 0.5��
		28: freq = 851;	 //���� �� 1��
		29: freq = 902;	 //���� ��# 0.5��
		30: freq = 851;	 //���� �� 1��
		31: freq = 0;	 //�� 0.5��
		32: freq = 1275;	 //�� 0.5��
		33: freq = 851;	 //���� �� 0.5��
		34: freq = 955;	 //���� �� 1��
		35: freq = 1012;	 // �� 0.5��
		36: freq = 955;	 //���� �� 1.5��
		37: freq = 1012;	 // �� 0.5��
		38: freq = 1136;	 //�� 2��
		39: freq = 0;	 	 //�� 1��
		40: freq = 1012;	 //��  1.5��
		41: freq = 1516;	 //��  0.5��
		42: freq = 955;	 //���� �� //0.5��
		43: freq = 1012;	 //�� 1��
		44: freq = 1136;	 //�� 0.5��
		45: freq = 1275;	 //�� 0.5��
		46: freq = 1012;	 //�� 1��
		47: freq = 0;	    //�� 0.5��
		48: freq = 1607;	 //��# 0.5��
		49: freq = 955;	//���� �� 0.5��	 
		50: freq = 1012;	 //�� 1��
		51: freq = 1136;	 //�� 0.5��
		52: freq = 1275;	 //�� 0.5��
		53: freq = 1012;	 //�� 2��
		54: freq = 716;	 //���� �� 1.5��
		55: freq = 758;	 //���� �� 0.5��
		56: freq = 1012;	 //��  2��
		57: freq = 0;	 	 //��  0.5��
		58: freq = 1516;	 //��  0.5��
		59: freq = 1431;	 //��  0.5��
		60: freq = 1275;	 //��  0.5��
		61: freq = 1012;	 //��  0.5��
		62: freq = 1136;	 //��  1��
		63: freq = 1204;	 //��#  0.5��
		64: freq = 1136;	 //��  1��
		65: freq = 0;	 //�� 0.5��
		66: freq = 1516;	 //�� 0.5��
		67: freq = 758;	 //���� �� 0.5��
		68: freq = 851;	 //���� �� 1��
		69: freq = 902;	 //���� ��# 0.5��
		70: freq = 851;	 //���� �� 1��
		71: freq = 0;	 //�� 0.5��
		72: freq = 1275;	 //�� 0.5��
		73: freq = 851;	 //���� �� 0.5��
		74: freq = 955;	 //���� �� 1��
		75: freq = 1012;	 //�� 0.5��
		76: freq = 1136;	 //�� 1.5��
		77: freq = 1275;	 //�� 0.5��
		78: freq = 1275;	 //�� 2��
		79: freq = 0;      // �� 1��
		
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
			if(A==1 || T==1)        //�뷡 Ʋ �������ļֶ�õ�
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
								if( (CLK_COUNT < 250000) )        // 0.5�� ����
									begin
										if(CNT_SOUND >= freq)  // freq ���� ũ��
											begin
												CNT_SOUND = 0;  // 0���� �ʱ�ȭ
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq���� �۴�
											begin
												CNT_SOUND =CNT_SOUND +1; // 1�� ����
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //0.5�� �̻�
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
								if( (CLK_COUNT < 500000) )        // 1�� ����
									begin
										if(CNT_SOUND >= freq)  // freq ���� ũ��
											begin
												CNT_SOUND = 0;  // 0���� �ʱ�ȭ
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq���� �۴�
											begin
												CNT_SOUND =CNT_SOUND +1; // 1�� ����
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //1�� �̻�
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;
										scale = scale + 1;
									end
							end	
					
					
					else if(scale == 0|| scale ==14|| scale ==36|| scale ==40 || scale ==54 ||
						 scale ==76)
						 begin
								if( (CLK_COUNT < 750000) )        // 1.5�� ����
									begin
										if(CNT_SOUND >= freq)  // freq ���� ũ��
											begin
												CNT_SOUND = 0;  // 0���� �ʱ�ȭ
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq���� �۴�
											begin
												CNT_SOUND =CNT_SOUND +1; // 1�� ����
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //1.5�� �̻�
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;	
										scale = scale + 1;
									end
							end
					
					else if(scale == 13|| scale ==16|| scale ==38|| scale ==53 || scale ==56 ||
						 scale ==78)
						 begin
								if( (CLK_COUNT < 1500000) )        // 2�� ����
									begin
										if(CNT_SOUND >= freq)  // freq ���� ũ��
											begin
												CNT_SOUND = 0;  // 0���� �ʱ�ȭ
												BUFF = ~BUFF;					
												CLK_COUNT = CLK_COUNT+1; // 
											end				
										else  //freq���� �۴�
											begin
												CNT_SOUND =CNT_SOUND +1; // 1�� ����
												CLK_COUNT = CLK_COUNT+1;
											end
									end						
								else //2�� �̻�
									begin
										CLK_COUNT = 0;	
										CNT_SOUND = 0;	
										scale = scale + 1;
									end
						 end
					
				
					else      //scale �� 80 �̻��϶� 
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