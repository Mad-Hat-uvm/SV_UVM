class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard);

    uvm_analysis_imp#(fifo_transaction, fifo_scoreboard) write_ap;
    uvm_analysis_imp#(fifo_transaction, fifo_scoreboard) read_ap;

    queue [7:0] fifo_queue;
    int fifo_depth; //Number of items in FIFO
    int max_fifo_size; //Maximum FIFO size (to be set based on FIFO's depth)

    function new(string name = "fifo_scoreboard", uvm_component parent);
        super.new(name, parent);
        write_ap =new("write_ap",this);
        read_ap =new("read_ap",this);
        max_fifo_size = 16; //Set to the actual FIFO depth
        fifo_depth = 0;   // Initial depth is 0, i.e., the FIFO is empty

        fifo_queue = new();
    endfunction

    //Capture write transactions and push to FIFO
    function void write(fifo_transaction tr);
        //Handle Write transactions
        if(tr.wr_en) begin
            //Check if the FIFIo is full
            if(fifo_depth == max_fifo_size) begin
                `uvm_error(get_type_name(), "Write occured when FIFO is full!");
            end else begin
            // Push written data into reference model
            fifo_queue.push_back(tr.wr_data);
            `uvm_info("FIFO_SB", $sformatf("Data written to FIFO: %0h", tr.wr_data), UVM_LOW);
            fifo_depth++;
            end
        end

        check_flags(tr.full, tr.empty);
    endfunction

    //Capture read transactions and pop from FIFO queue
    function void read(fifo_transaction tr);
        if(tr.rd_en) begin
            //Check if the FIFO is empty
            if(fifo_depth == 0) begin
                `uvm_error(get_type_name(), "Read occured when FIFO is empty!");
            end else begin
                bit [7:0] expected_data = fifo_queue.pop_front();
                fifo_depth--;
                //Check if read data matches the earliest written unread data
                if(tr.rd_data === expected_data) begin
                    `uvm_info("FIFO_SB", $sformatf("Data read from FIFO matches expected: %0h", tr.rd_data), UVM_LOW);
                end else begin
                    `uvm_error("FIFO_MISMATCH", $sformatf("Data read mismatch. Expected: %0h, Got: %0h", expected_data, tr.rd_data));
                end 
            end

        end
        check_flags(tr.full, tr.empty);
    endfunction
    
//Check full and empty flags based on current FIFO depth
    function void check_flags(bit full_flag, bit empty_flag);
        if(fifo_depth == 0) begin
            if(!empty_flag) begin
                `uvm_error(get_type_name(), "Empty flag is not asserted when FIFO is empty!");
            end
            if(full_flag) begin
                `uvm_error(get_type_name(), "Full flag is asserted when FIFO is empty!");
            end
        end else if(fifo_depth == max_fifo_size) begin
            if(!full_flag) begin
                `uvm_error(get_type_name(), "Full flag is not asserted when FIFO is Full!");
            end
            if(empty_flag) begin
                `uvm_error(get_type_name(), "Empty flag is asserted when FIFO is Full!");
            end
        end else begin
            //When FIFO is neither full nor empty, both flags should be deasserted
            if(full_flag) begin
                `uvm_error(get_type_name(), "Full flag is asserted when FIFO is not full!");
            end
            if(empty_flag) begin
                `uvm_error(get_type_name(), "Empty flag is asserted when FIFO is not empty!");
            end
        end
    endfunction
endclass
