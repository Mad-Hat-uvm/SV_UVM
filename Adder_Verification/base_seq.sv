class base_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(base_seq)

   seq_item req;
  
  function new(string name = "base_seq");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
     repeat(10)begin
      start_item(req);
      req.randomize();
      finish_item(req);
       `uvm_info(get_type_name(), $sformatf("Data sent to Driver ip1: %0d,ip2: %d",req.ip1, req.ip2), UVM_NONE);
    end

  endtask
  
endclass
