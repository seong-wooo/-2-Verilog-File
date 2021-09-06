module game1_1player(RESETN,CLK,
P_1,STATE_GAME,STATE3,G10,G1,P10,P1,LEVEL,COUNT1,COUNT2,COUNT_DOWN,P_1_2); //STATE_GAME�� ���� ����� OPTION


input RESETN,CLK;
input [1:0]P_1,P_1_2;
input [3:0]STATE_GAME; //0110
output [3:0] G10,G1,P10,P1;
output [2:0]STATE3;
output [3:0] LEVEL; 
output [31:0]COUNT1,COUNT2;
output [3:0]COUNT_DOWN;

wire [3:0]COUNT_DOWN;
wire [2:0]STATE3 ; //��ũ�� 
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



assign STATE3 = {ALL_CLEAR,LEVEL_FAIL,LEVEL_CLEAR};       //�ϴٰ� �ڵ� �����ϸ� STATE3 3��Ʈ�� ������ �����ϰ� �����ϱ�



always @(*)
begin
	if(LEVEL <= 5)
	LEVEL_COUNT = 10*LEVEL;
	else
	LEVEL_COUNT = 0;
end
	

// ��ư ����
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
			LEVEL_CLEAR = 1;     //�ʱ� 3 2 1 ȭ��
			LEVEL_FAIL = 0;             
			COUNT1 = 0;
			LEVEL = 1;	         //�ʱ� ���� 1
			ALL_CLEAR = 0;
		end
		
	else if(STATE_GAME != 4'b0110)	  //�ɼ��� 0110 �� �ƴ϶��
		begin			 
			LEVEL_CLEAR = 1;             // �׳� ���α�
			LEVEL_FAIL = 0;
			COUNT1 = 0;
			LEVEL = 1;	
			ALL_CLEAR = 0;
		end

			
	else                          //�ɼ���  0110�̶��
		begin
			if(ALL_CLEAR ==1)         //���� �ٲ��� �� 
				begin
					if(P_1[1] && P_1[0]&&P_1_2[0]&&P_1_2[1])	// �� ���� �� P_1[1] P_[0],P_1_2[0],P_1_2[1] 4����ư �� ������ �ٽ� ���ư�
					begin
						ALL_CLEAR  = 0; 
						LEVEL_CLEAR = 1;         //3 2 1 ȭ������ ���ư�
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
				if(LEVEL_FAIL == 1)            // ALLCLEAR == 0 ���� LEVEL_CLEAR  = 1 ; , LEVEL_FAIL  = 0;
					begin
						if(P_1[1] && P_1[0]&&P_1_2[0]&&P_1_2[1])            // fail ȭ�� �϶� ��ư �ΰ� ������ ���� �ٽ� ����
							begin
								LEVEL_FAIL = 0;					
								LEVEL_CLEAR = 1;         	  
							end
					end
						
				else  // ALL_CLEAR = 0 LEVEL FAIL = 0 LEVEL CLEAR = 1  
					begin
						if( (LEVEL_CLEAR==1) && (COUNT2 <= 3000) ) // Ŭ������ �� 3�� ����
								COUNT2 = COUNT2 +1 ;
						else if( (LEVEL_CLEAR==1) && (COUNT2 > 3000)  ) // 3�� ���� LEVEL_CLEAR �� 0�̵ȴ�
											begin
												COUNT2 = 0;
												LEVEL_CLEAR = 0;
											end
								
						else	  // ��Ŭ , ��Ŭ, ������ �� 0�� �� 		  	
							begin
										if(LEVEL <=5)   // LEVEL 5 ���� �̸�
										begin
														if( (COUNT1 <= 5000) && ( LEVEL_COUNT >  P_1_COUNT ) )  //5�ʺ��� ���� �� ���� ���Ѿ�ٸ�
															begin
																LEVEL_CLEAR = 0;  
																LEVEL_FAIL = 0;
																LEVEL = LEVEL;                               //��� �� �״��
 																COUNT1 = COUNT1 + 1;  //5���� ���Ѿ���
															end
														else if( (COUNT1 <= 5000)  && ( LEVEL_COUNT  <=  P_1_COUNT ) )     //5������ �Ѿ��
															begin
																if(LEVEL == 5)
																	LEVEL_CLEAR = 0;     
																else
																	LEVEL_CLEAR = 1;// 3 2 1 �߰� 
																LEVEL_FAIL = 0;
																LEVEL = LEVEL + 1;      // ���� ��
																COUNT1 = 0;  //5������ �Ѿ���
															end
														else 
															begin  
																LEVEL_CLEAR = 0;
																LEVEL_FAIL = 1;         //FAIL ��� ���� ~
																LEVEL = 1 ; 
																COUNT1 = 0;   //5�� ��  ���Ѿ���
															end
										end
															
										else   //LEVEL 6�̻�
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