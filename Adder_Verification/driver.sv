class driver extends uvm_driver#(seq_item)
  `uvm_component_utils(driver)

  virtual add_if vif;
  seq_item req;
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Interface not set at top level");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
     req = seq_item::type_id_create
    end
  endtask
  
endclass
