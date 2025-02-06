class my_seq_item extends uvm_sequence_item;

    rand logic [`ADDR_WIDTH_IN_BITS - 1 : 0] start_addr;
    rand logic [`DATA_WIDTH_IN_BITS - 1 : 0] data[];
    rand int unsigned payload_length;

    my_agent_cfg cfg;

    `uvm_object_utils_begin(my_seq_item)
      `uvm_field_int         (start_addr,      UVM_DEFAULT | UVM_HEX)
      `uvm_field_int         (payload_length,      UVM_DEFAULT | UVM_HEX)
      `uvm_field_int         (data,      UVM_DEFAULT | UVM_HEX)
    `uvm_object_utils_end

    constraint length_cn {
        payload_length inside {[cfg.min_payload_length : cfg.max_payload_length]};
        data.size == payload_length;
    }

    constraint order_cn {
        solve payload_length before data;
    }

    function new(string name="my_seq_item");
     super.new(name);
    endfunction

    function string convert2string();
        convert2string = $sformatf("start_addr: %0h, payload_length: %0d, data[0]: %0h, data[%0d]: %0h",
         start_addr, payload_length, data[0], payload_length-1, data[payload_length-1]);
    endfunction: convert2string
    
endclass : my_seq_item