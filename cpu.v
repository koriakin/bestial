module cpu(
	input wire [7:0] kd,
	input wire kv,
	output reg vwe,
	output reg [6:0] vwx,
	output reg [4:0] vwy,
	output reg [8:0] vwd,
	output wire [7:0] led,
	input wire clk
);

initial begin
	vwe = 0;
end

reg [7:0] state;
reg [10:0] pc;
reg [3:0] flags;

parameter STATE_BOOT = 8'h00;
parameter STATE_HALTED = 8'h01;
parameter STATE_FETCH = 8'h02;
parameter STATE_DECODE = 8'h03;
parameter STATE_EX_ALU = 8'h04;
parameter STATE_EX_SHIFT = 8'h05;
parameter STATE_EX_JUMP  = 8'h06;
parameter STATE_EX_READKBD = 8'h07;
parameter STATE_EX_PUTCHAR = 8'h08;

initial pc = 0;
initial state = STATE_BOOT;

reg [7:0] ignition;

initial ignition = 0;

always @(posedge clk) begin
	ignition = ignition << 1 | 1;
end

reg [17:0] code [0:1023];

reg [17:0] ir;

initial $readmemh("test.bin", code);

wire [3:0] d_rs1;
wire [3:0] d_rs2;
wire [3:0] d_rd;
wire [2:0] alu_op;
wire [1:0] shift_op;
wire [3:0] cond;
wire do_write, do_alu, do_shift, do_readkbd, do_putchar, do_jump;
wire jump_offset;
wire imm_s1, imm_s2;
wire [17:0] imm;

decode decode_inst (
	.ir(ir),
	.rs1(d_rs1),
	.rs2(d_rs2),
	.rd(d_rd),
	.imm_s1(imm_s1),
	.imm_s2(imm_s2),
	.imm(imm),
	.do_alu(do_alu),
	.do_shift(do_shift),
	.do_write(do_write),
	.do_readkbd(do_readkbd),
	.do_putchar(do_putchar),
	.do_jump(do_jump),
	.jump_offset(jump_offset),
	.cond(cond),
	.alu_op(alu_op),
	.shift_op(shift_op)
);

reg [17:0] s1;
reg [17:0] s2;

reg [17:0] regs [0:15];

wire [17:0] alu_res;
wire [3:0] alu_flags;

alu alu_inst (
	.s1(s1),
	.s2(s2),
	.flags(flags),
	.op(alu_op),
	.res(alu_res),
	.new_flags(alu_flags)
);

wire [17:0] shift_res;

shifter shifter_inst (
	.s1(s1),
	.s2(s2),
	.op(shift_op),
	.res(shift_res)
);

jc jc_inst (
	.cond(cond),
	.flags(flags),
	.out(jc_out)
);

always @(posedge clk) begin
	vwe <= 0;
	case (state)
		STATE_BOOT: begin
			if (ignition[7])
				state <= STATE_FETCH;
		end
		STATE_FETCH: begin
			ir <= code[pc];
			pc <= pc + 1;
			state <= STATE_DECODE;
		end
		STATE_DECODE: begin
			s1 <= imm_s1 ? imm : regs[d_rs1];
			s2 <= imm_s2 ? imm : regs[d_rs2];
			if (do_alu)
				state <= STATE_EX_ALU;
			else if (do_shift)
				state <= STATE_EX_SHIFT;
			else if (do_jump)
				state <= STATE_EX_JUMP;
			else if (do_putchar)
				state <= STATE_EX_PUTCHAR;
			else if (do_readkbd)
				state <= STATE_EX_READKBD;
			else
				state <= STATE_HALTED;
		end
		STATE_EX_ALU: begin
			if (do_write)
				regs[d_rd] <= alu_res;
			flags <= alu_flags;
			state <= STATE_FETCH;
		end
		STATE_EX_SHIFT: begin
			regs[d_rd] <= shift_res;
			state <= STATE_FETCH;
		end
		STATE_EX_JUMP: begin
			if (jc_out) begin
				pc <= jump_offset ? s1 + imm : imm;
				if (do_write)
					regs[d_rd] <= pc;
			end
			state <= STATE_FETCH;
		end
		STATE_EX_READKBD: begin
			if (kv) begin
				regs[d_rd] <= kd;
				state <= STATE_FETCH;
			end
		end
		STATE_EX_PUTCHAR: begin
			vwe <= 1;
			vwx <= regs[d_rd];
			vwy <= s1;
			vwd <= s2;
			state <= STATE_FETCH;
		end
	endcase
end

assign led = {pc, state[3:0]};

endmodule
