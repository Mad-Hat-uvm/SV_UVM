/*This sequence generates constrained random transactions to simulate realistic FIFO 
behavior while ensuring that reads happen only when the FIFO is non-empty and write 
//happens only when its not full. */

class fifo_constrained_write_read_seq extends uvm_sequence#(fifo_transaction);
    `uvm_object_utils(fifo_constrained_write_read_seq);

    rand int fifo_depth;
    rand bit wr_en;
    rand bit rd_en;
    rand int data_value;

    //Constraints to ensure valid FIFO operation
    constraint valid_fifo_ops {
        //Cannot read when FIFO is empty
        if(fifo_depth == 0) rd_en == 0;
        //Cannot write when FIFO is full(Assuming max FIFO depth = 16)
        if(fifo_depth == 16) wr_en == 0;
        //Write and read cannot happen at the same time
        !(wr_en && rd_en);
    }

    function new(string name = "fifo_constrained_write_read_seq");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;
        for(i = 0; i < 20; i++) begin
            tr = fifo_transaction::type_id::create("tr");
           
            //Randomize the operation while respecting the constraints
            assert(randomize(fifo_depth, wr_en, rd_en, data_value))
           
            if(wr_en) begin //Randomly decide to write
                tr.data = data_value;
                tr.wr_en = 1;
                tr.rd_en = 0;
                fifo_depth++;
            end else begin // Randomly decide to read
                tr.wr_en = 0;
                tr.rd_en = 1;
                fifo_depth--;
            end

            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass