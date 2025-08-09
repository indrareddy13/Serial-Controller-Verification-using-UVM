//wr_driver

class wr_driver extends uvm_driver #(wr_xtns);
	`uvm_component_utils(wr_driver)

	virtual scon_if.WR_DRV_MP vif;
	wr_agt_config agt_cfg;

	extern function new(string name="wr_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive(wr_xtns xtn);
endclass

function wr_driver::new(string name="wr_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void wr_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(wr_agt_config)::get(this,"","wr_agt_cfg",agt_cfg))
		`uvm_fatal("CONFIG","Failed to get config at write driver")
endfunction

function void wr_driver::connect_phase(uvm_phase phase);
	vif=agt_cfg.vif;
endfunction

task wr_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    vif.wr_drv_cb.reset <= 1;
    @(vif.wr_drv_cb);
    vif.wr_drv_cb.reset <= 0;
    @(vif.wr_drv_cb);

    forever begin
        //`uvm_info("DRIVER", "Waiting for sequence item...", UVM_LOW);
        seq_item_port.get_next_item(req);
        if (req == null) begin
            `uvm_error("DRIVER", "Received null request");
            break;  // Exit forever loop if null
        end
        //`uvm_info("DRIVER", $sformatf("Received item:\n%s", req.sprint()), UVM_MEDIUM);
        drive(req);
        seq_item_port.item_done();
    end
endtask

task wr_driver::drive(wr_xtns xtn);
  if (xtn == null) begin
    `uvm_error("DRIVER", "xtn is null")
    return;
  end
  `uvm_info("WRITE DRIVER","Write Driver sending Data",UVM_LOW)
  xtn.print();  // Verify this outputs to the console

  vif.wr_drv_cb.mode <= xtn.mode;
  vif.wr_drv_cb.ren <= xtn.ren;
  vif.wr_drv_cb.tb8_set <= xtn.tb8_set;
  vif.wr_drv_cb.rb8_receive <= xtn.rb8_receive;
  vif.wr_drv_cb.tx_complete <= xtn.tx_complete;
  vif.wr_drv_cb.rx_complete <= xtn.rx_complete;
  repeat(2)
	@(vif.wr_drv_cb);
endtask

