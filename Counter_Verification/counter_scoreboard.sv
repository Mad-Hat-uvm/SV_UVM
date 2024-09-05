class counter_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (counter_scoreboard)
 
  //Analysis FIFOs to receive transactions from monitors
  uvm_tlm_analysis_fifo# (counter_trans) input_mon_fifo;
  uvm_tlm_analysis_fifo# (counter_trans) output_mon_fifo;

  //Transaction objects for input, output, expected output and coverage
  counter_trans input_mon_pkt;
  counter_trans output_mon_pkt;
  counter_trans expected_output_pkt;
  counter_trans cov_data_pkt;

  //Counters for tracking verified data and received packets
  int data_verified = 0;
  int input_mon_pkt_cnt = 0;
  int output_mon_pkt_cnt = 0;

  //Covergroup for coverage analysis
  covergroup counter_coverage;
    option.per_instance = 1; //Enable per-instance coverage
    LOAD_DATA : coverpoint cov_data_pkt.data_in { // Coverage bins for data_in

      bins ZERO             = {0};
      bins LOW1             = {[1:2]};
      bins LOW2             = {[3:4]};
      bins MID_LOW          = {[5:6]};
      bins MID              = {[7:8]};
      bins MID_HIGH         = {[9:10]};
      bins HIGH1            = {[11:12]};
      bins HIGH2            = {[13:14]};
      bins MAX              = {[15]};
    }

    RESET_CMD  : coverpoint cov_data_pkt.rst { //Coverage bins for reset signal

      bins cmd_rst          = {0, 1};
    }

    LOAD_CMD   : coverpoint cov_data_pkt.load{  //Coverage bins for load signal

      bins cmd_load         = {0, 1};

    }

    READxWRITE : cross LOAD_CMD, LOAD_DATA;

  endgroup
  
  function new(string name = "counter_scoreboard", uvm_component parent = null);
    super.new(name, parent);

    input_mon_fifo  = new("input_mon_fifo", this); //Initialize the input FIFO
    output_mon_fifo = new("output_mon_fifo", this); //Initialize the output FIFO

    counter_coverage = new; // Initialize the covergroup

  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    input_mon_pkt       = counter_trans::type_id::create("input_mon_pkt");
    output_mon_pkt      = counter_trans::type_id::create("output_mon_pkt");
    expected_output_pkt = counter_trans::type_id::create("expected_output_pkt");
    cov_data_pkt        = counter_trans::type_id::create("cov_data_pkt");
    
  endfunction

  //Run phase to continuously check for input and output transactions
  task run_phase(uvm_phase phase);
    forever begin
      //Get transactions from the input monitor FIFO
       input_mon_fifo.get(input_mon_pkt);
       input_mon_pkt_cnt++;
       `uvm_info(get_type_name(), $sformatf("Scoreboard has received the following packet from the input monitor: \n%s", input_mon_pkt.sprint()), UVM_LOW);

       //Get transactions from the output monitor FIFO
       output_mon_fifo.get(output_mon_pkt);
       output_mon_pkt_cnt++;
       `uvm_info(get_type_name(), $sformatf("Scoreboard has received the following packet from the output monitor: \n%s", output_mon_pkt.sprint()), UVM_LOW);

       //Perform reference model logic and validation
       ref_model_logic() ;
       validate_output() ;
    end
  endtask : run_phase

  virtual task validate_output() ;
    if (!expected_output_pkt.compare(output_mon_pkt)) begin:
      `uvm_error(get_type_name(), "Data Mismatch");
      `uvm_info(get_type_name(), $sformatf("Expected packet is: \n%s", expected_output_pkt.sprint()), UVM_LOW);
      `uvm_info(get_type_name(), $sformatf("DUT's output packet is: \n%s", output_mon_pkt.sprint()), UVM_LOW);
    end
    else begin
      `uvm_info(get_type_name(), "Data Match Successful", UVM_LOW);
      data_verified++;
    end

    //Update coverage with the current input transaction
     cov_data_pkt = input_mon_pkt;
     counter_coverage.sample(); // Sample the coverage data
     `uvm_info(get_type_name(), $sformatf("STDOUT: % 3.2f%% coverage achieved. ", counter_coverage.get_inst_coverage()), UVM_LOW);
  endtask : validate_output

  function void report_phase(uvm_phase phase);
    $display("\n---------------------SCOREBOARD-----------------------\n") ;
    $display("Input monitor packet count = %");
  endfunction

 
  
endclass
