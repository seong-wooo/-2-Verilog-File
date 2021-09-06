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
			if(CLK_COUNT >= 1500)  // 1.5초 이상 
				begin
					SW_S_MODE =2'b00;       //  RESET 
				end
			else if ( (CLK_COUNT > 0) && (CLK_COUNT<1500) )	//눌렸는데1.5초 미만으로 눌렸을 때
				begin
					if(SW_S_MODE == 2'b00)   //RESET 상태였다면
							SW_S_MODE = 2'b01;      // START 
					else if(SW_S_MODE == 2'b01)    // 돌아가는중이었다면
							SW_S_MODE = 2'b10;        // 멈춤
					else if (SW_S_MODE == 2'b10)    // 멈춤상태였다면
						   SW_S_MODE = 2'b01;       //다시 돌아가게
					else 
						SW_S_MODE = 2'b00;
				end
			else
				SW_S_MODE = SW_S_MODE;      //CLK_COUNT = 0 이다 -> 아무것도 안눌림 그냥 원래대로 진행
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
					CLK_COUNT = CLK_COUNT + 1;     //스위치 누르고 있으면 CLK_COUNT 올라간다
				else
					CLK_COUNT = 0;                  // 안누르면 0
			end	
end



endmodule











