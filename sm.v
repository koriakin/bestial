module sm(
	input wire [7:0] kd,
	input wire kv,
	output reg vwe,
	output reg [6:0] vwx,
	output reg [4:0] vwy,
	output reg [8:0] vwd,
	output wire [7:0] led,
	input wire clk
);

reg [2:0] state;

initial state = 0;
initial vwe = 0;

assign led = state;

always @(posedge clk) begin
	case (state)
	0: begin
		if (kv) begin
			state <= 1;
			vwe <= 1;
			if (kd[7:4] < 10)
				vwd <= 9'h30 + kd[7:4];
			else
				vwd <= 9'h41 + kd[7:4] - 10;
		end
	end
	1: begin
		vwx <= vwx + 1;
		if (kd[3:0] < 10)
			vwd <= 9'h30 + kd[3:0];
		else
			vwd <= 9'h41 + kd[3:0] - 10;
		state <= 2;
	end
	2: begin
		vwx <= vwx + 1;
		if (vwx == 79) begin
			vwx <= 0;
			vwy <= vwy + 1;
			if (vwy == 24) begin
				vwy <= 0;
			end
		end
		state <= 0;
		vwe <= 0;
	end
	endcase
end

endmodule
