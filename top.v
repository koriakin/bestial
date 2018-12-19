module top(
	input wire PS2C,
	input wire PS2D,
	output wire [7:0] Led,
	output wire HSYNC,
	output wire VSYNC,
	output wire [2:0] OutRed,
	output wire [2:0] OutGreen,
	output wire [2:1] OutBlue,
	input wire [7:0] sw,
	input wire [3:0] btn,
	input wire uclk
);

wire vclk;

wire [7:0] kd;
wire kv;

wire we;
wire [6:0] wx;
wire [4:0] wy;
wire [8:0] wd;

kbd kbd_inst (
	.PS2C(PS2C),
	.PS2D(PS2D),
	.kd(kd),
	.kv(kv),
	.clk(vclk)
);

vga vga_inst (
	.HS(HSYNC),
	.VS(VSYNC),
	.R(OutRed),
	.G(OutGreen),
	.B(OutBlue),
	.we(we),
	.wx(wx),
	.wy(wy),
	.wd(wd),
	.clk(vclk)
);

cpu cpu_inst (
	.kd(kd),
	.kv(kv),
	.vwe(we),
	.vwx(wx),
	.vwy(wy),
	.vwd(wd),
	.led(Led),
	.clk(vclk)
);

/*
assign vclk = btn[0];
assign kv = sw[0];
assign kd = 8'h12;
*/

DCM_SP #(
	.CLKFX_DIVIDE(26),
	.CLKFX_MULTIPLY(23),
	.CLKIN_PERIOD(31.25),
	.CLK_FEEDBACK("NONE"),
	.STARTUP_WAIT("TRUE")
) dcm_vclk (
	.CLKFX(vclk),
	.CLKIN(uclk)
);

endmodule
