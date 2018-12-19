module alu (
	input wire [17:0] s1,
	input wire [17:0] s2,
	input wire [3:0] flags,
	input wire [2:0] op,
	output reg [17:0] res,
	output reg [3:0] new_flags
);

parameter ALU_AND = 0;
parameter ALU_OR = 1;
parameter ALU_XOR = 2;
parameter ALU_SETHI = 3;
parameter ALU_ADD = 4;
parameter ALU_SUB = 5;
parameter ALU_ADDC = 6;
parameter ALU_SUBC = 7;

reg z, c, o, s;
reg ic, is_add;
reg [17:0] is2;

always @(*) begin
	res = 18'hxxxxx;
	is_add = 0;
	is2 = 18'hxxxxx;
	ic = 1'bx;
	case (op)
		ALU_AND:
			res = s1 & s2;
		ALU_OR:
			res = s1 | s2;
		ALU_XOR:
			res = s1 ^ s2;
		ALU_SETHI:
			res = {s2[17:9], s1[8:0]};
		ALU_ADD: begin
			is_add = 1;
			is2 = s2;
			ic = 0;
		end
		ALU_ADDC: begin
			is_add = 1;
			is2 = s2;
			ic = flags[3];
		end
		ALU_SUB: begin
			// a - b == a + ~b + 1
			is_add = 1;
			is2 = ~s2;
			ic = 1;
		end
		ALU_SUBC: begin
			is_add = 1;
			is2 = ~s2;
			ic = flags[3];
		end
	endcase
	if (is_add) begin
		{c, res} = {1'b0, s1} + is2 + ic;
		o = (s1[17] == is2[17]) && (s1[17] != res[17]);
	end else begin
		c = 0;
		o = 0;
	end
	s = res[17];
	z = res == 0;
	new_flags = {c, o, s, z};
end

endmodule
