class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard);

    virtual fifo_if.sb vif;     //Use the sb modport
    uvm_analysis_imp#(fifo_transaction, fifo_scoreboard) ap;
    queue#(bit [7:0]) expected_fifo;

    function new(string name = "fifo_scoreboard", uvm_component parent);
        super.new(name, parent);
        ap =new("ap",this);
        expected_fifo = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if.sb)::get(this, "", "vif", vif))
         `uvm_fatal("NOVIF", "No virtual interface for scoreboard found via uvm_config_db");
    endfunction

    virtual function void write(fifo_transaction tr);
        //Handle Write transactions
        if(tr.wr_en && !vif.full) begin
            // Push written data into reference model
            expected_fifo.push_back(tr.wr_data);
            `uvm_info("FIFO_SB", $sformatf("Data written to FIFO: %0h", tr.wr_data), UVM_LOW);
        end

        //Handle Read transactions
        if(tr.rd_en && !vif.empty) begin
            if(expected_fifo.size() > 0) begin
                bit [7:0] expected_data = expected_fifo.pop_front();

                //Check if read data matches the earliest written unread data
                if(tr.rd_data === expected_data) begin
                    `uvm_info("FIFO_SB", $sformatf("Data read from FIFO matches expected: %0h", tr.rd_data), UVM_LOW);
                end else begin
                    `uvm_error("FIFO_MISMATCH", $sformatf("Data read mismatch. Expected: %0h, Got: %0h", expected_data, tr.rd_data));
                end
            end else begin
                `uvm_warning("FIFO_UNDERFLOW", "Read attempted when FIFO is empty.");
            end

        end
    endfunction
    
endclass
