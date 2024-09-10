class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    virtual apb_if vif;
    transaction tr;

    function new(string name = "drv", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        tr = transaction::type_id::create("tr");

        if(!uvm_config_db# (virtual apb_if)::get(this,"","vif",vif))
        `uvm_error("drv", "Unable to accress interface");
    endfunction

    task reset_dut();

        repeat(5) begin
            vif.presetn <= 1'b0;
            vif.paddr   <= 'h0;
            vif.pwdata  <= 'h0;
            vif.penable <= 1'b0;
            vif.psel    <= 1'b0;
            vif.pwrite  <= 1'b0;

            `uvm_info("DRV", "System Reset: Start of Simulation", UVM_MEDIUM);
            @(posedge vif.pclk);
        end
    endtask

    task drive();
     reset_dut();

     forever begin
        seq_item_port.get_next_item(tr);

        if (tr.op == rst) begin
            vif.presetn <= 1'b0;
            vif.psel    <= 1'b0;
            vif.paddr   <= 'h0;
            vif.pwdata  <= 'h0;
            vif.pwrite  <= 1'b0;
            vif.penable <= 1'b0;
            @(posedge vif.pclk);
         
        else if(tr.op == writed) begin
            vif.psel    <= 1'b1;
            vif.paddr   <= tr.PADDR;
            vif.pwdata  <= tr.PWDATA;
            vif.presetn <= 1'b1;
            vif.pwrite  <= 1'b1;
            @(posedge vif.pclk);
            vif.penable <= 1'b1;
            `uvm_info("DRV", $sformatf("mode:%0s, addr:%0d, wdata:%0d, rdata:%0d",tr.op,tr.PADDR,tr.PWDATA,tr.PRDATA),UVM_NONE);
            @(negedge vif.pready);
            vif.penable <= 1'b0;
            tr.PSLVERR  <= vif.pslverr;
            `uvm_info("DRV", $sformatf("mode:%0s, addr:%0d, wdata:%0d, rdata:%0d, slverr:%0d",tr.op,tr.PADDR,tr.PWDATA,tr.PRDATA,tr.PSLVERR),UVM_NONE);
         end

         else if(tr.op == readd) begin
            vif.psel    <= 1'b1;
            vif.paddr   <= tr.PADDR;
            vif.presetn <= 1'b1;
            vif.pwrite  <= 1'b0;
            @(posedge vif.pclk);
            vif.penable <= 1'b1;
            `uvm_info("DRV", $sformatf("mode:%0s, addr:%0d, wdata:%0d, rdata:%0d",tr.op,tr.PADDR,tr.PWDATA,tr.PRDATA),UVM_NONE);
            @(negedge vif.pready);
            vif.penable <= 1'b0;
            tr.PRDATA   <= vif.prdata;
            tr.PSLVERR  <= vif.pslverr;
            `uvm_info("DRV", $sformatf("mode:%0s, addr:%0d, wdata:%0d, rdata:%0d, slverr:%0d",tr.op,tr.PADDR,tr.PWDATA,tr.PRDATA,tr.PSLVERR),UVM_NONE);
         end
        seq_item_port.item_done(tr);
     end
    endtask

    virtual task run_phase(uvm_phase phase);
        drive();
    endtask

endclass: driver