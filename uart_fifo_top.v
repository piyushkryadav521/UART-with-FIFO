module uart_fifo_top(
    input clk,
    input rst,
    input rx_serial,
    output tx_serial
);

wire [7:0] rx_data;
wire rx_done;
wire [7:0] fifo_out;
wire fifo_empty;

uart_rx rx (
    .clk(clk),
    .rst(rst),
    .rx_serial(rx_serial),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

fifo f (
    .clk(clk),
    .rst(rst),
    .wr_en(rx_done),
    .rd_en(!fifo_empty),
    .data_in(rx_data),
    .data_out(fifo_out),
    .full(),
    .empty(fifo_empty)
);

uart_tx tx (
    .clk(clk),
    .rst(rst),
    .tx_start(!fifo_empty),
    .tx_data(fifo_out),
    .tx_serial(tx_serial),
    .tx_done()
);

endmodule