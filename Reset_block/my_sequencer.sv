class my_sequencer extends uvm_sequencer# (my_seq_item);
    my_agent parent;
    `uvm_component_utils(my_sequencer)

    function new(string name="my_sequencer", uvm_component parent);
     super.new(name, parent);
     if (parent == null) begin
        `uvm_fatal(get_name() , $sformatf("NULL handle is provided in parent argument of constructor"))
     end
     else begin
        if(!$cast(this.parent, parent)) begin
            `uvm_fatal(get_name(),
            $sformatf("Casting failed, provide parent of valid type"))
     end
    end
    endfunction: new
endclass: my_sequencer