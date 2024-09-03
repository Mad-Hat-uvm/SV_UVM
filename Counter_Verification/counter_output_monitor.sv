class counter_output_monitor extends uvm_monitor;
    `uvm_component_utils(counter_output_monitor)
  
    virtual counter_inf.OUTPUT_MON rd_mon_vif;
    uvm_analysis_port #(counter_trans) monitor_output_o;
    counter_trans output_mon_pkt; //transaction object to capture output data
    counter_env_cfg m_cfg; //Environment configuration object
  
    function new(string name = "counter_input_monitor", uvm_component parent = null);
      super.new(name, parent);
      monitor_output_o = new("Write", this);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(counter_env_cfg) :: get(this, "", "counter_env_cfg", m_cfg))
        `uvm_fatal(get_type_name(), "Cannot get() m_cfg from uvm_config_db");
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      rd_mon_vif = m_cfg.vif; // Connect the virtual interface for input monitoring
    endfunction
  
    task run_phase(uvm_phase phase);
      repeat(2) @(rd_mon_vif.output_mon_cb)
      forever begin
       monitor();
      end
    endtask
  
    task monitor();
      int i = 1;
      output_mon_pkt = counter_trans::type_id::create("TRANS");
     
      begin
      @(rd_mon_vif.output_mon_cb);
      `uvm_info(get_type_name(),"Monitor transaction no.: %0d",i);
     
      output_mon_pkt.data_out <= rd_mon_vif.output_mon_cb.data_out;
      
      `uvm_info(get_type_name(), $sformatf("DATA_OUT = %d", output_mon_pkt.data_out), UVM_LOW);
  
      `uvm_info(get_type_name(), $sformatf("Output monitor has captured the following transaction: \n%s", output_mon_pkt.sprint()), UVM_LOW);
  
      monitor_output_o.write(output_mon_pkt);    
      end
    endtask : monitor
    
  endclass
  