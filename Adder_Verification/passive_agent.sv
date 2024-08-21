class passive_agent extends uvm_agent;
  `uvm_component_utils(passive_agent)

  monitor mon;

  function new(string name = "passive_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE) begin
      mon = monitor::type_id::create("drv", this);
      `uvm_info(get_type_name(), "This is a Passive Agent", UVM_LOW);
    end
  endfunction

endclass
