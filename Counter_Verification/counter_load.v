module counter_load(
             input logic clk,
             input logic reset,
             input logic load,
             input logic [3:0] data_in,
             output logic [3:0] data_out
);

logic [3:0] counter_reg;

always_ff @(posedge clk or posedge rst) begin
 if (rst) begin
  counter_reg <= 4'b0000;
 end

 else if(load) begin
  counter_reg <= data_in;
 end

 else if(counter_reg >= 4'd13) begin
  counter_reg <= 4'b0000;
 end

 else begin
  counter_reg <= counter_reg + 1;
 end
end

assign data_out = counter_reg;

endmodule
