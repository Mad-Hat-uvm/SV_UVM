class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor);

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_transaction) mon_ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;
        forever begin
            @(posedge vif.clk);
            if(vif.rd_en && !vif.empty) begin
                tr = fifo_transaction::type_id::create("tr");
                tr.exp_data = vif.dout;
                mon_ap.write(tr);
            end 
        end
    endtask
    
endclass