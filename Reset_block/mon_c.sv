class mon_c extends uvm_monitor;
 `uvm_component_utils(mon_c)

.....

virtual task run_phase(uvm_phase phase);
    forever begin 
        @(posedge my_vi.rst_n);
        fork
            monitir_items();
        join_none

        @(negedge my_vi.rst_n);
         disable fork;
         cleanup();
    end
endtask: run_phase

virtual task monitor_items();
    forever begin
        ...
    end
endtask: monitor_items()

endclass : mon_c