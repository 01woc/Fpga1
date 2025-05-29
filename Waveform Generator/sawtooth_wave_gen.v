module sawtooth_wave_gen (
    input clk,                          // Clock hệ thống
    input reset,                        // Tín hiệu reset đồng bộ
    input [9:0] phase_acc,              // Bộ tích lũy pha (10-bit)
    output reg [15:0] sawtooth_wave     // Tín hiệu sóng răng cưa (16-bit)
);

always @(posedge clk) begin
    if (reset) begin
        sawtooth_wave <= 16'd0;
    end else begin
       
        sawtooth_wave <= {phase_acc, 6'b000000};  // hoặc: phase_acc << 6
    end
end

endmodule
