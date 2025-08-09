//wr_xtn

class wr_xtns extends uvm_sequence_item;
	`uvm_object_utils(wr_xtns)

	bit reset;    
    	rand bit[1:0] mode;   
    	rand bit ren;          
    	rand bit tb8_set;       
    	rand bit rb8_receive;  
    	rand bit tx_complete;  
    	rand bit rx_complete;
	bit[7:0] scon;

	extern function new(string name="wr_xtns");
	extern function void do_print(uvm_printer printer);
endclass

function wr_xtns::new(string name="wr_xtns");
	super.new(name);
endfunction

function void wr_xtns::do_print(uvm_printer printer);
    super.do_print(printer);  // Ensure base class implementation is included
    printer.print_field("mode", this.mode, 2, UVM_BIN);
    printer.print_field("ren", this.ren, 1, UVM_BIN);
    printer.print_field("tb8_set", this.tb8_set, 1, UVM_BIN);
    printer.print_field("rb8_receive", this.rb8_receive, 1, UVM_BIN);
    printer.print_field("tx_complete", this.tx_complete, 1, UVM_BIN);
    printer.print_field("rx_complete", this.rx_complete, 1, UVM_BIN);
endfunction

