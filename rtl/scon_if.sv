interface scon_if(input clk);
    bit reset;         // Reset signal
    bit [1:0] mode;    // Serial mode (SM0, SM1)
    bit ren;           // Receive enable (REN)
    bit tb8_set;       // Set TB8 bit (9th transmit bit)
    bit rb8_receive;   // Set RB8 bit (9th receive bit)
    bit tx_complete;   // Transmission complete flag (sets TI)
    bit rx_complete;   // Reception complete flag (sets RI)
    reg [7:0] scon;

	clocking wr_drv_cb@(posedge clk);
		default input #1 output #1;
		output reset;    
    		output mode;   
    		output ren;          
    		output tb8_set;       
    		output rb8_receive;  
    		output tx_complete;  
    		output rx_complete;
	endclocking


	clocking wr_mon_cb@(posedge clk);
		default input #1 output #1;
    		input mode;    
    		input ren;          
    		input tb8_set;      
    		input rb8_receive;   
    		input tx_complete;   
    		input rx_complete;
	endclocking

	clocking rd_mon_cb@(posedge clk);
		default input #1 output #1;
		input scon;
	endclocking

	modport WR_DRV_MP(clocking wr_drv_cb);
	modport WR_MON_MP(clocking wr_mon_cb);
	modport RD_MON_MP(clocking rd_mon_cb);
endinterface
