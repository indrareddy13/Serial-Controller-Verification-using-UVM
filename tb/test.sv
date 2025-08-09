class test extends uvm_test;
    `uvm_component_utils(test)

    env envh;
    env_config env_cfg;

    wr_agt_config wr_cfg;
    rd_agt_config rd_cfg;

    wr_seqs seqs;

    function new(string name="test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_cfg = env_config::type_id::create("env_cfg");
        wr_cfg = wr_agt_config::type_id::create("wr_cfg");
        rd_cfg = rd_agt_config::type_id::create("rd_cfg");

        if (!uvm_config_db#(virtual scon_if)::get(this, "", "vif", wr_cfg.vif))
            `uvm_fatal("Config", "failed to get config at test");
        env_cfg.wr_cfg = wr_cfg;

        if (!uvm_config_db#(virtual scon_if)::get(this, "", "vif", rd_cfg.vif))
            `uvm_fatal("Config", "failed to get config at test");
        env_cfg.rd_cfg = rd_cfg;

        uvm_config_db#(env_config)::set(this, "*", "env_config", env_cfg);
        envh = env::type_id::create("envh", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
	phase.raise_objection(this);
        seqs = wr_seqs::type_id::create("seqs");
        seqs.start(envh.wr_agt.seqr);  // Ensure this starts the sequence properly
	phase.drop_objection(this);
    endtask
endclass

