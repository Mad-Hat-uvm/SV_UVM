class mem_ctrl_env extendsuvm_env;
    `uvm_component_utils(mem_ctrl_env);

    mem_ctrl_agent agent;
    mem_ctrl_scoreboard scbd;

    function new(string name = "mem_ctrl_scbd", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = mem_ctrl_agent::type_id::create("agent");
        scbd  = mem_ctrl_scoreboard::type_id::create("scbd");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.analysis_port.connect(scbd.analysis_port);
    endfunction
endclass