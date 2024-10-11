class valid_wrrd_wrap extends uvm_sequence# (transaction);
    `uvm_object_utils(valid_wrrd_wrap)

    function new(string name = "valid_wrrd_wrap");
     super.new(name);
    endfunction

    virtual task body();
        tr = transaction::type_id::create("tr");
        $display("-------------------------------------------");
        `uvm_info("SEQ", "Sending WRAP mode Transaction to DRV", UVM_NONE);
        start_item(tr);

        assert(tr.randomize);
         tr.op = wrrdwrap;
         tr.awlen = 7;
         tr.awburst = 2;
         tr.awsize  = 2;

        finish_item(tr);

    endtask

endclass
