module frequency_wave_sel(
    input [1:0] freq_wave,
    output reg [9:0] phase_step
);

always @(*) begin
    case (freq_wave)
        2'b00:  phase_step = 10'b0000000001;  // 1024 samples
        2'b01:  phase_step = 10'b0000000010;  // 512 samples
        2'b10:  phase_step = 10'b0000000100;  // 256 samples
        default: phase_step = 10'b0000000001;
    endcase
end

endmodule
