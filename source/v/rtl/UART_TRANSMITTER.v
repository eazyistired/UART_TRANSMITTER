module UART_TRANSMITTER (
	input clock_i, reset_n_i, data_write_i,
	input [7:0] data_i,
	input [5:0] data_buffer_full_thres_i,
	input [1:0] baudrate_select_i,
	output data_buffer_full_o,
	output uart_tx_o
);

wire [7:0] data;
wire fifo_empty, fifo_read;

FIFO dut_0 (
	.clock(clock_i),
	.reset_n(reset_n_i),
	.write_enable(data_write_i),
	.data_in(data_i),
	.full_thres(data_buffer_full_thres_i),
	.full(data_buffer_full_o),
	.data_out(data),
	.empty(fifo_empty),
	.read_enable(fifo_read)
);

wire tx_baud;
TX_BAUD_GEN dut_1 (
	.clock(clock_i),
	.reset_n(reset_n_i),
	.baudrate_select(baudrate_select_i),
	.tx_baud(tx_baud)
);

UART_TX dut_2 (
	.clock(clock_i),
	.reset_n(reset_n_i),
	.tx_start(~fifo_empty),
	.tx_baud(tx_baud),
	.data_in(data),
	.tx(uart_tx_o),
	.tx_done(fifo_read)
);

endmodule