module alu #(parameter WIDTH = 4)(output [WIDTH - 1:0] out, input [WIDTH - 1:0] a, b, input cin);
assign out = a + b + cin;
endmodule

module booth_multiplier #(
	parameter WIDTH = 4)(output wire [2*WIDTH - 1:0] product, input [WIDTH - 1:0] Multiplier, Multiplicand, input clk, start, output finish, output reg[2*WIDTH - 1:0] clock_count);

reg [WIDTH - 1:0] A;
reg [WIDTH - 1:0] M;
reg [WIDTH - 1:0] Q;
reg Q1;
integer count;
wire [WIDTH - 1:0] sum, diff;
always@(posedge clk)
begin
	if(start)
	begin
        	A <= 0;
        	Q1 <= 0;
        	M <= Multiplicand;
        	Q <= Multiplier;
		clock_count <= 1;
		count = WIDTH;
	end
	else if(!finish)
	//else
	begin
		clock_count <= clock_count + 1;
		case({Q[0], Q1})
			2'b01: {A, Q, Q1} <= {sum[WIDTH - 1], sum[WIDTH - 1:0], Q[WIDTH - 1:0]};
			2'b10: {A, Q, Q1} <= {diff[WIDTH - 1], diff[WIDTH - 1:0], Q[WIDTH - 1:0]};
			default: {A, Q, Q1} <= {A[WIDTH - 1], A, Q};
		endcase
		count = count - 1;
	end
end

alu #(.WIDTH(WIDTH))adder(sum, A, M, 1'b0);
alu #(.WIDTH(WIDTH))subtractor(diff, A, ~M, 1'b1);

assign product = {A, Q};
assign finish = (count == 0) ? 1 : 0;

endmodule

