module square_wave_gen (
    input      [9:0] phase_acc,     // địa chỉ LUT
    input      [3:0] duty_cycle,    // chọn mức duty
    output reg [15:0] square_wave
);

    parameter MEM_SIZE = 1024;

    reg [15:0] square_lut10 [0:MEM_SIZE-1];
    reg [15:0] square_lut25 [0:MEM_SIZE-1];
    reg [15:0] square_lut50 [0:MEM_SIZE-1];
	 reg [15:0] square_lut75 [0:MEM_SIZE-1];

    // Nạp dữ liệu LUT từ file
    initial begin
        $readmemh("D:/k242/Fgpa/fir_iir/fir/square_lut10.dump", square_lut10);
        $readmemh("D:/k242/Fgpa/fir_iir/fir/square_lut25.dump", square_lut25);
        $readmemh("D:/k242/Fgpa/fir_iir/fir/square_lut50.dump", square_lut50);
		  $readmemh("D:/k242/Fgpa/fir_iir/fir/square_lut75.dump", square_lut75);
    end

    always @(*) begin
        case (duty_cycle)
            4'd0: square_wave = square_lut10[phase_acc];
            4'd1: square_wave = square_lut25[phase_acc];
            4'd2: square_wave = square_lut50[phase_acc];
				4'd3:  square_wave = square_lut75[phase_acc];
				default: square_wave = square_lut50[phase_acc];
        endcase
    end

endmodule
