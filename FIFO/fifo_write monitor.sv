class fifo_write_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_write_monitor);

    virtual fifo_if.mon vif;     //Use the drv modport
    uvm_analysis_port#(fifo_transaction) ap;

    function new(string name = "fifo_write_monitor", uvm_component parent);
        super.new(name, parent);
        ap =new("ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if.mon)::get(this, "", "vif", vif))
         `uvm_fatal("NOVIF", "No virtual interface for write monitor found via uvm_config_db");
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;

        forever begin
           @(posedge vif.clk);
         if (vif.wr_en) begin
           //Collect all relevant signal values into the transaction
           tr = fifo_transaction::type_id::create("tr");
           tr.wr_data =  vif.wr_data;
           tr.wr_en   =  vif.wr_en;
           tr.rd_en   =  vif.rd_en;

           //Write the transaction into analysis port for other components
           ap.write(tr);
           `uvm_info(get_type_name(), $sformatf("Monitored Write data: %0h", tr.wr_data), UVM_MEDIUM);
         end
        end
    endtask
    
endclass