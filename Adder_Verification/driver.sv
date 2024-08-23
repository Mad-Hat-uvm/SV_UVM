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
 vif.ip1   <= 0;
 vif.ip2.  <= 0;
 repeat(5) @(posedge vif.clk);
 vif.reset <= 1'b0;
 `uvm_info(get_type_name(), "Reset Done", UVM_NONE);
 
endtask

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    req = seq_item::type_id::create("req");

    if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Interface not set at top level");
  endfunction

  task run_phase(uvm_phase phase);
    reset_dut();
    forever begin
      seq_item_port.get_next_item(req);
      vif.ip1 <= req.ip1;
      vif.ip2 <= req.ip2;
      `uvm_info(get_type_name(), $sformatf("Trigger DUT ip1 = %0d, ip2 = %0d", req.ip1, req.ip2), UVM_NONE);
      seq_item_port.item_done();
      repeat(2)@(posedge vif.clk);
    end
  endtask
  
endclass
