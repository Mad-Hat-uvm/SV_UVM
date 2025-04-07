//Parameter ADDR_WIDTH is calculated using $clog2(DEPTH) to index the memory
//The FIFO supports simultaneous read and write.
//It uses circular buffer approach.
//The design assumes registered output(i.e., dout is updated on clock edge)
//On reset, pointers and counters are cleared. 

module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input logic clk,
    input logic rst,

    input logic wr_en,
    input logic rd_en,
    input logic [WIDTH-1:0] din,
    input logic [WIDTH-1:0] dout,

    output logic full,
    output logic empty
);

logic [WIDTH-1:0] mem [DEPTH-1:0];
logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
logic [ADDR_WIDTH] count;

//Write Logic
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        wr_ptr <= 0;
    end else if(wr_en && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
end
end

//Read Logic
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        rd_ptr <= 0;
    end else if(rd_en && !empty) begin
        rd_ptr <= rd_ptr + 1;
    end
end

assign dout = mem[rd_ptr];

//Counter to track number of items
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 0;
    end else begin
        case ({wr_en && !full, rd_en && !empty})
            2'b10: count <= count + 1;  //Write only
            2'b01: count <= count - 1; //rd_only
            default: count <= count;   //No change or simultaneous read + write
        endcase
    end
end

assign full  = (count == DEPTH);
assign empty = (count == 0);

endmodule