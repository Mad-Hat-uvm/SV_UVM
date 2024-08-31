class counter_input_agent extends uvm_agent;
  `uvm_component_utils(counter_input_agent)

   counter_env_cfg m_cfg;

   counter_input_driver drv;
   uvm_sequencer #(counter_trans) sqr;
   counter_input_monitor mon;

  function new(string name = "counter_input_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(counter_env_cfg) :: get(this, "", "counter_env_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Cannot get() m_cfg from uvm_config_db");
    end

    mon = counter_input_monitor::type_id::create("mon", this);

    if(m_cfg.input_agent_is_active == UVM_ACTIVE) begin
      drv = counter_input_driver::type_id::create("drv", this);
      sqr = uvm_sequencer #(counter_trans)::type_id::create("SEQ", this);
      `uvm_info(get_type_name(), "This is a Active Agent", UVM_LOW);
    end
    
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(m_cfg.input_agent_is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
  
endclass


