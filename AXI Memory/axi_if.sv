 //////////////////////////////////////////////
   
  interface axi_if();
    
    ////////write address channel (aw)
    
    logic awvalid;  /// master is sending new address  
    logic awready;  /// slave is ready to accept request
    logic [3:0] awid; ////// unique ID for each transaction
    logic [3:0] awlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
    logic [2:0] awsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
    logic [31:0] awaddr; ////write adress of transaction
    logic [1:0] awburst; ////burst type : fixed , INCR , WRAP
    
    
    //////////write data channel (w)
    logic wvalid; //// master is sending new data
    logic wready; //// slave is ready to accept new data 
    logic [3:0] wid; /// unique id for transaction
    logic [31:0] wdata; //// data 
    logic [3:0] wstrb; //// lane having valid data
    logic wlast; //// last transfer in write burst
    
    
    //////////write response channel (b) 
    logic bready; ///master is ready to accept response
    logic bvalid; //// slave has valid response
    logic [3:0] bid; ////unique id for transaction
    logic [1:0] bresp; /// status of write transaction 
    
    ///////////////read address channel (ar)
   
    logic arvalid;  /// master is sending new address  
    logic arready;  /// slave is ready to accept request
    logic [3:0] arid; ////// unique ID for each transaction
    logic [3:0] arlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
    logic [2:0] arsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
    logic [31:0] araddr; ////write adress of transaction
    logic [1:0] arburst; ////burst type : fixed , INCR , WRAP
    
    /////////// read data channel (r)
    
    logic rvalid; //// master is sending new data
    logic rready; //// slave is ready to accept new data 
    logic [3:0] rid; /// unique id for transaction
    logic [31:0] rdata; //// data 
    logic [3:0] rstrb; //// lane having valid data
    logic rlast; //// last transfer in write burst
    logic [1:0] rresp; ///status of read transfer
    
    ////////////////
    
    logic clk;
    logic resetn;
    
    //////////////////
    logic [31:0] next_addrwr;
    logic [31:0] next_addrrd;
    
    
   
    
  endinterface 