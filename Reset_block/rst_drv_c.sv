/*The following driver drives the active low reset signal to which it is attached during the reset phase, waits a random time, takes the signal out of reset, 
and releases its objection.*/

//class: rst_drv_c

class rst_drv_c extends uvm_driver;
    `uvm_component_utils_begin
        `uvm_field_string(intf_name, UVM_ALL_ON)
        `uvm_field_int(reset_time_ps, UVM_ALL_ON | UVM_DEC)
    `uvm_component_utils_end

    //VAR: intf_name
    string intf_name = "rst_i";

    //var: reset_time_ps
    //The length of time, in ps, that reset will stay active
    rand int reset_time_ps;

    //Base Constraints
    constraint rst_cnstr {reset_time_ps inside {[1:1000000]}; }

    //var: rst_vi
    //Reset virtual interface
    virtual rst_intf rst_vi;

    function new(string name = "rst_drv", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase;
        //Get the interface
        uvm_resource_db#(virtual rst_intf)::read_by_name("rst_intf", intf_name, rst_vi);
    endfunction: build_phase

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        rst_vi.rst_n <= 0;
        #(reset_time_ps * 1ps);
        rst_vi.rst_n <= 1;
        phase.drop_objection(this);
    endtask: reset_phase

endclass: rst_drv_c
