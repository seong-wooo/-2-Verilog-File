module COUNTDOWN_game2(COUNT1,COUNT_DOWN,CLK,RESETN);

input CLK,RESETN;
input [31:0]COUNT1;
output [2:0]COUNT_DOWN;

reg [2:0]COUNT_DOWN;


always @(negedge RESETN or posedge CLK)
begin 
	if(RESETN ==1'b0)
		COUNT_DOWN = 0;
	else
		 begin
						if( COUNT1>0 && COUNT1 <999)  
									COUNT_DOWN = 3'b011; 		//3					
						else if( COUNT1>=1000 && COUNT1 <1999)  
									COUNT_DOWN = 3'b010; 	//2					
						else if( COUNT1>=2000 && COUNT1 <2999)  
										COUNT_DOWN = 3'b001; //1					
						else 
									COUNT_DOWN = 0;
		end
end


endmodule