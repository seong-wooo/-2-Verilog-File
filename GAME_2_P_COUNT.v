module WT_SEP_PLAYER(
NUMBER,C,A,B);

input [6:0] NUMBER;
output [3:0]A,B,C;

reg [3:0]A,B,C;

always @(NUMBER)
begin
	if(NUMBER <=9)
		begin
			C=0;
			A=0;
			B=NUMBER[3:0];		
		end
	else if(NUMBER <=19)
		begin
			C=0;
			A=1;
			B=NUMBER -10;
		end
	else if(NUMBER <=29)
		begin
			C=0;
			A=2;
			B=NUMBER -20;
		end	
	else if(NUMBER <=39)
		begin
			C=0;
			A=3;
			B=NUMBER -30;
		end
	else if(NUMBER <=49)
		begin
			C=0;
			A=4;
			B=NUMBER -40;
		end
	else if(NUMBER <=59)
		begin
			C=0;
			A=5;
			B=NUMBER -50;
		end
	else if(NUMBER <=69)
		begin
			C=0;
			A=6;
			B=NUMBER -60;
		end
	else if(NUMBER <=79)
		begin
			C=0;
			A=7;
			B=NUMBER -70;
		end
	else if(NUMBER <=89)
		begin
			C=0;
			A=8;
			B=NUMBER -80;
		end
	else if(NUMBER <=99)
		begin
			C=0;
			A=9;
			B=NUMBER -90;
		end
	else if(NUMBER <=109)
		begin
			C=1;
			A=0;
			B=NUMBER -100;
		end
	else if(NUMBER <=119)
		begin
			C=1;
			A=1;
			B=NUMBER -110;
		end
	else if(NUMBER <=129)
		begin
			C=1;
			A=2;
			B=NUMBER -120;
		end
		
	else 
		begin
			A=0;
			B=0;
		end
end

endmodule
		
		