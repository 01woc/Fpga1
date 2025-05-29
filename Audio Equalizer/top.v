module top (
    input wire clk,
    input wire reset,
    input wire [9:0] i_SW,
    output reg [15:0] dout,
    output wire [15:0] data_wave,
    output wire [15:0] data_low_filtered,
    output wire [15:0] data_high_filtered,
    output wire [15:0] data_band_filtered
);
    wire [9:0] phase_acc, phase_step;
    wire [1:0] freq_wave_sel;
    wire signed [15:0] gain_low, gain_high, gain_band;
   // wire [15:0] data_low_filtered, data_high_filtered, data_band_filtered;
    wire [31:0] data_low_with_gain, data_high_with_gain, data_band_with_gain; // Sử dụng 32-bit để chứa kết quả nhân
    wire [31:0] sum;  // Dùng 32-bit để chứa tổng trước khi cắt xuống 16 bit

    // Chọn tần số sóng
    assign freq_wave_sel = i_SW[3:2];
    
    // Chọn gain từ i_SW
    gain_selector gain_low_selector (
        .gain_sel(i_SW[5:4]), // Ví dụ: chọn gain cho lowpass từ i_SW[5:4]
        .gain_out(gain_low)
    );
    
    gain_selector gain_high_selector (
        .gain_sel(i_SW[7:6]), // Ví dụ: chọn gain cho highpass từ i_SW[7:6]
        .gain_out(gain_high)
    );
    
    gain_selector gain_band_selector (
        .gain_sel(i_SW[9:8]), // Ví dụ: chọn gain cho bandpass từ i_SW[9:8]
        .gain_out(gain_band)
    );
    
    // Module tạo sóng
    fre_wave fre_wave1 (
        .fre_wave(freq_wave_sel),
        .phase_step(phase_step)
    );
    
    waveLUT wave (
        .clk(clk),
        .phase_acc(phase_acc),
        .reset(reset),
        .wave(data_wave)
    );
    
    phase_accumulator phase_gen (
        .clk(clk),
        .reset(reset),
        .phase_step(phase_step),
        .phase_acc(phase_acc)
    );

    // Bộ lọc FIR lowpass
    fir_57tap_lowpass lowpass (
        .clk(clk),
        .data_in(data_wave),
        .data_out(data_low_filtered)
    );
    
    // Bộ lọc FIR highpass
    fir_57tap_highpass pass1 (
        .clk(clk),
        .data_in(data_wave),
        .data_out(data_high_filtered)
    );
    
    // Bộ lọc FIR bandpass
    fir_57tap_bandpass pass2 (
        .clk(clk),
        .data_in(data_wave),
        .data_out(data_band_filtered)
    );
    
    // Nhân tín hiệu lọc với gain và sử dụng 32-bit cho kết quả nhân
    assign data_low_with_gain = data_low_filtered * gain_low;
    assign data_high_with_gain = data_high_filtered * gain_high;
    assign data_band_with_gain = data_band_filtered * gain_band;

    // Cộng ba tín hiệu đã nhân với gain
    assign sum = data_low_with_gain + data_high_with_gain + data_band_with_gain;

    // Lấy 16 bit thấp nhất từ tổng để gán vào dout
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 16'd0;
        end else begin
            dout <= sum[15:0];  // Lấy 16 bit thấp nhất của tổng
        end
    end
endmodule
