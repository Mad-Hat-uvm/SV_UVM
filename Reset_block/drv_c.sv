class drv_c extends uvm_driver;
    `uvm_component_utils(drv_c)

    event reset_driver;

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge my_vi.rst_n);
            fork
                driver();
            join_none

            @(reset_driver);
            disable fork;
            cleanup();
        end
    endtask : run_phase

    virtual task driver();
        forever begin
            ...
        end
    endtask : driver
endclass : drv_c