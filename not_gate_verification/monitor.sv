class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual not_if vif;

    uvm_analysis_port#(seq_item) item_collect_port;

    seq_item mon_item;

    function new(string name="monitor", uvm_component parent=null);
        super.new(name, parent);

        item_collect_port = new("item_collect_port", this);

    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual not_if)::get(this, "", "vif", vif)) begin
          `uvm_fatal(get_type_name(), "Virtual interface not set on top level")
        end

        mon_item = seq_item::type_id::create("mon_item");
    endfunction

    task run_phase (uvm_phase phase);
        forever begin
            mon_item.in <= vif.in;
            `uvm_info(get_type_name(), $sformatf("IN = %0d", mon_item.in), UVM_LOW);

            mon_item.out <= vif.out;
            `uvm_info(get_type_name(), $sformatf("OUT = %0d", mon_item.out), UVM_LOW);
        
            item_collect_port.write(mon_item);

            #1ns;
        end

    endtask
endclass