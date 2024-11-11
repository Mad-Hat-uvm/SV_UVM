class mem_ctrl_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mem_ctrl_scoreboard);
 
    uvm_analysis_imp #(mem_ctrl_transaction, mem_ctrl_scoreboard) analysis_port;

    type_def struct packed {
        logic [31:0] addr;
        logic [31:0] data;
    } mem_ref_entry_t;

    mem_ref_entry_t mem_model [1024];  //Reference model

    function new(string name = "mem_ctrl_scoreboard", uvm_component parent);
     super.new(name, parent);
     analysis_port = new("analysis_port", this);
    endfunction
 
    function void build_phase(uvm_phase phase);
     super.build_phase(phase);
 
     `uvm_info(get_name(), "Scoreboard build phase executed", UVM_MEDIUM);
     
    endfunction
 
    virtual function void write(mem_ctrl_transaction txn);
        if(txn.we) begin
            mem_model[txn.addr] = txn.data;
        end
        if (txn.re) begin
            assert(mem_model[txn.addr] == rdata)
            else `uvm_error("DATA_MISMATCH", $sformatf("Read %h, Expected %h", txn.rdata, mem_model[txn.addr]));
        end
    endfunction
endclass