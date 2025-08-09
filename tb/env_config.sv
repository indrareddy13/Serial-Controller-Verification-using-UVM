
class env_config extends uvm_object;
	`uvm_object_utils(env_config)


	int has_wagent=1;
	int has_ragent=1;
	int has_scoreboard=1;

	wr_agt_config wr_cfg;
	rd_agt_config rd_cfg;

	extern function new(string name="env_config");
endclass

function env_config::new(string name="env_config");
	super.new(name);
endfunction
