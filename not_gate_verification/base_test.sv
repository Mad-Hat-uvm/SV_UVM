`include "package.sv"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    env env_o;
    base_seq bseq;

    function new(string name="env", uvm_component parent=null);
        super.new(name, parent);
endclass