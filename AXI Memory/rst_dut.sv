class rst_dut extends uvm_sequence# (transaction);
    `uvm_object_utils(rst_dut);

    transaction tr;

    function new(string name = "rst_dut");
        super.new(name);
    endfunction: new

    virtual task body();
        repeat(5) begin
            tr = transaction::type_id::create("tr");
            $display("--------------------------------------------");
            `uvm_info("SEQ", "Sending RST transaction to DRV", UVM_NONE);
            start_item(tr);
            assert(tr.randomize);
            tr.op   = rstdut;
            finish_item(tr);
        end
    endtask

endclass: rst_dut