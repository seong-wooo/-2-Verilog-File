module STOP_WATCH(RESETN,CLK,MIN_S10,MIN_S1,SEC_S10,SEC_S1,SW_S);
	
input RESETN,CLK;
input SW_S;

output [3:0]MIN_S10,MIN_S1,SEC_S10,SEC_S1;

reg [6:0]MIN_S,SEC_S;
reg [1:0]S;


wire [3:0]MIN_S10,MIN_S1,SEC_S10,SEC_S1;
wire SW_S;
wire [1:0]SW_S_MODE;
wire RESETN,CLK;

integer CNT;


always @(negedge RESETN or posedge CLK)
begin
   if(~RESETN)
      CNT = 0;
   else
      begin
			if(SW_S_MODE == 2'b00)     // ���»���
				CNT = 0;
			else if(SW_S_MODE == 2'b01) // �������	
				begin
					if(CNT>=999) //1�ʸ��� CNT ����
						CNT = 0;
					else
						CNT = CNT+1;
				end
			else if(SW_S_MODE == 2'b10) // �������
				CNT = CNT ;   //CNT ���� 
			else 
				CNT = 0;      //?? ����  CNT = 0;
      end
end


always @ (negedge RESETN or posedge CLK)
begin
	if(~RESETN)
		begin
			SEC_S = 0;
		end
	else
		begin
			if(SW_S_MODE == 2'b00)        //���»���
					SEC_S = 0;							
			else if(SW_S_MODE == 2'b01)    //ī��Ʈ �������
				begin
					if( CNT==999 ) // 1�� ��������
					begin
						if(SEC_S >= 59) // SEC�� 59���� ũ�� ����
							SEC_S=0;
					else
						SEC_S = SEC_S + 1; // SEC 1�ʿ� 1���� ����
					end
				end
				
			else if(SW_S_MODE == 2'b10)    //STOP ����
					SEC_S = SEC_S;     //����
			else
				SEC_S = 0; 
		end
end

         
always @(negedge RESETN or posedge CLK)
begin
   if(~RESETN)
      MIN_S=0;
   else
		begin
			if(SW_S_MODE == 2'b00)        //���»���
					MIN_S = 0;							
			else if(SW_S_MODE == 2'b01)    //ī��Ʈ �������
				begin
					if( (CNT == 999) && (SEC_S == 59) ) // 1�� ��������
					begin
						if(MIN_S >= 59) // MIN�� 59���� ũ�� ����
							MIN_S=0;
					else
						MIN_S = MIN_S + 1; // MIN_S 1�п� 1���� ����
					end
				end				
			else if(SW_S_MODE == 2'b10)    //STOP ����
				begin
					MIN_S = MIN_S;     //����
				end
			else
				MIN_S  = 0; 
		end
end
	
SW_TRANSFER sw(RESETN,CLK,SW_S,SW_S_MODE);


WT_SEP_SM S_S_SEP(SEC_S,SEC_S10,SEC_S1); 
WT_SEP_SM S_M_SEP(MIN_S,MIN_S10,MIN_S1); 
endmodule