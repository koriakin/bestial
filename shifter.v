module shifter (
	input wire [17:0] s1,
	input wire [17:0] s2,
	input wire [1:0] op,
	output reg [17:0] res
);

parameter SHIFT_SHL = 0;
parameter SHIFT_SHR = 2;
parameter SHIFT_SAR = 3;

reg [17:0] tmp;

always @(*) begin
	res = 18'hxxxxx;
	case (op)
		SHIFT_SHL:
			res = s1 << s2;
		SHIFT_SHR:
			res = s1 >> s2;
		SHIFT_SAR: begin
			tmp = {18{s1[17]}};
			res = s1 >> s2 | (tmp & ~(18'h3ffff >> s2));
		end
	endcase
end

endmodule
