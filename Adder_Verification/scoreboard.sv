class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
 
  uvm_analysis_port #(seq_item, scoreboard) item_collect_export;
  seq_item item_q[$];

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_export = new("item_collect_export", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void write(seq_item req);
    `uvm_info(get_type_name(), $sformatf("Received transaction = %s", req), UVM_LOW);
    item_q.push_back(req);
  endfunction

  task run_phase(uvm_phase phase);
    seq_item sb_item;
    forever begin
      wait(item_q.size > 0) begin
        sb_item = item_q.pop_front();
        //Checking comparing logic
      end
    end
  endtask
  
endclass
