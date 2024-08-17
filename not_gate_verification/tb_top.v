`include "uvm_macros.svh"
import uvm_pkg::*;

`include "not_if.sv"
`include "base_test.sv"

module tb_top;

    not_if vif();

    not_gate dut(
        .in(vif.in),
        .out(vif.out)
    );

    initial begin
        uvm_config_db#(virtual not_if)::set(uvm_root::get(), "*", "vif", vif);
    end

    initial begin
        run_test("base_test");
    end
    
endmodule