class mem_ctrl_monitor extends uvm_monitor;
    `uvm_component_utils(mem_ctrl_monitor);

    virtual mem_ctrl_if vif;
    mem_ctrl_transaction txn;
 
    uvm_analysis_port #(mem_ctrl_transaction) analysis_port;

    function new(string name = "mem_ctrl_monitor", uvm_component parent);
     super.new(name, parent);
     analysis_port = new("analysis_port", this);
    endfunction
 
    function void build_phase(uvm_phase phase);
     super.build_phase(phase);
 
     if (!uvm_config_db#(virtual mem_ctrl_if)::get(this, "vif", vif)) begin
         `uvm_fatal("VIF IS NOT SET", "Virtual interface not set for driver")
     end
    endfunction
 
    task run_phase(uvm_phase phase);
     forever begin
         txn = mem_ctrl_transaction::type_id::create("txn");
         
         txn.addr     <= vif.addr;
         txn.data     <= vif.data;
         txn.we       <= vif.we;
         txn.re       <= vif.re;
         txn.is_valid <= vif.is_valid;
        
     end
    endtask
endclass