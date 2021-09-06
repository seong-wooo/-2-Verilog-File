module oneshot(CLK,SW,SW_EN);
input SW,CLK;
output SW_EN;
reg SW_LAST,SW_EN;

always @(posedge CLK)
begin
	SW_LAST <= SW;
	SW_EN <= SW & ~SW_LAST;
end

endmodule