class mem_ctrl_driver extends uvm_driver #(mem_ctrl_transaction);
    `uvm_component_utils(mem_ctrl_driver);

   virtual mem_ctrl_if vif;
   mem_ctrl_transaction txn;

   function new(string name = "mem_ctrl_driver", uvm_component parent);
    super.new(name, parent);
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
        seq_item_port.get_next_item(txn);
        vif.addr     <= txn.addr;
        vif.wdata     <= txn.wdata;
        vif.we       <= txn.we;
        vif.re       <= txn.re;
        vif.is_valid <= txn.is_valid;
        seq_item_done.item_done();
    end
   endtask

endclass