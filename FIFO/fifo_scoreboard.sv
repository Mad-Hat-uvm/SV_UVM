class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard);

    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) sb_port;
    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) sb_ref_port;
    mailbox #(bit[7:0]) model;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        model = new();
        sb_port = new("sb_port", this);
        sb_ref_port = new("sb_ref_port", this);
    endfunction

    function void write_sb_port(fifo_transaction tr);
        bit [7:0] ref_data;
        model.get(ref_data);
        if(ref_data !== tr.exp_data)
          `uvm_error("FIFO_SB", $sformatf("Expected: %0h, Got: %0h", ref_data, tr.exp_data))
        else
          `uvm_info("FIFO_SB", "Data match!", UVM_LOW)
    endfunction
    
    function void write_sb_ref_port(fifo_transaction tr);
      model.put(tr);
    endfunction

endclass
