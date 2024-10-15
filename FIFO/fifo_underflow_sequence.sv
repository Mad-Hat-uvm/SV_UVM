//This sequence will test the FIFO's ability to handle underflow conditions by 
//reading data from an empty FIFO
class fifo_underflow_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_underflow_sequence)

    function new(string name = "fifo_underflow_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;
//Read transaction
            tr = fifo_transaction::type_id::create("tr");
            tr.wr_en = 0;
            tr.rd_en = 1;
            start_item(tr);
            finish_item(tr);
    endtask
endclass