module TIMER_SET(
RESETN,CLK,MIN_A,SEC_A,U,D,COUNT);

input RESETN,CLK;
input U,D;
input [3:0]COUNT;
output [6:0]SEC_A,MIN_A;

reg U_EN ,D_EN,U_LAST,D_LAST;

reg[6:0] SEC_A,MIN_A;

always @(posedge CLK) 
begin
	U_LAST <= U;
	U_EN <= U & ~U_LAST;
	D_LAST <= D;
	D_EN <= D & ~D_LAST;
end

always @(negedge RESETN or posedge CLK )
begin
   if(RESETN==1'b0)
		begin
			SEC_A = 0;
			MIN_A = 0;
		end
   else
		begin		
				if( (U_EN&&COUNT==4'b0110) ) 
						begin
							if(SEC_A >= 60 ) 
								SEC_A=0;
							else
								SEC_A = SEC_A + 1; 			
							end
				else if( (D_EN&&COUNT==4'b0110) )
						begin
							if(SEC_A == 0)
								SEC_A = 59;
							else
								SEC_A = SEC_A - 1;   
						end
				
				else if( (U_EN&&COUNT==4'b0111) ) 
						begin
							if(MIN_A >= 59) 
								MIN_A=0;
							else
								MIN_A = MIN_A + 1; 			
							end
				else if((D_EN&&COUNT==4'b0111))
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
end
 
endmodule