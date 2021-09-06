module WT_SEP_M(
NUMBER,A,B);

input [6:0] NUMBER;
output [3:0]A,B;

reg [3:0]A,B;

always @(NUMBER)
begin
	if(NUMBER <=9)
		begin
			A=0;
			B=NUMBER[3:0];
		end
	else if(NUMBER <=19)
		begin
			A=1;
			B=NUMBER -10;
		end
	else 
		begin
			A=0;
			B=0;
		end
end

endmodule
		
		