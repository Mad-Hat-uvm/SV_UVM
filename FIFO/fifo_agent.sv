class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_driver drv;
    fifo_monitor mon;
    uvm_sequencer#(fifo_transaction) seqr;

    //Active/Passive mode
    bit is_active;

    function new(string name = "fifo_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(uvm_phase phase);

        //Get the agent's active/passive setting from the uvm_config_db(default is active)
        if(!uvm_config_db#(bit)::get(this, "", "is_active", is_active))
          is_active = 1;  //Default to active mode

        //Create monitor (always required)
          mon = fifo_monitor::type_id::create("mon", this);

        //Create sequencer and agent if the agent is active
          if(is_active) begin
            drv  = fifo_driver::type_id::create("drv", this);
            seqr = uvm_sequencer#(fifo_transaction)::type_id::create("seqr", this);
          end

    endfunction

    //Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //If active, connect the sequencer to the driver
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass