`include "package.sv"

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  env env_0;
  base_seq bseq;
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_o = env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = base_seq::type_id::create("bseq", this);

    repeat(10)begin
      #5;
      bseq.start(env_0.agt.sqr);
    end
    phase.drop_objection(this);

    `uvm_info(get_type_name(), "End of testcase", UVM_LOW);
  endtask
  
endclass
