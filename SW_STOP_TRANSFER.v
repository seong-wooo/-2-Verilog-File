module SW_TRANSFER(RESETN,CLK,SW_S,SW_S_MODE);

input RESETN,CLK;
input SW_S;

output [1:0]SW_S_MODE;

reg [1:0]SW_S_MODE;

integer CLK_COUNT;

always @(negedge RESETN or posedge CLK)
begin
	if(~RESETN)
		begin
			SW_S_MODE = 0;
		end
	else
		begin
			if(CLK_COUNT >= 1500)  // 1.5�� �̻� 
				begin
					SW_S_MODE =2'b00;       //  RESET 
				end
			else if ( (CLK_COUNT > 0) && (CLK_COUNT<1500) )	//���ȴµ�1.5�� �̸����� ������ ��
				begin
					if(SW_S_MODE == 2'b00)   //RESET ���¿��ٸ�
							SW_S_MODE = 2'b01;      // START 
					else if(SW_S_MODE == 2'b01)    // ���ư������̾��ٸ�
							SW_S_MODE = 2'b10;        // ����
					else if (SW_S_MODE == 2'b10)    // ������¿��ٸ�
						   SW_S_MODE = 2'b01;       //�ٽ� ���ư���
					else 
						SW_S_MODE = 2'b00;
				end
			else
				SW_S_MODE = SW_S_MODE;      //CLK_COUNT = 0 �̴� -> �ƹ��͵� �ȴ��� �׳� ������� ����
		end
		
end	

always @(negedge RESETN or posedge CLK)
begin
		if(~RESETN)
			begin
				CLK_COUNT =  0; 
			end
		else 
			begin
				if(SW_S == 1)
					CLK_COUNT = CLK_COUNT + 1;     //����ġ ������ ������ CLK_COUNT �ö󰣴�
				else
					CLK_COUNT = 0;                  // �ȴ����� 0
			end	
end



endmodule











