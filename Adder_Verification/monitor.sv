class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual add_if vif;
  uvm_analysis_port #(seq_item) item_collect_port;
  seq_item mon_item;

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_port = new("Write", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_item = seq_item::type_id::create("TRANS");
    if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Interface not set at top level");
  endfunction

  task run_phase(uvm_phase phase);
    @(negedge vif.reset);
    forever begin
      repeat(2)@(posedge vif.clk);
      mon_item.ip1 <= vif.ip1;
      mon_item.ip2 <= vif.ip2;
      mon_item.out <= vif.out;
      `uvm_info(get_type_name(), $sformatf("ip1 = %0d, ip2 = %0d, out: %d", mon_item.ip1, mon_item.ip2, mon_item.out), UVM_NONE);
      @(posedge vif.clk);
      item_collect_port.write(mon_item);
    end
  endtask
  
endclass
