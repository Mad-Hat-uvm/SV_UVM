class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env);

    fifo_driver drv;
    fifo_monitor mon;
    fifo_scoreboard sb;
    fifo_coverage cov;

    function new(string name = "fifo_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        drv = fifo_driver::type_id::create("drv", this);
        mon = fifo_monitor::type_id::create("mon", this);
        sb  = fifo_scoreboard::type_id::create("sb", this);
        cov = fifo_coverage::type_id::create("cov", this);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(uvm_phase phase);

        //Connect monitor's analysis port to the scoreboard's analysis imp
        mon.ap.connect(sb.ap);

        //Connect monitor's analysis port to the coverage's analysis export
        mon.ap.connect(cov.analysis_export);
    endfunction
    
endclass