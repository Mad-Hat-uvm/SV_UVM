interface fifo_if #(parameter DATA_WIDTH = 8, DEPTH = 16);

    //Define signals
    logic clk;
    logic reset_n;
    logic wr_en;
    logic rd_en;
    logic [DATA_WIDTH-1:0] wr_data;
    logic [DATA_WIDTH-1:0] rd_data;
    logic full;
    logic empty;

    //Modport for the driver: driver drives wr_en, rd_en and wr_data.
    modport drv (output wr_en, output rd_en, output wr_data, input full, input empty, input rd_data, input clk, input reset_n);

    //Modport for the monitor: Monitor observes everything but drives nothing
    modport mon (input wr_en, input rd_en, input wr_data, input full, input empty, input rd_data, input clk, input reset_n);

    //Modport for scoreboard: scoreboard reads relevant output signals from the FIFO.
    modport sb(input rd_data, input clk, input reset_n);

    //Modport for assertions or coverage to observesignals
    modport cov (input wr_en, input rd_en, input full, input empty, input clk, input reset_n);
    
endinterface