class fifo_driver extends uvm_driver #(fifo_transaction);
`uvm_component_utils(fifo_transaction);
    
    virtual fifo_if vif;

    //Mailbox to push written data into reference model
    uvm_analysis_port #(fifo_transaction) drv_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        drv_ap = new("drv_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
          `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            @(posedge vif.clk);
            vif.wr_en <= tr.wr_en;
            vif.rd_en <= tr.rd_en;
            vif.din   <= tr.data;
            seq_item_port.item_done();

            if(tr.wr_en && !vif.full) begin
                fifo_transaction tx = tr.clone();
                drv_ap.write(tx); //Send to scoreboard reference model
            end
        end
    endtask


endclass