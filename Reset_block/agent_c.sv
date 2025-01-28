class agent_c extends uvm_agent;
    `uvm_component_utils(agent_c)

    sqr_c sqr;
    rst_drv_c drv;
    ...
    virtual task pre_reset_phase(uvm_phase phase);
        if(sqr && drv) begin
            sqr.stop_sequences();
            ->drv.reset_driver;
        end
    endtask : pre_reset_phase
endclass : agent_c