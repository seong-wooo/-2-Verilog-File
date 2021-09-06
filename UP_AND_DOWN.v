module up_down (CLK,COUNT_U,COUNT_D, COUNT);

input CLK,COUNT_U,COUNT_D; 
output [3:0]COUNT;

reg [3:0]COUNT;

wire U_EN,D_EN;

oneshot COUNT_U_ENABLE(CLK,COUNT_U,U_EN);
oneshot COUNT_D_ENABLE(CLK,COUNT_D,D_EN);

always @( posedge CLK)
begin
	if(U_EN && ~D_EN)  //���ΰ��
		begin
			if(COUNT == 4'b0011) 
					COUNT= 4'b0000;
			else
				COUNT = COUNT + 1;
		end
	else if(~U_EN && D_EN) //�ٿ��� ���
		begin
			if(COUNT == 4'b0000) 
					COUNT= 4'b0011;
			else
				COUNT = COUNT - 1;
		end
	else
		COUNT = COUNT ;
end

endmodule
