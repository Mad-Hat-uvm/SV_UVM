class fifo_transaction extends uvm_sequence_item;
    `uvm_object_utils(fifo_transaction)
   rand bit [7:0] data;
   rand bit wr_en;
   rand bit rd_en;
   bit [7:0] exp_data;

   function new(string name = "fifo_transaction");
    super.new(name);
   endfunction

   function string convert2string();
    return $sformatf("wr_en = %0b, rd_en = %b, data = 0x%0h", wr_en, rd_en, data);
   endfunction

endclass