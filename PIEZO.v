module PIEZO(RESETN,CLK_1MHZ,A,T,SONG );

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
		0: freq = 1910;
		1: freq = 1702;
		2: freq = 1516;
		3: freq = 1431;
		4: freq = 1275;
		5: freq = 1136;
		6: freq = 1012;
		7: freq = 955;
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
					if( (CLK_COUNT < 500000) )        // 0.5�� ����
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
							if(scale == 7)
								scale = 0;
							else
								scale = scale + 1;
						end
				end
			else      //�뷡 ��Ʋ
				begin
					scale = 0;
					BUFF  = 0;
					CNT_SOUND = 0;
					CLK_COUNT = 0;
				end
		end
end

endmodule