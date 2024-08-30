class counter_trans extends uvm_sequence_item;
  
  `uvm_object_utils(counter_trans)
   rand logic rst,
   rand logic load,
   rand logic [3:0] data_in,
   logic [3:0] data_out;

  static int no_of_txn;

  constraint VALID_RST { rst dist {1 := 1, 0 := 15}; }
  constraint VALID_LOAD { load dist {1 := 1, 0 := 15}; }
  constraint VALID_DATA { data_in inside {[0 : 15]}; }

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    counter_trans temp;
    if($cast(temp, rhs)) begin
      `uvm_fatal("do_compare", "cast of the rhs object failed")
      return 0;
    end
    return super.do_compare(rhs, comparer) && (data_out == temp.data_out);
  endfunction : do_compare

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("rst", rst, 1, UVM_DEC);
    printer.print_field("load", rst, 1, UVM_DEC);
    printer.print_field("data_in", rst, 1, UVM_DEC);
    printer.print_field("data_out", rst, 1, UVM_DEC);
  endfunction: do_print

  function void post_randomize();
    no_of_txn++;
    `uvm_info("randomized data", $sformatf("randomized transaction [%0d] is \n%s", no_of_txn, this.sprint()), UVM_MEDIUM)
  endfunction: post_randomize

endclass
