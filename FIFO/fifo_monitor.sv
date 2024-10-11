class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor);

    virtual fifo_if.mon vif;     //Use the drv modport
    uvm_analysis_port#(fifo_transaction) ap;

    function new(string name = "fifo_monitor", uvm_component parent);
        super.new(name, parent);
        ap =new("ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if.mon)::get(this, "", "vif", vif))
         `uvm_fatal("NOVIF", "No virtual interface for monitor found via uvm_config_db");
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;

        forever begin
           @(posedge vif.clk);

           //Collect all relevant signal values into the transaction
           tr = fifo_transaction::type_id::create("tr");
           tr.wr_en   =  vif.wr_en;
           tr.rd_en   =  vif.rd_en;
           tr.wr_data =  vif.wr_data;
           //The read data is sampled
           tr.rd_data =  vif.rd_data;

           //Write the transaction into analysis port for other components
           ap.write(tr);
        end
    endtask
    
endclass