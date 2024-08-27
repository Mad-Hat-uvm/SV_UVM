class active_agent extends uvm_agent;
  `uvm_component_utils(active_agent)

  driver drv;
  monitor mon;
  uvm_sequencer #(seq_item) sqr;

  function new(string name = "active_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv = driver::type_id::create("drv", this);
      sqr = uvm_sequencer #(seq_item)::type_id::create("SEQ", this);
      `uvm_info(get_type_name(), "This is a Active Agent", UVM_LOW);
    end
    mon = monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
  
endclass




