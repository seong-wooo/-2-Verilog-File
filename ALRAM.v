module ARALM (RESETN,CLK,
HOUR,MIN,U,D,COUNT,SW_A,M_A10,M_A1,H_A10,H_A1,ALR_ONOFF,s,OPTION);

input [3:0]OPTION;
input RESETN,CLK;
input SW_A,U,D;
input [3:0]COUNT;
input [6:0]HOUR,MIN;

output [3:0]M_A10,M_A1,H_A10,H_A1;
output ALR_ONOFF;
output s;

wire RESETN,CLK;
wire [6:0]HOUR_A,MIN_A;
wire U,D;
wire [3:0]COUNT;
wire [3:0]OPTION;

reg SW_A_EN,SW_A_LAST,ALR_ONOFF;
reg s;
 

parameter ON = 1 , OFF = 0;

always @(posedge CLK) 
begin
	SW_A_LAST <= SW_A;
	SW_A_EN <= SW_A & ~SW_A_LAST;
end


always @(negedge RESETN or posedge CLK)
begin
	if(RESETN==1'b0)
		begin
			ALR_ONOFF = OFF;
		end
		
	else
		begin
			if(ALR_ONOFF == OFF) //�˶� OFF 
				begin
					if(SW_A_EN == 1)   // ����ġ ������
						begin 
							ALR_ONOFF = ON;  // Ŵ
 						end
					else
						ALR_ONOFF = OFF; //�ȴ����� ��
				end
			else                  //�˶� ON 
				begin
					if(SW_A_EN == 1)    // ����ġ ������ 
						ALR_ONOFF = OFF;     // ���� 
					else
						ALR_ONOFF = ON;     
				end
		end
end


always @(negedge RESETN or posedge CLK)
begin
	if(RESETN==1'b0)
		 s<=0;
	else
		begin
			if (ALR_ONOFF == ON)        //�˶� ���������� 
				begin
					if( (HOUR_A	== HOUR) && (MIN_A == MIN) )    // �����ð��� ������
						begin
							s<=1;                   //START ( �뷡)
						end
					else  
						 s<=0;                   //  START ���� 
				end
			else                             // �˶�������
				begin
					s<=0;                    //START ���� -> �뷡 ����
				end
		end
end

ALARM_SET ALR_SET(RESETN,CLK,HOUR_A,MIN_A,U,D,COUNT,OPTION);
WT_SEP_SM M_A_SEP(MIN_A,M_A10,M_A1); // M ���ڸ��� M10�� M1 �� ���� �˶�
WT_SEP_H H_A_SEP(HOUR_A,H_A10,H_A1); // H ���ڸ��� H10�� H1 �� ���� �˶�

endmodule