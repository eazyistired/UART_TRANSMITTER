module TX_BAUD_GEN (
	input clock,
	input reset_n,
	input [1:0] baudrate_select,
	output tx_baud
);

reg [7:0] num;
reg w;
always@(posedge clock)
	num <= reset_n ? w ? 0 : num + 1 : 0;

always@(*)
case (baudrate_select)
	0: w = num[4];
	1: w = num[5];
	2: w = num[6];
	3: w = num[7];
	default: w = 1;
endcase

assign tx_baud = reset_n & w;

endmodule