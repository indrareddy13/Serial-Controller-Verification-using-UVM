//wr_seqs

class wr_seqs extends uvm_sequence #(wr_xtns);
	`uvm_object_utils(wr_seqs)
	//wr_xtns req;
	
	extern function new(string name="wr_seqs");
	extern task body();
endclass

function wr_seqs::new(string name="wr_seqs");
	super.new(name);
endfunction

task wr_seqs::body();
    repeat(10) begin
        req = wr_xtns::type_id::create("req");
        start_item(req);
	assert(req.randomize()) else `uvm_error("SEQ", "Failed to randomize req");
        //`uvm_info("SEQ", $sformatf("Generated item:\n%s", req.sprint()), UVM_LOW);
        finish_item(req);
    end
endtask

