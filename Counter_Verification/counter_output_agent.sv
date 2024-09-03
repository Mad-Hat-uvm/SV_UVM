class counter_output_agent extends uvm_agent;
    `uvm_component_utils(counter_output_agent)
  
     counter_env_cfg m_cfg;
  
     counter_output_monitor mon_o;
  
    function new(string name = "counter_output_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
  
      if(!uvm_config_db#(counter_env_cfg) :: get(this, "", "counter_env_cfg", m_cfg)) begin
          `uvm_fatal(get_type_name(), "Cannot get() m_cfg from uvm_config_db");
      end
  
      if(m_cfg.input_agent_is_active == UVM_PASSIVE) begin
        mon_o = counter_output_monitor::type_id::create("mon_o", this);
        `uvm_info(get_type_name(), "This is a Passive Agent", UVM_LOW);
      end
      
    endfunction
  
 endclass
  
  
  