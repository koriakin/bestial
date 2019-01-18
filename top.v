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

wire [12:0] vga_wraddr;
wire [8:0] vga_wrdata;
wire vga_wrvalid;
wire vga_wrready;

wire [12:0] led_wraddr;
wire [8:0] led_wrdata;
wire led_wrvalid;
wire led_wrready;

wire [16:0] cpu_wraddr;
wire [8:0] cpu_wrdata;
wire cpu_wrvalid;
wire cpu_wrready;

vga vga_inst (
	.HS(HSYNC),
	.VS(VSYNC),
	.R(OutRed),
	.G(OutGreen),
	.B(OutBlue),
	.bus_wraddr(vga_wraddr),
	.bus_wrdata(vga_wrdata),
	.bus_wrvalid(vga_wrvalid),
	.bus_wrready(vga_wrready),
	.clk(vclk)
);

cpu cpu_inst (
	.kd(kd),
	.kv(kv),
	.bus_wraddr(cpu_wraddr),
	.bus_wrdata(cpu_wrdata),
	.bus_wrvalid(cpu_wrvalid),
	.bus_wrready(cpu_wrready),
	.clk(vclk)
);

led led_inst (
	.bus_wraddr(led_wraddr),
	.bus_wrdata(led_wrdata),
	.bus_wrvalid(led_wrvalid),
	.bus_wrready(led_wrready),
	.out(Led),
	.clk(vclk)
);

wrswitch wrswitch_inst (
	.m_wraddr(cpu_wraddr),
	.m_wrdata(cpu_wrdata),
	.m_wrvalid(cpu_wrvalid),
	.m_wrready(cpu_wrready),
	.s0_wraddr(vga_wraddr),
	.s0_wrdata(vga_wrdata),
	.s0_wrvalid(vga_wrvalid),
	.s0_wrready(vga_wrready),
	.s2_wraddr(led_wraddr),
	.s2_wrdata(led_wrdata),
	.s2_wrvalid(led_wrvalid),
	.s2_wrready(led_wrready),
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
