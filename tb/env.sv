//env

class env extends uvm_env;
	`uvm_component_utils(env)


	wr_agent wr_agt;
	rd_agent rd_agt;
	env_config env_cfg;
	scoreboard sb;

	extern function new(string name="env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function env::new(string name="env", uvm_component parent);
	super.new(name,parent);
endfunction

function void env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("Config","Failed to get env config")


	if(env_cfg.has_wagent)begin
		uvm_config_db#(wr_agt_config)::set(this,"wr_agt*","wr_agt_cfg",env_cfg.wr_cfg);
		wr_agt=wr_agent::type_id::create("wr_agt",this);
	end


	if(env_cfg.has_ragent) begin
		uvm_config_db#(rd_agt_config)::set(this,"rd_agt*","rd_agt_cfg",env_cfg.rd_cfg);
		rd_agt=rd_agent::type_id::create("rd_agt",this);
	end

	sb=scoreboard::type_id::create("sb",this);
endfunction

function void env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(env_cfg.has_scoreboard) begin
		wr_agt.monh.monitor_port.connect(sb.wr_fifo.analysis_export);
		rd_agt.monh.monitor_port.connect(sb.rd_fifo.analysis_export);
	end
endfunction
