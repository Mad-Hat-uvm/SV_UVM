class counter_env_config extends uvm_object;
    `uvm_object_utils(counter_env_cfg)

    //Configuration agents to determine which agents and components are included in the environment
    bit has_input_agent = 1;
    bit has_output_agent = 1;
    bit has_scoreboard = 1;

    uvm_active_passive_enum input_agent_is_active;  //Indicates whether the input agent is active or passive
    uvm_active_passive_enum output_agent_is_active; //Indicates whether the input agent is active or passive
   
    //Virtual interface handle to connect agents to DUT's interface
    counter_inf vif; 

    function new(string name = "counter_env_config");
        super.new(name);
      endfunction
endclass