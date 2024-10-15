//This sequence will test the FIFO's ability to handle overflow conditions by 
//writing more data than it can store
class fifo_overflow_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_overflow_sequence)

    function new(string name = "fifo_overflow_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;
        for(int i = 0;i < 16, i++) begin //Assuming FIFO depth is 16
            //Write transaction
            tr = fifo_transaction::type_id::create("tr");
            tr.data = i;
            tr.wr_en = 1;
            tr.rd_en = 0;
            start_item(tr);
            finish_item(tr);
        end

        //Assume to write one more to check overflow handling
        tr.data = 17;
        tr.wr_en = 1;
        tr.rd_en = 0;
        start_item(tr);
        finish_item(tr); //This should trigger an overflow
    endtask
endclass