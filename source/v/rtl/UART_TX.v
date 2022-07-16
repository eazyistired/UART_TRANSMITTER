module UART_TX (
	input clock, reset_n, tx_start, tx_baud, 
	input [7:0] data_in,
	output reg tx_done, reg tx
); 

localparam STATE_IDLE = 2'b00;
localparam STATE_START = 2'b01;
localparam STATE_DATA = 2'b10;
localparam STATE_STOP = 2'b11;

reg [1:0] state, state_next;
always@(posedge clock)
	state <= reset_n ? state_next : STATE_IDLE;
	
reg [4:0] bit_counter;
always@(posedge clock)
	bit_counter <= tx_baud ? state == STATE_IDLE ? 0 : bit_counter + (state == STATE_DATA) : bit_counter;
	
always@(*) begin
	state_next = state;
	case (state)
		STATE_IDLE: state_next = tx_start & tx_baud ? STATE_START : STATE_IDLE;
		STATE_START: state_next = tx_baud ? STATE_DATA : STATE_START;
		STATE_DATA: state_next = bit_counter == 8 & tx_baud ? STATE_STOP : STATE_DATA;
		STATE_STOP: state_next = tx_baud ? STATE_IDLE : STATE_STOP;
	endcase
end

reg [8:0] aux;
always@(*) begin
	tx_done = 0;
	if (state == STATE_IDLE)
		tx = 1;
	else if (state == STATE_START)
		tx = 0;
	else if (state == STATE_DATA) begin
		aux = {^data_in, data_in};
		tx = aux[bit_counter];
		end
	else begin
		tx_done = tx_baud;
		tx = 1;
	end
end

endmodule