class fifo_read_agent extends uvm_agent;
    `uvm_component_utils(fifo_read_agent)

    fifo_read_driver drv;
    fifo_read_monitor mon;
    fifo_read_sequencer seqr;
    bit is_active;

    function new(string name = "fifo_read_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(uvm_phase phase);

          //Get the agent's active/passive setting from the uvm_config_db(default is active)
        if(!uvm_config_db#(bit)::get(this, "", "is_active", is_active))
        is_active = UVM_ACTIVE;  //Default to active mode

      //Create monitor (always required)
        mon = fifo_read_monitor::type_id::create("mon", this);

      //Create sequencer and agent if the agent is active
        if(is_active == UVM_ACTIVE) begin
          drv  = fifo_read_driver::type_id::create("drv", this);
          seqr = fifo_read_sequencer::type_id::create("seqr", this);
        end
         
    endfunction

    //Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(is_active == UVM_ACTIVE) begin
        drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass