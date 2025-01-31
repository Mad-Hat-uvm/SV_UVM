interface my_interface(input logic clk,
                       input logic rstn /*Active low Reset */);
    bit valid;
    logic [`ADDR_WIDTH_IN_BITS - 1 : 0] start_addr;
    reg   [`DATA_WIDTH_IN_BITS - 1 : 0] data_reg;
    wire  [`DATA_WIDTH_IN_BITS - 1 : 0] data;
    int unsigned length_in_bytes;

    assign data = data_reg;
endinterface : my_interface

typedef virtual my_interface my_vif;
typedef class my_agent;


