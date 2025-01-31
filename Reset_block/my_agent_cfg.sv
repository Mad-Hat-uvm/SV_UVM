class my_agent_cfg extends uvm_object;

    my_vif vif;
     //The length in time, in ps, that reset will stay active
    int unsigned reset_time_ps = 10;
    int unsigned min_payload_length = 5;
    int unsigned max_payload_length = 100;
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    `uvm_object_utils_begin(my_agent_cfg)
       `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
       `uvm_field_int(reset_time_ps,       UVM_DEFAULT | UVM_DEC)
       `uvm_field_int(min_payload_length,       UVM_DEFAULT | UVM_DEC)
       `uvm_field_int(max_payload_length,       UVM_DEFAULT | UVM_DEC)
    `uvm_object_utils_end(my_agent_cfg)

    function new(string name="my_agent_cfg");
        super.new(name);
    endfunction

    function void is_valid();
        if(max_payload_length < min_payload_length) begin
            `uvm_error(get_name(), $sformatf("Value of max_payload_length has to be greater or equal to the min_payload_length, configured vales of max_payload_length: %0d, min_payload_length: %0d", max_payload_length, min_payload_length));
        end

        if(reset_time_ps <= 0) begin
            `uvm_error(get_type_name(), $sformatf("reset_time_ps should be greater than 0"));
        end
    endfunction: is_valid

endclass : my_agent_cfg