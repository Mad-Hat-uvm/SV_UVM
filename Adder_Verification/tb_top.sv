// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "add_if.sv"
`include "base_test.sv"

module tb_top;
  
 add_if vif();
  
initial begin
 vif.clk = 0;
 vif.reset = 0;
end

always #10 vif.clk = ~vif.clk;

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
