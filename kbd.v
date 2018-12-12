module kbd(
	input wire PS2C,
	input wire PS2D,
	output reg [7:0] kd,
	output reg kv,
	input wire clk
);

wire PS2C_S, PS2D_S;

sync #(.INIT(1)) sync_ps2c(.I(PS2C), .O(PS2C_S), .CLK(clk));
sync sync_ps2d(.I(PS2D), .O(PS2D_S), .CLK(clk));

reg prev_clk;

initial prev_clk = 1;

reg [3:0] bitidx;
reg [10:0] recvbyte;

initial bitidx = 0;

always @(posedge clk) begin
	prev_clk <= PS2C_S;
	kv <= 0;
	if (PS2C_S == 1 && prev_clk == 0) begin
		recvbyte[bitidx] <= PS2D_S;
		if (bitidx == 10) begin
			bitidx <= 0;
			kd <= recvbyte[8:1];
			kv <= 1;
		end else begin
			bitidx <= bitidx + 1;
		end
	end
end

endmodule
