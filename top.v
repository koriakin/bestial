module top(
	output wire HSYNC,
	output wire VSYNC,
	output wire [2:0] OutRed,
	output wire [2:0] OutGreen,
	output wire [2:1] OutBlue,
	input wire uclk
);

wire vclk;

vga vga_inst (
	.HS(HSYNC),
	.VS(VSYNC),
	.R(OutRed),
	.G(OutGreen),
	.B(OutBlue),
	.clk(vclk)
);

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
