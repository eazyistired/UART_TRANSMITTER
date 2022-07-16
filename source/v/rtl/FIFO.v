module FIFO (
	input clock, reset_n, write_enable, read_enable,
	input [7:0] data_in,
	input [5:0] full_thres,
	output [7:0] data_out,
	output reg empty, reg full 
);

// WRITE_PTR
reg wr_en_mem;
reg [4:0]write_ptr;
always@(posedge clock)
	write_ptr <= reset_n ? wr_en_mem ? write_ptr + 1 : write_ptr : 0;

// READ_PTR
reg rd_en_mem;
reg [4:0]read_ptr;
always@(posedge clock)
	read_ptr <= reset_n ? rd_en_mem ? read_ptr + 1 : read_ptr : 0;

//FIFO_COUNTER
reg [5:0] fifo_cnt;
always@(posedge clock) begin
	fifo_cnt <= reset_n ? fifo_cnt + (wr_en_mem ? 1 : 0) + (rd_en_mem ? -1 : 0) : 0;
end

// CONTROL
always@(*) begin
	empty = fifo_cnt == 0;
	full = fifo_cnt == full_thres;
	wr_en_mem = write_enable & ~full;
	rd_en_mem = read_enable & ~empty;
end

// RAM
reg [7:0] mem [0:31];
always@(posedge clock) begin
	mem[write_ptr] <= wr_en_mem ? data_in : mem[write_ptr];
end
	
assign data_out = mem[read_ptr];	
endmodule