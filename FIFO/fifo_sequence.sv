//This sequence will perform basic write operations followed by read operations
class fifo_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_sequence);

    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tx;
        repeat (10) begin
            tx = fifo_transaction::type_id::create("tx");
            tx.randomize() with { wr_en == 1; rd_en == 0; }; //Write only
            start_item(tx);
            finish_item(tx); 
        end

        repeat (10) begin
            tx = fifo_transaction::type_id::create("tx");
            tx.randomize() with { wr_en == 0; rd_en == 1; }; //Read only
            start_item(tx);
            finish_item(tx);
        end
    endtask
endclass