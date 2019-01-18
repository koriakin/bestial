module led(
	output reg [7:0] out,
	input wire [12:0] bus_wraddr,
	input wire [8:0] bus_wrdata,
	input wire bus_wrvalid,
	output wire bus_wrready,
	input wire clk
);

assign bus_wrready = 1;

always @(posedge clk) begin
	if (bus_wrvalid) begin
		case (bus_wraddr)
			0: out <= bus_wrdata;
			1: out <= out | bus_wrdata;
			2: out <= out & ~bus_wrdata;
			3: out <= out ^ bus_wrdata;
		endcase
	end
end

endmodule
