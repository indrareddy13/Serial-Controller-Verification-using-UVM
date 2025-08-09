class scoreboard extends uvm_component;
  `uvm_component_utils(scoreboard)

  // Analysis FIFOs for transactions
  uvm_tlm_analysis_fifo#(wr_xtns) wr_fifo;
  uvm_tlm_analysis_fifo#(wr_xtns) rd_fifo;

  // Transaction objects for write and read
  wr_xtns wr;
  wr_xtns rd;

  // Coverage group
  covergroup scon_coverage;
    coverpoint wr.mode {
      bins mode_0 = {2'b00};  // Serial Mode 0
      bins mode_1 = {2'b01};  // Serial Mode 1
      bins mode_2 = {2'b10};  // Serial Mode 2
      bins mode_3 = {2'b11};  // Serial Mode 3
    }
    coverpoint wr.ren { bins enabled = {1'b1}; bins disabled = {1'b0}; }
    coverpoint wr.tb8_set { bins tb8_on = {1'b1}; bins tb8_off = {1'b0}; }
    coverpoint wr.rb8_receive { bins rb8_on = {1'b1}; bins rb8_off = {1'b0}; }
    coverpoint wr.tx_complete { bins tx_done = {1'b1}; bins tx_not_done = {1'b0}; }
    coverpoint wr.rx_complete { bins rx_done = {1'b1}; bins rx_not_done = {1'b0}; }
  endgroup

  // Constructor
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    wr_fifo = new("wr_fifo", this);
    rd_fifo = new("rd_fifo", this);
    scon_coverage = new();
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr = wr_xtns::type_id::create("wr", this);
    rd = wr_xtns::type_id::create("rd", this);
  endfunction

  // Run Phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    fork
      begin
        forever begin
          wr_fifo.get(wr);  // Get transaction from write FIFO
        //$display("Getting dat from write monitor");  
	//wr.print();       // Debug print for write transaction
          scon_coverage.sample(); // Sample functional coverage
        end
      end

      begin
        forever begin
          rd_fifo.get(rd);  // Get transaction from read FIFO
        //$display("Getting data from Read monitor");  
	//rd.print();       // Debug print for read transaction
	compare();
        end
      end

    join

    // Perform comparison
/*	repeat(10)
    		compare();*/
/*forever
begin
  fork
      begin

       /// forever begin
          wr_fifo.get(wr);  // Get transaction from write FIFO
        //$display("Getting dat from write monitor");  
//	wr.print();       // Debug print for write transaction
        //$display("Getting data from dcoreboard1111111111111");  

          scon_coverage.sample(); // Sample functional coverage
      //  end
      end

      begin
        //forever begin

          rd_fifo.get(rd);  // Get transaction from read FIFO
        //$display("Getting data from Read monitor");  
	//rd.print();       // Debug print for read transaction
        //$display("Getting data from dcoreboard1111111111111222222222222222");  

	compare();
       // end
      end

    join
    	//	compare(); 

    // Perform comparison
//	repeat(10)


end*/



  endtask

// Compare Write and Read Transactions
task compare();
   //begin
    //wr_fifo.get(wr); // Retrieve write transaction
    //rd_fifo.get(rd); // Retrieve read transaction

    // Compare individual bits directly from rd.scon and wr.scon
    if (wr.mode == rd.scon[7:6])
      `uvm_info(get_full_name(), "MODE matched successfully.", UVM_LOW)
    else
      `uvm_error(get_full_name(), "Mismatch in MODE.")

    if (wr.ren == rd.scon[5])
      `uvm_info(get_full_name(), "REN matched successfully.", UVM_LOW)
    else
      `uvm_error(get_full_name(), "Mismatch in REN.")

    if (wr.tb8_set == rd.scon[4])
      `uvm_info(get_full_name(), "TB8_SET matched successfully.", UVM_LOW)
    else
      `uvm_error(get_full_name(), "Mismatch in TB8_SET.")

    if (wr.rb8_receive == rd.scon[3])
      `uvm_info(get_full_name(), "RB8_RECEIVE matched successfully.", UVM_LOW)
    else
      `uvm_error(get_full_name(), "Mismatch in RB8_RECEIVE.")

    if (wr.tx_complete == rd.scon[2])
      `uvm_info(get_full_name(), "TX_COMPLETE matched successfully.", UVM_LOW)
    else
      `uvm_error(get_full_name(), "Mismatch in TX_COMPLETE.")

    if (wr.rx_complete == rd.scon[1])
      `uvm_info(get_full_name(), "RX_COMPLETE matched successfully.", UVM_LOW)
    else
      `uvm_error(get_full_name(), "Mismatch in RX_COMPLETE.")
  //end
endtask

endclass

