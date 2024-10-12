class fifo_write_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_write_driver);

    virtual fifo_if.drv vif;     //Use the drv modport

    function new(string name = "fifo_write_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if.drv)::get(this, "", "vif", vif))
         `uvm_fatal("NOVIF", "No virtual interface for write driver found via uvm_config_db");
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;

        forever begin
            tr = fifo_transaction::type_id::create("tr", this);

            seq_item_port.get_next_item(tr);

            //Drive the signals via the vif(virtual interface) using modports
            if(tr.wr_en && !vif.full) begin
                vif.wr_en   <= 1;
                vif.wr_data <= tr.wr_data;
                @(posedge vif.clk);
                vif.wr_en   <= 0;
                `uvm_info(get_type_name(), $sformatf("Writedata: %0h", tr.wr_data), UVM_MEDIUM); 
            end

            //Handle any backpressure or FIFO full conditions if needed
            else if(tr.wr_en && vif.full) begin
                `uvm_warning("FIFO FULL", "FIFO is full, cannot write");
            end
                        
            seq_item_port.item_done();
        end
    endtask

endclass