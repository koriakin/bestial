module cpu(
	input reg [7:0] kd,
	input reg kv,
	output reg vwe,
	output reg [6:0] vwx,
	output reg [4:0] vwy,
	output reg [8:0] vwd,
);

initial begin
	vwe = 0;
end

endmodule
