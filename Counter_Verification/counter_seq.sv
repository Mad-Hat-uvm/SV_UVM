class counter_seq extends uvm_sequence#(counter_trans);
  `uvm_object_utils(counter_seq)

   int txn_num = 1; //Variable to keep track of the transaction number
  
  function new(string name = "counter_seq");
    super.new(name);
  endfunction

  task body();
    req = counter_trans::type_id::create("req");
    repeat(30)begin
      start_item(req);
      if(txn_num == 1) begin
        assert(req.randomize() with {rst == 1;});
        txn_num++;
      end 
      else begin
        assert(req.randomize());
      end
      `uvm_info(get_type_name(), $sformatf("Data sent to Driver rst: %0d, load: %d, data_in: %d",req.rst, req.load, req.data_in), UVM_NONE);
    finish_item(req);
    end

  endtask
  
endclass
