module jc (
	input wire [3:0] cond,
	input wire [3:0] flags,
	output reg out
);

wire c, o, s, z;

assign {c, o, s, z} = flags;

reg tmp;

always @(*) begin
	tmp = 0;
	case (cond[3:1])
		3'b000: tmp = z;
		3'b001: tmp = s;
		3'b010: tmp = o;
		3'b011: tmp = c;
		3'b100: tmp = s ^ o; // L
		3'b101: tmp = !(s ^ o) && !z; // G
		3'b110: tmp = (c && !z); // A
		3'b111: tmp = 1;
	endcase
	out = tmp ^ cond[0];
end

endmodule

