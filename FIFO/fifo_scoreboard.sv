class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard);

    uvm_analysis_imp#(fifo_transaction, fifo_scoreboard) write_ap;
    uvm_analysis_imp#(fifo_transaction, fifo_scoreboard) read_ap;

    queue [7:0] fifo_queue;

    function new(string name = "fifo_scoreboard", uvm_component parent);
        super.new(name, parent);
        write_ap =new("write_ap",this);
        read_ap =new("read_ap",this);

        fifo_queue = new();
    endfunction

    virtual function void write(fifo_transaction tr);
        //Handle Write transactions
        if(tr.wr_en && !vif.full) begin
            // Push written data into reference model
            fifo_queue.push_back(tr.wr_data);
            `uvm_info("FIFO_SB", $sformatf("Data written to FIFO: %0h", tr.wr_data), UVM_LOW);
        end

        //Handle Read transactions
        if(tr.rd_en && !vif.empty) begin
            if(fifo_queue.size() > 0) begin
                bit [7:0] expected_data = fifo_queue.pop_front();

                //Check if read data matches the earliest written unread data
                if(tr.rd_data === expected_data) begin
                    `uvm_info("FIFO_SB", $sformatf("Data read from FIFO matches expected: %0h", tr.rd_data), UVM_LOW);
                end else begin
                    `uvm_error("FIFO_MISMATCH", $sformatf("Data read mismatch. Expected: %0h, Got: %0h", expected_data, tr.rd_data));
                end
            end else begin
                `uvm_warning("FIFO_UNDERFLOW", "Read attempted when FIFO is empty.");
            end

        end
    endfunction
    
endclass
