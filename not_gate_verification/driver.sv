class driver extends uvm_driver#(seq_item);
    `uvm_component_utils(driver)

    virtual not_if vif;

    function new(string name="driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual not_if)::get(this, "", "vif", vif)) begin
          `uvm_fatal(get_type_name(), "Virtual interface not set on top level")
        end
    endfunction

    task run_phase(uvm_phase phase);
        seq_item req;
        forever begin
            seq_item_port.get_next_item(req);

            if (req == null) begin
                `uvm_fatal(get_type_name(), "Received null item from sequencer.")
            end

            if(vif == null) begin
                `uvm_fatal(get_type_name(), "Virtual interface (vif) not set")
            end

            `uvm_info(get_type_name(), $sformat("IN = %0d", req.in), UVM_LOW);

            vif.in <= req.in;

            seq_item_port.item_done();

            #1ns;
        end

    endtask
    
endclass