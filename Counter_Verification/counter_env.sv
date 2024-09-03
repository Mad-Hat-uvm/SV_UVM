class counter_env extends uvm_env;
  `uvm_component_utils(counter_env)

  counter_env_config m_cfg;

  counter_input_agent input_agent;
  counter_output_agent output_agent;
  counter_scoreboard scoreboard;
  
  function new(string name = "counter_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(m_cfg.has_input_agent) begin
    input_agent  = counter_input_agent::type_id::create("input_agent", this);
    end
    if(m_cfg.has_output_agent) begin
    output_agent = counter_output_agent::type_id::create("output_agent", this);
    end
    if(m_cfg.has_scoreboard) begin
    scoreboard   = counter_scoreboard::type_id::create("scoreboard", this);
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    uvm_top.print_topology();

    if(m_cfg.has_input_agent && m_cfg.has_scoreboard) begin
      input_agent.mon.monitor_output.connect(scoreboard.input_mon_fifo.analysis_export);
    end
    if(m_cfg.has_output_agent && m_cfg.has_scoreboard) begin
      output_agent.mon_o.monitor_output_o.connect(scoreboard.output_mon_fifo.analysis_export);
    end
    
  endfunction
  
endclass: counter_env
