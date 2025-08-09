//wr_agent

class wr_agent extends uvm_agent;
	`uvm_component_utils(wr_agent)

	wr_driver drvh;
	wr_sequencer seqr;
	wr_monitor monh;

	wr_agt_config m_cfg;

	extern function new(string name="wr_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function wr_agent::new(string name="wr_agent", uvm_component parent);
	super.new(name,parent);
endfunction

function void wr_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	monh=wr_monitor::type_id::create("monh",this);
	if(!uvm_config_db#(wr_agt_config)::get(this,"","wr_agt_cfg",m_cfg))
		`uvm_fatal("Config","Failed to get config in write agent");
	if(m_cfg.is_active==UVM_ACTIVE) begin
		drvh=wr_driver::type_id::create("drvh",this);
		seqr=wr_sequencer::type_id::create("seqr", this);
	end
endfunction

function void wr_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(m_cfg.is_active==UVM_ACTIVE)
		drvh.seq_item_port.connect(seqr.seq_item_export);
endfunction
