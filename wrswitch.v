module wrswitch (
	input wire [16:0] m_wraddr,
	input wire [8:0] m_wrdata,
	input wire m_wrvalid,
	output wire m_wrready,
	output wire [12:0] s0_wraddr,
	output wire [8:0] s0_wrdata,
	output wire s0_wrvalid,
	input wire s0_wrready,
	output wire [12:0] s2_wraddr,
	output wire [8:0] s2_wrdata,
	output wire s2_wrvalid,
	input wire s2_wrready,
	input wire clk
);

reg buf_valid;
reg [3:0] buf_target;
reg [12:0] buf_wraddr;
reg [8:0] buf_wrdata;
initial buf_valid = 0;

assign s0_wraddr = buf_wraddr;
assign s2_wraddr = buf_wraddr;
assign s0_wrdata = buf_wrdata;
assign s2_wrdata = buf_wrdata;
assign s0_wrvalid = buf_valid && buf_target == 0;
assign s2_wrvalid = buf_valid && buf_target == 2;

reg s_ready;

assign m_wrready = !buf_valid || s_ready;

always @(*) begin
	case (buf_target)
		0: s_ready <= s0_wrready;
		2: s_ready <= s2_wrready;
		default: s_ready <= 1;
	endcase
end

always @(posedge clk) begin
	if (buf_valid && s_ready) begin
		buf_valid <= 0;
	end
	if (m_wrvalid && m_wrready) begin
		buf_target <= m_wraddr[16:13];
		buf_wraddr <= m_wraddr;
		buf_wrdata <= m_wrdata;
		buf_valid <= 1;
	end
end

endmodule
