interface mem_ctrl_if(input logic clk, input logic reset_n);
    logic [31:0] addr;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic we;
    logic re;
    logic ready;
endinterface

