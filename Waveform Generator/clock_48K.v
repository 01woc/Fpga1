module clock_48K (
    input clk_in,        // 12MHz clock input
    input reset_n,       // active-low synchronous reset
    output reg clk_out   // 48kHz clock output
);

    reg [7:0] counter;  // 8-bit counter to count up to 249 (i.e., 250 clock cycles)
    
    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 8'd0;
            clk_out <= 1'b0;
        end else begin
            if (counter == 8'd249) begin   // After 250 cycles (0 to 249)
                clk_out <= ~clk_out;       // Toggle the clock output
                counter <= 8'd0;           // Reset the counter
            end else begin
                counter <= counter + 1;    // Increment the counter
            end
        end
    end

endmodule
