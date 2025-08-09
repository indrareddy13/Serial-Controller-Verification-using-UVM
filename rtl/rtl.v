/*  Specification:
 
The “SCON (Serial Control) register” in the 8051 microcontroller is an 8-bit register used to configure and control the serial communication functionality via the UART. It allows selection of different serial modes (Mode 0 to Mode 3) and manages essential features like enabling reception, handling 9-bit data communication, and controlling interrupts for transmission and reception. The register also includes flags for the transmission complete (“TI”) and reception complete (“RI”) interrupts, ensuring smooth serial data transfer operations.
*/
// Original

  module SCON (
    input  clk,           // Clock signal
    input  reset,         // Reset signal
    input  [1:0] mode,    // Serial mode (SM0, SM1)
    input  ren,           // Receive enable (REN)
    input  tb8_set,       // Set TB8 bit (9th transmit bit)
    input  rb8_receive,   // Set RB8 bit (9th receive bit)
    input  tx_complete,   // Transmission complete flag (sets TI)
    input  rx_complete,   // Reception complete flag (sets RI)
    output reg [7:0] scon     // Serial Control Register (SCON)
);

    // SCON Bits:
    // scon[7]: SM0  (Serial mode bit 0)
    // scon[6]: SM1  (Serial mode bit 1)
    // scon[5]: REN  (Receive Enable)
    // scon[4]: TB8  (Transmit 9th data bit)
    // scon[3]: RB8  (Receive 9th data bit)
    // scon[2]: TI   (Transmit Interrupt Flag)
    // scon[1]: RI   (Receive Interrupt Flag)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scon <= 8'b0000_0000; // Reset SCON register

     end else begin
            // Serial Mode Control
            scon[7:6] <= mode;

            // Receive Enable
            scon[5] <= ren;

            // Transmit 9th bit (TB8)
            if (tb8_set)
                scon[4] <= 1'b1;
            else
                scon[4] <= 1'b0;

            // Receive 9th bit (RB8)
            if (rb8_receive)
                scon[3] <= 1'b1;
            else
                scon[3] <= 1'b0;

            // Transmit Interrupt Flag (TI)
            if (tx_complete)
                scon[2] <= 1'b1; // Set TI when transmission completes
            else
                scon[2] <= 1'b0;

            // Receive Interrupt Flag (RI)
            if (rx_complete)
 		scon[1] <= 1'b1; // Set RI when reception completes
            else
                scon[1] <= 1'b0;
        end
    end
endmodule


// APPLICATION - Used in 8051-based embedded systems to enable serial communication with other devices.

/*module SCON (
    input  clk,           // Clock signal
    input  reset,         // Reset signal
    input  [1:0] mode,    // Serial mode (SM0, SM1)
    input  ren,           // Receive enable (REN)
    input  tb8_set,       // Set TB8 bit (9th transmit bit)
    input  rb8_receive,   // Set RB8 bit (9th receive bit)
    input  tx_complete,   // Transmission complete flag (sets TI)
    input  rx_complete,   // Reception complete flag (sets RI)
    output reg [7:0] scon // Serial Control Register (SCON)
);

    // SCON Bits:
    // scon[7]: SM0  (Serial mode bit 0)
    // scon[6]: SM1  (Serial mode bit 1)
    // scon[5]: REN  (Receive Enable)
    // scon[4]: TB8  (Transmit 9th data bit)
    // scon[3]: RB8  (Receive 9th data bit)
    // scon[2]: TI   (Transmit Interrupt Flag)
    // scon[1]: RI   (Receive Interrupt Flag)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scon <= 8'b0000_0000; // Reset SCON register
        end else begin
            // Serial Mode Control
            scon[7:6] <= mode;

            // Receive Enable
            scon[5] <= ren;

            // Transmit 9th bit (TB8)
            scon[4] <= tb8_set ? 1'b1 : 1'b0;

            // Receive 9th bit (RB8)
            scon[3] <= rb8_receive ? 1'b1 : 1'b0;

            // Transmit Interrupt Flag (TI)
            scon[2] <= tx_complete ? 1'b1 : 1'b0;

            // Receive Interrupt Flag (RI)
            scon[1] <= rx_complete ? 1'b1 : 1'b0;
        end
    end

    // -----------------------------------------------
    // Assertions (SVA) to check correct behavior
    // -----------------------------------------------

    // Assertion 1: Reset should clear SCON register
    property p_reset;
        @(posedge clk) reset |-> (scon == 8'b0000_0000);
    endproperty
    a_reset: assert property (p_reset)
        $display("[PASS] Reset successfully cleared SCON register.");
    else
        $error("[FAIL] Reset did not clear SCON! scon = %b", scon);

    // Assertion 2: Serial Mode (SM0, SM1) should match input mode
    property p_mode_correct;
        @(posedge clk) !reset |-> (scon[7:6] == mode);
    endproperty
    a_mode: assert property (p_mode_correct)
        $display("[PASS] Serial mode correctly set: %b", scon[7:6]);
    else
        $error("[FAIL] Serial mode mismatch! Expected: %b, Got: %b", mode, scon[7:6]);

    // Assertion 3: Receive Enable (REN) should match input ren signal
    property p_receive_enable;
        @(posedge clk) !reset |-> (scon[5] == ren);
    endproperty
    a_receive_enable: assert property (p_receive_enable)
        $display("[PASS] REN (Receive Enable) set correctly: %b", scon[5]);
    else
        $error("[FAIL] REN mismatch! Expected: %b, Got: %b", ren, scon[5]);

    // Assertion 4: TB8 should be set only when tb8_set is high
    property p_tb8_set;
        @(posedge clk) !reset |-> (scon[4] == tb8_set);
    endproperty
    a_tb8_set: assert property (p_tb8_set)
        $display("[PASS] TB8 correctly updated: %b", scon[4]);
    else
        $error("[FAIL] TB8 mismatch! Expected: %b, Got: %b", tb8_set, scon[4]);

    // Assertion 5: RB8 should be set only when rb8_receive is high
    property p_rb8_set;
        @(posedge clk) !reset |-> (scon[3] == rb8_receive);
    endproperty
    a_rb8_set: assert property (p_rb8_set)
        $display("[PASS] RB8 correctly updated: %b", scon[3]);
    else
        $error("[FAIL] RB8 mismatch! Expected: %b, Got: %b", rb8_receive, scon[3]);

    // Assertion 6: TI (Transmit Interrupt) should be set only when tx_complete is high
    property p_tx_complete;
        @(posedge clk) !reset |-> (scon[2] == tx_complete);
    endproperty
    a_tx_complete: assert property (p_tx_complete)
        $display("[PASS] TI flag correctly set: %b", scon[2]);
    else
        $error("[FAIL] TI flag mismatch! Expected: %b, Got: %b", tx_complete, scon[2]);

    // Assertion 7: RI (Receive Interrupt) should be set only when rx_complete is high
    property p_rx_complete;
        @(posedge clk) !reset |-> (scon[1] == rx_complete);
    endproperty
    a_rx_complete: assert property (p_rx_complete)
        $display("[PASS] RI flag correctly set: %b", scon[1]);
    else
        $error("[FAIL] RI flag mismatch! Expected: %b, Got: %b", rx_complete, scon[1]);

endmodule */

