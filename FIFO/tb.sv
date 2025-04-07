module tb;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    logic clk;
    logic rst;
    fifo_if #(WIDTH) fifo_if();

    //Clock
    initial clk = 0;
    always #5 clk = ~clk;
    assign fifo_if.clk = clk;
    
    //DUT instance
    fifo #(WIDTH, DEPTH) dut (
        .clk(fifo_if.clk),
        .rst(fifo_if.rst),
        .wr_en(fifo_if.wr_en),
        .rd_en(fifo_if.rd_en),
        .din(fifo_if.din),
        .dout(fifo_if.dout),
        .full(fifo_if.full),
        .empty(fifo_if.empty)
    );

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", fifo_if);
        run_test("fifo_test");
    end
endmodule