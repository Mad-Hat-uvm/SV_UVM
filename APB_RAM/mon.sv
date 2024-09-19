class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    uvm_analysis_port#(transaction) send;
    virtual apb_if vif;
    transaction tr;

    function new(string name = "drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        tr   = transaction::type_id::create("tr");
        send = new("send",this);

        if(!uvm_config_db# (virtual apb_if)::get(this,"","vif",vif))
        `uvm_error("drv", "Unable to accress interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.pclk);
            if(!vif.presetn) begin
                tr.op    = rst;
                `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
            end

            else if (vif.presetn && vif.pwrite) begin
                @(negedge vif.pready);
                tr.op    = writed;
                tr.PWDATA = vif.pwdata;
                tr.PADDR  = vif.paddr;
                tr.PSLVERR = vif.pslverr;

                `uvm_info("MON",$sformatf("DATA WRITE addr:%0d, wdata:%0d, rdata:%0d",tr.PADDR,tr.PWDATA,tr.PRDATA),UVM_NONE);
                    send.write(tr);
            end
            else if (vif.presetn && !vif.pwrite) begin
                @(negedge vif.pready);
                tr.op    = readd;
                tr.PWDATA = vif.pwdata;
                tr.PADDR  = vif.paddr;
                tr.PSLVERR = vif.pslverr;

                `uvm_info("MON",$sformatf("DATA READ addr:%0d, wdata:%0d, rdata:%0d",tr.PADDR,tr.PWDATA,tr.PRDATA),UVM_NONE);
                    send.write(tr);
            end
        end
    endtask

endclass: mon