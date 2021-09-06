module WORLD_TIME(
RESETN,CLK,HOUR,HOUR_W10,HOUR_W1,W_SELECT,W_COUNT);

input RESETN,CLK;
input [6:0]HOUR;
input W_SELECT;

output [3:0]HOUR_W10,HOUR_W1;
output [2:0]W_COUNT;

wire W_SELECT;
wire [3:0]HOUR_W10,HOUR_W1;
wire CLK;
wire [6:0]HOUR_W;
wire [6:0]HOUR;

wire W_EN ;
reg [2:0]W_COUNT;


always @(negedge RESETN or posedge CLK)
begin
	if (RESETN==1'b0)
			W_COUNT = 0;
	else
		begin
			if(W_EN==1)
				begin	
					if(W_COUNT >= 3'b011) //0 1 2 3 값만 가질수잇음
						W_COUNT = 0;
					else
						W_COUNT = W_COUNT + 1;
				end
			else
				W_COUNT = W_COUNT ;
		end 
end


//0 시드니 1베이징 2뉴욕 3런던
HOUR_W_TRANSFER W_HOUR(HOUR_W,HOUR,W_COUNT);
oneshot W_ENABLE(CLK,W_SELECT,W_EN);
WT_SEP_H H_SEP(HOUR_W,HOUR_W10,HOUR_W1); // H 두자리를 H10과 H1 로 나눔

endmodule