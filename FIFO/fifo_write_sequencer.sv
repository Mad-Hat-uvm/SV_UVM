class fifo_write_sequencer extends uvm_sequencerr#(fifo_transaction);
    `uvm_component_utils(fifo_write_sequencer)

    function new(string name = "fifo_write_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass