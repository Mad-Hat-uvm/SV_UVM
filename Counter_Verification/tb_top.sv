`include "uvm_macros.svh"
import uvm_pkg::*;

`include "add_if.sv"
`include "base_test.sv"

module tb_top;
 bit clk = 0;
bit reset = 0;

always #10 clk = ~clk;

initial begin
 reset = 1;
 #5;
 reset = 0;
end

add_if vif(clk, reset);

adder DUT(
   .clk(vif.clk),
 .reset(vif.reset),
   .in1(vif.ip1),
   .in2(vif.ip2),
   .out(vif.out)
);

initial begin
  uvm_config_db#(virtual add_if)::set(uvm_root::get(), "*", "vif", vif);
 $dumpfile("dump.vcd");
 $dumpvars;
end

initial begin
run_test("base_test");
end 

endmodule
