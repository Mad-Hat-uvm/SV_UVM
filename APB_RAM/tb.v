module tb;

    apb_if vif();

    apb_ram dut (.presetn(vif.presetn), .pclk(vif.pclk), .psel(vif.psel), .penable(vif.penable), .pwrite(vif.pwrite), .paddr(vif.paddr), .pwdata(vif.pwdata), .prdata(vif.prdata), .pslverr(vif.pslverr), .pready(vif.pready));

    initial begin
        vif.pclk <= 0;
    end

    always #10 vif.pclk <= ~vif.pclk;

    initial begin
     uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
     run_test("test");
    end

    initial begin
        $dumpfile("dmp.vcd");
        $dumpvars;
    end
endmodule