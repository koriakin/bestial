module sync #(
	parameter WIDTH = 1,
	parameter INIT = 0
) (
	input wire [WIDTH-1:0] I,
	input wire CLK,
	output reg [WIDTH-1:0] O
);

reg [WIDTH-1:0] tmpa;
reg [WIDTH-1:0] tmpb;

initial begin
	tmpa = INIT;
	tmpb = INIT;
	O = INIT;
end

always @(posedge CLK) begin
	tmpa <= I;
	tmpb <= tmpa;
	O <= tmpb;
end

endmodule
