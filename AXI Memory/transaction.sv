`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [2:0] {wr_rdfixed = 0, wrrdincr = 1, wrrdwrap = 2, wrrderrfix = 3, rstdut = 4 } oper_mode;

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction);

    //  Constructor: new
    function new(string name = "transaction");
        super.new(name);
    endfunction: new

   int len = 0;
   rand bit [3:0] id;
   oper_mode op;

   //Write address channel signals//
  
   rand bit awvalid;
   rand bit [3:0] awlen;
   rand bit [2:0] awsize;
   rand bit [31:0] awaddr;
   rand bit [1:0] awburst;
        bit [3:0] awid;
        bit awready;

   //Write data channel//
   
        bit wvalid;
   rand bit [3:0] wid;
   rand bit [31:0] wdata;
   rand bit [3:0] wstrb;
        bit wlast;
        bit wready;

   //Write response channel

        bit bready;
        bit bvalid;
        bit [3:0] bid;
        bit [1:0] bresp;

   //Read address channel

   rand bit arvalid;
        bit arready;
        bit arrid;
   rand bit [3:0] arlen;
   rand bit [31:0] araddr;
        bit [2:0] arsize;
   rand bit [1:0] arburst;

   //Read Data channel

        bit [3:0] rid;
        bit [31:0] rdata;
        bit [1:0] rresp;
        bit rlast;
        bit rvalid;

   constraint txid { awid == id; wid == id; arrid == id; rid == id; }
   constraint burst { awburst inside {0,1,2}; arburst inside {0,1,2}; }
   constraint valid { awvalid != arvalid; }
   constraint length { awlen = arlen; }

endclass: transaction



