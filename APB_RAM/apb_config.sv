class apb_config extends uvm_object;  //configuration of environment
    `uvm_object_utils(counter_env_cfg)

      function new(string name = "apb_config");
        super.new(name);
      endfunction

      uvm_active_passive_enum is_active = UVM_ACTIVE;
endclass