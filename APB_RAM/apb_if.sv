interface apb_if();
    logic                   pclk;
    logic                   presetn;
    logic            [31:0] paddr;
    logic                   pwrite;
    logic            [31:0] pwdata;
    logic            [31:0] prdata;
    logic                   penable;
    logic                   psel;
    logic                   pslverr;
    logic                   pready;

endinterface : apb_if