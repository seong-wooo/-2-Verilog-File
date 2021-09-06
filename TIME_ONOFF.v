module TIMER_ONOFF(RESETN,CLK,TIMER_ONOFF,SW_T_EN);

input RESETN,CLK,SW_T_EN;
output TIMER_ONOFF;
reg TIMER_ONOFF;

parameter ON =1 , OFF = 0;


always @(negedge RESETN or posedge CLK)
begin
	if(RESETN==1'b0)
		begin
			TIMER_ONOFF = OFF;
		end
		
	else
		begin
			if(TIMER_ONOFF == OFF)
				begin
					if(SW_T_EN == 1)
						begin
							TIMER_ONOFF = ON;
	
						end
					else
						TIMER_ONOFF = OFF;
				end
			else 
				begin
					if(SW_T_EN == 1)
						TIMER_ONOFF = OFF;
					else
						TIMER_ONOFF = ON;
				end

		end
end

endmodule