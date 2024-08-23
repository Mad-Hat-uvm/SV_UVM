class base_seq extends uvm_sequencer #(seq_item);
  `uvm_object_utils(base_seq)

   seq_item req;
  
  function new(string name = "base_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    `uvm_do(req);
  endtask
  
endclass
