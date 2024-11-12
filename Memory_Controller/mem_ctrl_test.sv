class mem_ctrl_test extends uvm_test;
    `uvm_component_utils(mem_ctrl_test);

    mem_ctrl_env env;

    function new(string name = "mem_ctrl_test", uvm_component parent);
     super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     env = mem_ctrl_env::type_id::create("env");
    endfunction
 
    task run_phase(uvm_phase phase);
     phase.raise_objection(this);
     mem_
     phase.drop_objection(this);
    endtask
endclass