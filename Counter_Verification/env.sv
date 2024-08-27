class env extends uvm_env;
  `uvm_component_utils(env)

  active_agent agt;
  scoreboard sb;
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agt = active_agent::type_id::create("agt", this);
    sb = scoreboard::type_id::create("sb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    agt.mon.item_collect_port.connect(sb.item_collect_export);
  endfunction
  
endclass
