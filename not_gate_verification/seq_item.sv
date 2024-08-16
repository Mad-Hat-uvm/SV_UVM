class seq_item extends uvm_sequence_item;
    
    rand bit in;
    bit out;

    function new(string name = "seq_item");
        super.new(name);
    endfunction

    `uvm_object_utils_begin
      `uvm_field_int(in, UVM_ALL_ON)
      `uvm_field_int(out, UVM_ALL_ON)
    `uvm_object_utils_end