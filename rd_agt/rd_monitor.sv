//rd_monitor

class rd_monitor extends uvm_monitor;
	`uvm_component_utils(rd_monitor)
	virtual scon_if.RD_MON_MP vif;
	rd_agt_config agt_cfg;

	wr_xtns xtn2;
	uvm_analysis_port#(wr_xtns)monitor_port;

	extern function new(string name="rd_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect();
endclass

function rd_monitor::new(string name="rd_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port", this);
endfunction

function void rd_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(rd_agt_config)::get(this,"","rd_agt_cfg",agt_cfg))
		`uvm_fatal("CONFIG","Failed to get config at write driver")
	
endfunction

function void rd_monitor::connect_phase(uvm_phase phase);
	vif=agt_cfg.vif;
endfunction

task rd_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(3)begin //3
		@(vif.rd_mon_cb);
	end
	forever
		collect();
endtask

task rd_monitor::collect();
    xtn2 = wr_xtns::type_id::create("xtn", this);
    repeat(1)begin
	    @(vif.rd_mon_cb);
	end
    xtn2.scon = vif.rd_mon_cb.scon;

    // Print scon using uvm_info
    `uvm_info("READ MONITOR", $sformatf("Read Monitor Collected scon: %0d", xtn2.scon), UVM_LOW)
	`uvm_info("Acknowledgement","______________Done transaction_______________",UVM_LOW)
    // If you want a detailed print of the transaction, use xtn.sprint()
    //`uvm_info("READ MONITOR", $sformatf("Transaction Details:\n%s", xtn2.sprint()), UVM_LOW)

    @(vif.rd_mon_cb);
    //`uvm_info("READ MONITOR", "Read Monitor collected Data", UVM_LOW)
    
    // Uncomment if using analysis ports to forward data
     monitor_port.write(xtn2);
endtask

