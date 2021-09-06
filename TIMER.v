module TIEMR( 
RESETN,CLK,U,D,COUNT,SW_T,S_T10,S_T1,M_T10,M_T1,S,OPTION);

input [3:0]OPTION;
input RESETN,CLK;
input SW_T,U,D;
input [3:0]COUNT;

output [3:0]S_T10,S_T1,M_T10,M_T1;
output S;

wire U,D,SW_T;
wire [3:0]COUNT;
wire SW_T_EN,U_EN ,D_EN;
wire RESETN,CLK;
wire TIMER_ONOFF;

reg [6:0]MIN_A,SEC_A;
reg S;

integer CNT1;

parameter ON =1 , OFF = 0;


always @(negedge RESETN or posedge CLK)
begin
	if(RESETN==1'b0)
		 S<=0;
	else
		begin
			if (TIMER_ONOFF == ON)        //Ÿ�̸� ���������� 
				begin
					if( (MIN_A	== 0) && (SEC_A == 0) )    // �����ð� == 0
						begin
							S<=1;                   //START ( �뷡)
						end
					else  
						 S<=0;                   //  START ���� 
				end
			else                             // Ÿ�̸Ӳ�����
				begin
					S<=0;                    //START ���� -> �뷡 ����
				end
		end
end





always @(negedge RESETN or posedge CLK )
begin
   if(RESETN==1'b0)
		begin
			SEC_A = 0;
			MIN_A = 0;
			CNT1 = 0;
			
		end
   else
		begin		
				if(TIMER_ONOFF == OFF)
					begin
						if( (U_EN&&COUNT==4'b0001)&&OPTION==4'b0010 ) 
								begin
									if(SEC_A >= 60 ) 
										SEC_A=0;
									else
										SEC_A = SEC_A + 1; 			
									end
						else if( (D_EN&&COUNT==4'b0001)&&OPTION==4'b0010 )
								begin
									if(SEC_A == 0)
										SEC_A = 59;
									else
										SEC_A = SEC_A - 1;   
								end
						
						else if( (U_EN&&COUNT==4'b0010)&&OPTION==4'b0010 )  
								begin
									if(MIN_A >= 59) 
										MIN_A=0;
									else
										MIN_A = MIN_A + 1; 			
									end
						else if((D_EN&&COUNT==4'b0010)&&OPTION==4'b0010)
								begin
									if(MIN_A == 0)
										MIN_A = 59;
									else
										MIN_A = MIN_A - 1;  
								end
						else
							begin
								SEC_A = SEC_A;
								MIN_A = MIN_A;
							end
				end
			
			else            //TIMER ON �� �� 
				begin
						if(CNT1 < 999)      // 1�� �ȵ����� 
							CNT1 = CNT1 + 1;    // CNT ++
							
						else                  //1�� ������
							begin
								if(MIN_A != 0 )       // 0���� �ƴϸ� 
									begin
										if(SEC_A != 0)         //  0�ʰ� �ƴҶ�
												begin
													SEC_A = SEC_A -1; 	// 59�� �ǰ�
													MIN_A = MIN_A ; 		// ���� �״�� ����
													CNT1 = 0;           // CNT �ٽ� 0�ȴ� 
												end
											else                 // 0�ʶ��
												begin   
													SEC_A =59;        // 59�ʰ� �ǰ�
													MIN_A =MIN_A -1;  // 1�� ����
													CNT1 = 0;     //CNT �ٽ� 0�ȴ�
												end
									end
								else      // 0�� �� ��
									begin
											if(SEC_A != 0)         //  0�ʰ� �ƴҶ�
													begin
														SEC_A = SEC_A -1; 	// -1
														MIN_A = MIN_A ; 		// ���� �״�� ����
														CNT1 = 0;           // CNT �ٽ� 0�ȴ� 
													end
												else                 // 0�ʶ��
													begin   
														SEC_A =0;        // 0
														MIN_A =0;  // 0
														CNT1 = 0;     //CNT 0
													end
									end
							end				
				end			
		end				
end


oneshot U_ENABLE(CLK,U,U_EN);
oneshot D_ENABLE(CLK,D,D_EN);
oneshot SW_T_ENABLE(CLK,SW_T,SW_T_EN);
TIMER_ONOFF ONOFF(RESETN,CLK,TIMER_ONOFF,SW_T_EN);

WT_SEP_SM T_S_SEP(SEC_A,S_T10,S_T1); // S ���ڸ��� S10�� S1 �� ���� Ÿ�̸�
WT_SEP_SM T_M_SEP(MIN_A,M_T10,M_T1); // M ���ڸ��� M10�� M1 �� ���� Ÿ�̸�

endmodule