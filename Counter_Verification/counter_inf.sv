interface counter_inf(input logic clk);

 logic [3:0] data_in;
 logic [3:0] data_out;
 logic load;
 logic rst;

clocking driver_cb @(posedge clock);
  default input #1 output #1;
  output rst;
  output data_in;
  output load;
endclocking

clocking output_mon_cb @(posedge clock);
  default input #1 output #1;
  input data_out;
endclocking

clocking input_mon_cb @(posedge clock);
  default input #1 output #1;
  input load;
  input rst;
  input data_in;
endclocking
  
modport DRIVER(
  clocking driver_cb
);

modport INPUT_MON (
  clocking input_mon_cb
);

modport OUTPUT_MON (
  clocking output_mon_cb
);
endinterface
