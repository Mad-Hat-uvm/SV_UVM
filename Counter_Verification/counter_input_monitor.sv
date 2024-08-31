class counter_input_monitor extends uvm_monitor;
  `uvm_component_utils(counter_input_monitor)

  virtual counter_inf.INPUT_MON mon_vif;
  uvm_analysis_port #(counter_trans) item_collect_port;
  counter_trans drv2mon_pkt; //transaction object to capture monitored data
  counter_env_cfg m_cfg; //Environment configuration object

  static 
  function new(string name = "counter_input_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_port = new("Write", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(counter_env_cfg) :: get(this, "", "counter_env_cfg", m_cfg))
      `uvm_fatal(get_type_name(), "Cannot get() m_cfg from uvm_config_db");
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    mon_vif = m_cfg.vif; // Connect the virtual interface for input monitoring
  endfunction

  task run_phase(uvm_phase phase);
    @(mon_vif.input_mon_cb)
    forever begin
     monitor();
    end
  endtask

  task monitor();
    int i = 1;
    drv2mon_pkt = counter_trans::type_id::create("TRANS");
   
    begin
    @(mon_vif.input_mon_cb);
    `uvm_info(get_type_name(),"Monitor transaction no.: %0d",i);
    drv2mon_pkt.rst <= mon_vif.input_mon_cb.rst;
    drv2mon_pkt.load <= mon_vif.input_mon_cb.load;
    drv2mon_pkt.data_in <= mon_vif.input_mon_cb.data_in;
    
    `uvm_info(get_type_name(), $sformatf("DATA_IN = %d", drv2mon_pkt.data_in), UVM_LOW);

    `uvm_info(get_type_name(), $sformatf("Input monitor has captured the following transaction: \n%s", drv2mon_pkt.sprint()), UVM_LOW);

    item_collect_port.write(drv2mon_pkt);    
    end
  endtask : monitor
  
endclass
