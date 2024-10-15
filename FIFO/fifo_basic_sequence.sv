//This sequence will perform basic write operations followed by read operations
class fifo_basic_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_basic_sequence)

    function new(string name = "fifo_basic_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;

        //Basic Write-Read Pattern
        for(int i = 0;i < 5, i++) begin
            //Write transaction
            tr = fifo_transaction::type_id::create("tr");
            tr.data = i;
            tr.wr_en = 1;
            tr.rd_en = 0;
            start_item(tr);
            finish_item(tr);

            //Read transaction
            tr.wr_en = 0;
            tr.rd_en = 1;
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass