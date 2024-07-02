module counter_16bit 
(
	input clk,
	input reset,
	output [15:0] o_Count
);

reg [15:0] ov_count_D;
reg [15:0] ov_count_Q;
assign o_Count= ov_count_Q;

always@(posedge clk, posedge reset)
begin
	if(i_Rst)
	begin
		ov_count_Q <= 16'd0;
	end
	else
	begin
		ov_count_Q <= ov_count_D;
	end
end

always@*
begin
	ov_count_D = ov_count_Q + 1'd1;
end
endmodule 
