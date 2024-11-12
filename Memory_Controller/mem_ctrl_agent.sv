class mem_ctrl_agent extends uvm_agent;
    `uvm_component_utils(mem_ctrl_agent);

    mem_ctrl_driver drv;
    mem_ctrl_monitor mon;
    mem_ctrl_sequencer seqr;

    function new(string name = "mem_ctrl_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = mem_ctrl_driver::type_id::create("drv");
        mon = mem_ctrl_monitor::type_id::create("mon");
        seqr = mem_ctrl_sequencer::type_id::create("seqr");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass