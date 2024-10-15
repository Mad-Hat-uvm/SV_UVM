/*This sequence simulates burst writes followed by burst reads.It ensures 
that large amount of data can be written and read back in aburst mode.*/

class fifo_burst_sequence extends uvm_sequence#(fifo_transaction);
    `uvm_object_utils(fifo_burst_sequence);

    rand int burst_size;   //Number of transactions in a burst
    
   //Constraint
     burst size between 1 and 8
    constraint burst_size_c {
        burst_size inside {[1:8]};
    }

    function new(string name = "fifo_burst_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;
        
        //Burst Write
        assert(randomize(burst_size));
        for(i = 0; i < burst_size; i++) begin
            tr = fifo_transaction::type_id::create("tr");
            tr.data = $urandom_range(0,255);
            tr.wr_en = 1;
            tr.rd_en = 0;
            start_item(tr);
            finish_item(tr);
        end

        //Burst Read
        for(int j = 0; j < burst_size; j++) begin
            tr = fifo_transaction::type_id::create("tr");
            tr.wr_en = 0;
            tr.rd_en = 1;
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass