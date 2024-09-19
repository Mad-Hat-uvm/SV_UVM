class test extends uvm_test;
    `uvm_component_utils(test)

   function new(string inst = "test", uvm_component parent = null);
        super.new(inst, parent);
    endfunction

    env e;
    reset_dut rst_dut;
    write_data wdata;
    read_data rdata;
    write_read wr_rd;
    writeb_readb wrb_rdb;
    write_err werr;
    read_err rerr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e       = env::type_id::create("env",this);
        rst_dut = reset_dut::type_id::create("rst_dut",this);
        wdata   = write_data::type_id::create("wdata",this);
        rdata   = read_data::type_id::create("rdata",this);
        wr_rd   = write_read::type_id::create("wr_rd",this);
        wrb_rdb = writeb_readb::type_id::create("wrb_rdb",this);
        werr    = write_err::type_id::create("werr",this);
        rerr    = read_err::type_id::create("rerr",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        wr_rd.start(e.a.seqr);
        #20;
        rerr.start(e.a.seqr);
        #20;
        phase.drop_objection(this);
    endtask
endclass