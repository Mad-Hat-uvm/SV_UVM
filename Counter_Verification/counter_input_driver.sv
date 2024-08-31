class counter_input_driver extends uvm_driver#(counter_trans);
  `uvm_component_utils(counter_input_driver)

  virtual counter_inf.DRIVER drv_vif; //Virtual interface for driver
  counter_trans data_2_dut_packet; // Transaction object
  counter_env_config m_cfg; // Environment configuration object

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
   data_2_dut_packet = counter_trans::type_id::create("data_2_dut_packet");

   if(!uvm_config_db#(counter_env_config) :: get(this, "", "counter_env_config", m_cfg))
     `uvm_fatal("CONFIG", "Cannot get m_cfg from uvm_config_db. Have you set it?");
   end
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    drv_vif = m_cfg.vif; // Connect the virtual interface to the driver
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(data_2_dut_packet);
      send_to_dut(data_2_dut_packet);
      seq_item_port.item_done();
      //repeat(2)@(posedge vif.clk);
    end
  endtask : run_phase

  virtual task send_to_dut(counter_trans trans_packet);
    int i = 1;
    @(drv_vif.driver_cb); // Synchronize with the driver's clocking block
    `uvm_info(get_type_name(),"Driver transaction no.: %0d",i);
     drv_vif.driver_cb.data_in <= trans_packet.data_in; // Assign transaction data to DUT
    `uvm_info(get_type_name(), $sformatf("DATA_IN = %d", trans_packet.data_in), UVM_LOW);
     drv_vif.driver_cb.rst <= trans_packet.rst;
     drv_vif.driver_cb.load <= trans_packet.load;
     i++;
  endtask : send_to_dut
  
endclass
