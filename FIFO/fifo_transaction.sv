class fifo_transaction extends uvm_sequence_item;
    
    rand bit wr_en;
    rand bit rd_en;
    rand bit [7:0] wr_data;

    //Prevent both read and write from being unabled at the same time
    constraint valid_op {!(wr_en && rd_en); }

    //Only write if FIFO is not full and read if FIFO is not empty
    constraint check_valid_fifo_ops {
        wr_en == 1'b0 || !vif.full;
        rd_en == 1'b0 || !vif.empty;
    }

    `uvm_object_utils_begin(fifo_transaction)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(rd_en, UVM_ALL_ON)
        `uvm_field_int(wr_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction
    
endclass