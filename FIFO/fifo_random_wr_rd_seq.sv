class fifo_random_wr_rd_seq extends uvm_sequence#(fifo_transaction);
    `uvm_object_utils(fifo_random_wr_rd_seq);

    function new(string name = "fifo_random_wr_rd_seq");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;

        //Randomly generate a sequence of write and read transactions
        repeat(20) begin
            tr = fifo_transaction::type_id::create("tr", this);
            start_item(tr);

            //Randomize wr_en, rd_en an er_data
            if(!tr.randomize()) begin
                `uvm_error("RANDOMIZE_FAIL","Failed to randomize transaction");
            end

            finish_item(tr);
            `uvm_info("FIFO_TEST", $sformatf("Generated transaction: wr_en: %0b, rd_en: %0b, wr_data=%0h", tr.wr_en, tr.rd_en, tr.wr_data), UVM_LOW);
        end
    endtask
endclass