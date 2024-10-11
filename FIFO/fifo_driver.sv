class fifo_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_driver);

    virtual fifo_if.drv vif;     //Use the drv modport

    function new(string name = "fifo_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;

        forever begin
            seq_item_port.get_next_item(tr);

            //Drive the signals via the vif(virtual interface) using modports
            vif.wr_en   =  tr.wr_en;
            vif.rd_en   =  tr.rd_en;
            vif.wr_data =  tr.wr_data;

            //Ensure signals are driven properly and hold until the next clock cycle
            @(posedge vif.clk);

            //Handle any backpressure or FIFO full/empty conditions if needed
            if(tr.wr_en && vif.full) begin
                `uvm_warning("FIFO FULL", "FIFO is full, cannot write");
            end
            if(tr.rd_en && vif.empty) begin
                `uvm_warning("FIFO EMPTY", "FIFO is empty, cannot read");
            end

            seq_item_port.item_done();
        end
    endtask
    
endclass