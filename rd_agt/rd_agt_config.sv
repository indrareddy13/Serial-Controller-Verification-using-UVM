//rd_agt_config
class rd_agt_config extends uvm_object;
	`uvm_object_utils(rd_agt_config)

	virtual scon_if vif;
	uvm_active_passive_enum is_active=UVM_PASSIVE;

	extern function new(string name="rd_agt_config");
endclass

function rd_agt_config::new(string name="rd_agt_config");
	super.new(name);
endfunction
