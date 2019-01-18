module decode (
	input wire [17:0] ir,
	output reg [3:0] rs1,
	output reg [3:0] rs2,
	output reg [3:0] rd,
	output reg imm_s1,
	output reg imm_s2,
	output reg [17:0] imm,
	output reg do_alu,
	output reg do_shift,
	output reg do_write,
	output reg do_readkbd,
	output reg do_stb,
	output reg do_jump,
	output reg jump_offset,
	output reg [3:0] cond,
	output reg [2:0] alu_op,
	output reg [1:0] shift_op
);

parameter ALU_AND = 0;
parameter ALU_OR = 1;
parameter ALU_XOR = 2;
parameter ALU_SETHI = 3;
parameter ALU_ADD = 4;
parameter ALU_SUB = 5;
parameter ALU_ADDC = 6;
parameter ALU_SUBC = 7;

parameter SHIFT_SHL = 0;
parameter SHIFT_SHR = 2;
parameter SHIFT_SAR = 3;

always @(*) begin
	rd <= 4'hx;
	rs1 <= 4'hx;
	rs2 <= 4'hx;
	imm_s1 <= 1'bx;
	imm_s2 <= 1'bx;
	imm <= 18'hxxxxx;
	do_alu <= 0;
	do_shift <= 0;
	do_write <= 0;
	do_readkbd <= 0;
	do_stb <= 0;
	do_jump <= 0;
	jump_offset <= 1'bx;
	cond <= 4'bxxxx;
	alu_op <= 3'bxxx;
	shift_op <= 2'bxx;
	casex (ir[17:12])
		6'b000xxx: begin
			rd <= ir[3:0];
			rs1 <= ir[7:4];
			rs2 <= ir[11:8];
			do_write <= 1;
			imm_s1 <= 0;
			imm_s2 <= 0;
			do_alu <= 1;
			alu_op <= ir[14:12];
		end
		6'b001xxx: begin
			rd <= ir[3:0];
			rs1 <= ir[7:4];
			rs2 <= ir[11:8];
			do_write <= 1;
			imm_s1 <= 0;
			imm_s2 <= ir[14];
			imm <= ir[11:8];
			do_shift <= 1;
			shift_op <= ir[13:12];
		end
		6'b010010: begin
			rs1 <= ir[7:4];
			rs2 <= ir[3:0];
			imm_s1 <= 0;
			imm_s2 <= 1;
			imm <= ir[11:8];
			alu_op <= ALU_ADD;
			do_stb <= 1;
		end
		6'b011xxx: begin
			do_jump <= 1;
			jump_offset <= 0;
			cond <= ir[3:0];
			imm <= ir[14:4];
		end
		6'b100xxx: begin
			do_jump <= 1;
			do_write <= 1;
			jump_offset <= 0;
			rd <= ir[3:0];
			cond <= 4'he;
			imm <= ir[14:4];
		end
		6'b101xxx: begin
			do_jump <= 1;
			jump_offset <= 1;
			rs1 <= ir[3:0];
			cond <= 4'he;
			imm <= ir[14:4];
		end
		6'b11000x: begin
			// MOV a, i
			imm_s1 <= 1;
			imm_s2 <= 1;
			imm <= {{9{ir[12]}}, ir[12:4]};
			rd <= ir[3:0];
			do_alu <= 1;
			do_write <= 1;
			alu_op <= ALU_AND;
		end
		6'b11001x: begin
			// SETHI a, i
			rd <= ir[3:0];
			rs1 <= ir[3:0];
			do_alu <= 1;
			do_write <= 1;
			imm_s1 <= 0;
			imm_s2 <= 1;
			imm <= {ir[12:4], 9'hxxx};
			alu_op <= ALU_SETHI;
		end
		6'b11010x: begin
			// ADD a, a, i
			rd <= ir[3:0];
			rs1 <= ir[3:0];
			imm_s1 <= 0;
			imm_s2 <= 1;
			imm <= {{9{ir[12]}}, ir[12:4]};
			do_alu <= 1;
			do_write <= 1;
			alu_op <= ALU_ADD;
		end
		6'b11011x: begin
			// CMP a, i
			rs1 <= ir[3:0];
			imm_s1 <= 0;
			imm_s2 <= 1;
			imm <= {{9{ir[12]}}, ir[12:4]};
			do_alu <= 1;
			alu_op <= ALU_SUB;
		end
		6'b111110: begin
			rd <= ir[3:0];
			do_readkbd <= 1;
			do_write <= 1;
		end
	endcase
end

endmodule
