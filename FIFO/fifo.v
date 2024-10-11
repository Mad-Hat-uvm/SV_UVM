module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16
)(
    input clk,
    input reset_n,
    input wr_en,
    input rd_en,
    input  [DATA_WIDTH-1:0] wr_data,
    output [DATA_WIDTH-1:0] rd_data,
    output full,
    output empty
);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
reg [3:0] wr_ptr, rd_ptr, count;

assign full    = (count == DEPTH);
assign empty   = (count == 0);
assign rd_data = mem[rd_ptr];

always @(posedge clk or negedge reset_n)begin
    if(!reset_n) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;
    end else begin
        if(wr_en && !full) begin
            mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end
        if(rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
            count  <= count - 1;
        end
    end
end
endmodule