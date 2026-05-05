module tb;

reg clk = 0;
reg rst = 1;
reg rx_serial = 1;
wire tx_serial;

uart_fifo_top uut (
    .clk(clk),
    .rst(rst),
    .rx_serial(rx_serial),
    .tx_serial(tx_serial)
);

always #5 clk = ~clk;

// Task to send 1 byte
task send_byte;
input [7:0] data;
integer i;
begin
    rx_serial = 0; // start bit
    #(87*10);

    for (i = 0; i < 8; i = i + 1) begin
        rx_serial = data[i];
        #(87*10);
    end

    rx_serial = 1; // stop bit
    #(87*10);
end
endtask

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);

    #20 rst = 0;

    send_byte(8'hA5);
    #2000;

    send_byte(8'h3C);
    #5000;

    $finish;
end

endmodule