//wr_monitor

class wr_monitor extends uvm_monitor;
	`uvm_component_utils(wr_monitor)

	virtual scon_if.WR_MON_MP vif;
	wr_agt_config agt_cfg;

	wr_xtns xtn;
	uvm_analysis_port #(wr_xtns)monitor_port;

	extern function new(string name="wr_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect();
endclass

function wr_monitor::new(string name="wr_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port", this);
endfunction

function void wr_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(wr_agt_config)::get(this,"","wr_agt_cfg",agt_cfg))
		`uvm_fatal("CONFIG","Failed to get config at write driver")
endfunction

function void wr_monitor::connect_phase(uvm_phase phase);
	vif=agt_cfg.vif;
endfunction

task wr_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	@(vif.wr_mon_cb);

	forever begin
		//@(vif.wr_mon_cb);
		collect();
	end
endtask

task wr_monitor::collect();
	xtn=wr_xtns::type_id::create("xtn",this);
	repeat(2)
		@(vif.wr_mon_cb);
	xtn.mode=vif.wr_mon_cb.mode;
	xtn.ren=vif.wr_mon_cb.ren;
	xtn.tb8_set=vif.wr_mon_cb.tb8_set;
	xtn.rb8_receive=vif.wr_mon_cb.rb8_receive;
	xtn.tx_complete=vif.wr_mon_cb.tx_complete;
	xtn.rx_complete=vif.wr_mon_cb.rx_complete;
	//`uvm_info("WRITE Monitor","Write Monitor Collected Data",UVM_LOW)
	//xtn.print;
	monitor_port.write(xtn);
endtask
