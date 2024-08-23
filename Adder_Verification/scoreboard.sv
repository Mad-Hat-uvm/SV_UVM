class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
 
  uvm_analysis_imp #(seq_item, scoreboard) item_collect_export;
  seq_item item_q[$];
  seq_item sb_item;

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_export = new("item_collect_export", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_item = seq_item::type_id::create("TRANS");
  endfunction

 virtual function void write(input seq_item req);
    item_q.push_back(req);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      wait(item_q.size > 0);

        if(item_q.size > 0) begin
          sb_item = item_q.pop_front();
          $display("--------------------------------------------------------------------------------------------------------------------------------");
          if(sb_item.ip1 + sb_item.ip2 == sb_item.out) begin
            `uvm_info(get_type_name(), $sformatf("Matched: ip1 = %0d, ip2 = %0d , out = %0d",sb_item.ip1, sb_item.ip2, sb_item.out), UVM_LOW);
          end
          else begin
            `uvm_error(get_type_name(), $sformatf("Not Matched: ip1 = %0d, ip2 = %0d , out = %0d",sb_item.ip1, sb_item.ip2, sb_item.out));
          end
         $display("--------------------------------------------------------------------------------------------------------------------------------");
      end
    end
  endtask
  
endclass
