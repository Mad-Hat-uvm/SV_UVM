class fifo_random_wr_rd_seq extends uvm_sequence#(fifo_transaction);
    `uvm_object_utils(fifo_random_wr_rd_seq);

    function new(string name = "fifo_random_wr_rd_seq");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;
        int data_value;

        //Randomly generate a sequence of write and read transactions
        for(i = 0; i < 20; i++) begin
            tr = fifo_transaction::type_id::create("tr", this);
            data_value = $urandom_range(0, 255); //Random data value
           
            if($urandom_range(0, 1) == 0) begin //Randomly decide to write
                tr.data = data_value;
                tr.wr_en = 1;
                tr.rd_en = 0;
                start_item(tr);
                finish_item(tr);
            end else begin // Randomly decide to read
                tr.wr_en = 0;
                tr.rd_en = 1;
                start_item(tr);
                finish_item(tr);
            end
        end
    endtask
endclass