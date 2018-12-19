module test_cpu;

reg clk;

cpu cpu_inst(
	.kv(1),
	.kd(8'h12),
	.clk(clk)
);

integer i;

initial begin
	for (i = 0; i < 100; i = i + 1) begin
		clk = 0;
		#13;
		clk = 1;
		#13;
		$display(cpu_inst.pc, " ", cpu_inst.state, " ", cpu_inst.alu_op, " ", cpu_inst.do_alu,
			" ", cpu_inst.regs[0],
			" ", cpu_inst.regs[1],
			" ", cpu_inst.regs[2],
			" ", cpu_inst.regs[3],
			" ", cpu_inst.regs[4],
			" ", cpu_inst.regs[5],
			" ", cpu_inst.regs[6],
			" ", cpu_inst.regs[7],
			" ", cpu_inst.regs[8],
			" ", cpu_inst.regs[9],
			" ", cpu_inst.regs[10],
			" ", cpu_inst.regs[11],
			" ", cpu_inst.regs[12],
			" ", cpu_inst.regs[13],
			" ", cpu_inst.regs[14],
			" ", cpu_inst.regs[15]
		);
	end
	$finish;
end

endmodule
