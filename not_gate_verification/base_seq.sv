class base_seq extends uvm_sequence#(seq_item);
    `uvm_object_utils(base_seq)

    function new(string name="base_seq");
        super.new(name);
    endfunction

    task body();
        req = seq_item::type_id::create("req");

        start_item(req);

        assert(req.randomize());

        finish_item(req);
        
    endtask
endclass