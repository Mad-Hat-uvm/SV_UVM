class mem_ctrl_transaction extends uvm_transaction;
    `uvm_object_utils(mem_ctrl_transaction)

    rand logic [31:0] addr;
    rand logic [31:0] wdata;
    rand bit          we;
    rand bit          re;
    rand bit          is_valid;

    constraint valid_op { we || re; }
    constraint valid_data { addr < 32'hFFFF; }
   
    function new(string name = "mem_ctrl_transaction");
        super.new(name);
    endfunction
endclass