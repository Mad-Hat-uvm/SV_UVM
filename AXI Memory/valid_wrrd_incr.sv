class valid_wrrd_incr extends uvm_sequence# (transaction);
    `uvm_object_utils(valid_wrrd_incr)

    function new(string name = "valid_wrrd_incr");
     super.new(name);
    endfunction

    virtual task body();
        tr = transaction::type_id::create("tr");
        $display("-------------------------------------------");
        `uvm_info("SEQ", "Sending INCR mode Transaction to DRV", UVM_NONE);
        start_item(tr);

        assert(tr.randomize);
         tr.op = wrrdincr;
         tr.awlen = 7;
         tr.awburst = 1;
         tr.awsize  = 2;

        finish_item(tr);

    endtask

endclass