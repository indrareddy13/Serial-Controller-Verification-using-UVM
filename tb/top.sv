module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import pkg::*;

    // Clock signal
    bit clk;  
    always #10 clk = ~clk; // Clock generation

    // Instantiate the interface
    scon_if vif(clk);

    // Instantiate the DUT (SCON)
    SCON DUV (
        .clk(clk),                    // Clock input
        .reset(1'b0),                 // No reset logic, tied to 0
        .mode(vif.mode),              // Connect mode signal from the interface
        .ren(vif.ren),                // Connect REN signal from the interface
        .tb8_set(vif.tb8_set),        // Connect TB8 signal from the interface
        .rb8_receive(vif.rb8_receive),// Connect RB8 signal from the interface
        .tx_complete(vif.tx_complete),// Connect TX complete flag from the interface
        .rx_complete(vif.rx_complete),// Connect RX complete flag from the interface
        .scon(vif.scon)               // Connect SCON register to the interface
    );

    // Testbench setup
    initial begin
	`ifdef VCS
		$fsdbDumpvars(0,top);
	`endif
        // Bind the virtual interface to the UVM environment
        uvm_config_db#(virtual scon_if)::set(null, "*", "vif", vif);

        // Run the UVM test
        run_test("test");
    end
endmodule

