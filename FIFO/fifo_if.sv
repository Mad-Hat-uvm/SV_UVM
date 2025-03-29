interface fifo_if #(parameter = 8);
    logic clk, rst;
    logic wr_en, rd_en;
    logic [WIDTH-1 : 0] din;
    logic [WIDTH-1 : 0] dout;
    logic empty, full;
endinterface