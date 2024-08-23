class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver)

  virtual add_if vif;
  seq_item req;

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

/////////////////////reset logic//////////////////////
task reset_dut();
 vif.reset <= 1'b1;
 
endtask

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Interface not set at top level");
  endfunction

  task run_phase(uvm_phase phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), $sformatf("ip1 = %0d, ip2 = %0d", req.ip1, req.ip2), UVM_LOW);
       vif.ip1 <= req.ip1;
       vif.ip2 <= req.ip2;
      seq_item_port.item_done();
    end
  endtask
  
endclass
