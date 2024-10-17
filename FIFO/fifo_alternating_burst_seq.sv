/*This sequence alternates between burst of writes and reads. It models FIFO behavior 
where large blocks of data are wriiten and read in alternating phases. */

class fifo_alternating_burst_seq extends uvm_sequence#(fifo_transaction);
    `uvm_object_utils(fifo_alternating_burst_seq);

    rand int burst_size;   //Number of transactions in a burst
    
   //Constraint
     burst size between 1 and 8
    constraint burst_size_c {
        burst_size inside {[3:8]};  //Alternating burst size between 3 and 8
    }

    function new(string name = "fifo_alternating_burst_seq");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;

        //Alternating bursts
        for(int i = 0; i < 5; i++) begin
         assert(randomize(burst_size));

        //Burst Write
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
    end
    endtask
endclass