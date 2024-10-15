class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)

    uvm_analysis_imp#(fifo_transaction, fifo_coverage) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

   // Covergroup for FIFO operations
    covergroup cov_fifo;

        //Coverpoint for write enable(wr_en)
        coverpoint wr_en{
            bins wr_enabled = {1};
            bins wr_enabled = {0};
        }

        //Coverpoint for read enable(rd_en)
        coverpoint rd_en{
            bins rd_enabled = {1};
            bins rd_enabled = {0};
        }

        //Coverage to write transactions at different FIFO depths
        write_coverage : coverpoint fifo_depth {
            bins empty_fifo   = {0};                  //Covers writes when FIFO is empty
            bins partial_fifo = {[1:max_fifo_size-1]}; //Cover writes when FIFO is partially filled
            bins full_fifo    = {max_fifo_size}; 
        }

         //Coverage to read transactions at different FIFO depths
        read_coverage : coverpoint fifo_depth {
            bins empty_fifo   = {0};                  //Covers reads when FIFO is empty
            bins partial_fifo = {[1:max_fifo_size-1]}; //Cover reads when FIFO is partially filled
            bins full_fifo    = {max_fifo_size}; 
        }
        
        //Cross-coverage between depth and flags(full and empty)
        depth_flag_coverage : cross fifo_depth, full_flag, empty_flag;

        //Cross coverage of read and write enables
        rw_coverage : cross wr_en, rd_en;
    endgroup 

     //Analysis port write function to capture transactions
    function void write(fifo_transaction tr);
        sample_coverage(tr.wr_en,tr.rd_en, tr.full, tr.empty, fifo_depth, max_fifo_size);
    endfunction

    function void read(fifo_transaction tr);
        sample_coverage(tr.wr_en,tr.rd_en, tr.full, tr.empty, fifo_depth, max_fifo_size);
    endfunction
    //Coverage sampling function
    function void sample_coverage(bit wr_en, bit rd_en, bit full_flag, bit empty_flag, int fifo_depth, int max_fifo_size);
    
        if(tr.wr_en) begin
            cov_fifo.write_coverage.sample();
        end

        if(tr.rd_en) begin
            cov_fifo.read_coverage.sample();
        end
        cov_fifo.depth_flag_coverage.sample();
        cov_fifo.rw_coverage.sample();
    
    endfunction
endclass