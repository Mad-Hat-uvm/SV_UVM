class fifo_read_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_read_driver);

    virtual fifo_if.drv vif;     //Use the drv modport

    function new(string name = "fifo_read_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if.drv)::get(this, "", "vif", vif))
         `uvm_fatal("NOVIF", "No virtual interface for read driver found via uvm_config_db");
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;

        forever begin
            tr = fifo_transaction::type_id::create("tr", this);

            seq_item_port.get_next_item(tr);

            //Drive the signals via the vif(virtual interface) using modports
            if(tr.rd_en && !vif.empty) begin
                vif.rd_en   <= 1;
                @(posedge vif.clk);
                tr.rd_data <= vif.rd_data;
                vif.rd_en   <= 0;
                `uvm_info(get_type_name(), $sformatf("Read data: %0h", tr.rd_data), UVM_MEDIUM); 
            end

            //Handle any backpressure or FIFO empty conditions if needed
            else if(tr.rd_en && vif.empty) begin
                `uvm_warning("FIFO EMPTY", "FIFO is EMPTY, cannot read");
            end
                        
            seq_item_port.item_done();
        end
    endtask

endclass