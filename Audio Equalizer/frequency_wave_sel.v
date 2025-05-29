module frequency_wave_sel(
    input [1:0] freq_wave_sel,
    output reg [9:0] o_phase_step
);

always @(*) begin
    case (freq_wave_sel)
        2'b00:  o_phase_step = 10'b0000000001;  // 1024 samples
        2'b01:  o_phase_step = 10'b0000000010;  // 512 samples
        2'b10:  o_phase_step = 10'b0000000100;  // 256 samples
        default: o_phase_step = 10'b0000000001;
    endcase
end

endmodule
