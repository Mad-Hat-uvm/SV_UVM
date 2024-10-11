class driver extends uvm_driver# (transaction);
    `uvm_component_utils(driver)

    virtual axi_if vif;
    transaction tr;

    function new(input string path = "drv", uvm_component parent = null);
    super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(uvm_phase);

    tr = transaction::type_id::create("tr");

    if(!uvm_config_db# (virtual axi_if)::get(this,"vif",vif))
    `uvm_error("drv","Unable to access Interface");
    endfunction

    task reset_dut();
        begin
            `uvm_info("DRV", "System Reset: Start of Simulation", UVM_MEDIUM);
            vif.resetn       <= 1'b0; //active high reset
            vif.awvalid      <= 1'b0;
            vif.awid         <= 3'b0;
            vif.awlen        <= 0;
            vif.awsize       <= 0;
            vif.awaddr       <= 0;
            vif.awburst      <= 0;

            vif.wvalid       <= 0;
            vif.wid          <= 0;
            vif.wdata        <= 0;
            vif.wstrb        <= 0;
            vif.wlast        <= 0;

            vif.bready       <= 0;

            vif.arvalid      <= 1'b0;
            vif.arid         <= 3'b0;
            vif.araddr       <= 0;
            vif.arlen        <= 0;
            vif.arsize       <= 0;
            vif.araddr       <= 0;
            vif.arburst      <= 0;

            vif.rready       <= 0;

            @(posedge vif.clk);
        end
    endtask

    ////////////////write read in fixed mode/////////////////////

    task wrrd_fixed_wr();
        `uvm_info("DRV", "Fixed Mode Write Transaction Started", UVM_NONE);

    ///////////////////write logic//////////////////////////
        vif.resetn           <= 1'b1; //active high reset
            vif.awvalid      <= 1'b1;
            vif.awid         <= tr.id;
            vif.awlen        <= 7;
            vif.awsize       <= 2;
            vif.awaddr       <= 5;
            vif.awburst      <= 0;

            vif.wvalid       <= 1;
            vif.wid          <= tr.id;
            vif.wdata        <= $urandom_range(0,10);
            vif.wstrb        <= 4'b1111;
            vif.wlast        <= 0;

            vif.arvalid      <= 1'b0;
            vif.rready       <= 1'b0;
            vif.bready       <= 0;
            @posedge(vif.clk);

            @(posedge vif.wready);
            @posedge(vif.clk);

            for(int i = 0; i < (vif.awlen); i++) begin
                vif.wdata    <= $urandom_range(0,10);
                vif.wstrb    <= 4'b1111;
                @(posedge vif.wready);
                @(posedge vif.clk);
            end
            vif.awvalid     <= 1'b0;
            vif.wvalid      <= 1'b0;
            vif.wlast       <=1'b1;
            vif.bready      <= 1'b1;

            @(negedge vif.bvalid);
            vif.wlast       <= 1'b0;
            vif.bready      <= 1'b0;
    endtask

    /////////////////////////read logic////////////////////////

    task wrrd_fixed_rd();
        `uvm_info("DRV", "Fixed Mode Read Transaction Started", UVM_NONE);
        @(posedge vif.clk);

        vif.arvalid        <= 1'b1;
        vif.arid           <= tr.id;
        vif.arlen          <= 7;
        vif.arsize         <= 2;
        vif.araddr         <= 5;
        vif.arburst        <= 0;
        vif.rready         <= 1'b1;

        for (int i = 0; i < (vif.arlen +1); i++) begin
            @(posedge vif.arready);
            @(posedge vif.clk);
        end

        @(negedge vif.rlast);
        vif.arvalid       <= 1'b0;
        vif.rready        <= 1'b0;

    endtask

    /////////////////////////////////////////////////////////

    task wrrd_incr_wr();
        `uvm_info("DRV", "INCR Mode Write Transaction Started", UVM_NONE);

    ///////////////////write logic//////////////////////////
        vif.resetn           <= 1'b1; //active high reset
            vif.awvalid      <= 1'b1;
            vif.awid         <= tr.id;
            vif.awlen        <= 7;
            vif.awsize       <= 2;
            vif.awaddr       <= 5;
            vif.awburst      <= 1;

            vif.wvalid       <= 1'b1;
            vif.wid          <= tr.id;
            vif.wdata        <= $urandom_range(0,10);
            vif.wstrb        <= 4'b1111;
            vif.wlast        <= 0;

            vif.arvalid      <= 1'b0;
            vif.rready       <= 1'b0;
            vif.bready       <= 0;
            //@posedge(vif.clk);

            @(posedge vif.wready);
            @posedge(vif.clk);

            for(int i = 0; i < (vif.awlen); i++) begin
                vif.wdata    <= $urandom_range(0,10);
                vif.wstrb    <= 4'b1111;
                @(posedge vif.wready);
                @(posedge vif.clk);
            end
            vif.awvalid     <= 1'b0;
            vif.wvalid      <= 1'b0;
            vif.wlast       <=1'b1;
            vif.bready      <= 1'b1;

            @(negedge vif.bvalid);
            vif.wlast       <= 1'b0;
            vif.bready      <= 1'b0;
    endtask

    /////////////////////read logic//////////////////////////

    task wrrd_incr_rd();
        `uvm_info("DRV", "INCR Mode Read Transaction Started", UVM_NONE);
        @(posedge vif.clk);

        vif.arvalid        <= 1'b1;
        vif.arid           <= tr.id;
        vif.arlen          <= 7;
        vif.arsize         <= 2;
        vif.araddr         <= 5;
        vif.arburst        <= 1;
        vif.rready         <= 1'b1;

        for (int i = 0; i < (vif.arlen +1); i++) begin
            @(posedge vif.arready);
            @(posedge vif.clk);
        end

        @(negedge vif.rlast);
        vif.arvalid       <= 1'b0;
        vif.rready        <= 1'b0;

    endtask

    task wrrd_wrap_wr();
        `uvm_info("DRV", "WRAP Mode Write Transaction Started", UVM_NONE);

    ///////////////////write logic//////////////////////////
        vif.resetn           <= 1'b1; //active high reset
            vif.awvalid      <= 1'b1;
            vif.awid         <= tr.id;
            vif.awlen        <= 7;
            vif.awsize       <= 2;
            vif.awaddr       <= 5;
            vif.awburst      <= 2;

            vif.wvalid       <= 1'b1;
            vif.wid          <= tr.id;
            vif.wdata        <= $urandom_range(0,10);
            vif.wstrb        <= 4'b1111;
            vif.wlast        <= 0;

            vif.arvalid      <= 1'b0;
            vif.rready       <= 1'b0;
            vif.bready       <= 0;
            //@posedge(vif.clk);

            @(posedge vif.wready);
            @(posedge vif.clk);

            for(int i = 0; i < (vif.awlen); i++) begin
                vif.wdata    <= $urandom_range(0,10);
                vif.wstrb    <= 4'b1111;
                @(posedge vif.wready);
                @(posedge vif.clk);
            end
            vif.awvalid     <= 1'b0;
            vif.wvalid      <= 1'b0;
            vif.wlast       <=1'b1;
            vif.bready      <= 1'b1;

            @(negedge vif.bvalid);
            vif.wlast       <= 1'b0;
            vif.bready      <= 1'b0;
    endtask

    /////////////////////read logic//////////////////////////

    task wrrd_wrap_rd();
        `uvm_info("DRV", "WRAP Mode Read Transaction Started", UVM_NONE);
        @(posedge vif.clk);

        vif.arvalid        <= 1'b1;
        vif.arid           <= tr.id;
        vif.arlen          <= 7;
        vif.arsize         <= 2;
        vif.araddr         <= 5;
        vif.arburst        <= 2;
        vif.rready         <= 1'b1;

        for (int i = 0; i < (vif.arlen +1); i++) begin
            @(posedge vif.arready);
            @(posedge vif.clk);
        end

        @(negedge vif.rlast);
        vif.arvalid       <= 1'b0;
        vif.rready        <= 1'b0;

    endtask

    task err_wr();
        `uvm_info("DRV", "Error Write Transaction Started", UVM_NONE);

    ///////////////////write logic//////////////////////////
        vif.resetn           <= 1'b1; //active high reset
            vif.awvalid      <= 1'b1;
            vif.awid         <= tr.id;
            vif.awlen        <= 7;
            vif.awsize       <= 2;
            vif.awaddr       <= 128;
            vif.awburst      <= 0;

            vif.wvalid       <= 1'b1;
            vif.wid          <= tr.id;
            vif.wdata        <= $urandom_range(0,10);
            vif.wstrb        <= 4'b1111;
            vif.wlast        <= 0;

            vif.arvalid      <= 1'b0;
            vif.rready       <= 1'b0;
            vif.bready       <= 0;
            //@posedge(vif.clk);

            @(posedge vif.wready);
            @(posedge vif.clk);

            for(int i = 0; i < (vif.awlen); i++) begin
                vif.wdata    <= $urandom_range(0,10);
                vif.wstrb    <= 4'b1111;
                @(posedge vif.wready);
                @(posedge vif.clk);
            end
            vif.awvalid     <= 1'b0;
            vif.wvalid      <= 1'b0;
            vif.wlast       <=1'b1;
            vif.bready      <= 1'b1;

            @(negedge vif.bvalid);
            vif.wlast       <= 1'b0;
            vif.bready      <= 1'b0;
    endtask

    /////////////////////read logic//////////////////////////

    task err_rd();
        `uvm_info("DRV", "Error Read Transaction Started", UVM_NONE);
        @(posedge vif.clk);

        vif.arvalid        <= 1'b1;
        vif.arid           <= tr.id;
        vif.arlen          <= 7;
        vif.arsize         <= 2;
        vif.araddr         <= 5;
        vif.arburst        <= 0;
        vif.rready         <= 1'b1;

        for (int i = 0; i < (vif.arlen +1); i++) begin
            @(posedge vif.arready);
            @(posedge vif.clk);
        end

        @(negedge vif.rlast);
        vif.arvalid       <= 1'b0;
        vif.rready        <= 1'b0;

    endtask

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
            if(tr.op == rstdut) 
            reset_dut();

            else if (tr.op == wrrdfixed) begin
                `uvm_info("DRV", $sformatf("Fixed Mode Write -> Read WLEN:%0d WSIZE: %0d", tr.awlen+1, tr.awsize), UVM_NONE);
                wrrd_fixed_wr();
                wrrd_fixed_rd();
            end

            else if (tr.op == wrrdincr) begin
                `uvm_info("DRV", $sformatf("INCR Mode Write -> Read WLEN:%0d WSIZE: %0d", tr.awlen+1, tr.awsize), UVM_NONE);
                wrrd_incr_wr();
                wrrd_incr_rd();
            end

            else if (tr.op == wrrdwrap) begin
                `uvm_info("DRV", $sformatf("WRAP Mode Write -> Read WLEN:%0d WSIZE: %0d", tr.awlen+1, tr.awsize), UVM_NONE);
                wrrd_wrap_wr();
                wrrd_wrap_rd();
            end

            else if (tr.op == wrrderrfix) begin
                `uvm_info("DRV", $sformatf("Error Transaction Mode WLEN:%0d WSIZE: %0d", tr.awlen+1, tr.awsize), UVM_NONE);
                err_wr();
                err_rd();
            end
            seq_item_port.item_done();
        end
    endtask
endclass